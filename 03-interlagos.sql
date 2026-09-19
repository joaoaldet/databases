SET SQL_SAFE_UPDATES = 0;
DROP TABLE engenheiros;
DROP TABLE equipes;
CREATE DATABASE IF NOT EXISTS interlagos;
USE interlagos;

CREATE TABLE IF NOT EXISTS equipes (
id INT AUTO_INCREMENT PRIMARY KEY,
nome_equipe VARCHAR(60),
pais_origem VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS engenheiros (
id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
anos_experiencia INT CHECK(anos_experiencia >= 0),
especialidade VARCHAR(50),
disponivel_paddock BOOLEAN,
credencial_ativa BOOLEAN,
nota_avaliacao INT CHECK(nota_avaliacao >= 0 AND nota_avaliacao <= 100),
status_convocacao ENUM ('DISPONIVEL', 'EM_ESPERA', 'PROMOVIDO', 'INDISPONIVEL'),
equipe_id INT,
FOREIGN KEY (equipe_id) REFERENCES equipes(id)
);

INSERT INTO equipes (nome_equipe, pais_origem) VALUES ('Ferrari Academy', 'Itália');
INSERT INTO equipes (nome_equipe, pais_origem) VALUES ('Mercedes Junior', 'Alemanha');
INSERT INTO equipes (nome_equipe, pais_origem) VALUES ('Red Bull Powertrains', 'Áustria');
INSERT INTO equipes (nome_equipe, pais_origem) VALUES ('Alpine Academy', 'França');

INSERT INTO engenheiros (nome, anos_experiencia, especialidade, disponivel_paddock, credencial_ativa, nota_avaliacao, status_convocacao, equipe_id) VALUES ('Carlos Eduardo', 12, 'Telemetria Sênior', TRUE, FALSE, 95, 'INDISPONIVEL', 1);
INSERT INTO engenheiros (nome, anos_experiencia, especialidade, disponivel_paddock, credencial_ativa, nota_avaliacao, status_convocacao, equipe_id) VALUES ('Marcus Vance', 8, 'Analista de Dados', TRUE, TRUE, 88, 'DISPONIVEL', 2);
INSERT INTO engenheiros (nome, anos_experiencia, especialidade, disponivel_paddock, credencial_ativa, nota_avaliacao, status_convocacao, equipe_id) VALUES ('Sérgio Perez', 3, 'Telemetria Pleno', TRUE, TRUE, 78, 'DISPONIVEL', 3);
INSERT INTO engenheiros (nome, anos_experiencia, especialidade, disponivel_paddock, credencial_ativa, nota_avaliacao, status_convocacao, equipe_id) VALUES ('Lucas Di Grassi', 10, 'Sistemas Embarcados', FALSE, TRUE, 92, 'EM_ESPERA', 4);
INSERT INTO engenheiros (nome, anos_experiencia, especialidade, disponivel_paddock, credencial_ativa, nota_avaliacao, status_convocacao, equipe_id) VALUES ('Beatriz Figueiredo', 6, 'Engenharia de Telemetria', TRUE, TRUE, 94, 'DISPONIVEL', 4);
INSERT INTO engenheiros (nome, anos_experiencia, especialidade, disponivel_paddock, credencial_ativa, nota_avaliacao, status_convocacao, equipe_id) VALUES ('Pietro Fittipaldi', 4, 'Aerodinâmica', TRUE, TRUE, 85, 'DISPONIVEL', 3);

UPDATE engenheiros SET nota_avaliacao = 91 WHERE id = 6;
UPDATE engenheiros SET credencial_ativa = TRUE WHERE id = 1;
DELETE FROM engenheiros WHERE disponivel_paddock = FALSE;

SELECT nome, especialidade, nota_avaliacao, equipe_id FROM engenheiros;
SELECT nome, especialidade, nota_avaliacao, equipe_id FROM engenheiros WHERE equipe_id = 4;
SELECT nome, especialidade, nota_avaliacao, equipe_id FROM engenheiros WHERE equipe_id IN (2, 3);

SELECT nome, anos_experiencia, equipe_id FROM engenheiros WHERE anos_experiencia >= 5 AND equipe_id IN (1, 4);
SELECT COUNT(*) AS total_engenheiros FROM engenheiros WHERE equipe_id = 3;
SELECT equipe_id, AVG(nota_avaliacao) AS media_nota FROM engenheiros GROUP BY equipe_id;

SELECT nome, especialidade, nota_avaliacao, equipe_id
FROM engenheiros
WHERE disponivel_paddock = TRUE
AND credencial_ativa = TRUE
AND anos_experiencia >= 5
AND (especialidade LIKE '%Telemetria%'
OR especialidade LIKE '%Dados%'
OR especialidade LIKE '%Sistemas%')
AND status_convocacao = 'DISPONIVEL'
AND equipe_id IN (2, 3, 4)
ORDER BY nota_avaliacao DESC
LIMIT 1;