import sys
import os
import pandas as pd
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config.db_config import DatabaseConfig   
from pandasql import sqldf

def read_sql_file(file_path):
    with open(file_path, 'r') as file:
        query = file.read()   
    return query

def query_to_csv(script_sql,name_generate_csv):

    # Caminho para o arquivo SQL
    sql_file_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'data', 'sql', script_sql)) 

    # Ler o conteúdo do arquivo SQL
    query = read_sql_file(sql_file_path)
    
    #Cria o objeto para interação com o banco banco
    database = DatabaseConfig()

    # Realizar o tratamento de dados
    df = database.query_to_dataframe(query)
    print(df)
    df.to_csv(f'./data/query_output/{name_generate_csv}',sep=';', header=True)



if __name__ == "__main__":
    querys=[
    'query_canc_base_produto_v1.sql',
    'query_canc_base_produto_v2.sql',
    'query_canc_base_total.sql',
    'query_canc_cohort.sql',
    'query_canc_ticket_open.sql']
    for x in querys:
        query_to_csv(x,f'{x}.csv')
        
    