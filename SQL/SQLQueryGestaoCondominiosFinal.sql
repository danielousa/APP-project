USE [MASTER]
GO

--DROP Database GestaoCondominios

--Criar base de dados 'GestaoCondominios' caso não exista
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'GestaoCondominios')
BEGIN

	CREATE DATABASE [GestaoCondominios]
	END
	GO
	USE [GestaoCondominios]

	DROP TABLE IF EXISTS Utilizadores;
	DROP TABLE IF EXISTS TipoUtilizador;
	DROP TABLE IF EXISTS Condominios;
	DROP TABLE IF EXISTS CodigoPostal;
	DROP TABLE IF EXISTS Notificacoes;
	DROP TABLE IF EXISTS Servicos;
	DROP TABLE IF EXISTS TipoServico;
	DROP TABLE IF EXISTS CabecalhoFatura;
	DROP TABLE IF EXISTS LinhaFatura;
	DROP TABLE IF EXISTS Pagamentos;
	DROP TABLE IF EXISTS Fracoes;

	GO
	CREATE TABLE TipoServico (
	IdTipoServico INT Identity(1,1),
	Descricao NVARCHAR(50) NOT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),

	CONSTRAINT PK_TipoServico_IdTipoServico PRIMARY KEY (IdTipoServico),

	CONSTRAINT CK_TipoServico_Descricao CHECK (Descricao IN ('jardinagem', 'limpeza', 'manutencao', 'outro'))
	);

	
	CREATE TABLE CodigoPostal (
	IdCodigoPostal NVARCHAR(8),
	Localidade NVARCHAR(50) NOT NULL,
	DataCriacao DATETIME NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NULL DEFAULT GETDATE(),

	CONSTRAINT PK_CodigoPostal_IdCodigoPostal PRIMARY KEY (IdCodigoPostal),

	CONSTRAINT CK_CodigoPostal_IdCodigoPostal CHECK (LEN(IdCodigoPostal) = 8)
	);
	
	
	CREATE TABLE TipoUtilizador(
	IdTipoUtilizador INT Identity(1,1),
	Designcacao NVARCHAR(50) NOT NULL,
	DataCriacao DATETIME NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NULL DEFAULT GETDATE(),

	CONSTRAINT PK_TipoUtilizador_IdTipoUtilizador PRIMARY KEY (IdTipoUtilizador),

	CONSTRAINT CK_TipoUtilizador_Designcacao CHECK (Designcacao IN ('gestor', 'inquilino'))
	);

	
	CREATE TABLE Utilizadores (
	IdUtilizador INT Identity(1,1),
	Nome NVARCHAR(200) NOT NULL,
	ContactoEmail NVARCHAR(30) NOT NULL,
	ContactoTelefone INT NOT NULL,
	Nif INT NOT NULL,
	[Password] VARBINARY(64) NOT NULL,
	Morada NVARCHAR(80) NOT NULL,
	IdCodigoPostal NVARCHAR(8) NOT NULL,
	IdTipoUtilizador INT NOT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),
	Inativo BIT DEFAULT 1,

	CONSTRAINT PK_Utilizadores_IdUtilizador PRIMARY KEY (IdUtilizador),

	CONSTRAINT FK_Utilizadores_IdTipoUtilizador FOREIGN KEY (IdTipoUtilizador) REFERENCES TipoUtilizador(IdTipoUtilizador),
	CONSTRAINT FK_Utilizadores_IdCodigoPostal FOREIGN KEY (IdCodigoPostal) REFERENCES CodigoPostal(IdCodigoPostal),

	CONSTRAINT CK_Utilizadores_ContactoTelefone CHECK (LEN(ContactoTelefone) < 20),
	CONSTRAINT CK_Utilizadores_Nif CHECK (LEN(Nif) = 9),

	CONSTRAINT UK_Utilizadores_ContactoEmail UNIQUE (ContactoEmail)
	);

	
	CREATE TABLE Condominios (
	IdCondominio INT Identity(1,1),
	Edificio NVARCHAR(50) NOT NULL,
	Morada NVARCHAR(80) NOT NULL,
	IdCodigoPostal NVARCHAR(8) NOT NULL,
	Iban NVARCHAR(25) NOT NULL,
	Nif INT NOT NULL,
	Quotas DECIMAL(5,2) NOT NULL,
	SaldoAtual DECIMAL(7,2) NOT NULL,
	IdUtilizadorGestor INT NOT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),
	Inativo BIT DEFAULT 1,

	CONSTRAINT PK_Condominios_IdCondominio PRIMARY KEY (IdCondominio),
	 
	CONSTRAINT FK_Condominios_IdUtilizadorGestor FOREIGN KEY (IdUtilizadorGestor) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_Condominios_IdCodigoPostal FOREIGN KEY (IdCodigoPostal) REFERENCES CodigoPostal(IdCodigoPostal),

	CONSTRAINT CK_Condominios_Iban CHECK (LEN(Iban) = 25),
	CONSTRAINT CK_Condominios_Nif CHECK (LEN(Nif) = 9),
	CONSTRAINT CK_Condominios_Quotas CHECK (Quotas > 0)
	);

	
	CREATE TABLE Servicos (
	IdServico INT Identity(1,1),
	IdTipoServico INT NOT NULL,
	DataHoraInicio SMALLDATETIME NOT NULL,
	DataHoraPrevistaFim SMALLDATETIME NULL,
	IdUtilizadorGestor INT NOT NULL,
	ValorServico DECIMAL(5,2) NOT NULL,
	Obs NVARCHAR(200) NULL,
	IdCondominio INT NOT NULL,
	Anexo TEXT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),
	  
	CONSTRAINT PK_Servicos_IdServico PRIMARY KEY (IdServico),

	CONSTRAINT FK_Servicos_IdTipoServico FOREIGN KEY (IdTipoServico) REFERENCES TipoServico(IdTipoServico),
	CONSTRAINT FK_Servicos_IdUtilizadorGestor FOREIGN KEY (IdUtilizadorGestor) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_Servicos_IdCondominio FOREIGN KEY (IdCondominio) REFERENCES Condominios(IdCondominio),

	CONSTRAINT CK_Servicos_ValorServico CHECK (ValorServico > 0)
	);

	
	CREATE TABLE Notificacoes (
	IdNotificacao INT Identity(1,1),
	Descricao NVARCHAR(80) NOT NULL,
	IdUtilizadorCriador INT NOT NULL,
	IdUtilizadorRecetor INT NOT NULL,
	DataHora SMALLDATETIME NOT NULL,
	IdCondominio INT NOT NULL,
	Anexo TEXT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),

	CONSTRAINT PK_Notificacoes_IdNotificacao PRIMARY KEY (IdNotificacao),

	CONSTRAINT FK_Notificacoes_IdUtilizadorCriador FOREIGN KEY (IdUtilizadorCriador) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_Notificacoes_IdUtilizadorRecetor FOREIGN KEY (IdUtilizadorRecetor) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_Notificacoes_IdCondominio FOREIGN KEY (IdCondominio) REFERENCES Condominios(IdCondominio),

	CONSTRAINT CK_Notificacoes_IdUtilizadorCriador_IdUtilizadorRecetor CHECK (IdUtilizadorCriador <> IdUtilizadorRecetor)
	);

	
	CREATE TABLE Fracoes (
	IdFracao INT Identity(1,1),
	ArtigoPerdial INT NOT NULL,
	Permilagem DECIMAL(5,3) NOT NULL,
	IdUtilizador INT NOT NULL,
	IdCondominio INT NOT NULL,
	DataCriacao DATETIME NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NULL DEFAULT GETDATE(),

	CONSTRAINT PK_Fracoes_IdFracao PRIMARY KEY (IdFracao),

	CONSTRAINT FK_Fracoes_IdUtilizador FOREIGN KEY (IdUtilizador) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_Fracoes_IdCondominio FOREIGN KEY (IdCondominio) REFERENCES Condominios(IdCondominio),
	
	CONSTRAINT UK_Fracoes_IdFracao_ArtigoPerdial UNIQUE(IdFracao, ArtigoPerdial),

	CONSTRAINT CK_Fracoes_Permilagem CHECK(Permilagem > 0 and Permilagem <=100)
	);

	
	CREATE TABLE Pagamentos (
	IdPagamento INT Identity(1,1),
	IdCondominio INT NOT NULL,
	FormaPagamento NVARCHAR(50) NOT NULL,
	ValorPagamento DECIMAL(5,2) NOT NULL,
	Obs NVARCHAR(200) NULL,
	IdUtilizadorInquilino INT NOT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),
	
	CONSTRAINT PK_Pagamentos_IdPagamento PRIMARY KEY (IdPagamento),

	CONSTRAINT FK_Pagamentos_IdUtilizadorInquilino FOREIGN KEY (IdUtilizadorInquilino) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_Pagamentos_IdCondominio FOREIGN KEY (IdCondominio) REFERENCES Condominios(IdCondominio),

	CONSTRAINT CK_Pagamentos_ValorPagamento CHECK (ValorPagamento > 0)
	);

	
	CREATE TABLE CabecalhoFatura (
	NumeroFatura NVARCHAR(7),
	[Data] DATE NOT NULL,
	IdUtilizadorInquilino INT NOT NULL,
	IdCondominio INT NOT NULL,
	Estado NVARCHAR(10) NOT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),

	CONSTRAINT PK_CabecalhoFatura_NumeroFatura PRIMARY KEY (NumeroFatura),

	CONSTRAINT FK_CabecalhoFatura_IdUtilizadorInquilino FOREIGN KEY (IdUtilizadorInquilino) REFERENCES Utilizadores(IdUtilizador),
	CONSTRAINT FK_CabecalhoFatura_IdCondominio FOREIGN KEY (IdCondominio) REFERENCES Condominios(IdCondominio),

	CONSTRAINT CK_CabecalhoFatura_Estado CHECK (Estado IN ('pago', 'não pago'))
	);

	
	CREATE TABLE LinhaFatura (
	IdLinhaFatura INT Identity(1,1),
	NumeroFatura NVARCHAR(7) NOT NULL,
	DescricaoPagamento NVARCHAR(200) NOT NULL,
	ValorPagamento DECIMAL(5,2) NOT NULL,
	DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),

	CONSTRAINT PK_LinhaFatura_IdLinhaFatura PRIMARY KEY (IdLinhaFatura),
	
	CONSTRAINT FK_LinhaFatura_NumeroFatura FOREIGN KEY (NumeroFatura) REFERENCES CabecalhoFatura(NumeroFatura),

	CONSTRAINT CK_LinhaFatura_ValorPagamento CHECK (ValorPagamento > 0)
	);


	--------------------VIEWS-----------------------------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW GetSaldoAtual
