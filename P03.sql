--Exercícios

--Recuperando todos os itens
SELECT * FROM sch01.tb_item;
SELECT * FROM sch01.tb_estoque;

--Recuperando itens que estao no estoque
SELECT i.id_item, i.ds_item, e.quantidade
FROM sch01.tb_estoque e, sch01.tb_item i
WHERE i.id_item = e.id_item;

--Recuperando itens que nao estao no estoque
SELECT i.id_item, i.ds_item
FROM sch01.tb_item i
WHERE i.id_item NOT IN(SELECT i.id_item FROM sch01.tb_estoque e, sch01.tb_item i WHERE i.id_item = e.id_item)

--Recuperando todos os itens (estoque união sem estoque)
SELECT i.id_item, i.ds_item, e.quantidade
FROM sch01.tb_estoque e, sch01.tb_item i
WHERE i.id_item = e.id_item
UNION
SELECT i.id_item, i.ds_item, '0'::INTEGER
FROM sch01.tb_item i
WHERE i.id_item NOT IN(SELECT i.id_item FROM sch01.tb_estoque e, sch01.tb_item i WHERE i.id_item = e.id_item)
ORDER BY id_item;

--Recuperando todos os pedidos, com id_pedido, o id do cliente e o nome do cliente
SELECT p.id_pedido, c.id_cliente, c.nome
FROM sch01.tb_pedido p, sch01.tb_cliente c
WHERE p.id_cliente = c.id_cliente
ORDER BY id_cliente;

--Recuperando os itens dos pedidos, descrição dos produtos e o valor de cada item
SELECT ip.id_pedido, i.id_item, i.ds_item,
ip.quantidade, i.preco_venda,
ip.quantidade * i.preco_venda AS "total_item"
FROM sch01.tb_item i, sch01.tb_item_pedido ip WHERE i.id_item = ip.id_item

--Agrupando os pedidos e exibindo o valor total de cada pedidos
SELECT ip.id_pedido,
SUM(ip.quantidade * i.preco_venda) AS "total_pedido"
FROM sch01.tb_item_pedido ip, sch01.tb_item i
WHERE ip.id_item = i.id_item
GROUP BY ip.id_pedido ORDER BY ip.id_pedido

--Recuperar o total do pedido e o nome do id_cliente
SELECT p.id_pedido, p.id_cliente,
  (SELECT c.nome FROM sch01.tb_cliente c
    WHERE c.id_cliente = p.id_cliente),
  (SELECT SUM(ip.quantidade * i.preco_venda) AS "total_pedido"
    FROM sch01.tb_item_pedido ip, sch01.tb_item i
    WHERE ip.id_item = i.id_item AND p.id_pedido = ip.id_pedido
    GROUP BY ip.id_pedido)
FROM sch01.tb_pedido p, sch01.tb_cliente c
WHERE p.id_cliente = c.id_cliente

--pgModeler: Ferramenta para modelo lógico
