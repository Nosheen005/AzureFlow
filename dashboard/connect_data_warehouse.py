from pathlib import Path
import duckdb
db_path = str(Path(__file__).parents[1] / "data_warehouse/job_ads.duckdb")
 
def query_job_listings(query='SELECT * FROM mart_construction'):
    with duckdb.connect(db_path, read_only=True) as conn:
        return conn.query(f"{query}").df()