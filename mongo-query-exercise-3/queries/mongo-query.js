db = db.getSiblingDB("testdb");

print("\n📌 Query 1: Get Amount by _id");
printjson(
  db.orders
    .find({ _id: ObjectId("60b8d295f1a7f2355e9f1d8c") }, { _id: 0, Amount: 1 })
    .toArray()
);

print("\n📌 Query 2: Orders from May 1 to June 1, 2024");
printjson(
  db.orders
    .find({
      Date: {
        $gte: new Date("2024-05-01T00:00:00Z"),
        $lt: new Date("2024-06-01T00:00:00Z"),
      },
    })
    .toArray()
);

print("\n📌 Query 3: Amount > 100, sorted by latest");
printjson(
  db.orders
    .find({ Amount: { $gt: 100 } })
    .sort({ Date: -1 })
    .toArray()
);

print("\n📌 Query 4: Total Amount per Day");
printjson(
  db.orders
    .aggregate([
      {
        $group: {
          _id: {
            $dateToString: { format: "%Y-%m-%d", date: "$Date" },
          },
          totalAmount: { $sum: "$Amount" },
        },
      },
      { $sort: { _id: 1 } },
    ])
    .toArray()
);

print("\n📌 Query 5: Count of Transactions per Day");
printjson(
  db.orders
    .aggregate([
      {
        $group: {
          _id: {
            $dateToString: { format: "%Y-%m-%d", date: "$Date" },
          },
          transactionCount: { $sum: 1 },
        },
      },
      { $sort: { _id: 1 } },
    ])
    .toArray()
);
