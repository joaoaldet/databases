-- ================================================
-- BANCO: financeiro
-- ================================================

DROP DATABASE IF EXISTS financeiro;
CREATE DATABASE financeiro;
USE financeiro;

CREATE TABLE contas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titular VARCHAR(100),
    saldo NUMERIC(10,2)
);

INSERT INTO contas (titular, saldo) VALUES
    ('Alice', 1500.00),
    ('Bruno', 200.00),
    ('Carla', 800.00);
    
-- Exercício 1 — com COMMIT
START TRANSACTION;
    UPDATE contas SET saldo = saldo - 300 WHERE id = 1; -- Alice: 1200
    UPDATE contas SET saldo = saldo + 300 WHERE id = 2; -- Bruno: 500
COMMIT;

SELECT * FROM contas;

-- Exercício 1 — com ROLLBACK
START TRANSACTION;
    UPDATE contas SET saldo = saldo - 300 WHERE id = 1;
    UPDATE contas SET saldo = saldo + 300 WHERE id = 2;
ROLLBACK;

SELECT * FROM contas;
-- saldos voltam ao estado anterior, nada foi alterado

-- ================================================

-- Exercício 2 — SAVEPOINT
START TRANSACTION;
    UPDATE contas SET saldo = saldo - 100 WHERE id = 3; -- Carla: 700
    UPDATE contas SET saldo = saldo + 100 WHERE id = 1; -- Alice: 1300

    SAVEPOINT entre_transferencias;

    UPDATE contas SET saldo = saldo - 100 WHERE id = 3; -- Carla: 600
    UPDATE contas SET saldo = saldo + 100 WHERE id = 2; -- Bruno: 300

ROLLBACK TO entre_transferencias; -- desfaz só a segunda transferência
COMMIT;

SELECT * FROM contas;

-- ================================================

-- Exercício 3 — Dissertativa
START TRANSACTION;
    UPDATE contas SET saldo = saldo - 200 WHERE id = 1;
    SAVEPOINT sp1;
    UPDATE contas SET saldo = saldo + 200 WHERE id = 2;
    ROLLBACK TO sp1;
COMMIT;

-- Apenas o primeiro UPDATE é salvo.
-- O ROLLBACK TO sp1 desfez o segundo UPDATE,
-- mas o primeiro continuou ativo e foi confirmado pelo COMMIT.
SELECT * FROM contas;