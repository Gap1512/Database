--Recuperando itens que estao no estoque
SELECT i.id_item, i.ds_item, e.quantidade
FROM sch01.tb_estoque e, sch01.tb_item i
WHERE i.id_item = e.id_item;

--Mesma query utilizando INNER JOIN
SELECT i.id_item, i.ds_item, e.quantidade
FROM sch01.tb_item i
INNER JOIN sch01.tb_estoque e
ON i.id_item = e.id_item;

--Selecionar os registros que tem estoque,
--incluindo as ocorrências
SELECT i.id_item, i.ds_item, e.quantidade
FROM sch01.tb_item i
LEFT JOIN sch01.tb_estoque e
ON i.id_item = e.id_item;

--Selecionar os registros que não tem estoque
SELECT i.id_item, i.ds_item, e.quantidade
FROM sch01.tb_item i
LEFT JOIN sch01.tb_estoque e
ON i.id_item = e.id_item
WHERE e.id_item IS NULL;

--Listar todos os clientes que fizeram algum pedido
SELECT c.id_cliente, c.nome, c.sobrenome
FROM sch01.tb_cliente c
RIGHT JOIN sch01.tb_pedido p
ON p.id_cliente = c.id_cliente

--Seleciona os itens que o cliente comprou
SELECT p.id_pedido, c.id_cliente, c.nome,
it.id_item, i.ds_item, it.quantidade,
i.preco_venda * it.quantidade AS valor_total
FROM sch01.tb_pedido p
INNER JOIN sch01.tb_item_pedido it
  ON p.id_pedido = it.id_pedido
INNER JOIN sch01.tb_cliente c
  ON p.id_cliente = c.id_cliente
INNER JOIN sch01.tb_item i
  ON it.id_item = i.id_item

--Exibe o total que um cliente consumiu e quantos pedidos ele fez
SELECT c.id_cliente, c.nome,
  SUM(i.preco_venda * it.quantidade) AS valor_total,
  COUNT(p.id_pedido)
FROM sch01.tb_pedido p
INNER JOIN sch01.tb_item_pedido it
  ON p.id_pedido = it.id_pedido
INNER JOIN sch01.tb_cliente c
  ON p.id_cliente = c.id_cliente
INNER JOIN sch01.tb_item i
  ON  it.id_item = i.id_item
GROUP BY c.id_cliente
