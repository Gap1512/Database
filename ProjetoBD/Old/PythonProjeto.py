
import os
import time
from Arduino import *
from PostgreDB import *


def menu():
    os.system('clear')
    print(" ----------MENU---------- \n"
          "|1.           Fazer Login|\n"
          "|2.      Realizar Leitura|\n"
          "|3.     Cadastrar Usuário|\n"
          "|4.    Atualizar Cadastro|\n"
          "|5.  Cadastrar Localidade|\n"
          "|6.  Atualizar Localidade|\n"
          "|7.       Deletar Medição|\n"
          "|8.                  Sair|\n"
          " ------------------------ \n")

def command(choice, usuario):
    id_pessoa = -1

    if choice == 1:
        id_pessoa = fazer_login(usuario)
        if id_pessoa != -1:
            print("Login Realizado Com Sucesso")
        else:
            print("Usuario Não Encontrado, Favor Realizar Cadastro")
        return id_pessoa
    elif choice == 2:
        arduinoUtil = Arduino()
        arduinoUtil.connectArduino()
        measuresData = arduinoUtil.readMeasures()
        humAir,tempAir,lum,humSoil = (measuresData.split(';'))
        if usuario == -1:
            print("Realize Login Para Continuar")
            return -1
        id_local = (input("Qual O Código Do Local Onde Está Sendo Feita A Medição? "))
        status = realizar_medida(tempAir,humAir,humSoil,lum,usuario,id_local)
        if status != -1:
            print("Medidas Inseridas Com Sucesso")
        else:
            print("Ocorreu Um Erro")
    elif choice == 3:
        id_pessoa = cadastrar_usuario()
        if id_pessoa != -1:
            print("Cadastro Realizado Com Sucesso")
        else:
            print("Ocorreu Um Erro")
        print("Seu Código De Usuário É: %s" % id_pessoa)
        return id_pessoa
    elif choice == 4:
        id_pessoa = atualizar_usuario()
        if id_pessoa != -1:
            print("Atualização Realizada Com Sucesso")
        else:
            print("Ocorreu Um Erro")
        return id_pessoa
    elif choice == 5:
        if usuario == -1:
            print("Realize Login Para Continuar")
            return -1
        id_local = cadastrar_local(usuario)
        if id_local != -1:
            print("Cadastro Realizado Com Sucesso")
        else:
            print("Ocorreu Um Erro")
        print("O Código Do Local É: %s" % id_local)
    elif choice == 6:
        if usuario == -1:
            print("Realize Login Para Continuar")
            return -1
        id_local = atualizar_local(usuario)
        if id_local != -1:
            print("Atualização Realizada Com Sucesso")
        else:
            print("Ocorreu Um Erro")
    elif choice == 7:
        if usuario == -1:
            print("Realize Login Para Continuar")
            return -1
        id_medida = (input("Qual O Código Do Medição A Ser Excluida? "))
        id_local = (input("Qual O Código Do Local Onde Foi Feita A Medição? "))
        status = excluir_medida(id_medida, usuario, id_local)
        if status != -1:
            print("Medida Excluida Com Sucesso")
        else:
            print("Ocorreu Um Erro")
    else:
        print('Comando Não Cadastrado')

    return id_pessoa

def fazer_login(usuario):
    print("Digite Seu Código De Usuário")
    usuario = input()
    sql = PostgreDB
    PostgreDB.set_query(sql, 'SELECT main.fn_consulta_usuario({})'.format(usuario))
    id_pessoa = PostgreDB.execute_query(sql)
    return id_pessoa[0]

def realizar_medida(tempAir,humAir,humSoil,lum,usuario,id_local):
    sql = PostgreDB
    PostgreDB.set_query(
                        sql,
                        'SELECT main.fn_inserir_medicoes({}, {}, {}, {}, {}, {}, {})'.format(
                                                                                    str('\''+ tempAir +'\''),
                                                                                    str('\''+ humAir +'\''),
                                                                                    str('\''+ humSoil + '\''),
                                                                                    str('\''+ lum + '\''),
                                                                                    str(usuario),
                                                                                    str('\''+ id_local + '\'')))
    id_medida = PostgreDB.execute_query(sql)
    return 1

