"""
export_orders.py

This script connects to a MongoDB collection, extracts orders data, parses it into a class, 
exports the data to a CSV file, and includes exception handling and logging.
"""

# Standard Library
import logging
import os
from datetime import datetime
from typing import List, Dict, Any

# Third Party
from pymongo import MongoClient
from pymongo.collection import Collection
from pymongo.errors import PyMongoError
from bson.objectid import ObjectId
import pandas as pd

# ---------------------------
# Logging Configuration
# ---------------------------
LOG_PATH = os.path.join(os.path.dirname(__file__), "export_orders.log")
logging.basicConfig(
    filename=LOG_PATH,
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)

# ---------------------------
# MongoDB Connection Configuration Class
# ---------------------------
class MongoConfig:
    """
    Encapsulates the MongoDB connection settings
    """
    def __init__(self, uri: str, db_name: str, collection_name: str):
        self.uri = uri
        self.db_name = db_name
        self.collection_name = collection_name

    def to_dict(self) -> Dict[str, str]:
        """
        Return config as dictionary for logging or debugging
        """
        return {
            "uri": self.uri,
            "database": self.db_name,
            "collection": self.collection_name
        }

# ---------------------------
# Domain Model for Orders
# ---------------------------
class Order:
    """
    Represents a single order entry from MongoDB
    """
    def __init__(self, _id: ObjectId, amount: float, date: datetime):
        self.id = str(_id)
        self.amount = amount
        self.date = date

    def to_dict(self) -> Dict[str, Any]:
        """
        Convert the order to a dictionary (for DataFrame and CSV export)
        """
        return {
            "ID": self.id,
            "Amount": self.amount,
            "Date": self.date.strftime('%Y-%m-%d %H:%M:%S')
            if isinstance(self.date, datetime) else self.date
        }

# ---------------------------
# MongoDB Exporter Logic
# ---------------------------
class MongoExporter:
    """
    Handles connection to MongoDB, data fetching, and exporting
    """
    def __init__(self, config: MongoConfig):
        self.config = config
        self.client = MongoClient(self.config.uri)
        self.collection: Collection = self.client[
            self.config.db_name
        ][self.config.collection_name]

    def fetch_orders(self) -> List[Order]:
        """
        Fetch all orders from the collection and convert them into Order objects
        """
        cursor = self.collection.find({}, {"_id": 1, "Amount": 1, "Date": 1})
        return [
            Order(doc["_id"], doc.get("Amount", 0), doc.get("Date"))
            for doc in cursor
        ]

    def export_to_csv(self, orders: List[Order], output_file: str = None) -> None:
        """
        Convert orders into DataFrame and write to a CSV file
        """
        df = pd.DataFrame([order.to_dict() for order in orders])
        if not output_file:
            output_file = os.path.join(os.path.dirname(__file__), "output.csv")
        df.to_csv(output_file, index=False)
        logging.info("Exported %d records to %s", len(orders), output_file)

# ---------------------------
# Main Controller Class
# ---------------------------
class Main:
    """
    Entry point of the script. Runs the full export workflow.
    """
    def __init__(self):
        self.config = MongoConfig("mongodb://localhost:27017/", "testdb", "orders")
        self.exporter = MongoExporter(self.config)

    def run(self) -> None:
        """
        Runs the steps: connect -> fetch -> export
        """
        try:
            logging.info("Starting export process...")
            logging.info("DB config: %s", self.config.to_dict())

            orders = self.exporter.fetch_orders()

            if not orders:
                logging.warning("No records found.")
                return

            self.exporter.export_to_csv(orders)
            logging.info("Export completed successfully.")

        except PyMongoError as err:
            logging.error("MongoDB Error: %s", err)
        except Exception as exc:
            logging.error("Unexpected error: %s", exc)

# ---------------------------
# Entry point
# ---------------------------
if __name__ == "__main__":
    main_app = Main()
    main_app.run()
