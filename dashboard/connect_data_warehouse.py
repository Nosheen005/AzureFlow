import duckdb
import os

DB_PATH = os.getenv("DUCKDB_PATH")
#DB_PATH='../data_warehouse/job_ads.duckdb'

 
def query_job_listings(query='SELECT * FROM marts.mart_construction'):
    with duckdb.connect(DB_PATH, read_only=True) as conn:
        return conn.query(f"{query}").df()