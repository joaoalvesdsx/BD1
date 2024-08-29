CREATE DATABASE smartHome;

USE smartHome;

CREATE TABLE `Comodo` (
  `ID_Comodo` int NOT NULL,
  `Nome_Comodo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Comodo`)
);

-- A coluna Ligado_Ou_Aberto é responsável por guardar o status binário de cada dispositivo
-- Apenas o status atual do dispositivo é armazenado, não existe um histórico do status
-- Os eventos capturados pelas câmeras podem conter dispositivos
CREATE TABLE `Dispositivo` (
  `ID_Dispositivo` int NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `Ligado_Ou_Aberto` BOOLEAN  NOT NULL,
  `ID_Comodo` int NOT NULL,
  PRIMARY KEY (`ID_Dispositivo`),
  FOREIGN KEY (`ID_Comodo`) REFERENCES `Comodo` (`ID_Comodo`)
);

CREATE TABLE `Camera` (
  `ID_Camera` int NOT NULL,
  `IP_Camera` varchar(50) DEFAULT NULL,
  `ID_Comodo` int NOT NULL,
  PRIMARY KEY (`ID_Camera`),
  FOREIGN KEY (`ID_Comodo`) REFERENCES `Comodo` (`ID_Comodo`)
);

CREATE TABLE `Evento` (
  `ID_Evento` int NOT NULL,
  `Data_Hora` DATETIME DEFAULT NOW(),
  `Descricao` varchar(100) DEFAULT NULL,
  `ID_Camera` int NOT NULL,
  PRIMARY KEY (`ID_Evento`),
  FOREIGN KEY (`ID_Camera`) REFERENCES `Camera` (`ID_Camera`)
);

CREATE TABLE `Pessoa` (
  `ID_Pessoa` int NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Face_ID` float NOT NULL,
  PRIMARY KEY (`ID_Pessoa`)
);

-- A FK ID_Dispositivo deve ser anulável pois um evento não precisa necessariamente de um dispositivo para ocorrer, uma pessoa andando pelo ambiente pode ser considerado um evento, por exemplo
-- Uma pessoa conhecida é uma pessoa em que o valor de Face_ID capturado existe na tabela Pessoa
-- Face_ID nao pode ser uma FK pois existirão valores armazenados que nao esxistem na tabela Pessoa
CREATE TABLE `PessoaEvento` (
  `ID_PessoaEvento` int NOT NULL,
  `ID_Evento` int NOT NULL,
  `ID_Dispositivo` int DEFAULT NULL,
  `Face_ID` float NOT NULL,
  `Pessoa_Conhecida` BOOLEAN  DEFAULT NULL,
  `Ligou_Ou_Abriu` BOOLEAN  DEFAULT NULL,
  PRIMARY KEY (`ID_PessoaEvento`),
  FOREIGN KEY (`ID_Evento`) REFERENCES `Evento` (`ID_Evento`),
  FOREIGN KEY (`ID_Dispositivo`) REFERENCES `Dispositivo` (`ID_Dispositivo`)
);


