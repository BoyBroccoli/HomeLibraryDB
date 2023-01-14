 -- Author: Dawan Savage Bell
 -- Date: January 13, 2023
 -- Description: Home Library DataBase to know which books are currently in my Home.
 
 CREATE DATABASE HomeLibraryDB;
 USE HomeLibraryDB;
 GO


 -- CREATING PUBLISHER TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Publisher' and xtype='U')
BEGIN
CREATE TABLE [dbo].Publisher (
    publisherID int IDENTITY(1,1) PRIMARY KEY,
    publishingName nvarchar(50)
);
END;
GO


-- CREATING GENRE TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Genre' and xtype='U')
BEGIN
CREATE TABLE [dbo].Genre (
    genreID int IDENTITY(1,1) PRIMARY KEY,
    genre varchar(30)
);
END;
GO

-- CREATING GENDER TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Gender' and xtype='U')
BEGIN
CREATE TABLE [dbo].Gender (
    genderID int IDENTITY(1,1) PRIMARY KEY,
    gender varchar(2)
);
END;
GO


 -- CREATING AUTHOR TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Author' and xtype='U')
BEGIN
CREATE TABLE [dbo].Author(
    authorID int IDENTITY(1,1) PRIMARY KEY,
    firstName nvarchar(30) NOT NULL,
    lastName nvarchar(30) NOT NULL,
	genderID int -- Foreign Key from Gender
);
END;
GO

-- CREATING BOOK TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Book' and xtype='U')
BEGIN
CREATE TABLE [dbo].Book (
    bookID int IDENTITY(1,1) PRIMARY KEY,
    title nvarchar(100) NOT NULL ,
    yearPublished date, -- YYYY-MM-DD
    ISBN varchar(45),
    genreID int, -- Foreign Key from Genre
	authorID int, -- Foreign Key from Author
	publisherID int, -- Foreign Key from Publisher
);
END;
GO


-- CREATING LIBRARY TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Library' and xtype='U')
BEGIN
CREATE TABLE [dbo].Library (
    libID int IDENTITY(1,1) PRIMARY KEY,
    bookID int -- Foreign Key from Book
);
END;
GO

-- CREATING RELATIONSHIPS --

-- AUTHOR TABLE RELATIONSHIP --
ALTER TABLE [dbo].Author
ADD CONSTRAINT FK_AUTHOR_GENDER
FOREIGN KEY(genderID) REFERENCES Gender(genderID)
ON DELETE CASCADE
ON UPDATE CASCADE;
GO

-- BOOK TABLE RELATIONSHIP --
ALTER TABLE [dbo].Book
ADD CONSTRAINT FK_Book_Genre
FOREIGN KEY(genreID) REFERENCES Genre(genreID)
ON DELETE CASCADE
ON UPDATE CASCADE;
GO

ALTER TABLE [dbo].Book
ADD CONSTRAINT FK_Book_Author
FOREIGN KEY(authorID) REFERENCES Author(authorID)
ON DELETE CASCADE
ON UPDATE CASCADE;
GO


ALTER TABLE [dbo].Book
ADD CONSTRAINT FK_Book_Publisher
FOREIGN KEY(publisherID) REFERENCES Publisher(publisherID)
ON DELETE CASCADE
ON UPDATE CASCADE;
GO

-- LIBRARY TABLE RELATIONSHIP --
ALTER TABLE [dbo].Library
ADD CONSTRAINT FK_Library_Book
FOREIGN KEY(bookID) REFERENCES Book(bookID)
ON DELETE CASCADE
ON UPDATE CASCADE;
GO


-- DATA --


-- GENDER -- 
INSERT INTO Gender (gender)
VALUES
	('M'), 
	('F'),
	('T'),
	('NB')
;
GO

-- GENRE TITLES --
INSERT INTO Genre (genre)
VALUES
    ('Fantasy'),
    ('Science Fiction'),
    ('Dystopian'),
    ('Action & Adventure'),
    ('Mystery'),
    ('Horror'),
    ('Thriller & Suspense'),
    ('Historical Fiction'),
    ('Romance'),
    ('Graphic Novel'),
    ('Short Story'),
    ('Young Adult'),
    ('Childrens'),
    ('Memory & Autobiography'),
    ('Biography'),
    ('Food & Drink'),
    ('Art & Photography'),
    ('Self-Help'),
    ('History'),
    ('Travel'),
    ('True Crime'),
    ('Humor'),
    ('Essays'),
    ('Guide/ How-to'),
    ('Religion & Spirituality'),
    ('Humanities & Social Sciences'),
    ('Parenting & Families'),
    ('Science & Technology'),
    ('Programming'),
    ('Poetry'),
    ('Magazine'),
    ('Health & Medicine'),
    ('Textbook'),
    ('Chinese Medicine'),
    ('Chinese Philosophy'),
	('Bibliography'),
	('Autobiography'),
	('Mythology'),
	('Philosophy')
;
GO


-----------------------
-- STORED PROCEDURES --
-----------------------


-- Procedure for Inserting Author --

