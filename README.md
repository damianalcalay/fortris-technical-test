# FORTRIS Technical Test – SQL Section

This repository contains technical test solutions for the Application Support Engineer position at Fortris.

Each exercise is implemented in its own folder as a fully functional Dockerized PostgreSQL environment. The structure includes seed data, query files, and detailed documentation to demonstrate hands-on skills with SQL.

---

## How to Run All SQL Tests

1. Make sure you have Docker and `psql` installed.
2. In the project root, run:

   docker-compose up -d

3. Each test runs a separate PostgreSQL container mapped to a different local port:

   - sql-query-test-1 → Port 5432
   - sql-query-test-2 → Port 5434

4. To execute the query of each test:

   - **Test 1**:  
     psql -h localhost -U demo -d company -p 5432 -f sql-query-test-1/queries/query_employees.sql

   - **Test 2**:  
     psql -h localhost -U demo -d company -p 5434 -f sql-query-test-2/queries/query_headcount.sql

   Default credentials:

   - User: demo
   - Password: demo

---

## SQL Query Test 1 – Employees and Departments

**Objective**: Retrieve all employees with their job title and department name.

**Concepts demonstrated**:

- INNER JOIN between `employees`, `jobs`, and `departments`
- Clear relational schema using foreign keys
- Structured and readable query design

**Data overview**:

- Employees like Jennifer Whalen (Administration Assistant) and Michael Hartstein (Marketing Manager) are included
- Departments: Administration, Marketing, Purchasing
- Jobs: Assistant, Manager, Clerk, etc.

**Expected result**: 9 employees with their job title and department, correctly joined and grouped.

---

## SQL Query Test 2 – Department Headcount

**Objective**: Generate a report showing each department's headcount (number of employees), including those with no employees.

**Concepts demonstrated**:

- LEFT JOIN between `departments` and `employees`
- GROUP BY and COUNT aggregation
- ORDER BY in descending order of headcount

**Data overview**:

- 11 departments created with varying numbers of employees
- Headcounts range from 7 (Shipping) to 1 (Administration, Human Resources, etc.)

**Expected result**:  
A list of all 11 departments with accurate headcounts, descending by number of employees.

---

## Exercise 3 - MongoDB: Querying the `orders` Collection

This exercise demonstrates how to query a MongoDB collection named `orders`, pre-seeded with a dataset using an `init.js` script. The collection stores transaction records with the following structure:

```json
{
  "_id": ObjectId("60b8d295f1a7f2355e9f1d8c"),
  "Date": ISODate("2024-06-20T15:30:00Z"),
  "Amount": 250.75,
  "txHash": "0xabcdef..."
}
```

### ✅ Run All Queries at Once

All queries from this exercise have been included in a single script for easy testing and validation.

📄 **Script path**: `mongo-query-test-3/queries/mongo-query.js`

You can execute the entire script with the following command:

mongosh --host localhost --port 27017 mongo-query-test-3/queries/mongo-query.js

## How to Connect to test app with mongosh terminal

- mongosh --host localhost --port 27017
- use testdb

## 1. Get the Amount of a specific \_id

- db.orders.find(
- { \_id: ObjectId("60b8d295f1a7f2355e9f1d8c") },
- { \_id: 0, Amount: 1 }
- )

- Why use find?
- Since we're retrieving a single document by its \_id, which is indexed by default, find is the most efficient and readable choice. There's no need to use an aggregation pipeline unless we need additional transformation.

## 2. Filter orders from May 1 to June 1, 2024

db.orders.find({
Date: {
$gte: new Date("2024-05-01T00:00:00Z"),
$lt: new Date("2024-06-01T00:00:00Z")
}
})

- Why use find?
- This is a basic range query, ideal for find as no aggregation or data restructuring is needed.

- When to prefer aggregate?
- If you want to extract parts of the date (day, month, etc.) or apply post-filters. Example:

db.orders.aggregate([
{
$match: {
Date: {
$gte: new Date("2024-05-01T00:00:00Z"),
$lt: new Date("2024-06-01T00:00:00Z")
}
}
},
{
$project: {
_id: 0,
Date: 1,
Amount: 1,
dayOfMonth: { $dayOfMonth: "$Date" }
}
}
])

## 3. Filter by Amount > 100 and sort by latest

db.orders.find(
{ Amount: { $gt: 100 } }
).sort({ Date: -1 })

- Why use find + sort?
- We're only filtering and sorting, not transforming data. find is clearer and performant, especially if we create indexes on Amount or Date in production.

## 4. Aggregate total Amount of transactions per day

db.orders.aggregate([
{
$group: {
_id: {
$dateToString: { format: "%Y-%m-%d", date: "$Date" }
},
totalAmount: { $sum: "$Amount" }
}
},
{ $sort: { \_id: 1 } }
])

- Why aggregate is necessary:
- Grouping and summing fields per day is not possible with find. This is a textbook case for aggregation pipelines.

## 🔎 5. Count the number of transactions per day

db.orders.aggregate([
{
$group: {
_id: {
$dateToString: { format: "%Y-%m-%d", date: "$Date" }
},
transactionCount: { $sum: 1 }
}
},
{ $sort: { \_id: 1 } }
])

- Why aggregate is required:
- Again, since we are counting by grouping over formatted dates, only aggregate can handle this logic.

## Exercise 4 - Python: Exporting Orders from MongoDB (It's inside exercise 3 since it's using Mongo DB)

