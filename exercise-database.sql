/*

CREATE TABLE [Students] (
    [StudentNumber] CHAR(8) NULL,
    [Firstname] NVARCHAR(50) NULL,
    [Lastname] NVARCHAR(50) NULL,
    [email] VARCHAR(100) NULL,
    [phone] CHAR(8) NULL,
    [Programme] CHAR(3) NULL
);
GO

CREATE TABLE [Programmes] (
	[Abbr] CHAR(3) NOT NULL, 
	[Name] VARCHAR(50) NOT NULL
);
GO

INSERT INTO Programmes
VALUES ('DMA', 'Datamatiker'), 
	('MMD', 'Multimedie Designer'), 
	('PSI', 'Top-up IT-Sikkerhed'), 
	('PSU', 'Top-up Softwareudvikling'), 
	('PWU', 'Top-up Webudvikling')
*/

declare @student_number char(8);
declare @firstname nvarchar(50);
declare @lastname nvarchar(50);
declare @email varchar(100)
declare @phone char(8);
declare @programme char(3);
declare @idx int = 0;

while @idx < 2000
	begin
		set @idx += 1
		-- student number
		select @student_number = LEFT(NEWID(), 8)

		-- firstname
		select @firstname = RndGenerator.dbo.getRandomFirstname();

		-- lastname
		select @lastname = RndGenerator.dbo.getRandomLastname();

		-- email 
		declare @username nchar(6)
		select @username = LEFT(@firstname + 'xxx', 3) + LEFT(@lastname + 'yyy', 3)
		select @email = LOWER(@username + '@' + Webdomain)
		from (select Name as Webdomain, ROW_NUMBER() over (order by name asc) as #row
			  from RndGenerator.dbo.Domains) as d
		where #row = FLOOR(RAND()*10000)+1

		-- phone
		--FLOOR(RAND()*(b-a+1))+a;
		declare @areacode char(2) = FLOOR(RAND()*78)+22;
		declare @number char(6) = FLOOR(RAND()*999999)+1;
		SELECT @phone = @areacode +''+ REPLICATE('0',6-LEN(RTRIM(@number))) + RTRIM(@number)

		-- programme
		SELECT @programme = Abbr 
		FROM (SELECT *, ROW_NUMBER() over (order by abbr asc) as row#
			  FROM Programmes) AS p
		WHERE p.row# = FLOOR(RAND()*5)+1

		insert into Students
		select 
			@student_number as StudentNumber,
			@firstname as Firstname, 
			@lastname as Lastname, 
			@email as Email, 
			@phone as Phone, 
			@programme as Programme
end;
