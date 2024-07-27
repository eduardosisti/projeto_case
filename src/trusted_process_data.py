import sys
import os
import pandas as pd
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config.db_config import DatabaseConfig


def read_sql_file(file_path):
    with open(file_path, 'r') as file:
        query = file.read()
    
    return query

def process_data(script_sql,generate_new_table_name):

    # Caminho para o arquivo SQL
    sql_file_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'data', 'sql', script_sql))    

    # Ler o conteúdo do arquivo SQL
    query = read_sql_file(sql_file_path)
    
    #Cria o objeto para interação com o banco banco
    database = DatabaseConfig()
    engine = database.create_engine()

    # Realizar o tratamento de dados
    df_tratado = database.query_to_dataframe(query)

    # Subir uma tabela no PostreSQL com os tratamentos
    df_tratado.to_sql(generate_new_table_name, engine, index=False, if_exists='replace')
    print(df_tratado)

if __name__ == "__main__":
    process_data('transform_trusted_data.sql','trusted_case_parte_um')
    