# import duckdb
# import os

# DB_PATH = os.getenv("DUCKDB_PATH")
# #DB_PATH='../data_warehouse/job_ads.duckdb'

 
# def query_job_listings(query='SELECT * FROM marts.mart_construction'):
#     with duckdb.connect(DB_PATH, read_only=True) as conn:
#         return conn.query(f"{query}").df()


import duckdb
import os
import pandas as pd

# Fallback if env var isn't set
DB_PATH = os.getenv("DUCKDB_PATH")

def _normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    # Make every dataframe schema consistent (UPPERCASE)
    df.columns = [c.upper() for c in df.columns]
    if "VACANCIES" in df.columns:
        df["VACANCIES"] = pd.to_numeric(df["VACANCIES"], errors="coerce").fillna(0)
    return df

def query_job_listings(query: str) -> pd.DataFrame:
    with duckdb.connect(DB_PATH, read_only=True) as conn:
        df = conn.query(query).df()
    return _normalize_columns(df)
