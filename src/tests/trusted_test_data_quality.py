import pytest
import sys
import os
import re
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from config.db_config import DatabaseConfig


# Funções auxiliares 
def validate_email(email):
    if isinstance(email, str):
        pattern = r'^[a-zA-Z0-9à-ÿ._+-]+@[a-zA-Z0-9à-ÿ.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None
    return False

def validate_phone(phone):    
    if isinstance(phone, str):
        pattern = r'^[1-9]{1}[0-9]{1}9[0-9]{8}$'
        return re.match(pattern, phone) is not None
    return False

def validate_postal_code(postal_code):    
    if isinstance(postal_code, str):
        pattern = r'^[0-9]{8}$'
        return re.match(pattern, postal_code) is not None
    return False


@pytest.fixture
def data():

    #Cria o objeto para interação com o banco banco
    database = DatabaseConfig()

    # Pegar o frame a ser testado
    df = database.query_to_dataframe('select * from trusted_case_parte_um') # chapei a tabela a ser tratada em codigo, um ponto de melhoria seria construir uma camada onde se passa a tabela como argumento e se faça os testes

    # Aplicar validação de email
    df['email_valid'] = df['email'].apply(validate_email)
    df['phone_valid'] = df['phone_number'].apply(validate_phone)
    df['postal_code_valid'] = df['postal_code'].apply(validate_postal_code)

    # Remoção de Espaços Extras
    df = df.map(lambda x: x.strip() if isinstance(x, str) else x)

    return df

def test_null_values(data):
    print(data.isnull().sum())
    assert data.isnull().sum().sum() == 0, "Existem valores nulos na trusted_case_parte_um"


def test_valid_emails(data):
    data.dropna(inplace=True)
    invalid_emails = data[~data['email_valid']]
    assert invalid_emails.empty, f"Existem e-mails inválidos: {invalid_emails['email'].tolist()}"

def test_valid_phone_numbers(data):
    data.dropna(inplace=True)
    invalid_phones = data[~data['phone_valid']]
    assert invalid_phones.empty, f"Existem números de telefone inválidos: {invalid_phones['phone_number'].tolist()}"

def test_valid_postal_codes(data):
    data.dropna(inplace=True)
    invalid_postal_codes = data[~data['postal_code_valid']]
    assert invalid_postal_codes.empty, f"Existem códigos postais inválidos: {invalid_postal_codes['postal_code'].tolist()}"

def test_no_duplicates_email(data):
    data.dropna(inplace=True)
    data['duplicates'] = data['email'].duplicated()
    assert not data['duplicates'].any(), f"Existem registros de email duplicados"

def test_no_duplicates_phone_number(data):
    data.dropna(inplace=True)
    data['duplicates'] = data['phone_number'].duplicated()
    assert not data['duplicates'].any(), f"Existem registros de phone_number duplicados"

def test_no_duplicates_postal_code(data):
    data.dropna(inplace=True)
    data['duplicates'] = data['postal_code'].duplicated()
    assert not data['duplicates'].any(), f"Existem registros de postal_code duplicados"

def test_data_types(data):
    print(data)
    assert data['email'].dtype == 'object', "O tipo de dado da coluna email não é object"
    assert data['phone_number'].dtype == 'object', "O tipo de dado da coluna phone_number não é object"

#python -m pytest src/tests/test_data_quality.py