def excluir_medida(id_medida, usuario, id_local):
    sql = PostgreDB
    PostgreDB.set_query(
                        sql,
                        'SELECT main.fn_deletar_medicoes({}, {}, {})'.format(
                                                                            str('\''+ id_medida +'\''),
                                                                            str(usuario),
                                                                            str('\''+ id_local + '\'')))
    id_medida = PostgreDB.execute_query(sql)
    return 1

def cadastrar_usuario():
    print("Digite Seu Nome:")
    nome = input()
    print("Digite Sua Idade:")
    idade = input()
    print("Digite Seu Curso:")
    curso = input()
    sql = PostgreDB
    PostgreDB.set_query(
                        sql,
                        'SELECT main.fn_usuario({}, {}, {}, {}, NULL)'.format(
                                                                            str('\''+ 'I' +'\''),
                                                                            str('\''+ nome + '\''),
                                                                            str(idade),
                                                                            str('\'' + curso + '\'')))
    id_pessoa = PostgreDB.execute_query(sql)
    return id_pessoa[0]

def cadastrar_local(usuario):
    print("Digite O Nome Do Local")
    nome = input()
    print("Digite A Cidade:")
    cidade = input()
    print("Digite O Estado:")
    estado = input()
    print("Digite O Clima Do Local:")
    clima = input()
    sql = PostgreDB
    PostgreDB.set_query(
                        sql,
                        'SELECT main.fn_local({}, {}, {}, {}, {}, {}, NULL)'.format(
                                                                                    str('\''+ 'I' +'\''),
                                                                                    str(usuario),
                                                                                    str('\''+ nome + '\''),
                                                                                    str('\''+ cidade + '\''),
                                                                                    str('\'' + estado + '\''),
                                                                                    str('\''+ clima + '\'')))
    id_local = PostgreDB.execute_query(sql)
    return id_local[0]

def atualizar_usuario():
    print("Digite O Código De Usuário:")
    usuario = input()
    print("Digite O Novo Nome:")
    nome = input()
    print("Digite A Nova Idade:")
    idade = input()
    print("Digite O Novo Curso:")
    curso = input()
    sql = PostgreDB
    PostgreDB.set_query(
                        sql,
                        'SELECT main.fn_usuario({}, {}, {}, {}, {})'.format(
                                                                            str('\''+ 'U' +'\''),
                                                                            str('\''+ nome + '\''),
                                                                            str(idade),
                                                                            str('\'' + curso + '\''),
                                                                            str('\''+ usuario +'\'')))
    id_pessoa = PostgreDB.execute_query(sql)
    return id_pessoa[0]

def atualizar_local(usuario):
    print("Digite O Código Do Local:")
    local = input()
    print("Digite O Novo Nome Do Local")
    nome = input()
    print("Digite A Nova Cidade:")
    cidade = input()
    print("Digite O Novo Estado:")
    estado = input()
    print("Digite O Novo Clima Do Local:")
    clima = input()
    sql = PostgreDB
    PostgreDB.set_query(
                        sql,
                        'SELECT main.fn_local({}, {}, {}, {}, {}, {}, {})'.format(
                                                                                str('\''+ 'U' +'\''),
                                                                                str(usuario),
                                                                                str('\''+ nome + '\''),
                                                                                str('\''+ cidade + '\''),
                                                                                str('\'' + estado + '\''),
                                                                                str('\''+ clima + '\''),
                                                                                str('\''+ local + '\'')))
    id_local = PostgreDB.execute_query(sql)
    return id_local[0]

def main():
    usuario = -1

    sql = PostgreDB()

    PostgreDB.bd_connection(sql)
    time.sleep(1.5)

    while True:
        menu()
        choice = int(input())
        if choice == 8:
            break
        else:
            os.system('clear')
            usuario = command(choice, usuario)
            print("Deseja Realizar Outra Operação? [y/n]")
            continue_yn = input()
            if continue_yn == 'n':
                break

    PostgreDB.close_connection(sql)

if __name__ == '__main__':
    main()
