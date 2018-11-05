import psycopg2

class PostgreDB:
    connection = None
    cursor = None
    query = None

    def bd_connection(self):
        try:
            print('Efetuando Conexão Com Banco De Dados...')
            PostgreDB.connection = psycopg2.connect(database="projeto",
            user="postgres", password="teste123",host='localhost',port=5432)
            PostgreDB.cursor = PostgreDB.connection.cursor()
            print('Sucesso!')
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)


    def close_connection(self):
        PostgreDB.connection.commit()
        PostgreDB.connection.close()

    def set_query(self, string):
        PostgreDB.query = string

    def execute_query(self):
        try:
            PostgreDB.cursor.execute(PostgreDB.query)
            return PostgreDB.cursor.fetchone()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            PostgreDB.connection.commit()
