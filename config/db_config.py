from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import pandas as pd

# o normal seria colocar minhas variaveis de ambiente em um arquivo .env, mas para esse exercicio vou chapar elas em codigo
class DatabaseConfig:
    def __init__(self):
        self.user = 'gabriel'
        self.password = '7mgkO'
        self.host = 'localhost'
        self.port = 5432
        self.database = 'quality_audit'
        self.engine = None
        self.Session = None

    def create_engine(self):
        if self.engine is None:
            self.engine = create_engine(
                f'postgresql://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}'
            )
        return self.engine

    def create_session(self):
        if self.Session is None:
            self.create_engine()
            self.Session = sessionmaker(bind=self.engine)
        return self.Session()
    
    def query_to_dataframe(self, query):
        engine = self.create_engine()
        with engine.connect() as connection:
            df = pd.read_sql_query(query, connection)
        return df



