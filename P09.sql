--Views e Tabelas Temporárias

--Views
CREATE OR REPLACE VIEW sch01.vs_status_estoque AS
  SELECT i.ds_item, e.quantidade
  FROM sch01.tb_item i
  JOIN sch01.tb_estoque e ON (i.id_item = e.id_item);

SELECT * FROM sch01.vs_status_estoque;

--Heranças em tabelas
CREATE TABLE sch01.tb_cidades (
  nome TEXT,
  populacao FLOAT,
  altitude INT
);

SELECT * FROM sch01.tb_cidades;

CREATE TABLE sch01.tb_capitais (
  uf CHAR(2),
  LIKE sch01.tb_cidades
);

SELECT * FROM sch01.tb_capitais;

CREATE TABLE sch01.tb_cidades_2 (
  id INTEGER PRIMARY KEY,
  nome TEXT,
  populacao FLOAT,
  altitude INT
);

SELECT * FROM sch01.tb_cidades_2;

CREATE TABLE sch01.tb_capitais_2 (
  uf CHAR(2),
  LIKE sch01.tb_cidades_2
);

SELECT * FROM sch01.tb_capitais_2;

--Ao modificar a tabela sch01.tb_capitais_3, a tabela cidades_2 será modificada, também
CREATE TABLE sch01.tb_capitais_3 (
  uf CHAR(2),
) INHERITS (sch01.tb_cidades_2);

SELECT * FROM sch01.tb_capitais_3;

CREATE TEMP TABLE tb_teste (
  chave1 INT,
  chave2 INT
);

INSERT INTO tb_teste VALUES (1, 1);
INSERT INTO tb_teste VALUES (2, 2);
INSERT INTO tb_teste VALUES (3, 3);

--Ao desconectar-se do banco, as tabelas temporarias são dropadas
SELECT * FROM tb_teste;

--Instalar Virtual Box (64B, Ubuntu)
