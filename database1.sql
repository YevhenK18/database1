USE [master]
GO
/****** Object:  Database [myprj]    Script Date: 21.04.2024 14:40:06 ******/
CREATE DATABASE [myprj]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'myprj', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\myprj.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'myprj_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\myprj_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [myprj] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [myprj].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [myprj] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [myprj] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [myprj] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [myprj] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [myprj] SET ARITHABORT OFF 
GO
ALTER DATABASE [myprj] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [myprj] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [myprj] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [myprj] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [myprj] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [myprj] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [myprj] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [myprj] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [myprj] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [myprj] SET  DISABLE_BROKER 
GO
ALTER DATABASE [myprj] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [myprj] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [myprj] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [myprj] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [myprj] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [myprj] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [myprj] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [myprj] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [myprj] SET  MULTI_USER 
GO
ALTER DATABASE [myprj] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [myprj] SET DB_CHAINING OFF 
GO
ALTER DATABASE [myprj] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [myprj] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [myprj] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [myprj] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [myprj] SET QUERY_STORE = ON
GO
ALTER DATABASE [myprj] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [myprj]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Books](
	[BookID] [int] NOT NULL,
	[Title] [nvarchar](100) NULL,
	[AuthorID] [int] NULL,
	[PublicationYear] [int] NULL,
	[GenreID] [int] NULL,
	[AvailabilityStatusID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Loans]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Loans](
	[LoanID] [int] NOT NULL,
	[BookID] [int] NULL,
	[UserID] [int] NULL,
	[LoanDate] [date] NULL,
	[ReturnDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[LoanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OverdueLoans]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OverdueLoans] AS
SELECT Loans.LoanID, Loans.LoanDate, Loans.ReturnDate, Books.Title AS BookTitle, Users.FirstName + ' ' + Users.LastName AS UserName
FROM Loans
INNER JOIN Books ON Loans.BookID = Books.BookID
INNER JOIN Users ON Loans.UserID = Users.UserID
WHERE Loans.ReturnDate < GETDATE();
GO
/****** Object:  View [dbo].[ActiveLoans]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ActiveLoans] AS
SELECT Loans.LoanID, Loans.LoanDate, Loans.ReturnDate, Books.Title AS BookTitle, Users.FirstName + ' ' + Users.LastName AS UserName
FROM Loans
INNER JOIN Books ON Loans.BookID = Books.BookID
INNER JOIN Users ON Loans.UserID = Users.UserID
WHERE Loans.ReturnDate IS NULL;
GO
/****** Object:  Table [dbo].[BookStatuses]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookStatuses](
	[StatusID] [int] NOT NULL,
	[StatusDescription] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UnavailableBooks]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UnavailableBooks] AS
SELECT Books.BookID, Books.Title, BookStatuses.StatusDescription
FROM Books
INNER JOIN BookStatuses ON Books.AvailabilityStatusID = BookStatuses.StatusID
WHERE BookStatuses.StatusDescription != 'Available';
GO
/****** Object:  Table [dbo].[Addresses]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses](
	[AddressID] [int] NOT NULL,
	[Street] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](50) NULL,
	[ZipCode] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Authors]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authors](
	[AuthorID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[DateOfBirth] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Position] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genres]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres](
	[GenreID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Publishers]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publishers](
	[PublisherID] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Address] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[PublisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD FOREIGN KEY([AuthorID])
REFERENCES [dbo].[Authors] ([AuthorID])
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD FOREIGN KEY([AvailabilityStatusID])
REFERENCES [dbo].[BookStatuses] ([StatusID])
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD FOREIGN KEY([GenreID])
REFERENCES [dbo].[Genres] ([GenreID])
GO
ALTER TABLE [dbo].[Loans]  WITH CHECK ADD FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[Loans]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
/****** Object:  StoredProcedure [dbo].[DeleteBook]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteBook]
    @BookID INT
AS
BEGIN
    DELETE FROM Books
    WHERE BookID = @BookID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetBookLoans]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBookLoans]
    @BookID INT
AS
BEGIN
    SELECT Loans.LoanID, Loans.LoanDate, Loans.ReturnDate, Users.FirstName + ' ' + Users.LastName AS UserName
    FROM Loans
    INNER JOIN Users ON Loans.UserID = Users.UserID
    WHERE Loans.BookID = @BookID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetLoansByDateRange]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLoansByDateRange]
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT Loans.LoanID, Loans.LoanDate, Loans.ReturnDate, Books.Title AS BookTitle, Users.FirstName + ' ' + Users.LastName AS UserName
    FROM Loans
    INNER JOIN Books ON Loans.BookID = Books.BookID
    INNER JOIN Users ON Loans.UserID = Users.UserID
    WHERE Loans.LoanDate BETWEEN @StartDate AND @EndDate;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetUserActiveLoans]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserActiveLoans]
    @UserID INT
AS
BEGIN
    SELECT Loans.LoanID, Loans.LoanDate, Loans.ReturnDate, Books.Title AS BookTitle
    FROM Loans
    INNER JOIN Books ON Loans.BookID = Books.BookID
    WHERE Loans.UserID = @UserID AND Loans.ReturnDate IS NULL;
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertBook]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBook]
    @Title NVARCHAR(100),
    @AuthorID INT,
    @PublicationYear INT,
    @GenreID INT,
    @AvailabilityStatusID INT
AS
BEGIN
    INSERT INTO Books (Title, AuthorID, PublicationYear, GenreID, AvailabilityStatusID)
    VALUES (@Title, @AuthorID, @PublicationYear, @GenreID, @AvailabilityStatusID);
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateBook]    Script Date: 21.04.2024 14:40:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateBook]
    @BookID INT,
    @Title NVARCHAR(100),
    @AuthorID INT,
    @PublicationYear INT,
    @GenreID INT,
    @AvailabilityStatusID INT
AS
BEGIN
    UPDATE Books
    SET Title = @Title,
        AuthorID = @AuthorID,
        PublicationYear = @PublicationYear,
        GenreID = @GenreID,
        AvailabilityStatusID = @AvailabilityStatusID
    WHERE BookID = @BookID;
END;
GO
USE [master]
GO
ALTER DATABASE [myprj] SET  READ_WRITE 
GO
