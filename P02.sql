SELECT COUNT(*), cidade FROM sch01.tb_cliente
GROUP BY cidade HAVING COUNT(*) > 1; --Conta os registros agrupados por cidade e exibe apenas os maiores que '1'

SELECT DISTINCT(sobrenome) FROM aulas.tb_cliente;

SELECT COUNT(DISTINCT(sobrenome)) AS sobrenomes_unicos,
  COUNT(sobrenome) AS sobrenomes_com_duplicidade
  FROM sch01.tb_cliente; --'As' determina o título da coluna resultante

SELECT AVG(preco_custo) FROM sch01.tb_item; --Exibe a média dos valores

SELECT MIN(preco_custo) FROM sch01.tb_item; --Exibe o valor mínimo

SELECT MAX(preco_custo) FROM sch01.tb_item; --Exibe o valor máximo

SELECT ds_item, preco_custo FROM sch01.tb_item
  WHERE preco_custo = (SELECT MIN(preco_custo) FROM sch01.tb_item)
  ORDER BY preco_custo;

SELECT COUNT(id_cliente) FROM sch01.tb_cliente; --Conta apenas registros válidos

SELECT AVG(preco_venda)::NUMERIC(7,2) FROM sch01.tb_item; --Exibe resultado formatado

SELECT CAST(AVG(preco_venda) AS NUMERIC(7,2)) AS "Média" FROM sch01.tb_item --Exibe a média formatada e intitula a coluna

SELECT ds_item,preco_venda FROM sch01.tb_item WHERE preco_venda >
  (SELECT AVG(preco_venda) FROM sch01.tb_item) ORDER BY preco_venda; --Subquery: Resultado de um SELECT é utilizado como parâmetro para outro SELECT

SELECT ds_item, preco_venda, preco_custo FROM sch01.tb_item WHERE
  preco_venda > (SELECT AVG(preco_venda) FROM sch01.tb_item)
  AND
  preco_custo > (SELECT AVG(preco_custo) FROM sch01.tb_item)
  ORDER BY preco_venda;

SELECT sch01.tb_pedido.dt_compra, sch01.tb_compras.dt_compra
  FROM sch01.tb_pedido sch01.tb_compras;

SELECT p.dt_compra FROM sch01.tb_pedido p;

SELECT p.dt_compra, p.id_cliente FROM sch01.tb_pedido p
WHERE p.id_cliente =
(SELECT c.id_cliente FROM sch01.tb_cliente c
  WHERE c.id_cliente = p.id_cliente);

SELECT p.dt_compra, p.id_cliente FROM sch01.tb_pedido p
  WHERE p.id_cliente =
  (SELECT c.id_cliente FROM sch01.tb_cliente c
  WHERE c.id_cliente = p.id_cliente AND c.nome = 'Alex')
  ORDER BY id_cliente;

SELECT c.id_cliente, nome, sobrenome
FROM sch01.tb_cliente c WHERE EXISTS (
  SELECT 1
  FROM sch01.tb_pedido P
  WHERE p.id_cliente = c.id_cliente
);
