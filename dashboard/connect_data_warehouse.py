import duckdb
import os
from pathlib import Path

DB_PATH = Path("/mnt/data/job_ads.duckdb")
#DB_PATH = os.getenv("DUCKDB_PATH")
#DB_PATH='../data_warehouse/job_ads.duckdb'

def query_job_listings(query='SELECT * FROM marts.mart_construction'):
    with duckdb.connect(DB_PATH, read_only=True) as conn:
        df = conn.query(query).df()
        df.columns = [c.upper() for c in df.columns]
    return df