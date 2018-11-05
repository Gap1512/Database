#!/usr/bin/python

import time
import serial


class Arduino:
    connectionArduino = serial.Serial()

    def __init__(self):
        self.connectionArduino.port = ("/dev/ttyACM0")
        self.connectionArduino.baudrate = 9600

    def connectArduino(self):
        try:
            self.connectionArduino.open()

        except Exception as e:
            print("Erro Ao Abrir A Porta Serial: " + str(e))

    def readMeasures(self):
        if self.connectionArduino.isOpen():
            rawData = []

            try:
                self.connectionArduino.flushInput() #flush input buffer, discarding all its contents
                self.connectionArduino.flushOutput()#flush output buffer, aborting current output
                         #and discard all that is in buffer
                print("\n ---------------OPÇÕES--------------- \n"
                      "|[r]     Força A Leitura Das Medições|\n"
                      "|[w]            Recebe Os Dados Lidos|\n"
                      "|[t]                     Liga A Bomba|\n"
                      "|[o]                  Desliga A Bomba|\n")
                op_write = (input("Qual A Opção Desejada? "))

                self.connectionArduino.write(str.encode(op_write))
                rawData = str(self.connectionArduino.readline()).strip("\\r\\n\'\"\"").strip("\"b\'")
                return rawData
                #print(rawData)

            except Exception as e:
                print("Erro Ao Enviar Ou Receber Dados: " + str(e))
            finally:
                self.connectionArduino.close()

        else:
            print ("Serial Não Conectado")
