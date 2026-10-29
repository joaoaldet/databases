-- Exercícios Views e Triggers - Biblioteca
-- Escreva cada resolução no espaço abaixo da questão correspondente.
-- Lembre-se: triggers com BEGIN ... END precisam de DELIMITER $$ (volte com DELIMITER ; ao final).

DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca;
USE biblioteca;

-- Considere as seguintes tabelas:

CREATE TABLE Livro (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    titulo VARCHAR(60) NOT NULL,
    autor VARCHAR(45) NOT NULL,
    ano INT NOT NULL,
    exemplares INT NOT NULL
);

CREATE TABLE Emprestimo (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_livro INT NOT NULL,
    nome_aluno VARCHAR(45) NOT NULL,
    data_emprestimo DATE NOT NULL,
    FOREIGN KEY (id_livro) REFERENCES Livro(id)
);

-- Inserir livros

INSERT INTO Livro (titulo, autor, ano, exemplares) VALUES
('Dom Casmurro', 'Machado de Assis', 1899, 3),
('O Hobbit', 'J.R.R. Tolkien', 1937, 2),
('1984', 'George Orwell', 1949, 1),
('Clean Code', 'Robert C. Martin', 2008, 4),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943, 2);


-- ================= PARTE 1: TRIGGERS =================

-- Questão 1:
-- Crie um trigger chamado corrige_exemplares que, ANTES de inserir um livro,
-- corrija a quantidade de exemplares para 0 caso ela seja negativa.
-- Depois, insira o livro ('Duna', 'Frank Herbert', 1965) com -5 exemplares
-- e confira se ele foi gravado com 0.

DELIMITER $$

CREATE TRIGGER corrige_exemplares
BEFORE INSERT ON Livro
FOR EACH ROW
BEGIN
    IF NEW.exemplares < 0 THEN
        SET NEW.exemplares = 0;
    END IF;
END $$

DELIMITER ;

INSERT INTO Livro (titulo, autor, ano, exemplares)
VALUES ('Duna', 'Frank Herbert', 1965, -5);

SELECT * FROM Livro;


-- Questão 2:
-- Crie um trigger chamado baixa_exemplar que, DEPOIS de registrar um empréstimo,
-- diminua em 1 o número de exemplares do livro emprestado.
-- Depois, registre os empréstimos abaixo e confira os exemplares:
-- ('1984' para Ana Souza), ('O Hobbit' para Carla Dias) e
-- ('Dom Casmurro' para Bruno Lima), todos em '2026-10-29'.

DELIMITER $$

CREATE TRIGGER baixa_exemplar
AFTER INSERT ON Emprestimo
FOR EACH ROW
BEGIN
    UPDATE Livro
    SET exemplares = exemplares - 1
    WHERE id = NEW.id_livro;
END $$

DELIMITER ;

INSERT INTO Emprestimo
    (id_livro, nome_aluno, data_emprestimo)
VALUES
    (3, 'Ana Souza', '2026-10-29'),
    (2, 'Carla Dias', '2026-10-29'),
    (1, 'Bruno Lima', '2026-10-29');

SELECT * FROM Livro;


-- Questão 3 (Desafio):
-- Crie um trigger chamado devolve_exemplar que, DEPOIS de apagar um empréstimo
-- (devolução), aumente em 1 o número de exemplares do livro devolvido (use OLD).
-- Depois, apague o empréstimo de Bruno Lima e confira os exemplares do Dom Casmurro.

DELIMITER $$

CREATE TRIGGER devolve_exemplar
AFTER DELETE ON Emprestimo
FOR EACH ROW
BEGIN
    UPDATE Livro
    SET exemplares = exemplares + 1
    WHERE id = OLD.id_livro;
END $$

DELIMITER ;

DELETE FROM Emprestimo
WHERE nome_aluno = 'Bruno Lima';

SELECT titulo, exemplares
FROM Livro
WHERE titulo = 'Dom Casmurro';


-- ================= PARTE 2: VIEWS =================

-- Questão 4:
-- Crie uma view chamada emprestimos_detalhados que mostre o id do empréstimo,
-- o nome do aluno, o título do livro e a data do empréstimo.
-- Depois, consulte a view.

CREATE VIEW emprestimos_detalhados AS
SELECT
    Emprestimo.id AS Id,
    Emprestimo.nome_aluno AS Nome,
    Livro.titulo AS Titulo,
    Emprestimo.data_emprestimo AS Dia
FROM Emprestimo
JOIN Livro ON Emprestimo.id_livro = Livro.id;

SELECT * FROM emprestimos_detalhados;


-- Questão 5 (Desafio):
-- Crie uma view chamada livros_disponiveis que mostre o título, o autor e os
-- exemplares apenas dos livros que ainda têm exemplares disponíveis (maior que 0).
-- Depois, consulte a view.

CREATE VIEW livros_disponiveis AS
SELECT
    Livro.titulo AS Titulo,
    Livro.autor AS Autor,
    Livro.exemplares AS Exemplares
FROM Livro
WHERE Livro.exemplares > 0;

SELECT * FROM livros_disponiveis;


-- ================= LIMPEZA =================

-- Questão 6:
-- Apague as views e os triggers criados neste exercício.

DROP VIEW IF EXISTS emprestimos_detalhados;
DROP VIEW IF EXISTS livros_disponiveis;

DROP TRIGGER IF EXISTS corrige_exemplares;
DROP TRIGGER IF EXISTS baixa_exemplar;
DROP TRIGGER IF EXISTS devolve_exemplar;