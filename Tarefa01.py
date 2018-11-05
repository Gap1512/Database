#Gustavo Alves Pacheco
#11821ECP011

#Tarefa: Implementar em qualquer linguagem os comandos de
#UPDATE, DELETE e SELECT com WHERE
#Enviar para o e-mail: mjcunha@ufu.br

#Importando modulo do driver postgreSQL/Python
import psycopg2

#Realizando a conexão com o banco
con = psycopg2.connect(host = 'localhost', database = 'python',
    user = 'postgres', password = 'teste123')
cur = con.cursor()

def main():

    #UPDATE
    cur.execute("UPDATE sch01.tb_cliente SET titulo = 'Sr.' WHERE titulo = 'Sr'")

    #DELETE
    cur.execute("DELETE FROM sch01.tb_codigo_barras WHERE codigo_barras > 847673683");

    #SELECT
    cur.execute("SELECT c.titulo, c.nome, c.sobrenome, p.id_pedido FROM sch01.tb_cliente c, sch01.tb_pedido p WHERE p.id_cliente = c.id_cliente")

    #Retorno do Select
    recset = cur.fetchall()

    #Imprimir o Retorno
    for rec in recset:
        print(rec)

    #Commit e Close
    con.commit()
    con.close()

if __name__ == '__main__':
    main()
