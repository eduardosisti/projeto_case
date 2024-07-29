# Projeto de Auditoria de Qualidade de Dados

## Descrição
Este projeto realiza a auditoria de qualidade de um arquivo XLSX, carregando os dados em um banco de dados PostgreSQL, realizando o tratamento dos dados e executando testes automatizados para garantir a integridade e qualidade dos dados.

## Estrutura de Pastas

gabriel_case/
├── config/
│   ├── __init__.py
│   ├── db_config.py
├── data/
│   ├── SQL/
│   │   ├── refined_email_marketing_data.sql
│   │   ├── refined_sms_marketing_data.sql
│   │   ├── transform_trusted_data.sql
│   ├── Case Analista de Negócios - Eduardo.xlsx
│   ├── README.md
├── docker/
│   ├── data/
│   ├── docker-compose.yml
├── src/
│   ├── __init__.py
│   ├── load_raw_data.py
│   ├── refined_email_marketing_process_data.py
│   ├── refined_sms_marketing_process_data copy.py
│   ├── trusted_process_data.py
├── ├── tests/
│   │   ├── __init__.py
│   │   ├── trusted_test_data_quality.py
├── pytest.ini
├── README.md
├── requirements.txt

- `data/`: Contém o arquivo XLSX original, uma descrição dos dados e os scripts SQL.
- `src/`: Contém o código-fonte para carregar, processar e testar os dados.
- `config/`: Contém a configuração do banco de dados.
- `docker/`: Contém o arquivo Docker Compose para configurar o PostgreSQL.
- `requirements.txt`: Lista de dependências do projeto.
- `README.md`: Documentação do projeto.


## Ordem de processos
1. Execute o Docker Compose para subir o banco de dados PostgreSQL:
   ```bash
   docker-compose -f docker/docker-compose.yml up -d

2. Ter algum interpretador python instalado, recomendo a instalação de a criação de um ambiente virutal
   ```bash
   pip install virtualenv
   virtualenv venv
   source venv/bin/activate

3. instale os modulos:
   ```bash
   pip install -r requirements.txt

4. Carregue os dados na camada raw:
   ```bash
   python src/load_data_parte_um.py

5. Faça o tratamento dos dados:
   ```bash
   python src/trusted_process_data.py

6. Realize os testes:
   ```bash
   python -m pytest src/tests/trusted_test_data_quality.py 

7. Parte 2   
   ```bash
   python src/load_data_parte_dois.py 

8. exportar dados para a pasta data/query_output
   ```bash
   python src/parte_dois_case.py