This exercise demonstrates how to connect to a MongoDB collection, extract specific fields (`_id`, `Amount`, `Date`), map them to a Python class, and export the results to a CSV file. It also includes proper **exception handling**, **logging**, and **unit tests** to validate functionality.

---

### Problem Statement

> Using the previous MongoDB collection example:  
> `{ "_id": "ObjectId('60b8d295f1a7f2355e9f1d8c'), "Date": "2024-06-20T15:30:00Z", "Amount": 250.75, "txHash": "..." }`
>
> Write a Python script that:
>
> - Connects to the MongoDB collection
> - Extracts the fields `_id`, `Amount`, and `Date`
> - Parses the results into a class
> - Creates a DataFrame
> - Exports it into a CSV file
> - Includes exception handling and logging

---

### Directory Structure

mongo-query-exercise-3/
└── python-exercise-4/
├── export_orders.py # Main script (entry point)
├── output.csv # Auto-generated CSV file
├── export_orders.log # Log file for debug

---

### How It Works

- The script connects to MongoDB at `mongodb://localhost:27017/`
- It reads from the database `testdb`, collection `orders`
- Documents are mapped to the `Order` class with fields:
  - `ID` (converted from ObjectId)
  - `Amount`
  - `Date`
- Results are exported to a CSV using `pandas`
- Logs are written to `export_orders.log`

## Exercise 5 - Exercise - Docker Swarm Essentials

Docker Swarm Helper Scripts

To simplify and automate common Docker Swarm operations, this solution includes three shell scripts:

- deploy.sh
- scale.sh
- update.sh

Im executing this exercise in folder docker-swar-exercise.

This folder demonstrates key Docker Swarm operations using a basic `nginx` service.

## 1. What are the basic commands to manage Docker Swarm?

# Initialize Swarm mode on the manager node

docker swarm init

# Get token to join other nodes as workers

docker swarm join-token worker

# Join a node to the Swarm (run this on the worker node)

docker swarm join --token <worker-token> <manager-ip>:2377

# Deploy a stack using Docker Compose in Swarm mode

docker stack deploy -c docker-compose.yml mystack

# List all nodes in the Swarm

docker node ls

# List all services running in the Swarm

docker service ls

# Inspect a specific service in a user-friendly format

docker service inspect <service_name> --pretty

## 2. How do you find a service in a manager?

# Run on the manager node:

docker node ls # List nodes in the Swarm
docker service ls # List active services

## 3. How do you list a service in a certain host?

# On the specific host:

docker ps # Show containers running on that host

# Or from the manager:

docker service ps <service_name> # Shows tasks and which node they're running on

4. How do you access a container?

docker ps # Get the container ID
docker exec -it <container_id> /bin/sh # Or bash

# For Swarm services:

docker service ps <service_name> # Get the container/task ID
docker exec -it <task_id> /bin/sh

5. How do you retrieve the logs from a container and get the logs live?

# For a single container:

docker logs -f <container_id>

# For a Swarm service:

docker service logs -f <service_name>

6. How do you restart a service in Docker Swarm?

docker service update --force <service_name>

7. How do you update/create an environment variable for a certain service?

docker service update --env-add MY_VAR=value <service_name>

8. How do you scale a service?

docker service scale <service_name>=5 # Note: The default replica count in `docker-compose.yml` is 3, but the command below shows how to override and scale it to 5 at runtime.

## Exercise 6 - Git

1. How would you get a repository from a URL?

git clone https://github.com/your-username/fortris-technical-test.git

2. How would you show the differences between two branches?

git diff develop..main

3. How would you commit your changes to the repository?

git add .
git commit -m "finished all exercises"

## Exercise 7 - Linux

1. Write a command that displays current time of the system

date

# Explanation: This command displays the current system date and time. Example output: 'Mon Apr 1 22:00:00 UTC 2025' - Useful for logging, scripting, and confirming timestamps.

2. Write a command that prints updates on a log file named debug.log in real time, only showing the lines that contain the word “ERROR”

tail -f debug.log | grep "ERROR"

# Explanation: tail -f: continuously monitors the file. grep "ERROR": filters lines in real time that contain the word ERROR.

3. Write a command that prints the size of each directory in a human readable way, sorted by size

du -h --max-depth=1 | sort -hr

# Explanation: du -h: disk usage in human-readable format (e.g., MB, GB). --max-depth=1: only shows top-level folders. sort -hr: sorts by size, biggest first.

4. How would you schedule a task to be executed every Monday at 10pm?

crontab -e

# Then add this line:

0 22 \* \* 1 /ruta/script.sh

# Explanation: 0 22 \* \* 1 means: minute 0, hour 22 (10PM), every day, every month, only on Monday (1). /ruta/script.sh: your shell script to execute.

5. In VI Editor, how would you save changes in a file that was opened in read-only mode?

# Make your changes as usual. Type the following in command mode (Esc to ensure you're not in insert mode):

:w !sudo tee %

# What it does: :w: try to write. !sudo tee %: uses sudo to overwrite the file, where % is the current filename

6. How would you change the ownership of a directory recursively?

sudo chown -R username:groupname /path/to/directory

# Explanation: chown: change ownership. -R: recursive – applies to all files and subdirectories. username: new owner. groupname: (optional) group owner. If you don’t specify it, current group remains. /path/to/directory: the target directory you want to update.

# 📘 Example:

sudo chown -R damian:developers /home/damian/project
