-- Exercícios Comandos DQL (SELECT com JOIN) - Biblioteca de Jogos
-- Escreva cada consulta no espaço abaixo da questão correspondente.

DROP DATABASE IF EXISTS bibliotecaJogos;
CREATE DATABASE bibliotecaJogos;
USE bibliotecaJogos;

-- Considere as seguintes tabelas:

CREATE TABLE Jogador (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	idade INT NOT NULL,
	cidade VARCHAR(45) NOT NULL
);

CREATE TABLE Jogo (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	genero VARCHAR(45) NOT NULL,
	ano INT NOT NULL,
	preco DECIMAL(8,2) NOT NULL
);

CREATE TABLE Jogador_has_Jogo (
	idJogador INT NOT NULL,
	idJogo INT NOT NULL,
	dataCompra DATE NOT NULL,
	PRIMARY KEY (idJogador, idJogo),
	FOREIGN KEY (idJogador) REFERENCES Jogador(id) ON DELETE CASCADE,
	FOREIGN KEY (idJogo) REFERENCES Jogo(id) ON DELETE CASCADE
);

-- Inserir jogadores
INSERT INTO Jogador (nome, idade, cidade) VALUES
('Lucas Ferreira', 22, 'Santa Rita do Sapucaí'),
('Marina Duarte', 27, 'Pouso Alegre'),
('Rafael Moreira', 31, 'Itajubá'),
('Beatriz Nunes', 24, 'Campinas'),
('Gabriel Teixeira', 19, 'Belo Horizonte'),
('Larissa Campos', 29, 'São Paulo'),
('Otávio Mendes', 35, 'Poços de Caldas');

-- Inserir jogos
INSERT INTO Jogo (nome, genero, ano, preco) VALUES
('The Witcher 3', 'RPG', 2015, 79.90),
('Forza Horizon 5', 'Corrida', 2021, 199.90),
('Minecraft', 'Sandbox', 2011, 99.90),
('FC 24', 'Esporte', 2023, 249.90),
('Celeste', 'Plataforma', 2018, 36.99),
('Elden Ring', 'RPG', 2022, 229.90),
('Need for Speed Heat', 'Corrida', 2019, 59.90),
('Hades', 'Roguelike', 2020, 47.99),
('Stardew Valley', 'Simulação', 2016, 24.99);

-- Inserir compras (alguns jogadores têm mais de um jogo e um jogo pertence a mais de um jogador)
INSERT INTO Jogador_has_Jogo (idJogador, idJogo, dataCompra) VALUES
(1, 1, '2022-03-10'),
(1, 3, '2021-07-22'),
(2, 2, '2022-11-05'),
(2, 6, '2023-02-18'),
(3, 4, '2023-10-01'),
(4, 5, '2020-06-14'),
(5, 7, '2021-12-25'),
(6, 8, '2021-05-09'),
(6, 1, '2023-09-30');

-- Questão 1:
-- Busque o nome e a idade dos jogadores que possuem algum jogo;
SELECT DISTINCT
    j.nome,
    j.idade
FROM Jogador j
INNER JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador;


-- Questão 2:
-- Busque o nome dos jogadores que possuem mais de um jogo;
SELECT
    j.nome
FROM Jogador j
INNER JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador
GROUP BY j.id, j.nome
HAVING COUNT(jhj.idJogo) > 1;


-- Questão 3:
-- Busque o nome dos jogadores e o nome dos jogos que eles possuem;
SELECT
    j.nome AS jogador,
    jg.nome AS jogo
FROM Jogador j
INNER JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador
INNER JOIN Jogo jg ON jhj.idJogo = jg.id;


-- Questão 4:
-- Busque o nome dos jogadores, o nome e o gênero dos jogos que possuem,
-- ordenados pelo nome do jogador;
SELECT
    j.nome AS jogador,
    jg.nome AS jogo,
    jg.genero
FROM Jogador j
INNER JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador
INNER JOIN Jogo jg ON jhj.idJogo = jg.id
ORDER BY j.nome;


-- Questão 5:
-- Busque todas as informações dos jogadores que possuem jogos do gênero 'RPG' ou 'Corrida'.
SELECT DISTINCT
    j.*
FROM Jogador j
INNER JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador
INNER JOIN Jogo jg ON jhj.idJogo = jg.id
WHERE jg.genero IN ('RPG', 'Corrida');


-- Desafio 6:
-- Busque o nome de todos os jogadores e, quando houver, o nome dos jogos que possuem.
-- Jogadores sem nenhum jogo também devem aparecer na lista;
SELECT
    j.nome AS jogador,
    jg.nome AS jogo
FROM Jogador j
LEFT JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador
LEFT JOIN Jogo jg ON jhj.idJogo = jg.id;


-- Desafio 7:
-- Busque o nome dos jogadores que NÃO possuem nenhum jogo.
SELECT
    j.nome
FROM Jogador j
LEFT JOIN Jogador_has_Jogo jhj ON j.id = jhj.idJogador
WHERE jhj.idJogador IS NULL;