DROP DATABASE IF EXISTS agencia_db;
CREATE DATABASE IF NOT EXISTS agencia_db;
USE agencia_db;

CREATE TABLE agente (
id INT AUTO_INCREMENT PRIMARY KEY,
codinome VARCHAR(20),
nome_real VARCHAR(100),
especialidade VARCHAR(40),
pais_alocacao VARCHAR(50),
ano_recrutamento INT NOT NULL,
data_ultima_missao DATE,
orcamento_missao FLOAT(2),
em_servico_ativo BOOLEAN DEFAULT TRUE
);

ALTER TABLE agente ADD nivel_acesso VARCHAR(20);
ALTER TABLE agente ADD contato_emergencia VARCHAR(80);
ALTER TABLE agente MODIFY codinome VARCHAR(60);
ALTER TABLE agente MODIFY pais_alocacao VARCHAR(80);
ALTER TABLE agente DROP COLUMN nome_real;