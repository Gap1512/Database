-- Tarefa 02
-- Gustavo Alves Pacheco
-- 11821ECP011

CREATE GROUP Estagiário; --Pode Apenas Visualizar Informações
GRANT USAGE ON SCHEMA aulas TO Estagiário;
GRANT SELECT ON aulas.tb_cliente TO GROUP Estagiário;
GRANT SELECT ON aulas.tb_codigo_barras TO GROUP Estagiário;
GRANT SELECT ON aulas.tb_estoque TO GROUP Estagiário;
GRANT SELECT ON aulas.tb_item TO GROUP Estagiário;
GRANT SELECT ON aulas.tb_item_pedido TO GROUP Estagiário;
GRANT SELECT ON aulas.tb_pedido TO GROUP Estagiário;

CREATE GROUP Analista; --Pode Modificar Registros (Select, Insert, Update e Delete)
GRANT USAGE ON SCHEMA aulas TO Analista;
GRANT SELECT, INSERT, UPDATE, DELETE
	ON aulas.tb_cliente TO GROUP Analista;
GRANT SELECT, INSERT, UPDATE, DELETE
	ON aulas.tb_codigo_barras TO GROUP Analista;
GRANT SELECT, INSERT, UPDATE, DELETE
	ON aulas.tb_estoque TO GROUP Analista;
GRANT SELECT, INSERT, UPDATE, DELETE
	ON aulas.tb_item TO GROUP Analista;
GRANT SELECT, INSERT, UPDATE, DELETE
	ON aulas.tb_item_pedido TO GROUP Analista;
GRANT SELECT, INSERT, UPDATE, DELETE
	ON aulas.tb_pedido TO GROUP Analista;

CREATE GROUP Gerente; --Acesso Total
GRANT USAGE ON SCHEMA aulas TO Analista;
GRANT ALL ON SCHEMA aulas TO GROUP Gerente;

-- Testes
CREATE USER user1 WITH PASSWORD '123' LOGIN;
CREATE USER user2 WITH PASSWORD '123' LOGIN;
CREATE USER user3 WITH PASSWORD '123' LOGIN;
ALTER GROUP Estagiário ADD USER user1;
ALTER GROUP Analista ADD USER user2;
ALTER GROUP Gerente ADD USER user3;
