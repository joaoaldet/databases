DROP DATABASE IF EXISTS ECOMMERCE;
CREATE DATABASE IF NOT EXISTS ECOMMERCE;
USE ECOMMERCE;

CREATE TABLE IF NOT EXISTS Produto(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    descricao TEXT
);

#Parte 1:
# a)
CREATE USER 'dev_junior'@'%';
# b)
GRANT SELECT ON ECOMMERCE.* TO 'dev_junior'@'%';
# c)
GRANT INSERT ON ECOMMERCE.* TO 'dev_junior';
# d)
REVOKE INSERT ON ECOMMERCE.* FROM 'dev_junior';

#Parte 2:
# a)
CREATE ROLE 'role_vendas';
# b)
GRANT SELECT (nome) ON ECOMMERCE.Produto TO 'role_vendas';
GRANT SELECT (preco) ON ECOMMERCE.Produto TO 'role_vendas';
# c)
CREATE USER 'vendedor_1';
GRANT 'role_vendas' TO 'vendedor_1';
# d)
/*
Supondo que ele tente acessar a tabela Produto, o comando 'SELECT *' não funcionaria,
uma vez que o papel atribuído ao vendedor 1 possui permissão de acessar apenas as
colunas nome e preço da tabela Produto.
*/
