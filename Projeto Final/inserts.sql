-- criar mais inserts de um comodo só
INSERT INTO `Comodo` (`ID_Comodo`, `Nome_Comodo`) VALUES
(1, 'Sala'),
(2, 'Cozinha'),
(3, 'Quarto'),
(4, 'Varanda');

INSERT INTO `Dispositivo` (`ID_Dispositivo`, `Descricao`, `Ligado_Ou_Aberto`, `ID_Comodo`) VALUES
-- Para efeitos de simulação, alguns dispositivos já foram cadastrados como status Ligado_Ou_Aberto = true 
-- Portas em todos os comodos (4 portas na sala)
(1, 'Porta da Sala 1', true, 1),
(2, 'Porta da Sala 2', true, 1),
(3, 'Porta da Sala 3', true, 1),
(4, 'Porta da Sala 4', true, 1),
(5, 'Porta da Cozinha', false, 2),
(6, 'Porta do Quarto', false, 3),
(7, 'Porta da Varanda', false, 4),

-- 2 janelas na sala, 1 na cozinha e 1 no quarto
(8, 'Janela da Sala', false, 1),
(9, 'Janela da Cozinha', false, 1),
(10, 'Janela do Quarto', false, 2),
(11, 'Janela da Varanda', false, 3),

-- TVs na sala e no quarto
(12, 'TV da Sala', true, 1),
(13, 'TV do Quarto', true, 3),

-- Luz e Cortina em todos os cômodos
(14, 'Luz da Sala', false, 1),
(15, 'Luz da Cozinha', false, 2),
(16, 'Luz do Quarto', false, 3),
(17, 'Luz da Varanda', false, 4),

(18, 'Cortina da Sala', false, 1),
(19, 'Cortina da Cozinha', false, 2),
(20, 'Cortina do Quarto', false, 3),
(21, 'Cortina da Varanda', false, 4),

-- Geladeira e Fogao só na cozinha
(23, 'Fogao da Cozinha', false, 2),
(24, 'Geladeira daa Cozinha', true, 2);

INSERT INTO `Camera` (`ID_Camera`, `IP_Camera`, `ID_Comodo`) VALUES
-- Uma câmera em cada cômodo
(1, '192.168.0.10', 1),
(2, '192.168.0.11', 2),
(3, '192.168.0.12', 3),
(4, '192.168.1.10', 4);

INSERT INTO `Evento` (`ID_Evento`, `Data_Hora`, `Descricao`, `ID_Camera`) VALUES
(1, '2024-01-01 12:00:00', 'Movimento detectado', 1),
(2, '2024-01-01 13:00:00', 'Movimento detectado', 2),
(3, '2024-01-01 13:01:00', 'Movimento detectado', 2),
(4, '2024-01-01 13:02:00', 'Movimento detectado', 2),
(5, '2024-01-01 14:00:00', 'Movimento detectado', 3),
(6, '2024-01-02 14:30:00', 'Movimento detectado', 4);



INSERT INTO `Pessoa` (`ID_Pessoa`, `Nome`, `Face_ID`) VALUES
(1, 'João Silva', 0.65678),
(2, 'Maria Silva', 0.46689),
(3, 'Pedro Silva', 0.55978),
(4, 'Ana Silva', 0.45678),
(5, 'Carlos Pereira', 0.75891);


INSERT INTO `PessoaEvento` (`ID_PessoaEvento`, `ID_Evento`, `ID_Dispositivo`, `Ligou_Ou_Abriu`, `Face_ID`) VALUES
-- Joãao Silva usa a porta e Maria Silva o acompanha [EVENTO 1]
(1, 1, 1, true, 0.65678),
(2, 1, 1, false, 0.46689),

-- Pedro Silva e Ana Silva usam a geladeira 5 vezes (distribuído em 3 eventos) [EVENTOS 2,3 E 4]
(3, 2, 24, true, 0.55978),
(4, 2, 24, false, 0.45678),

(5, 3, 24, true, 0.55978),
(6, 3, 24, false,  0.45678),

(7, 4, 24, true, 0.55978),

-- Carlos Pereira liga a TV do quarto [EVENTO 5]
(8, 5, 13, true,  0.75891),

-- 2 Pessoas desconhecidas sao detectadas andando pela varanda [EVENTO 6]
(9, 6, null, null, 0.98921),
(10, 6, null, null, 0.23412);

