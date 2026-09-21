SET SQL_SAFE_UPDATES = 0;

CREATE DATABASE IF NOT EXISTS estudio;
USE estudio;

CREATE TABLE IF NOT EXISTS Tatuador (
    id_tatuador INT AUTO_INCREMENT PRIMARY KEY,
    cpf CHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%@inkhouse.br'),
    especialidade VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%@gmail.com'),
    data_cadastro DATE NOT NULL,
    qtd_tatuagens INT CHECK (qtd_tatuagens >= 0)
);

CREATE TABLE IF NOT EXISTS Sessao (
    id_sessao INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_tatuador INT,
    estilo_tatuagem VARCHAR(100) NOT NULL,
    temporada VARCHAR(10) NOT NULL,
    status_sessao ENUM('AGENDADA', 'CONFIRMADA', 'REALIZADA', 'CANCELADA') NOT NULL DEFAULT 'AGENDADA',
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_tatuador) REFERENCES Tatuador(id_tatuador)
);

ALTER TABLE Cliente ADD COLUMN categoria_cliente CHAR(3);

ALTER TABLE Tatuador MODIFY COLUMN especialidade VARCHAR(80) NOT NULL;

SHOW TABLES;

# TRUNCATE TABLE Sessao;

DROP DATABASE IF EXISTS inkhouse_teste;

INSERT INTO Tatuador (cpf, nome, email, especialidade) VALUES
('111.222.333-44', 'Thiago Rocha', 'thiago@inkhouse.br', 'Old School'),
('222.333.444-55', 'Bianca Alves', 'bianca@inkhouse.br', 'Old School'),
('333.444.555-66', 'Renata Cunha', 'renata@inkhouse.br', 'Realismo');

INSERT INTO Cliente (nome, email, data_cadastro, qtd_tatuagens, categoria_cliente) VALUES
('Gustavo Lima', 'gustavo@gmail.com', '2021-04-12', 3, 'NOV'),
('Sandy Junior', 'sandy@gmail.com', '2021-04-12', 1, 'NOV'),
('Jorge Vercillo', 'jorge@gmail.com', '2022-05-18', 6, 'VIP'),
('Sabrina Carpenter', 'sabrina@gmail.com', '2023-06-25', 1, 'NOV');

INSERT INTO Sessao (id_cliente, id_tatuador, estilo_tatuagem, temporada, status_sessao) VALUES
(1, 1, 'Old School', '2024-1', 'AGENDADA'),
(1, 2, 'Old School', '2024-1', 'AGENDADA'),
(2, 3, 'Realismo', '2024-1', 'REALIZADA'),
(4, 3, 'Fineline', '2024-1', 'CONFIRMADA'),
(1, 2, 'Realismo', '2024-2', 'CANCELADA');

UPDATE Sessao 
SET status_sessao = 'AGENDADA' 
WHERE id_sessao = 4;

UPDATE Sessao 
SET status_sessao = 'REALIZADA' 
WHERE temporada = '2024-1';

UPDATE Cliente 
SET email = 'jorge.vercillo@gmail.com', categoria_cliente = 'FIE' 
WHERE id_cliente = 3;

DELETE FROM Sessao 
WHERE id_sessao = 4;

# Atualização da FK para garantir a exclusão em cascata das sessões associadas ao deletar um cliente
ALTER TABLE Sessao DROP FOREIGN KEY sessao_ibfk_1;
ALTER TABLE Sessao ADD CONSTRAINT fk_sessao_cliente 
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE;

SELECT nome, email 
FROM Cliente 
WHERE data_cadastro >= '2022-01-01' 
ORDER BY nome ASC;

SELECT 
    id_cliente, 
    COUNT(*) AS total_sessoes, 
    MAX(temporada) AS temporada_mais_recente, 
    MIN(temporada) AS temporada_mais_antiga
FROM Sessao
GROUP BY id_cliente
ORDER BY total_sessoes DESC;

SELECT estilo_tatuagem, total_sessoes
FROM (
    SELECT estilo_tatuagem, COUNT(*) AS total_sessoes
    FROM Sessao
    GROUP BY estilo_tatuagem
) AS resumo_estilos
WHERE total_sessoes > 1;

SELECT id_cliente, total_sessoes
FROM (
    SELECT id_cliente, COUNT(*) AS total_sessoes
    FROM Sessao
    WHERE status_sessao IN ('CONFIRMADA', 'REALIZADA')
      AND id_tatuador IN (
          SELECT id_tatuador 
          FROM Tatuador 
          WHERE especialidade = 'Old School'
      )
    GROUP BY id_cliente
) AS resumo_clientes
WHERE total_sessoes > 1
ORDER BY total_sessoes DESC;
