
CREATE TABLE Categoria (
    CategoriaID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE Ator (
    AtorID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE Filme (
    FilmeID INT PRIMARY KEY,
    Título VARCHAR(255)
);

CREATE TABLE FilmeCategoria (
    FilmeID INT,
    CategoriaID INT,
    FOREIGN KEY (FilmeID) REFERENCES Filme(FilmeID),
    FOREIGN KEY (CategoriaID) REFERENCES Categoria(CategoriaID)
);

CREATE TABLE FilmeAtor (
    FilmeID INT,
    AtorID INT,
    FOREIGN KEY (FilmeID) REFERENCES Filme(FilmeID),
    FOREIGN KEY (AtorID) REFERENCES Ator(AtorID)
);

CREATE TABLE Loja (
    LojaID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(255),
    LojaID INT,
    FOREIGN KEY (LojaID) REFERENCES Loja(LojaID)
);

CREATE TABLE Funcionario (
    FuncionarioID INT PRIMARY KEY,
    Nome VARCHAR(255),
    LojaID INT,
    FOREIGN KEY (LojaID) REFERENCES Loja(LojaID)
);

CREATE TABLE Gerente (
    GerenteID INT PRIMARY KEY,
    FuncionarioID INT,
    FOREIGN KEY (FuncionarioID) REFERENCES Funcionario(FuncionarioID)
);

CREATE TABLE Aluguel (
    AluguelID INT PRIMARY KEY,
    ClienteID INT,
    FuncionarioID INT,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (FuncionarioID) REFERENCES Funcionario(FuncionarioID)
);

CREATE TABLE Pagamento (
    PagamentoID INT PRIMARY KEY,
    AluguelID INT,
    FuncionarioID INT,
    FOREIGN KEY (AluguelID) REFERENCES Aluguel(AluguelID),
    FOREIGN KEY (FuncionarioID) REFERENCES Funcionario(FuncionarioID)
);

CREATE TABLE Item (
    ItemID INT PRIMARY KEY,
    AluguelID INT,
    FilmeID INT,
    FOREIGN KEY (AluguelID) REFERENCES Aluguel(AluguelID),
    FOREIGN KEY (FilmeID) REFERENCES Filme(FilmeID)
);

CREATE TABLE Estoque (
    EstoqueID INT PRIMARY KEY,
    LojaID INT,
    FilmeID INT,
    FOREIGN KEY (LojaID) REFERENCES Loja(LojaID),
    FOREIGN KEY (FilmeID) REFERENCES Filme(FilmeID)
);


CREATE VIEW AtoresFilmes AS
SELECT A.AtorID, A.Nome, GROUP_CONCAT(F.Título SEPARATOR ', ') AS FilmesAtuados
FROM Ator A
JOIN FilmeAtor FA ON A.AtorID = FA.AtorID
JOIN Filme F ON FA.FilmeID = F.FilmeID
GROUP BY A.AtorID, A.Nome;


CREATE VIEW FilmesCategoriasAtores AS
SELECT F.Título, GROUP_CONCAT(C.Nome SEPARATOR ', ') AS Categorias, GROUP_CONCAT(A.Nome SEPARATOR ', ') AS Atores
FROM Filme F
JOIN FilmeCategoria FC ON F.FilmeID = FC.FilmeID
JOIN Categoria C ON FC.CategoriaID = C.CategoriaID
JOIN FilmeAtor FA ON F.FilmeID = FA.FilmeID
JOIN Ator A ON FA.AtorID = A.AtorID
GROUP BY F.Título;


CREATE VIEW FilmesMaisAlugados AS
SELECT F.Título, COUNT(*) AS TotalAluguéis
FROM Filme F
JOIN Item I ON F.FilmeID = I.FilmeID
GROUP BY F.Título
ORDER BY TotalAluguéis DESC
LIMIT 5;


CREATE VIEW LojasComGerente AS
SELECT L.LojaID, L.Nome AS Loja, F.Nome AS Gerente
FROM Loja L
JOIN Gerente G ON L.LojaID = G.LojaID
JOIN Funcionario F ON G.FuncionarioID = F.FuncionarioID;


CREATE VIEW ClientesPorLoja AS
SELECT L.LojaID, L.Nome AS Loja, C.Nome AS Cliente
FROM Loja L
JOIN Cliente C ON L.LojaID = C.LojaID
ORDER BY L.Nome, C.Nome;
