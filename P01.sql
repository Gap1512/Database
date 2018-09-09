CREATE SCHEMA sch01;

CREATE TABLE sch01.tb_clientes (
	id_cliente INTEGER,
	titulo CHAR(4),
	nome VARCHAR(32),
	sobrenome VARCHAR(32),
	endereco VARCHAR(62),
	numero VARCHAR(5),
	complemento VARCHAR(62),
	cep VARCHAR(10),
	cidade VARCHAR(62),
	estado CHAR(2),
	fone_fixo VARCHAR(15),
	fone_movel VARCHAR(15),
	fg_ativo INTEGER,
	CONSTRAINT clientes_id_cliente_pk PRIMARY KEY (id_cliente)
)

CREATE TABLE sch01.tb_pedido (
	id_pedido INTEGER,
	id_cliente INTEGER,
	dt_compra TIMESTAMP,
	dt_entrega TIMESTAMP,
	valor NUMERIC(7,2),
	fg_ativo INTEGER,
	CONSTRAINT pedido_id_pedido_pk PRIMARY KEY (id_pedido),
	CONSTRAINT pedido_id_cliente_fk FOREIGN KEY (id_cliente) REFERENCES sch01.tb_clientes (id_cliente)
)

CREATE TABLE sch01.tb_item (
	id_item INTEGER,
	ds_item VARCHAR(64),
	preco_custo NUMERIC(7,2),
	preco_venda NUMERIC(7,2),
	fg_ativo INTEGER,
	CONSTRAINT item_id_item_pk PRIMARY KEY (id_item)
)

CREATE TABLE sch01.tb_item_pedido (
	id_item INTEGER,
	id_pedido INTEGER,
	quantidade INTEGER,
	CONSTRAINT item_id_item_fk FOREIGN KEY (id_item) REFERENCES sch01.tb_item (id_item),
	CONSTRAINT item_id_pedido_fk FOREIGN KEY (id_pedido) REFERENCES sch01.tb_pedido (id_pedido)	
)

CREATE TABLE sch01.tb_estoque (
	id_item INTEGER,
	quantidade INTEGER,
	CONSTRAINT estoque_id_item_fk FOREIGN KEY (id_item) REFERENCES sch01.tb_item (id_item)
)

CREATE TABLE sch01.tb_codigo_barras (
	codigo_barras INTEGER,
	id_item INTEGER,
	CONSTRAINT codigo_barras_id_item_fk FOREIGN KEY (id_item) REFERENCES sch01.tb_item (id_item)
)

ALTER TABLE sch01.tb_clientes RENAME TO tb_cliente;

ALTER TABLE sch01.tb_item_pedido
	ADD CONSTRAINT item_pedido_id_item_id_pedido_pk PRIMARY KEY (id_item, id_pedido);
	
ALTER TABLE sch01.tb_estoque ADD CONSTRAINT estoque_id_item_pk PRIMARY KEY (id_item);

INSERT INTO sch01.tb_cliente (id_cliente, nome, sobrenome, endereco, numero, cidade) 
	VALUES (1, 'Peter', 'Parker', 'Ingram Street', '20', 'New York');
	
INSERT INTO sch01.tb_item (id_item, ds_item, preco_custo, preco_venda) 
	VALUES (1, 'Web Shooter', 50.25, 100), (2, 'Spider Costume', 60, 90.65);
			
INSERT INTO sch01.tb_codigo_barras VALUES (111111, 1), (222222, 2);

INSERT INTO sch01.tb_estoque VALUES (1, 100), (2, 2);

INSERT INTO sch01.tb_pedido (id_pedido, id_cliente, dt_compra, dt_entrega, valor) 
	VALUES (1, 1,'15-02-2018','18-02-2018', 190.65);
	
INSERT INTO sch01.tb_item_pedido VALUES (1, 1, 1), (2, 1, 2);

SELECT * FROM sch01.tb_cliente;

SELECT * FROM sch01.tb_pedido;

SELECT * FROM sch01.tb_item_pedido;

SELECT * FROM sch01.tb_item;

SELECT * FROM sch01.tb_codigo_barras;

SELECT * FROM sch01.tb_estoque;