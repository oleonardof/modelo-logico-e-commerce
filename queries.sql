-- QUERIES EXIGIDAS (exemplos e perguntas respondidas)
-- 1) Recuperações simples com SELECT
-- Pergunta: Liste todos os produtos com preço maior que 20 ordenados por preço decrescente
SELECT id_produto, sku, nome, preco
FROM produto
WHERE preco > 20
ORDER BY preco DESC;

-- 2) Filtros com WHERE + JOIN
-- Pergunta: Quais pedidos foram feitos pelo cliente com CPF '111.111.111-11'?
SELECT p.id_pedido, p.status, p.data_pedido, p.frete
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE c.cpf = '111.111.111-11';

-- 3) Atributos derivados (expressões) - total do pedido (soma itens + frete)
-- Pergunta: Mostre id_pedido, total_itens, frete, total_geral
SELECT
  p.id_pedido,
  SUM(pp.quantidade * pp.preco_unitario) AS total_itens,
  p.frete,
  SUM(pp.quantidade * pp.preco_unitario) + COALESCE(p.frete,0) AS total_geral
FROM pedido p
JOIN produto_pedido pp ON pp.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.frete
ORDER BY total_geral DESC;

-- 4) GROUP BY + HAVING
-- Pergunta: Quantos pedidos cada cliente fez? Mostrar apenas clientes com mais de 1 pedido
SELECT
  c.id_cliente,
  c.nome_razao,
  COUNT(p.id_pedido) AS qtd_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome_razao
HAVING COUNT(p.id_pedido) > 1;

-- 5) Junções entre várias tabelas (perspectiva complexa)
-- Pergunta: Relação de fornecedores com produtos e estoques (nome fornecedor, produto, qtd em estoque)
SELECT
  f.razao_social AS fornecedor,
  pr.nome AS produto,
  COALESCE(SUM(pe.quantidade),0) AS quantidade_estoque
FROM fornecedor f
JOIN fornecedor_produto fp ON fp.id_fornecedor = f.id_fornecedor
JOIN produto pr ON pr.id_produto = fp.id_produto
LEFT JOIN produto_estoque pe ON pe.id_produto = pr.id_produto
GROUP BY f.razao_social, pr.nome
ORDER BY f.razao_social, pr.nome;

-- 6) Pergunta: Algum vendedor também é fornecedor?
-- Estratégia: comparar razao_social / identificador entre tabelas terceiro_vendedor e fornecedor
SELECT
  tv.id_terceiro_vendedor,
  tv.razao_social AS vendedor,
  f.id_fornecedor,
  f.razao_social AS fornecedor
FROM terceiro_vendedor tv
JOIN fornecedor f ON tv.razao_social ILIKE f.razao_social
-- usa ILIKE para casamentos case-insensitive; pode não retornar nada se nomes diferentes

-- 7) Pergunta: Relação nomes dos fornecedores e nomes dos produtos (lista simples)
SELECT f.razao_social, p.nome
FROM fornecedor f
JOIN fornecedor_produto fp ON fp.id_fornecedor = f.id_fornecedor
JOIN produto p ON p.id_produto = fp.id_produto
ORDER BY f.razao_social, p.nome;

-- 8) Query mais complexa: Top 5 clientes por valor total comprado (considera soma dos itens + frete)
SELECT
  c.id_cliente,
  c.nome_razao,
  SUM(pp.quantidade * pp.preco_unitario) + COALESCE(p.frete,0) AS total_pedido,
  SUM(SUM(pp.quantidade * pp.preco_unitario) + COALESCE(p.frete,0)) OVER (PARTITION BY c.id_cliente) AS total_comprado
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
JOIN produto_pedido pp ON pp.id_pedido = p.id_pedido
GROUP BY c.id_cliente, c.nome_razao, p.id_pedido, p.frete
ORDER BY total_comprado DESC
LIMIT 5;

-- 9) Query com WHERE, JOIN e ORDER BY: listar pedidos pendentes com itens
SELECT
  p.id_pedido,
  c.nome_razao AS cliente,
  p.status,
  p.data_pedido,
  SUM(pp.quantidade * pp.preco_unitario) AS valor_itens
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
JOIN produto_pedido pp ON pp.id_pedido = p.id_pedido
WHERE p.status = 'PENDENTE'
GROUP BY p.id_pedido, c.nome_razao, p.status, p.data_pedido
ORDER BY p.data_pedido ASC;

-- 10) Consulta usando HAVING para estoques baixos
-- Pergunta: Produtos com estoque total menor que 20 unidades
SELECT pr.id_produto, pr.nome, SUM(pe.quantidade) AS total_estoque
FROM produto pr
JOIN produto_estoque pe ON pe.id_produto = pr.id_produto
GROUP BY pr.id_produto, pr.nome
HAVING SUM(pe.quantidade) < 20
ORDER BY total_estoque ASC;
