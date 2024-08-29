Sistema de Smart Home
Este projeto implementa um banco de dados para gerenciar e monitorar dispositivos e atividades em uma residência inteligente. A residência possui vários cômodos, cada um equipado com diferentes dispositivos, como portas, janelas, TVs, luzes, cortinas, fogões e geladeiras. Cada dispositivo possui um status binário, indicando se está ligado/desligado ou aberto/fechado. Além disso, há câmeras em alguns cômodos, que possuem um IP associado e são utilizadas por uma IA para identificar eventos, registrando a data e a hora dos mesmos.

Funcionalidades
Registro de Cômodos: Mapeamento dos diferentes cômodos da residência.
Gerenciamento de Dispositivos: Cada cômodo pode possuir diferentes dispositivos (porta, janela, TV, luz, cortina, fogão, geladeira), com status de ligado/desligado ou aberto/fechado.
Monitoramento com Câmeras: Câmeras nos cômodos possuem um IP associado, e os eventos capturados pelas câmeras são registrados com data e hora.
Identificação de Pessoas: Pessoas são registradas como conhecidas ou desconhecidas, e os eventos são atribuídos a uma ou mais pessoas.
Consultas Implementadas
Listar Eventos com Pessoas Desconhecidas:

Lista todos os eventos ocorridos em uma data específica, envolvendo pessoas desconhecidas.
Dispositivo Mais Utilizado:

Identifica qual dispositivo é mais utilizado na residência.
Ranqueamento de Dispositivos por Cômodo:

Classifica os dispositivos mais utilizados por cada cômodo da casa.
Cômodo Mais Usado da Residência:

Identifica qual cômodo é o mais utilizado na residência.
Dispositivos Abertos/Desligados:

Identifica se algum dispositivo foi aberto em algum momento e não foi fechado posteriormente.
Triggers e Procedures
Trigger para Atualizar Status de Dispositivo:

Uma trigger na tabela Evento que atualiza automaticamente o status do dispositivo envolvido no evento.
Procedure com Cursores para Identificar Pessoa Mais Ativa:

Uma procedure com cursores que retorna, em um parâmetro de saída, a pessoa mais ativa na casa.
Estrutura do Banco de Dados
Tabelas Principais
Residencia
Mapeamento da residência, contendo a lista de cômodos.
Comodo
Armazena os dados dos cômodos, incluindo nome e informações de localização.
Dispositivo
Registra os dispositivos de cada cômodo, com status binário de ligado/desligado ou aberto/fechado.
Camera
Contém as câmeras associadas a cada cômodo, incluindo o IP.
Evento
Registra os eventos detectados pelas câmeras, incluindo data, hora, dispositivos envolvidos e pessoas associadas.
Pessoa
Armazena informações sobre as pessoas, categorizando-as como conhecidas ou desconhecidas.
Como Usar
Clone o repositório:

Importe o banco de dados MySQL utilizando o script SQL fornecido.

Execute as consultas para gerar os relatórios e interagir com os dados da residência.

Utilize as triggers e procedures para automação e análise de eventos e atividades na residência.

Requisitos
MySQL 5.7 ou superior
MySQL Workbench ou outro cliente MySQL de sua preferência
