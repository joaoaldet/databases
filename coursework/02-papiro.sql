SET SQL_SAFE_UPDATES = 0;
DROP TABLE membros_expedicao;
CREATE DATABASE IF NOT EXISTS papiro;
USE papiro;

CREATE TABLE IF NOT EXISTS membros_expedicao (
id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
anos_exp INT CHECK(anos_exp >= 0),
funcao VARCHAR(50),
uni VARCHAR(60),
presente_tenda BOOLEAN,
horario TIME,
testemunha BOOLEAN,
pistas INT CHECK(pistas >= 0),
desconfianca ENUM ('BAIXO', 'MEDIO', 'ALTO', 'CRITICO')
);

INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Arthur Pendelton', 22, 'Arqueologo Chefe', 'Oxford', TRUE, '22:45:00', TRUE, 0, 'BAIXO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Elena Rostova', 12, 'Restauradora', 'Sorbonne', TRUE, '22:45:00', FALSE, 2, 'ALTO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Tariq Al-Mansoor', 8, 'Guia Local', 'Cairo University', FALSE, '21:30:00', TRUE, 0, 'BAIXO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Lucas Silva', 3, 'Assistente de Campo', 'USP', TRUE, '22:50:00', FALSE, 1, 'MEDIO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Beatriz Mendes', 5, 'Epigrafista', 'Coimbra', FALSE, '20:15:00', TRUE, 0, 'BAIXO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Hans Gruber', 18, 'Historiador', 'Heidelberg', TRUE, '22:40:00', FALSE, 3, 'CRITICO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Amira Hassan', 10, 'Fotografa Documentarista', 'Cairo University', FALSE, '23:10:00', TRUE, 0, 'BAIXO');
INSERT INTO membros_expedicao (nome, anos_exp, funcao, uni, presente_tenda, horario, testemunha, pistas, desconfianca) VALUES ('Mateo Benitez', 2, 'Estagiario de Conservacao', 'Madrid', TRUE, '22:35:00', TRUE, 0, 'MEDIO');

UPDATE membros_expedicao SET desconfianca = 'ALTO' WHERE id = 4;
UPDATE membros_expedicao SET uni = 'Cambridge' WHERE nome = 'Elena Rostova';
UPDATE membros_expedicao SET desconfianca = 'CRITICO' WHERE id = 6;

DELETE FROM membros_expedicao WHERE pistas = 0 AND desconfianca = 'BAIXO';
DELETE FROM membros_expedicao WHERE desconfianca = 'BAIXO';

SELECT * FROM membros_expedicao;
SELECT nome, funcao FROM membros_expedicao;
SELECT nome FROM membros_expedicao ORDER BY anos_exp DESC;
SELECT nome FROM membros_expedicao WHERE presente_tenda = TRUE;
SELECT nome FROM membros_expedicao WHERE desconfianca = 'ALTO' OR desconfianca = 'CRITICO';
SELECT nome FROM membros_expedicao WHERE anos_exp BETWEEN 5 AND 20;

SELECT nome FROM membros_expedicao WHERE nome LIKE 'A%';
SELECT nome FROM membros_expedicao WHERE nome LIKE '%o';
SELECT nome FROM membros_expedicao WHERE nome LIKE '%Arqueologo%' OR '%Assistente%';

SELECT nome FROM membros_expedicao WHERE uni IN ('Oxford', 'Cambridge', 'USP');
SELECT nome FROM membros_expedicao WHERE desconfianca IN ('MEDIO', 'ALTO', 'CRITICO');

SELECT
COUNT(*) AS total
FROM membros_expedicao;
SELECT SUM(pistas) from membros_expedicao;

SELECT 
COUNT(*) AS membros
FROM membros_expedicao
GROUP BY uni;

SELECT 
COUNT(*) AS membros
FROM membros_expedicao
GROUP BY desconfianca;

SELECT *
FROM membros_expedicao
WHERE presente_tenda = TRUE AND testemunha = FALSE AND desconfianca = 'CRITICO' AND pistas >= 1 AND (nome LIKE 'E%' OR nome LIKE 'H%');
