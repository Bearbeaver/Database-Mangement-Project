#!/usr/bin/env python3
"""Run the reporting and data-retrieval queries against MySQL and print the results.

Usage:
    python3 read_db.py --setup     # create database + tables + sample data, then run queries
    python3 read_db.py             # just run the queries
"""
import argparse
import getpass
import os
import sys
from pathlib import Path

try:
    import mysql.connector
    from mysql.connector import Error
except ImportError:
    sys.exit("Missing dependency. Run: pip install -r requirements.txt")

BASE = Path(__file__).parent


def get_config():
    """Connection settings come from environment variables (see README)."""
    password = os.getenv("DB_PASSWORD")
    if password is None:
        password = getpass.getpass("MySQL password: ")
    return {
        "host": os.getenv("DB_HOST", "localhost"),
        "port": int(os.getenv("DB_PORT", "3306")),
        "user": os.getenv("DB_USER", "root"),
        "password": password,
    }


def split_statements(sql_text):
    """Split a .sql file into statements, skipping blocks that are only comments."""
    statements = []
    for chunk in sql_text.split(";"):
        code = "\n".join(l for l in chunk.splitlines() if not l.strip().startswith("--")).strip()
        if code:
            statements.append(chunk.strip())
    return statements


def run_script(cursor, path):
    for stmt in split_statements(Path(path).read_text()):
        cursor.execute(stmt)


def title_of(statement, fallback):
    for line in statement.splitlines():
        if line.strip().startswith("--"):
            return line.strip().lstrip("- ").strip()
    return fallback


def print_result(cursor):
    rows = cursor.fetchall()
    if not rows:
        print("  (no rows)")
        return
    headers = list(cursor.column_names)
    table = [[("" if v is None else str(v)) for v in row] for row in rows]
    widths = [max(len(h), *(len(r[i]) for r in table)) for i, h in enumerate(headers)]
    line = "  " + "  ".join(h.ljust(w) for h, w in zip(headers, widths))
    print(line)
    print("  " + "  ".join("-" * w for w in widths))
    for r in table:
        print("  " + "  ".join(v.ljust(w) for v, w in zip(r, widths)))
    print(f"  ({len(rows)} row{'s' if len(rows) != 1 else ''})")

DB_NAME = os.getenv("DB_NAME", "retail_db")
QUERY_FILES = ["queries/reporting.sql", "queries/data_retrieval.sql"]


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("--setup", action="store_true", help="create the database, tables and sample data first")
    args = parser.parse_args()

    cfg = get_config()
    try:
        conn = mysql.connector.connect(**cfg)
        cur = conn.cursor()
        if args.setup:
            cur.execute(f"CREATE DATABASE IF NOT EXISTS `{DB_NAME}`")
        cur.execute(f"USE `{DB_NAME}`")
        if args.setup:
            run_script(cur, BASE / "schema.sql")
            run_script(cur, BASE / "sample_data.sql")
            conn.commit()
            print(f"Database '{DB_NAME}' is ready.")

        print(f"Connected to MySQL {cfg['host']}:{cfg['port']} / {DB_NAME}")
        for qfile in QUERY_FILES:
            print(f"\n######## {qfile} ########")
            for i, stmt in enumerate(split_statements((BASE / qfile).read_text()), 1):
                print(f"\n== {title_of(stmt, f'Query {i}')} ==")
                cur.execute(stmt)
                print_result(cur)
        conn.close()
    except Error as e:
        sys.exit(f"MySQL error: {e}\nTip: first run with --setup if the database doesn't exist yet.")


if __name__ == "__main__":
    main()