AS

SELECT IdCondominio, Edificio, SaldoAtual 
FROM Condominios
GO

SELECT*
FROM GetSaldoAtual


GO
CREATE OR ALTER VIEW GetHistoricoPagamentosInquilinos
AS

SELECT p.IdUtilizadorInquilino, u.Nome, p.IdCondominio, f.IdFracao, p.ValorPagamento
FROM Pagamentos AS p INNER JOIN (SELECT IdUtilizador, Nome FROM Utilizadores) AS u
ON p.IdUtilizadorInquilino = u.IdUtilizador 
INNER JOIN Fracoes AS f ON u.IdUtilizador = f.IdUtilizador
GO

SELECT*
FROM GetHistoricoPagamentosInquilinos
ORDER BY IdCondominio

SELECT*
FROM GetSaldoAtual

SELECT*
FROM GetHistoricoPagamentosInquilinos
ORDER BY IdCondominio

SELECT * FROM TipoServico
SELECT * FROM CodigoPostal
SELECT * FROM TipoUtilizador
SELECT * FROM Utilizadores
SELECT * FROM Condominios
SELECT * FROM Servicos
SELECT * FROM Notificacoes
SELECT * FROM Fracoes
SELECT * FROM Pagamentos
SELECT * FROM CabecalhoFatura
SELECT * FROM LinhaFatura


