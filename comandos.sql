/*CRIANDO TABELAS*/

/*Criando a tabela FUNCIONARIO*/
CREATE TABLE Funcionario (
CPF VARCHAR(11) PRIMARY KEY,
Nome VARCHAR(255),
Endereco VARCHAR(255),
Email VARCHAR(255),
Telefones VARCHAR(255),
DataNascimento DATE,
Salario DECIMAL(10, 2),
TurnoTrabalho VARCHAR(10)
);
/*Criando a tabela CLIENTE*/
CREATE TABLE Cliente (
CPF VARCHAR(11) PRIMARY KEY,
Telefone VARCHAR(20),
Nome VARCHAR(255),
Endereco VARCHAR(255),
Email VARCHAR(255)
);
/*Criando a tabela PRATO*/
CREATE TABLE Prato (
Codigo INT PRIMARY KEY,
Nome VARCHAR(255),
HoraServido VARCHAR(10),
Valor DECIMAL(10, 2)
);
/*Criando a tabela PEDIDO*/
CREATE TABLE Pedido (
NumeroPedido INT PRIMARY KEY,
CPFFuncionario VARCHAR(11),
CPFCliente VARCHAR(11),
DataPedido DATE,
HoraPedido TIME,
TurnoPedido VARCHAR(10),
FOREIGN KEY (CPFFuncionario) REFERENCES Funcionario(CPF),
FOREIGN KEY (CPFCliente) REFERENCES Cliente(CPF)
);
/*Criando a tabela ITENSPEDIDO*/
CREATE TABLE ItensPedido (
NumeroItem INT PRIMARY KEY,
NumeroPedido INT,
CodigoPrato INT,
FOREIGN KEY (NumeroPedido) REFERENCES Pedido(NumeroPedido),
FOREIGN KEY (CodigoPrato) REFERENCES Prato(Codigo)
);
/*Criando a tabela ENTREGADOR*/
CREATE TABLE Entregador (
IDEntregador INT PRIMARY KEY,
Nome VARCHAR(255),
NumeroEntregasDia INT
);

/*INSERINDO DADOS*/


/*Inserindo dados na tabela Funcionario*/
INSERT INTO Funcionario (CPF, Nome, Endereco, Email, Telefones, DataNascimento,
Salario, TurnoTrabalho)
VALUES ('12345678901', 'Joao Silva', 'Rua A, 123', 'joao@email.com', '123456789',
'1990-01-01', 5000.00, 'Manha'),
('98765432101', 'Maria Oliveira', 'Rua B, 456', 'maria@email.com', '987654321', '1985-05-
15', 6000.00, 'Tarde');
/*Inserindo dados na tabela Cliente*/
INSERT INTO Cliente (CPF, Telefone, Nome, Endereco, Email)
VALUES ('11122233344', '555-1234', 'Carlos Santos', 'Av X, 789', 'carlos@email.com'),
('55566677788', '555-5678', 'Ana Lima', 'Av Y, 456', 'ana@email.com');
/*Inserindo dados na tabela Prato*/
INSERT INTO Prato (Codigo, Nome, HoraServido, Valor)
VALUES (1, 'Feijoada', 'Almoco', 30.00),
(2, 'Pizza Margherita', 'Jantar', 25.00);
/*Inserindo dados na tabela Pedido*/
INSERT INTO Pedido (NumeroPedido, CPFFuncionario, CPFCliente, DataPedido,
HoraPedido, TurnoPedido)
VALUES (1, '12345678901', '11122233344', '2023-01-15', '12:30:00', 'Almoco'),
(2, '98765432101', '55566677788', '2023-01-15', '19:00:00', 'Jantar');
/*Inserindo dados na tabela ItensPedido*/
INSERT INTO ItensPedido (NumeroItem, NumeroPedido, CodigoPrato)
VALUES (1, 1, 1), (2, 1, 2), (3, 2, 2);
/*Inserindo dados na tabela Entregador*/
INSERT INTO Entregador (IDEntregador, Nome, NumeroEntregasDia)
VALUES (1, 'Pedro Rocha', 3), (2, 'Julia Santos', 4);

/*REALIZAÇÃO DE CONSULTAS*/

/*Relação dos pratos servidos e seus respectivos valores, considerando no
resultado inicialmente os produtos mais baratos:*/
SELECT Codigo, Nome, HoraServido, Valor FROM Prato ORDER BY Valor ASC;
/*O prato mais pedido e o menos pedido (vendido):
* Prato mais pedido*/
SELECT P.Codigo, P.Nome, COUNT(*) AS QuantidadePedidos FROM Prato P JOIN
ItensPedido IP ON P.Codigo = IP.CodigoPrato GROUP BY P.Codigo, P.Nome ORDER BY
QuantidadePedidos DESC LIMIT 1;
/* Prato menos pedido*/
SELECT P.Codigo, P.Nome, COUNT(*) AS QuantidadePedidos FROM Prato P JOIN
ItensPedido IP ON P.Codigo = IP.CodigoPrato GROUP BY P.Codigo, P.Nome ORDER BY
QuantidadePedidos ASC LIMIT 1;
/*O melhor cliente da empresa (quem compra mais):*/
SELECT C.CPF, C.Nome, COUNT(*) AS QuantidadePedidos FROM Cliente C JOIN
Pedido P ON C.CPF = P.CPFCliente GROUP BY C.CPF, C.Nome ORDER BY
QuantidadePedidos DESC LIMIT 1;12

/*Considerando o CPF de um cliente, identifique os pratos mais comprados e
recomende outro que ele ainda não tenha pedido:
* Consulta para obter os pratos mais comprados por um cliente específico*/
WITH PratosMaisComprados AS (SELECT IP.CodigoPrato, COUNT(*) AS Quantidade
FROM ItensPedido IP JOIN Pedido P ON IP.NumeroPedido = P.NumeroPedido WHERE
P.CPFCliente = 'CPF_DO_CLIENTE' GROUP BY IP.CodigoPrato ORDER BY Quantidade
DESC LIMIT 1);
/* Consulta principal para recomendar um prato que o cliente ainda não pediu*/
SELECT P.Codigo, P.Nome, P.HoraServido, P.Valor FROM Prato P LEFT JOIN
PratosMaisComprados PMC ON P.Codigo = PMC.CodigoPrato WHERE PMC.CodigoPrato IS NULL;
/*Clientes que compraram apenas o jantar (use a definição de turnos):*/
SELECT C.CPF, C.Nome FROM Cliente C JOIN Pedido P ON C.CPF = P.CPFCliente WHERE P.TurnoPedido
= 'noite' GROUP BY C.CPF, C.Nome HAVING COUNT(DISTINCT P.TurnoPedido) = 1;
/*Folha de pagamento da empresa (considerando que os funcionários trabalham por turno):*/
SELECT F.CPF, F.Nome, F.TurnoTrabalho, SUM(P.Salario) AS TotalSalario FROM
Funcionario F JOIN Pedido P ON F.CPF = P.CPFFuncionario GROUP BY F.CPF, F.Nome,
F.TurnoTrabalho;
/*Data (dia) com o maior 'famero de entregas (delivery):*/
SELECT F.CPF, F.Nome, F.TurnoTrabalho, F.Salario, SUM(F.Salario) AS TotalSalario
FROM Funcionario F LEFT JOIN Pedido P ON F.CPF = P.CPFFuncionario GROUP BY
F.CPF, F.Nome, F.TurnoTrabalho, F.Salario;