CREATE OR ALTER PROCEDURE dbo.InsertAuthor
	@firstName nvarchar(30),
	@lastName nvarchar(30),
	@gender nvarchar(2)
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for declaring genderID
				DECLARE @genderID int = (SELECT [genderID] FROM Gender WHERE gender LIKE @gender )		
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to Declare genderID based off param given'
			END CATCH

			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Author([firstName],[lastName],[genderID])
				VALUES (@firstName,@lastName,@genderID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values for Author Table'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Author Values'
	END CATCH
END;
GO

-- TEST STORED PROCEDURE STORED PASSED --
EXEC dbo.InsertAuthor 'Charles','Bukowski','M';
GO


-- Procedure for Inserting Publisher --
CREATE OR ALTER PROCEDURE dbo.InsertPublisher
	@pubName nvarchar(50)
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Publisher([publishingName])
				VALUES (@pubName)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert publishingName'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Publisher Values'
	END CATCH
END;
GO


-- Insert Book Procedure --

CREATE OR ALTER PROCEDURE dbo.InsertBook
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
    @genreID int,
	@authorID int, 
	@publisherID int
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO


-- Graphic Novel Procedure --

CREATE OR ALTER PROCEDURE dbo.InsertGraphicNovelBook
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
	@authorID int, 
	@publisherID int
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for decalring genreID
				DECLARE @genreID int = (SELECT [genreID] FROM Genre WHERE genre LIKE 'Graphic Novel')
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set genreID'
			END CATCH
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO

-- Fantasy Procedure --
CREATE OR ALTER PROCEDURE dbo.InsertFantasyBook
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
	@authorID int, 
	@publisherID int
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for decalring genreID
				DECLARE @genreID int = (SELECT [genreID] FROM Genre WHERE genre LIKE 'Fantasy')
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set genreID'
			END CATCH
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO

-- Science Fiction Procedure
CREATE OR ALTER PROCEDURE dbo.InsertScienceFictionBook
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
	@authorID int, 
	@publisherID int
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for decalring genreID
				DECLARE @genreID int = (SELECT [genreID] FROM Genre WHERE genre LIKE 'Science Fiction')
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set genreID'
			END CATCH
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO

-- Poetry Procedure --

CREATE OR ALTER PROCEDURE dbo.InsertPoetryBook
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
	@authorID int, 
	@publisherID int
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for decalring genreID
				DECLARE @genreID int = (SELECT [genreID] FROM Genre WHERE genre LIKE 'Poetry')
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set genreID'
			END CATCH
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO

-- Young Adult Procedure -- 

CREATE OR ALTER PROCEDURE dbo.InsertYoungAdultBook
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
	@authorID int, 
	@publisherID int
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN
			BEGIN TRY -- Try Catch for decalring genreID
				DECLARE @genreID int = (SELECT [genreID] FROM Genre WHERE genre LIKE 'Young Adult')
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set genreID'
			END CATCH
			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO


-- Full Book Details Procedure

CREATE OR ALTER PROCEDURE dbo.InsertFullBookDetails
	@bookTitle nvarchar(50),
    @yearPublished date, -- YYYY-MM-DD
    @ISBN varchar(45),
    @genreID int,
	@authorFirstName nvarchar(30),
	@authorLastName nvarchar(30),
	@authorGender nvarchar(2),
	@publisherName nvarchar(50)
AS
BEGIN
	BEGIN TRY -- Try Catch for whole procedure
		BEGIN TRAN

			BEGIN TRY -- Try Catch for declaring genderID
				DECLARE @genderID int = (SELECT [genderID] FROM Gender WHERE gender LIKE @authorGender)		
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to Declare genderID based off param given'
			END CATCH


			BEGIN TRY -- Try Catch to insert Author firstName, lastName, and genderID
				INSERT INTO dbo.Author([firstName],[lastName],[genderID])
				VALUES (@authorFirstName, @authorLastName,@genderID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Author firstName, lastName, and genderID'
			END CATCH

			BEGIN TRY -- Try Catch to get authorID
				DECLARE @authorID int = (SELECT [authorID] FROM Author WHERE [firstName] LIKE @authorFirstName AND [lastName] LIKE @authorLastName)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set authorID.'
			END CATCH

			BEGIN TRY -- Try Catch to insert publishingName into Publisher
				INSERT INTO dbo.Publisher([publishingName])
				VALUES (@publisherName)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert publishingName'
			END CATCH

			BEGIN TRY -- Try Catch to get publisherID 
				DECLARE @publisherID int = (SELECT [publisherID] FROM Publisher WHERE [publishingName] LIKE @publisherName)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to set publisherID'
			END CATCH

			BEGIN TRY -- Try Catch for Inserting Author Values
				INSERT INTO dbo.Book([title],[yearPublished],[ISBN],[genreID],[authorID],[publisherID])
				VALUES (@bookTitle,@yearPublished,@ISBN,@genreID,@authorID,@publisherID)
			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert values into Book'
			END CATCH

			BEGIN TRY 
				BEGIN TRY -- Try catch for declaring bookID
					DECLARE @bookID int = (SELECT [bookID] FROM Book WHERE [title] LIKE @bookTitle)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to declare bookID'
				END CATCH

				BEGIN TRY -- Try Catch for Inserting bookID into Library
					INSERT INTO dbo.Library([bookID])
					VALUES (@bookID)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS 'Error: Unable to insert bookID into Library.'
				END CATCH

			END TRY
			BEGIN CATCH
				SELECT ERROR_MESSAGE() AS 'Error: Unable to insert book into Library'
			END CATCH

			IF (@@ERROR > 0)
				BEGIN 
					SELECT ERROR_MESSAGE() AS 'Error: Rolling Back.'
					ROLLBACK TRAN
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'Error: Unable to insert Book Values'
	END CATCH
END;
GO