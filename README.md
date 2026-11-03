# Database Management Project

A relational database design and SQL project (MySQL + Python): a normalised **Retail Sales & Inventory** schema with queries for **reporting** and **data retrieval**.

## What's Inside
- **Relational schema design:** 5 normalised tables (3NF) with primary keys, foreign keys, `CHECK` constraints and indexes
- **Sample data** to run every query straight away
- **Reporting queries:** monthly revenue, revenue by category, top customers, ranked best-sellers (joins, aggregates, window functions)
- **Data retrieval queries:** order history, low-stock alerts, customers with no orders, filtered lookups

## Schema Overview
```
categories ──< products ──< order_items >── orders >── customers
```
| Table | Description |
|-------|-------------|
| `categories` | Product groupings |
| `products` | Items with price, stock level and reorder threshold |
| `customers` | Customer details |
| `orders` | Order header (customer, date, status) |
| `order_items` | Line items linking orders to products |

## Project Structure
```
.
├── read_db.py          # Python script: connects to MySQL and reads the data
├── requirements.txt
├── schema.sql
├── sample_data.sql
├── queries/
│   ├── reporting.sql
│   └── data_retrieval.sql
└── README.md
```

## Getting Started
Requires a MySQL 8+ (or MariaDB 10.2+) server and Python 3.8+.

```bash
git clone https://github.com/<your-username>/database-management-project.git
cd database-management-project
pip install -r requirements.txt

# Linux / macOS
export DB_USER=root
export DB_PASSWORD=your_password     # omit to be prompted instead
# Windows (PowerShell): $env:DB_USER="root"; $env:DB_PASSWORD="your_password"

python3 read_db.py --setup   # first time: creates database, tables, sample data, then runs every query
python3 read_db.py           # afterwards: just runs the queries
```
Optional settings: `DB_HOST` (default `localhost`), `DB_PORT` (default `3306`), `DB_NAME` (default `retail_db`).

`read_db.py` connects with `mysql-connector-python`, loads `queries/reporting.sql` and `queries/data_retrieval.sql`, and prints each result as a table.

## Skills Demonstrated
Schema design and normalisation · Constraints and indexing · JOINs · Aggregation and `GROUP BY` · Window functions · Reporting and data retrieval

