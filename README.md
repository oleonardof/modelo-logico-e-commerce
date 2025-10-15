## Contexto
Modelo lógico de banco de dados para um cenário de e-commerce que contempla:
- Clientes (Pessoa Física ou Jurídica);
- Produtos, Fornecedores e relação entre eles;
- Estoques distribuídos;
- Pedidos com itens (produto_pedido);
- Entregas com código de rastreio e status;
- Pagamentos (associação entre pedido e formas de pagamento);
- Vendedores terceiros (marketplace) e seus produtos.

## Regras de negócio / restrições importantes
- Um cliente é **ou** Pessoa Física **ou** Jurídica (`tipo = 'F'` ou `'J'`), com checagem que exige CPF para PF e CNPJ para PJ.
- Um cliente pode ter **múltiplas formas de pagamento** (cartão, pix, boleto).
- Um pedido pode ter **vários pagamentos** (parcelas, pagamentos parciais).
- Entrega possui `codigo_rastreio` e `status_entrega` (rastreamento).
- Fornecedor-produto e terceiro_vendedor-produto são modelados como relacionamentos N:N via tabelas de junção.

## Entregáveis
- `schema.sql` — script de criação de tabelas (PostgreSQL).
- `seed.sql` — inserts de exemplo para testes.
- `queries.sql` — exemplos de consultas que usam SELECT, WHERE, JOIN, GROUP BY, HAVING, ORDER BY e expressões derivadas.
- `README.md` — descrição do projeto lógico e instruções.

## Exemplos de perguntas respondidas pelas queries
- Quantos pedidos cada cliente fez?
- Quais pedidos foram feitos por um cliente específico (CPF/CNPJ)?
- Qual o total (valor itens + frete) por pedido?
- Quais fornecedores fornecem cada produto e qual o estoque disponível?
- Algum vendedor é também fornecedor (possível checagem por nome/identificador)?
- Quais produtos estão com estoque baixo?

## Observações para avaliação
- Script preparado para PostgreSQL (tipos `SERIAL`, `TIMESTAMP`, `NUMERIC`).
- Constraints e checks implementados (ex.: verificação PF/PJ).
- Recomenda-se ajustar formatação e validação de CPF/CNPJ na camada de aplicação ou via funções/expressões regulares no banco, se necessário.
- Para produção considerar índices adicionais (ex: índices em `produto.nome`, `pedido.data_pedido`, `fornecedor.razao_social`) e políticas de integridade referencial (ON DELETE/ON UPDATE) conforme regras do negócio.