--------------QUERY DANIEL-------------------------------------------
SELECT Top 1 u.Nome, sum(ghpi.ValorPagamento) as ValorPago, sum(c.SaldoAtual) as ValorAcumuladoCondominio, (sum(ghpi.ValorPagamento)-sum(c.SaldoAtual)) as ValorEmDivida
FROM Utilizadores as u INNER JOIN GetHistoricoPagamentosInquilinos as ghpi
ON u.IdUtilizador = ghpi.IdUtilizadorInquilino INNER JOIN Condominios as c
ON ghpi.IdCondominio = c.IdCondominio INNER JOIN CabecalhoFatura as cf
ON u.IdUtilizador = cf.IdUtilizadorInquilino AND c.IdCondominio = cf.IdCondominio
WHERE cf.Estado = 'não pago'
GROUP BY u.Nome
ORDER BY ValorEmDivida

-- QUERY SOFIA--------------------------------------------------

SELECT c.IdCondominio, c.Edificio, 

CASE
	WHEN SUM(s.ValorServico) IS NULL THEN '0'
	WHEN SUM(s.ValorServico) IS NOT NULL THEN SUM(s.ValorServico)
	END AS TotalValorServico

FROM Condominios AS c LEFT JOIN Servicos AS s
ON s.IdCondominio = c.IdCondominio
GROUP BY c.IdCondominio, c.Edificio;

	----------------PROCEDURES INSERT VALUES---------------------------------------------------------------------------------------------------------------

	GO
	CREATE OR ALTER PROCEDURE InsertUtilizadores 

	--@IdUtilizador INT,
	@Nome NVARCHAR(200),
	@ContactoEmail NVARCHAR(30),
	@ContactoTelefone INT,
	@Nif INT,
	--@Password VARBINARY(64),
	@Morada NVARCHAR(80),
	@IdCodigoPostal INT,
	@IdTipoUtilizador INT,
	@Inativo BIT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			Declare @Password VARBINARY(64)
			SET @Password = CRYPT_GEN_RANDOM(64)

			INSERT INTO Utilizadores (Nome, ContactoEmail, ContactoTelefone, Nif, [Password], Morada, IdCodigoPostal, IdTipoUtilizador, Inativo, DataCriacao, DataAtualizacao)
			VALUES (@Nome, @ContactoEmail, @ContactoTelefone, @Nif, @Password, @Morada, @IdCodigoPostal, @IdTipoUtilizador, @Inativo, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertTipoUtilizador

	--IdTipoUtilizador INT,
	@Designcacao NVARCHAR(50)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO TipoUtilizador (Designcacao, DataCriacao, DataAtualizacao)
			VALUES (@Designcacao, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertCondominios 

	--IdCondominio INT,
	@Edificio NVARCHAR(50),
	@Morada NVARCHAR(80),
	@IdCodigoPostal INT,
	@Iban NVARCHAR(25),
	@Nif INT,
	@Quotas DECIMAL(5,2),
	@IdUtilizadorGestor INT,
	@Inativo BIT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Condominios (Edificio, Morada, IdCodigoPostal, Iban, Nif, Quotas, IdUtilizadorGestor, Inativo, DataCriacao, DataAtualizacao)
			VALUES (@Edificio, @Morada, @IdCodigoPostal, @Iban, @Nif, @Quotas, @IdUtilizadorGestor, @Inativo, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertCodigoPostal

	@IdCodigoPostal NVARCHAR(8),
	@Localidade NVARCHAR(50)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO CodigoPostal (IdCodigoPostal, Localidade, DataCriacao, DataAtualizacao)
			VALUES (@IdCodigoPostal, @Localidade, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END

	EXECUTE InsertCodigoPostal '4470-109', 'Maia'

	SELECT * FROM CodigoPostal

	GO
	CREATE OR ALTER PROCEDURE InsertNotificacoes

	--@IdNotificacao INT,
	@Descricao NVARCHAR(80),
	@IdUtilizadorCriador INT, 
	@IdUtilizadorRecetor INT,
	@DataHora SMALLDATETIME,
	@IdCondominio INT

	AS
	BEGIN
		SET @DataHora = GETDATE();
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Notificacoes (Descricao, IdUtilizadorCriador, IdUtilizadorRecetor, DataHora, IdCondominio, DataCriacao, DataAtualizacao)
			VALUES (@Descricao, @IdUtilizadorCriador, @IdUtilizadorRecetor, GETDATE(), @IdCondominio, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertServicos 

	--@IdServico INT,
	@IdTipoServico INT,
	@DataHoraInicio SMALLDATETIME,
	@DataHoraPrevistaFim SMALLDATETIME,
	@IdUtilizadorGestor INT,
	@Obs NVARCHAR(200),
	@IdCondominio INT,
	@ValorServico DECIMAL(5,2)

	AS
	BEGIN
		SET @DataHoraInicio = GETDATE();
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Servicos (IdTipoServico, DataHoraInicio, DataHoraPrevistaFim, IdUtilizadorGestor, Obs, IdCondominio, ValorServico, DataCriacao, DataAtualizacao)
			VALUES (@IdTipoServico, GETDATE(), @DataHoraPrevistaFim, @IdUtilizadorGestor, @Obs, @IdCondominio, @ValorServico, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertTipoServico

	--@IdTipoServico INT,
	@Descricao NVARCHAR(50)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO TipoServico (Descricao, DataCriacao, DataAtualizacao)
			VALUES (@Descricao, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END

	EXECUTE InsertTipoServico 'outro'

	SELECT * FROM TipoServico

	GO
	CREATE OR ALTER PROCEDURE InsertCabecalhoFatura

	@NumeroFatura NVARCHAR(7),
	@Data DATE,
	@IdUtilizadorInquilino INT,
	@IdCondominio INT, 
	@Estado NVARCHAR(10)

	AS
	BEGIN
	SET @Data = GETDATE();
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO CabecalhoFatura (NumeroFatura,[Data], IdUtilizadorInquilino, IdCondominio, Estado, DataCriacao, DataAtualizacao)
			VALUES (@NumeroFatura,GETDATE(), @IdUtilizadorInquilino, @IdCondominio, @Estado, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertLinhaFatura

	--IdLinhaFatura INT,
	@NumeroFatura NVARCHAR(7),
	@DescricaoPagamento NVARCHAR(200),
	@ValorPagamento DECIMAL(5,2)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO LinhaFatura (NumeroFatura, DescricaoPagamento, ValorPagamento, DataCriacao, DataAtualizacao)
			VALUES (@NumeroFatura, @DescricaoPagamento, @ValorPagamento, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertPagamentos

	--IdPagamento INT,
	@FormaPagamento NVARCHAR(50),
	@ValorPagamento DECIMAL(5,2),
	@Obs NVARCHAR(200),
	@IdUtilizadorInquilino INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Pagamentos (FormaPagamento, ValorPagamento, Obs, IdUtilizadorInquilino, DataCriacao, DataAtualizacao)
			VALUES (@FormaPagamento, @ValorPagamento, @Obs, @IdUtilizadorInquilino, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE InsertFracoes

	--IdFracao INT,
	@ArtigoPerdial INT,
	@Permilagem DECIMAL(5,2),
	@IdUtilizador INT, 
	@IdCondominio INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Fracoes (ArtigoPerdial, Permilagem, IdUtilizador, IdCondominio, DataCriacao, DataAtualizacao)
			VALUES (@ArtigoPerdial, @Permilagem, @IdUtilizador, @IdCondominio, GETDATE(), GETDATE())

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


----------------------PROCEDURES UPDATE-------------------------------------------------

	GO
	CREATE OR ALTER PROCEDURE UpadateUtilizadores

	@IdUtilizador INT,
	@Nome NVARCHAR(200),
	@ContactoEmail NVARCHAR(30),
	@ContactoTelefone INT,
	@Nif INT,
	@Password VARBINARY(64),
	@Morada NVARCHAR(80),
	@IdCodigoPostal INT,
	@IdTipoUtilizador INT
	--@Inativo BIT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Utilizadores 
				SET Nome = @Nome,
					ContactoEmail = @ContactoEmail,
					ContactoTelefone = @ContactoTelefone,
					Nif = @Nif,
					[Password] = @Password,
					Morada = @Morada,
					IdCodigoPostal = @IdCodigoPostal,
					IdTipoUtilizador = @IdTipoUtilizador,
					--Inativo = @Inativo,
					DataAtualizacao = GETDATE()

				WHERE IdUtilizador = @IdUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpadateTipoUtilizador

	@IdTipoUtilizador INT,
	@Designcacao NVARCHAR(50)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE TipoUtilizador 
				SET Designcacao = @Designcacao,
					DataAtualizacao = GETDATE()

				WHERE IdTipoUtilizador = @IdTipoUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpadateCondominios 

	@IdCondominio INT,
	@Edificio NVARCHAR(50),
	@Morada NVARCHAR(80),
	@IdCodigoPostal INT,
	@Iban NVARCHAR(25),
	@Nif INT,
	@Quotas DECIMAL(5,2),
	@IdUtilizadorGestor INT
	--@Inativo BIT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Condominios 
				SET Edificio = @Edificio,
					Morada = @Morada,
					IdCodigoPostal = @IdCodigoPostal,
					Iban = @Iban,
					Nif = @Nif,
					Quotas = @Quotas,
					IdUtilizadorGestor = @IdUtilizadorGestor,
					--Inativo = @Inativo,
					DataAtualizacao = GETDATE()

				WHERE IdCondominio = @IdCondominio

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateCodigoPostal

	@IdCodigoPostal INT,
	@Localidade NVARCHAR(50)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE CodigoPostal
				SET Localidade = @Localidade,
					DataAtualizacao = GETDATE()

				WHERE IdCodigoPostal = @IdCodigoPostal

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateNotificacoes

	@IdNotificacao INT,
	@Descricao NVARCHAR(80),
	@IdUtilizadorCriador INT, 
	@IdUtilizadorRecetor INT,
	@IdCondominio INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Notificacoes
				SET Descricao = @Descricao,
					IdUtilizadorCriador = @IdUtilizadorCriador, 
					IdUtilizadorRecetor = @IdUtilizadorRecetor,
					IdCondominio = @IdCondominio,
					DataAtualizacao = GETDATE()

				WHERE IdNotificacao = @IdNotificacao

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateServicos 

	@IdServico INT,
	@IdTipoServico INT,
	@DataHoraPrevistaFim SMALLDATETIME,
	@IdUtilizadorGestor INT,
	@Obs NVARCHAR(200),
	@IdCondominio INT,
	@ValorServico DECIMAL(5,2)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Servicos
				SET IdTipoServico = @IdTipoServico,
					DataHoraPrevistaFim = @DataHoraPrevistaFim,
					IdUtilizadorGestor = @IdUtilizadorGestor,
					Obs = @Obs,
					IdCondominio = @IdCondominio,
					ValorServico = @ValorServico,
					DataAtualizacao = GETDATE()

				WHERE IdServico = @IdServico

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateTipoServico

	@IdTipoServico INT,
	@Descricao NVARCHAR(50)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE TipoServico
				SET Descricao= @Descricao,
					DataAtualizacao = GETDATE()

				WHERE IdTipoServico = @IdTipoServico

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateCabecalhoFatura

	@NumeroFatura NVARCHAR(7),
	@Data DATE,
	@IdUtilizadorInquilino INT,
	@IdCondominio INT, 
	@Estado NVARCHAR(10)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
		UPDATE CabecalhoFatura 
				SET [Data] = @Data,
					IdUtilizadorInquilino = @IdUtilizadorInquilino,
					Estado = @Estado,
					DataAtualizacao = GETDATE()

				WHERE NumeroFatura = @NumeroFatura

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateLinhaFatura

	@IdLinhaFatura INT,
	@NumeroFatura NVARCHAR(7),
	@DescricaoPagamento NVARCHAR(200),
	@ValorPagamento DECIMAL(5,2)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
		UPDATE LinhaFatura 
				SET NumeroFatura= @NumeroFatura,
					DescricaoPagamento = @DescricaoPagamento,
					ValorPagamento =  @ValorPagamento,
					DataAtualizacao = GETDATE()

				WHERE IdLinhaFatura = @IdLinhaFatura

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdatePagamentos

	@IdPagamento INT,
	@FormaPagamento NVARCHAR(50),
	@ValorPagamento DECIMAL(5,2),
	@Obs NVARCHAR(200),
	@IdUtilizadorInquilino INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
		UPDATE Pagamentos 
				SET FormaPagamento = @FormaPagamento,
					ValorPagamento = @ValorPagamento,
					Obs =  @Obs,
					IdUtilizadorInquilino = @IdUtilizadorInquilino,
					DataAtualizacao = GETDATE()

				WHERE IdPagamento = @IdPagamento

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateFracoes

	@IdFracao INT,
	@ArtigoPerdial INT,
	@Permilagem DECIMAL(5,2),
	@IdUtilizador INT, 
	@IdCondominio INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
		UPDATE Fracoes 
				SET ArtigoPerdial= @ArtigoPerdial,
					Permilagem = @Permilagem,
					IdUtilizador=  @IdUtilizador, 
					IdCondominio = @IdCondominio,
					DataAtualizacao = GETDATE()

				WHERE IdFracao = @IdFracao

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpdateInatividadeCondominios 

	@IdCondominio INT,
	@Edificio NVARCHAR(50),
	@Morada NVARCHAR(80),
	@IdCodigoPostal INT,
	@Iban NVARCHAR(25),
	@Nif INT,
	@Quotas DECIMAL(5,2),
	@IdUtilizadorGestor INT,
	@Inativo BIT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Condominios 
				SET Edificio = @Edificio,
					Morada = @Morada,
					IdCodigoPostal = @IdCodigoPostal,
					Iban = @Iban,
					Nif = @Nif,
					Quotas = @Quotas,
					IdUtilizadorGestor = @IdUtilizadorGestor,
					Inativo = @Inativo,
					DataAtualizacao = GETDATE(),
					Inativo = 0

				WHERE IdCondominio = @IdCondominio

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE UpadateInatividadeUtilizadores

	@IdUtilizador INT,
	@Nome NVARCHAR(200),
	@ContactoEmail NVARCHAR(30),
	@ContactoTelefone INT,
	@Nif INT,
	@Password VARBINARY(64),
	@Morada NVARCHAR(80),
	@IdCodigoPostal INT,
	@IdTipoUtilizador INT,
	@Inativo BIT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Utilizadores 
				SET Nome = @Nome,
					ContactoEmail = @ContactoEmail,
					ContactoTelefone = @ContactoTelefone,
					Nif = @Nif,
					[Password] = @Password,
					Morada = @Morada,
					IdCodigoPostal = @IdCodigoPostal,
					IdTipoUtilizador = @IdTipoUtilizador,
					Inativo = 0,
					DataAtualizacao = GETDATE()

				WHERE IdUtilizador = @IdUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END

-------------------------PROCEDURES DELETE--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	GO
	CREATE OR ALTER PROCEDURE DeleteUtilizadores

	@IdUtilizador INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM Utilizadores
				WHERE IdUtilizador = @IdUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteTipoUtilizador

	@IdTipoUtilizador INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM TipoUtilizador
				WHERE IdTipoUtilizador = @IdTipoUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteCondominios 

	@IdCondominio INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   DELETE FROM Condominios  
			   WHERE IdCondominio = @IdCondominio

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteCodigoPostal

	@IdCodigoPostal NVARCHAR(8)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM CodigoPostal
				WHERE IdCodigoPostal = @IdCodigoPostal

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteNotificacoes

	@IdNotificacao INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM Notificacoes 
				WHERE IdNotificacao = @IdNotificacao

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteServicos 

	@IdServico INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM Servicos 
				WHERE IdServico = @IdServico

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteTipoServico

	@IdTipoServico INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM TipoServico
				WHERE IdTipoServico = @IdTipoServico

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteCabecalhoFatura

	@NumeroFatura NVARCHAR(7)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM CabecalhoFatura
			WHERE NumeroFatura = @NumeroFatura

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeleteLinhaFatura

	@IdLinhaFatura INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM LinhaFatura
			WHERE IdLinhaFatura = @IdLinhaFatura

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeletePagamentos

	@IdPagamento INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM Pagamentos
			WHERE IdPagamento = @IdPagamento

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE DeteteFracoes

	@IdFracao INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   DELETE FROM Fracoes  
			   WHERE IdFracao = @IdFracao

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END

---------------------------PROCEDURES GET------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	GO
	CREATE OR ALTER PROCEDURE GetUtilizadoresById

	@IdUtilizador INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				SELECT * FROM Utilizadores
				WHERE IdUtilizador = @IdUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetTipoUtilizadorById

	@IdTipoUtilizador INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				SELECT * FROM TipoUtilizador
				WHERE IdTipoUtilizador = @IdTipoUtilizador

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetCondominiosById 

	@IdCondominio INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   SELECT * FROM Condominios  
			   WHERE IdCondominio = @IdCondominio

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetCodigoPostalById

	@IdCodigoPostal INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				SELECT * FROM CodigoPostal
				WHERE IdCodigoPostal = @IdCodigoPostal

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetNotificacoesById

	@IdNotificacao INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				SELECT * FROM Notificacoes 
				WHERE IdNotificacao = @IdNotificacao

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetServicosById 

	@IdServico INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				SELECT * FROM Servicos 
				WHERE IdServico = @IdServico

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetTipoServicoById

	@IdTipoServico INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				SELECT * FROM TipoServico
				WHERE IdTipoServico = @IdTipoServico

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetCabecalhoFaturaById

	@NumeroFatura NVARCHAR(7)

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			SELECT * FROM CabecalhoFatura
			WHERE NumeroFatura = @NumeroFatura

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetLinhaFaturaById

	@IdLinhaFatura INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			SELECT * FROM LinhaFatura
			WHERE IdLinhaFatura = @IdLinhaFatura

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetPagamentosById

	@IdPagamento INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			SELECT * FROM Pagamentos
			WHERE IdPagamento = @IdPagamento

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER PROCEDURE GetFracoesById

	@IdFracao INT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   SELECT * FROM Fracoes  
			   WHERE IdFracao = @IdFracao

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'An error occured, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END

-----------------------TRIGGERS---------------------------------------------------------------------------------------------------------------------------------------------------------------------

	GO
	CREATE OR ALTER TRIGGER RestrictTypeOfUser_Condominios

	ON Condominios
	INSTEAD OF INSERT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   INSERT INTO Condominios (Edificio, Morada, IdCodigoPostal, Iban, Nif, Quotas, IdUtilizadorGestor, SaldoAtual)
			   SELECT i.Edificio, i.Morada, i.IdCodigoPostal, i.Iban, i.Nif, i.Quotas, i.IdUtilizadorGestor, i.SaldoAtual
			   FROM inserted AS i
			   INNER JOIN Utilizadores AS u ON i.IdUtilizadorGestor = u.IdUtilizador
			   WHERE u.IdTipoUtilizador = 1

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		--Declare @errorMessage INT, @errorSeverity INT, @errorState INT

		--	SELECT
		--	@errorMessage = ERROR_MESSAGE(),
		--	@errorSeverity = ERROR_SEVERITY(),
		--	@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			--PRINT 'No gestor user found, transaction rolled back';

			--THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER TRIGGER RestrictTypeOfUser_Servicos

	ON Servicos
	INSTEAD OF INSERT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   INSERT INTO Servicos (IdTipoServico, DataHoraInicio, DataHoraPrevistaFim, IdUtilizadorGestor, Obs, IdCondominio, ValorServico, Anexo)
			   SELECT i.IdTipoServico, i.DataHoraInicio, i.DataHoraPrevistaFim, i.IdUtilizadorGestor, i.Obs, i.IdCondominio, i.ValorServico, i.Anexo
			   FROM inserted AS i
			   INNER JOIN Utilizadores AS u ON i.IdUtilizadorGestor = u.IdUtilizador
			   WHERE u.IdTipoUtilizador = 1

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		--Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			--SELECT
			--@errorMessage = ERROR_MESSAGE(),
			--@errorSeverity = ERROR_SEVERITY(),
			--@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			--PRINT 'Only Gestor user can be add, transaction rolled back';

			--THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER TRIGGER RestrictTypeOfUser_Pagamentos

	ON Pagamentos
	INSTEAD OF INSERT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   INSERT INTO Pagamentos (FormaPagamento, ValorPagamento, Obs, IdUtilizadorInquilino, IdCondominio)
			   SELECT i.FormaPagamento, i.ValorPagamento, i.Obs, i.IdUtilizadorInquilino, i.IdCondominio
			   FROM inserted AS i
			   INNER JOIN Utilizadores AS u ON i.IdUtilizadorInquilino = u.IdUtilizador
			   WHERE u.IdTipoUtilizador = 2

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		--Declare @errorMessage INT, @errorSeverity INT, @errorState INT

		--	SELECT
		--	@errorMessage = ERROR_MESSAGE(),
		--	@errorSeverity = ERROR_SEVERITY(),
		--	@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			--PRINT 'Only Inquilino user can do payments, transaction rolled back';

			--THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER TRIGGER RestrictTypeOfUser_CabecalhoFatura

	ON CabecalhoFatura
	INSTEAD OF INSERT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			   INSERT INTO CabecalhoFatura (NumeroFatura, [Data], IdUtilizadorInquilino, IdCondominio, Estado)
			   SELECT i.NumeroFatura, i.[Data], i.IdUtilizadorInquilino, i.IdCondominio, i.Estado
			   FROM inserted AS i
			   INNER JOIN Utilizadores AS u ON i.IdUtilizadorInquilino = u.IdUtilizador
			   WHERE u.IdTipoUtilizador = 2

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		--Declare @errorMessage INT, @errorSeverity INT, @errorState INT

		--	SELECT
		--	@errorMessage = ERROR_MESSAGE(),
		--	@errorSeverity = ERROR_SEVERITY(),
		--	@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			--PRINT 'Only Inquilino user can be here, transaction rolled back';

			--THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER TRIGGER UpdateSaldoAtual_Pagamentos

	ON Pagamentos
	AFTER INSERT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			   UPDATE Condominios
			   SET SaldoAtual = SaldoAtual + i.ValorPagamento FROM Condominios as c
			   INNER JOIN Inserted AS i
			   ON c.IdCondominio = i.IdCondominio

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'Error on UpdateSaldoAtual_Pagamentos, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END


	GO
	CREATE OR ALTER TRIGGER UpdateSaldoAtual_Servicos

	ON Servicos
	AFTER INSERT

	AS
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			   UPDATE Condominios
	           SET SaldoAtual = SaldoAtual - i.ValorServico FROM Condominios AS c
			   INNER JOIN Inserted AS i
	           ON c.IdCondominio = i.IdCondominio

		--Declare @ErrorDescription NVARCHAR(MAX)
			
		--	SELECT
		--	@ErrorDescription = 'Business error occurred, please be aware!'

		--	INSERT INTO Tabela2.ErrorLog(ErrorDescription, DataCriacao)
		--	VALUES (@ErrorDescription, GETDATE())

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		Declare @errorMessage INT, @errorSeverity INT, @errorState INT

			SELECT
			@errorMessage = ERROR_MESSAGE(),
			@errorSeverity = ERROR_SEVERITY(),
			@errorState = ERROR_STATE()

			ROLLBACK TRANSACTION
			PRINT 'Error on UpdateSaldoAtual_Servicos, transaction rolled back';

			THROW @errorMessage, @errorSeverity, @errorState;

			--RAISERROR (@errorMessage, @errorSeverity, @errorState);
		END CATCH
	END

-----------------------MANUAL INSERTS---------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TipoUtilizador
INSERT INTO TipoUtilizador (Designcacao)
     VALUES ('gestor')

INSERT INTO TipoUtilizador (Designcacao)
	 VALUES ('inquilino')

SELECT* FROM TipoUtilizador


--TipoServico
INSERT INTO TipoServico (Descricao)
VALUES ('jardinagem');

INSERT INTO TipoServico (Descricao)
VALUES ('limpeza');

INSERT INTO TipoServico (Descricao)
VALUES ('manutencao');

INSERT INTO TipoServico (Descricao)
VALUES ('outro');

SELECT * FROM TipoServico


--CodigoPostal
INSERT INTO CodigoPostal (IdCodigoPostal, Localidade)
VALUES ('4700-001', 'Braga');

INSERT INTO CodigoPostal (IdCodigoPostal, Localidade)
VALUES ('4600-001', 'Barcelos');

INSERT INTO CodigoPostal (IdCodigoPostal, Localidade)
VALUES ('4500-001', 'Guimarães');

INSERT INTO CodigoPostal (IdCodigoPostal, Localidade)
VALUES ('4400-001', 'Vila Verde');


SELECT * FROM CodigoPostal

--Utilizadores
INSERT INTO Utilizadores (Nome, ContactoEmail, ContactoTelefone, Nif, [Password], Morada, IdCodigoPostal, IdTipoUtilizador)
VALUES 
	('Ana Silva', 'anasilva@gmail.com', 927654321, 432765890, CRYPT_GEN_RANDOM(64), 'rua das flores', '4700-001', 2),
    ('Joana Silva', 'joanasilva@gmail.com', 927654321, 432765890, CRYPT_GEN_RANDOM(64), 'rua das flores', '4700-001', 1),
    ('John Doe', 'johndoe@gmail.com', 123456789, 987654321, CRYPT_GEN_RANDOM(64), '123 Main St', '4600-001', 2),
    ('Jane Smith', 'janesmith@gmail.com', 555555555, 111223344, CRYPT_GEN_RANDOM(64), '456 Oak Ave', '4400-001', 1),
    ('Bob Johnson', 'bobjohnson@gmail.com', 987654321, 444433332, CRYPT_GEN_RANDOM(64), 'rua das flores', '4700-001', 2),
    ('Emily Brown', 'emilybrown@gmail.com', 111222333, 555544443, CRYPT_GEN_RANDOM(64), '101 Elm St', '4700-001', 1),
    ('Mike Miller', 'mikemiller@gmail.com', 777888999, 666677778, CRYPT_GEN_RANDOM(64), '202 Maple Ave', '4600-001', 2),
    ('Sophie White', 'sophiewhite@gmail.com', 333444555, 999988887, CRYPT_GEN_RANDOM(64), '303 Cedar St', '4500-001', 2),
    ('Tom Taylor', 'tomtaylor@gmail.com', 666777888, 222211110, CRYPT_GEN_RANDOM(64), '404 Birch Ave', '4400-001', 2),
    ('Olivia Black', 'oliviablack@gmail.com', 444555666, 888877776, CRYPT_GEN_RANDOM(64), '505 Walnut St', '4700-001', 2),
    ('Henry Green', 'henrygreen@gmail.com', 999000111, 333322221, CRYPT_GEN_RANDOM(64), '606 Pine Ave', '4600-001', 2),
    ('Eva Davis', 'evadavis@gmail.com', 222333444, 777766665, CRYPT_GEN_RANDOM(64), '707 Oak St', '4500-001', 2);


SELECT * FROM Utilizadores


--Condominios
INSERT INTO Condominios (Edificio, Morada, IdCodigoPostal, Iban, Nif, Quotas, IdUtilizadorGestor, SaldoAtual)
VALUES 
    (56, 'Rua do Meio', '4700-001', '2345678901234567890123456', '654321987', 25, 2, 1500),
    (57, 'Rua de Baixo', '4600-001', '3456789012345678901234567', '789456123', 35, 4, 1800),
    (58, 'Avenida Principal', '4500-001', '4567890123456789012345678', '123789456', 28, 4, 2200),
    (59, 'Travessa das Flores', '4400-001', '5678901234567890123456789', '456987321', 32, 6, 2500),
    (60, 'Largo da Praça', '4700-001', '6789012345678901234567890', '789123654', 30, 6, 2000),
    (61, 'Avenida Secundária', '4600-001', '7890123456789012345678901', '234567890', 22, 6, 1700),
    (62, 'Rua dos Comerciantes', '4500-001', '8901234567890123456789012', '567890123', 18, 4, 2100),
    (63, 'Praça Central', '4500-001', '9012345678901234567890123', '890123456', 40, 4, 2800),
    (64, 'Avenida das Árvores', '4400-001', '0123456789012345678901234', '123456789', 26, 2, 1900),
    (65, 'Largo da Estação', '4700-001', '1234567890123456789012345', '987654321', 31, 2, 2300);

SELECT * FROM Condominios


--Fracoes
INSERT INTO Fracoes (ArtigoPerdial, Permilagem, IdUtilizador, IdCondominio)
VALUES 
    (659, 15.5, 1, 1),
    (660, 25.0, 3, 2),
    (661, 18.7, 5, 3),
    (662, 22.3, 7, 4),
    (663, 19.8, 8, 5),
    (664, 16.4, 9, 6),
    (665, 28.6, 10, 7),
    (666, 21.2, 11, 8),
    (667, 17.9, 12, 9);

SELECT * FROM Fracoes


--Servicos
INSERT INTO Servicos (IdTipoServico, DataHoraInicio, DataHoraPrevistaFim, IdUtilizadorGestor, Obs, IdCondominio, ValorServico, Anexo)
VALUES 
    (1, GETDATE(), GETDATE(), 2, 'Outras observações', 9, 750.00, NULL),
    (2, GETDATE(), GETDATE(), 2, 'Detalhes do serviço', 1, 100.00, NULL),
    (3, GETDATE(), GETDATE(), 4, 'Notas adicionais', 3, 120.00, NULL),
    (4, GETDATE(), GETDATE(), 4, 'Observações importantes', 7, 900.00, NULL),
    (1, GETDATE(), GETDATE(), 6, 'Comentários adicionais', 4, 600.00, NULL),
    (2, GETDATE(), GETDATE(), 6, 'Informações extras', 5, 800.00, NULL),
    (3, GETDATE(), GETDATE(), 2, 'Comentários adicionais', 9, 110.00, NULL),
    (4, GETDATE(), GETDATE(), 2, 'Detalhes do serviço', 10, 950.00, NULL),
    (1, GETDATE(), GETDATE(), 6, 'Outras observações', 6, 700.00, NULL),
    (2, GETDATE(), GETDATE(), 4, 'Observações importantes', 2, 850.00, NULL);

SELECT * FROM Servicos


--Pagamentos
INSERT INTO Pagamentos (FormaPagamento, ValorPagamento, Obs, IdUtilizadorInquilino, IdCondominio)
VALUES 
    ('Transferência Bancária', 150.50, 'Detalhes do pagamento', 1, 1),
    ('Transferência Bancária', 500.75, 'Notas adicionais', 5, 3),
    ('Transferência Bancária', 300.00, 'Comentários extras', 7, 4),
    ('Transferência Bancária', 800.30, 'Observações importantes', 9, 6),
    ('Transferência Bancária', 800.45, 'Detalhes do pagamento', 10, 7),
    ('Transferência Bancária', 700.20, 'Comentários adicionais', 11, 8),
    ('Transferência Bancária', 950.10, 'Notas adicionais', 12, 9),
    ('Transferência Bancária', 850.99, 'Observações importantes', 3, 2),
    ('Transferência Bancária', 630.80, 'Comentários extras', 8, 5),
    ('Transferência Bancária', 850.60, 'Detalhes do pagamento', 1, 1);


SELECT * FROM Pagamentos


--Notificacoes
INSERT INTO Notificacoes (Descricao, IdUtilizadorCriador, IdUtilizadorRecetor, DataHora, IdCondominio, Anexo)
VALUES 
    ('Problema no elevador', 1, 4, GETDATE(), 1, NULL),
    ('Reunião de condomínio marcada', 12, 6, GETDATE(), 9, NULL),
    ('Manutenção no sistema de segurança', 7, 4, GETDATE(), 4, NULL),
    ('Atraso na coleta de lixo', 4, 5, GETDATE(), 3, NULL),
    ('Festa no salão comunitário', 5, 6, GETDATE(), 3, NULL),
    ('Vazamento na área comum', 6, 7, GETDATE(), 4, NULL),
    ('Alteração no horário da limpeza', 7, 2, GETDATE(), 4, NULL),
    ('Aviso de assembleia extraordinária', 8, 4, GETDATE(), 5, NULL),
    ('Pintura do prédio agendada', 9, 6, GETDATE(), 6, NULL),
    ('Problema no interfone', 10, 2, GETDATE(), 7, NULL);

SELECT * FROM Notificacoes


--CabecalhoFatura
INSERT INTO CabecalhoFatura (NumeroFatura, Data, IdUtilizadorInquilino, IdCondominio, Estado)
VALUES ('1234567', getdate(), 1, 1, 'pago');

INSERT INTO CabecalhoFatura (NumeroFatura, Data, IdUtilizadorInquilino, IdCondominio, Estado)
VALUES 
    ('2345678', GETDATE(), 7, 4, 'não pago'),
    ('3456789', GETDATE(), 5, 3, 'não pago'),
    ('4567890', GETDATE(), 9, 6, 'pago'),
    ('5678901', GETDATE(), 10, 7, 'pago'),
    ('6789012', GETDATE(), 3, 2, 'não pago'),
    ('7890123', GETDATE(), 10, 7, 'não pago'),
    ('8901234', GETDATE(), 1, 1, 'pago'),
    ('9012345', GETDATE(), 12, 9, 'pago'),
    ('0123456', GETDATE(), 11, 8, 'não pago'),
    ('1558567', GETDATE(), 8, 5, 'não pago');


SELECT * FROM CabecalhoFatura

--LinhaFatura
INSERT INTO LinhaFatura (NumeroFatura, DescricaoPagamento, ValorPagamento)
VALUES ('1234567', 'quota jan24', 200.00);

INSERT INTO LinhaFatura (NumeroFatura, DescricaoPagamento, ValorPagamento)
VALUES 
    ('2345678', 'quota jan24', 150.50),
    ('3456789', 'quota dez23', 120.00),
    ('4567890', 'quota nov23', 180.25),
    ('5678901', 'quota nov23', 250.00),
    ('6789012', 'quota dez23', 180.00),
    ('7890123', 'quota jan24', 130.75),
    ('8901234', 'quota dez23', 110.50),
    ('9012345', 'quota fez24', 200.00),
    ('1558567', 'quota jan24', 220.75),
    ('0123456', 'quota fev24', 190.50),
    ('4567890', 'quota fev24', 140.00);

SELECT * FROM LinhaFatura



