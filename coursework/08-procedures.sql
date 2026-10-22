-- Exercícios Procedures e Functions - Cantina
-- Escreva cada resolução no espaço abaixo da questão correspondente.
-- Lembre-se: use DELIMITER $$ para criar procedures/functions e volte com DELIMITER ; ao final.

DROP DATABASE IF EXISTS cantina;
CREATE DATABASE cantina;
USE cantina;

-- Considere a seguinte tabela:

CREATE TABLE Produto (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	categoria VARCHAR(45) NOT NULL,
	preco DECIMAL(8,2) NOT NULL,
	estoque INT NOT NULL
);

-- Inserir produtos
INSERT INTO Produto (nome, categoria, preco, estoque) VALUES
('Coxinha', 'Salgado', 6.50, 30),
('Pastel', 'Salgado', 8.00, 8),
('Suco Natural', 'Bebida', 7.00, 20),
('Refrigerante', 'Bebida', 5.50, 5),
('Pão de Queijo', 'Salgado', 4.00, 40),
('Brownie', 'Doce', 9.00, 12);

-- ================= PARTE 1: PROCEDURES =================

-- Questão 1:
-- Crie uma procedure chamada AplicarDesconto que receba o id de um produto e um
-- percentual de desconto e reduza o preço desse produto de acordo com o percentual.
-- Ao final, a procedure deve exibir a mensagem 'Desconto aplicado!' como Resultado.
-- Depois, chame a procedure para dar 10% de desconto na Coxinha (id 1) e confira o preço.
-- (Dica: o nome do parâmetro não pode ser igual ao nome da coluna, senão WHERE id = id
-- é sempre verdadeiro e altera todas as linhas.)

DELIMITER $$

DROP PROCEDURE IF EXISTS AplicarDesconto$$

CREATE PROCEDURE AplicarDesconto(
	IN produto_id INT,
    IN percentual_desconto DECIMAL(5, 2)
)
BEGIN
	UPDATE Produto
    SET preco = preco * (1 - (percentual_desconto) / 100)
    WHERE id = produto_id;
    
    SELECT 'Desconto aplicado!' AS Resultado;
END $$
DELIMITER ;

CALL AplicarDesconto(1, 10.0);
SELECT preco FROM Produto;


-- Questão 2:
-- Crie uma procedure chamada ReporEstoque que receba o id de um produto e uma
-- quantidade e some essa quantidade ao estoque do produto.
-- Depois, reponha 20 unidades do Refrigerante (id 4) e confira o estoque.

DELIMITER $$

DROP PROCEDURE IF EXISTS ReporEstoque$$

CREATE PROCEDURE ReporEstoque(
	IN produto_id INT,
    IN quantidade INT
)
BEGIN
	UPDATE Produto
    SET estoque = estoque + quantidade
    WHERE id = produto_id;
    
    SELECT 'Estoque foi abastecido!' AS Resultado;
END $$
DELIMITER ;

CALL ReporEstoque(4, 20);
SELECT estoque FROM Produto;


-- ================= PARTE 2: FUNCTIONS =================

-- Questão 3:
-- Crie uma function chamada ValorEmEstoque que receba o preço e a quantidade de
-- um produto e retorne o valor total (preço x quantidade).
-- Depois, use-a em um SELECT para mostrar o nome de cada produto e seu valor em estoque.

DELIMITER $$

DROP FUNCTION IF EXISTS ValorEmEstoque$$

CREATE FUNCTION ValorEmEstoque(preco DECIMAL, estoque INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
	RETURN preco * estoque;
END $$

DELIMITER ;

SELECT ValorEmEstoque(preco, estoque) AS Resultado FROM Produto;


-- Questão 4 (Desafio):
-- Crie uma function chamada SituacaoEstoque que receba uma quantidade e retorne
-- 'Baixo' se ela for menor que 10 e 'Ok' caso contrário.
-- Depois, use-a em um SELECT para mostrar o nome, o estoque e a situação de cada produto.

DELIMITER $$

DROP FUNCTION IF EXISTS SituacaoEstoque$$

CREATE FUNCTION SituacaoEstoque(estoque INT)
RETURNS VARCHAR(5)
DETERMINISTIC
BEGIN
	IF estoque < 10 THEN
		RETURN 'Baixo';
	ELSE
		RETURN 'Ok';
	END IF;
END $$

DELIMITER ;

SELECT nome, estoque, SituacaoEstoque(estoque) AS Resultado FROM Produto;


-- ================= LIMPEZA =================

-- Questão 5:
-- Apague todas as procedures e functions criadas neste exercício.

DROP PROCEDURE AplicarDesconto;
DROP PROCEDURE ReporEstoque;
DROP FUNCTION ValorEmEstoque;
DROP FUNCTION SituacaoEstoque;
