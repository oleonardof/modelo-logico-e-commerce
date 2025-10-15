-- SCRIPT COMPLETO (PostgreSQL)
-- Criação do esquema para desafio de e-commerce
BEGIN;

-- Tabelas principais
CREATE TABLE cliente (
  id_cliente SERIAL PRIMARY KEY,
  tipo CHAR(1) NOT NULL, -- 'F' = Pessoa Física, 'J' = Pessoa Jurídica
  nome_razao VARCHAR(255) NOT NULL,
  fname VARCHAR(60),
  lname VARCHAR(60),
  cpf VARCHAR(14) UNIQUE,   -- formato 000.000.000-00 (opcional)
  cnpj VARCHAR(18) UNIQUE,  -- formato 00.000.000/0000-00 (opcional)
  endereco VARCHAR(400),
  data_nasc DATE,
  CONSTRAINT chk_tipo_identificacao CHECK (
    (tipo = 'F' AND cpf IS NOT NULL AND cnpj IS NULL)
    OR (tipo = 'J' AND cnpj IS NOT NULL AND cpf IS NULL)
  )
);

CREATE TABLE produto (
  id_produto SERIAL PRIMARY KEY,
  sku VARCHAR(50) UNIQUE,
  nome VARCHAR(255) NOT NULL,
  categoria VARCHAR(100),
  preco NUMERIC(12,2) NOT NULL CHECK (preco >= 0)
);

CREATE TABLE fornecedor (
  id_fornecedor SERIAL PRIMARY KEY,
  razao_social VARCHAR(255) NOT NULL,
  cnpj VARCHAR(18) UNIQUE
);

CREATE TABLE fornecedor_produto (
  id_fornecedor INT NOT NULL REFERENCES fornecedor(id_fornecedor) ON DELETE CASCADE,
  id_produto INT NOT NULL REFERENCES produto(id_produto) ON DELETE CASCADE,
  preco_fornecedor NUMERIC(12,2),
  PRIMARY KEY (id_fornecedor, id_produto)
);

CREATE TABLE estoque (
  id_estoque SERIAL PRIMARY KEY,
  localizacao VARCHAR(255),
  data_ultima_atualizacao TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE produto_estoque (
  id_produto INT NOT NULL REFERENCES produto(id_produto) ON DELETE CASCADE,
  id_estoque INT NOT NULL REFERENCES estoque(id_estoque) ON DELETE CASCADE,
  quantidade INT NOT NULL CHECK (quantidade >= 0),
  PRIMARY KEY (id_produto, id_estoque)
);

CREATE TABLE pedido (
  id_pedido SERIAL PRIMARY KEY,
  id_cliente INT NOT NULL REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
  status VARCHAR(40) NOT NULL,
  descricao TEXT,
  frete NUMERIC(10,2) DEFAULT 0,
  data_pedido TIMESTAMP NOT NULL DEFAULT now(),
  data_entrega TIMESTAMP
);

CREATE TABLE produto_pedido (
  id_produto INT NOT NULL REFERENCES produto(id_produto) ON DELETE RESTRICT,
  id_pedido INT NOT NULL REFERENCES pedido(id_pedido) ON DELETE CASCADE,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario NUMERIC(12,2) NOT NULL CHECK (preco_unitario >= 0),
  PRIMARY KEY (id_produto, id_pedido)
);

-- Forma de pagamento (um cliente pode ter várias formas)
CREATE TABLE forma_pagamento (
  id_forma_pagamento SERIAL PRIMARY KEY,
  id_cliente INT NOT NULL REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  tipo_pagamento VARCHAR(50) NOT NULL, -- ex: CARTAO, BOLETO, PIX
  dados_referencia VARCHAR(200) -- ex: último 4 dígitos do cartão ou chave PIX
);

-- Pagamentos efetivos por pedido (um pedido pode ter vários pagamentos/parcelas)
CREATE TABLE pagamento (
  id_pagamento SERIAL PRIMARY KEY,
  id_pedido INT NOT NULL REFERENCES pedido(id_pedido) ON DELETE CASCADE,
  id_forma_pagamento INT REFERENCES forma_pagamento(id_forma_pagamento) ON DELETE SET NULL,
  valor NUMERIC(12,2) NOT NULL CHECK (valor >= 0),
  status_pagamento VARCHAR(30) NOT NULL, -- ex: PAGO, PENDENTE, ESTORNADO
  data_pagamento TIMESTAMP,
  codigo_transacao VARCHAR(120),
  parcelas INT DEFAULT 1,
  observacoes TEXT
);

CREATE TABLE entrega (
  id_entrega SERIAL PRIMARY KEY,
  id_pedido INT NOT NULL REFERENCES pedido(id_pedido) ON DELETE CASCADE,
  codigo_rastreio VARCHAR(80),
  status_entrega VARCHAR(30) NOT NULL, -- ex: PREPARANDO, ENVIADO, ENTREGUE, DEVOLVIDO
  data_atualizacao TIMESTAMP DEFAULT now()
);

-- Vendedor terceiro e relação com produtos (marketplace)
CREATE TABLE terceiro_vendedor (
  id_terceiro_vendedor SERIAL PRIMARY KEY,
  razao_social VARCHAR(255) NOT NULL,
  identificador VARCHAR(100) -- CNPJ/CPF/opcional
);

CREATE TABLE terceiro_produto (
  id_terceiro_vendedor INT NOT NULL REFERENCES terceiro_vendedor(id_terceiro_vendedor) ON DELETE CASCADE,
  id_produto INT NOT NULL REFERENCES produto(id_produto) ON DELETE CASCADE,
  quantidade INT NOT NULL CHECK (quantidade >= 0),
  preco NUMERIC(12,2),
  PRIMARY KEY (id_terceiro_vendedor, id_produto)
);

COMMIT;
