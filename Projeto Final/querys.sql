-- Liste todos os eventos com pessoas desconhecidas numa determinada data;

-- OPCAO 1: usando subquery para verificar quem n tem Face_ID cadastrado na tabela de Pessoa
SELECT E.ID_Evento, E.Data_Hora, E.Descricao, PE.Face_ID, PE.Pessoa_Conhecida 
FROM Evento E
JOIN PessoaEvento PE ON E.ID_Evento = PE.ID_Evento
WHERE DATE(E.Data_Hora) = '2024-01-02' AND PE.Face_ID NOT IN (SELECT P.Face_ID FROM Pessoa P);

-- OPCAO 2 filtrando pela própria coluna booleana de Pessoa_Conhecida
SELECT E.ID_Evento, E.Data_Hora, E.Descricao, PE.Face_ID, PE.Pessoa_Conhecida 
FROM Evento E
JOIN PessoaEvento PE ON E.ID_Evento = PE.ID_Evento
WHERE DATE(E.Data_Hora) = '2024-01-02' AND PE.Pessoa_Conhecida IS FALSE;


-- Qual o dispositivo mais utilizado na casa;
-- Nome do dispositivo, criar insert com 10 portas principais
SELECT D.ID_Dispositivo, D.Descricao, COUNT(PE.ID_Dispositivo) AS Utilizacao
FROM PessoaEvento PE
JOIN Dispositivo D ON D.ID_Dispositivo = PE.ID_Dispositivo
GROUP BY D.ID_Dispositivo
ORDER BY Utilizacao DESC
LIMIT 1;

-- Ranqueamento dos dispositivos mais utilizados por cômodo
-- colocar nome do dispositvo e aumentar de utilização
SELECT D.ID_Dispositivo, D.Descricao, C.Nome_Comodo, COUNT(PE.ID_Dispositivo) AS Utilizacao
FROM PessoaEvento PE
JOIN Dispositivo D ON D.ID_Dispositivo = PE.ID_Dispositivo
JOIN Comodo C ON D.ID_Comodo = C.ID_Comodo 
GROUP BY D.ID_Dispositivo, C.Nome_Comodo
ORDER BY Utilizacao DESC;

-- Qual o cômodo mais usado da residência
SELECT CO.ID_Comodo, CO.Nome_Comodo, COUNT(PE.ID_Evento) AS QuantidadeEventos
FROM PessoaEvento PE
JOIN Evento E ON E.ID_Evento = PE.ID_Evento 
JOIN Camera CA ON CA.ID_Camera = E.ID_Camera 
JOIN Comodo CO ON CO.ID_Comodo = CA.ID_Comodo 
GROUP BY CO.ID_Comodo
ORDER BY QuantidadeEventos desc
limit 1;

-- Identificar se algum dispositivo foi aberto em algum momento e não foi fechado
SELECT D.ID_Dispositivo, D.Descricao, D.Ligado_Ou_Aberto
FROM Dispositivo D
WHERE D.Ligado_Ou_Aberto IS TRUE;

-- pessoa mais ativa da casa
SELECT P.ID_Pessoa, P.Nome, COUNT(PE.Face_ID) AS QuantidadeEventos
FROM PessoaEvento PE
JOIN Pessoa P ON P.Face_ID = PE.Face_ID 
GROUP BY P.ID_Pessoa
ORDER BY QuantidadeEventos desc
limit 1;




DELIMITER //
-- Trigger para a tabela PessoaEvento atualizando o status do dispositivo
CREATE TRIGGER AtualizaStatusDispositivo
AFTER INSERT ON PessoaEvento
FOR EACH ROW
BEGIN
	DECLARE v_status INT DEFAULT FALSE;
    
	IF (NEW.Ligou_Ou_Abriu IS TRUE) THEN
		SET v_status = TRUE;
	END IF;

  -- Atualiza o status do dispositivo para o status capturado no evento
  UPDATE Dispositivo
  SET Ligado_Ou_Aberto = v_status
  WHERE ID_Dispositivo = NEW.ID_Dispositivo;
END//


-- Trigger para a tabela PessoaEvento atualizando a coluna de Pessoa_Conhecida
CREATE TRIGGER AtualizaPessoaConhecida
BEFORE INSERT ON PessoaEvento
FOR EACH ROW
BEGIN
	DECLARE v_conhecida INT DEFAULT FALSE;

    -- Verifica se a face_ID existe nan tabebla de pessoa
    SET v_conhecida = NEW.Face_ID IN ( SELECT P.Face_ID FROM Pessoa P);

  -- Atualiza o status da coluna de Pessoa_Conhecida para o status capturado no evento
  SET NEW.Pessoa_Conhecida = v_conhecida;
END//

DELIMITER ;


-- Faça uma procedure com cursores onde retorne num parâmetro de saída quem é a pessoa da casa mais ativa;
DELIMITER //

CREATE PROCEDURE PessoaMaisAtiva(OUT PessoaMaisAtiva VARCHAR(100))
BEGIN
  -- Variáveis locais
  DECLARE v_Nome VARCHAR(100);
  DECLARE v_QuantidadeEventos INT;
  
  -- Declaração do cursor
  DECLARE cur CURSOR FOR
    SELECT P.Nome, COUNT(PE.ID_Evento) AS TotalEventos
    FROM PessoaEvento PE
    JOIN Pessoa P ON P.ID_Pessoa = PE.ID_Pessoa
    GROUP BY P.Nome
    ORDER BY TotalEventos DESC
    LIMIT 1;
  
  -- Declaração do handler para cursor
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET PessoaMaisAtiva = NULL;
  
  -- Abrir o cursor
  OPEN cur;
  
  -- Buscar o valor
  FETCH cur INTO v_Nome, v_QuantidadeEventos;
  
  -- Fechar o cursor
  CLOSE cur;
  
  -- Definir o parâmetro de saída
  SET PessoaMaisAtiva = v_Nome;
END //

DELIMITER ;