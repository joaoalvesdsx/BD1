CREATE DATABASE transactions;

-- controlar as transações para que caso uma não tenha saldo desfazer todas
USE transactions;
SET autocommit = 0;

CREATE TABLE `conta` (
  `id_user` INT NOT NULL,
  `nome_user` VARCHAR(100) DEFAULT NULL,
  `saldo` FLOAT DEFAULT 0,
  PRIMARY KEY (`id_user`)
);

DELIMITER $$
CREATE PROCEDURE atualiza_saldo (in id_u INT, in v FLOAT)
BEGIN    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	begin
        ROLLBACK;
        RESIGNAL;
    end;    
       
    IF (SELECT saldo FROM conta WHERE id_user = id_u) < v THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo Insuficiente';
    END IF;    
--     
    UPDATE conta SET saldo = saldo - v WHERE id_user = id_u;
END $$
DELIMITER;

START TRANSACTION;  

call atualiza_saldo(1, 20);
call atualiza_saldo(1, 60);
call atualiza_saldo(1, 80);
call atualiza_saldo(1, 100);

commit;

select * from conta;

-- implemente a procedure de depósito
-- OBS: Os depositos nao precisam de validações pois apenas adicionam saldo
DELIMITER $$
CREATE PROCEDURE deposita_saldo (in id_u INT, in v FLOAT)
BEGIN     
    UPDATE conta SET saldo = saldo + v WHERE id_user = id_u;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE transferencia_saldo (in id_u1 INT,in id_u2 INT, in v FLOAT)
BEGIN 
	CALL deposita_saldo(id_u2, v);
    CALL atualiza_saldo(id_u1, v);
END $$
DELIMITER ;

-- insira 5 contas no banco e implemente operações entre contas, com transações
INSERT INTO `conta` (`id_user`, `nome_user`, `saldo`) VALUES
(1, 'Joao Silva', 100),
(2, 'Maria Oliveira', 100),
(3, 'Marcio Vitor', 100),
(4, 'Rodrigo Pereira', 100),
(5, 'Maria Aparecida', 100);

START TRANSACTION;  

call deposita_saldo(1, 20);
call deposita_saldo(2, 60);
call deposita_saldo(3, 80);

call atualiza_saldo(4, 50);

call transferencia_saldo (3, 2, 80);
call transferencia_saldo (1, 50, 80);

commit;

select * from conta;

-- execute depósitos e retiradas da conta, sem se preocupar con transações
-- OBS: Nesse caso, como não usamos transações, mesmo a ultima operação sendo inválida, as anteriores foram salvas
-- Como nao estamos usando transacoes vamos reativar o autocommit e depois desativar ao final das ações
SET autocommit = 1;
call deposita_saldo(1, 200);
call deposita_saldo(2, 200);
call deposita_saldo(3, 200);

call atualiza_saldo(1, 200);
call atualiza_saldo(2, 200);
call atualiza_saldo(3, 2000);
SET autocommit = 0;

select * from conta;

-- execute 3 transferências possíveis e uma com saldo insuficiente, onde deverá 
-- ser realizado rollback de todas as transações anteriores da conta com saldo insuficiente
-- OBS: Como usamos transactions, caso a ultima operação falhe, nenhuma será salva
SET autocommit = 0;
START TRANSACTION;  

call transferencia_saldo(3, 1, 20);
call transferencia_saldo(3, 2, 60);
call transferencia_saldo(3, 3, 80);

call transferencia_saldo(3, 5, 5000);

commit;

select * from conta;