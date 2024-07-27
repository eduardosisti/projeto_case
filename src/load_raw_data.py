import sys
import os
import pandas as pd
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config.db_config import DatabaseConfig


def load_data(file_path, nome_planilha):
    # le o arquivo excel
    df = pd.read_excel(file_path, sheet_name=nome_planilha)
    #Cria a engine com o banco de dados
    engine = DatabaseConfig().create_engine()
    #Cria a tabela raw_case_parte_um com os dados do excel
    df.to_sql('raw_case_parte_um', engine, index=False, if_exists='replace')

if __name__ == "__main__":
    load_data(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'data', 'Case Analista de Negócios - Eduardo.xlsx')),'Parte 1')

