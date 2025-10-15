-- POPULAÇÃO DE DADOS PARA TESTES (INSERTs)
BEGIN;

-- Clientes PF e PJ
INSERT INTO cliente (tipo, nome_razao, fname, lname, cpf, endereco, data_nasc)
VALUES
('F', 'João Silva', 'João', 'Silva', '111.111.111-11', 'Rua A, 100', '1990-05-10'),
('F', 'Maria Souza', 'Maria', 'Souza', '222.222.222-22', 'Av B, 200', '1985-07-20');

INSERT INTO cliente (tipo, nome_razao, cnpj, endereco)
VALUES
('J', 'Empresa X LTDA', '12.345.678/0001-90', 'Av Comércio, 500'),
('J', 'Loja Y ME', '98.765.432/0001-11', 'Rua do Comércio, 10');

-- Produtos
INSERT INTO produto (sku, nome, categoria, preco) VALUES
('SKU-100','Caderno 100 folhas','Papelaria',12.50),
('SKU-101','Caneta Azul','Papelaria',2.30),
('SKU-200','Mouse USB','Eletrônicos',45.00),
('SKU-201','Teclado Membrana','Eletrônicos',120.00);

-- Fornecedores
INSERT INTO fornecedor (razao_social, cnpj) VALUES
('Fornecedor A','11.111.111/0001-11'),
('Fornecedor B','22.222.222/0001-22');

-- Relacionamento fornecedor-produto
INSERT INTO fornecedor_produto (id_fornecedor, id_produto, preco_fornecedor) VALUES
(1,1,8.00),(1,2,1.00),(2,3,30.00),(2,4,80.00);

-- Estoques e quantidades
INSERT INTO estoque (localizacao) VALUES ('Galpão SP'),('Loja RJ');
INSERT INTO produto_estoque (id_produto, id_estoque, quantidade) VALUES
(1,1,100),(2,1,500),(3,1,50),(4,2,20);

-- Vendedores terceiros
INSERT INTO terceiro_vendedor (razao_social, identificador) VALUES
('Vendedor Terreno','33.333.333/0001-33');

INSERT INTO terceiro_produto (id_terceiro_vendedor, id_produto, quantidade, preco) VALUES
(1,3,10,40.00);

-- Pedidos (vários)
INSERT INTO pedido (id_cliente, status, descricao, frete, data_pedido) VALUES
(1,'ENTREGUE','Pedido 1 - materiais',10.00,'2025-09-01 10:00'),
(2,'ENVIADO','Pedido 2 - material escolar',8.00,'2025-09-02 11:30'),
(3,'PENDENTE','Pedido 3 - venda corporativa',0.00,'2025-09-03 09:00');

-- Itens dos pedidos (produto_pedido)
-- pedido 1 (id_pedido = 1)
INSERT INTO produto_pedido (id_produto, id_pedido, quantidade, preco_unitario) VALUES
(1,1,2,12.50),(2,1,5,2.30);

-- pedido 2 (id_pedido = 2)
INSERT INTO produto_pedido (id_produto, id_pedido, quantidade, preco_unitario) VALUES
(1,2,1,12.50),(3,2,1,45.00);

-- pedido 3 (id_pedido = 3)
INSERT INTO produto_pedido (id_produto, id_pedido, quantidade, preco_unitario) VALUES
(4,3,2,120.00);

-- Formas de pagamento dos clientes
INSERT INTO forma_pagamento (id_cliente, tipo_pagamento, dados_referencia) VALUES
(1,'CARTAO','Visa **** 1234'),
(2,'PIX','chave: maria@pix'),
(3,'BOLETO','Banco XYZ');

-- Pagamentos efetuados
INSERT INTO pagamento (id_pedido, id_forma_pagamento, valor, status_pagamento, data_pagamento, codigo_transacao, parcelas) VALUES
(1,1, (2*12.5 + 5*2.3 + 10.00) , 'PAGO','2025-09-02 15:00','TX100',1),
(2,2, (1*12.5 + 1*45.0 + 8.00) , 'PAGO','2025-09-03 10:00','TX101',1);

-- Entregas
INSERT INTO entrega (id_pedido, codigo_rastreio, status_entrega, data_atualizacao) VALUES
(1,'BR123456789BR','ENTREGUE','2025-09-05 12:00'),
(2,'BR987654321BR','EM ROTA','2025-09-04 09:00');

COMMIT;
