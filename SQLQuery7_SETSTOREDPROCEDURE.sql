USE ConstructionCompany;
GO

--sp_SetEmployee — додати/оновити працівника
CREATE OR ALTER PROCEDURE sp_SetEmployee
    @EmployeeID INT = NULL OUTPUT,
    @FullName NVARCHAR(150),
    @PositionID INT,
    @Phone VARCHAR(20),
    @HireDate DATE
AS
BEGIN
    BEGIN TRY
        
        IF @FullName LIKE '%[0-9]%'
        BEGIN
            RAISERROR ('Ім’я не може містити цифри', 16, 1);
            RETURN;
        END

        IF @Phone LIKE '%[^0-9+ ]%'
        BEGIN
            RAISERROR ('Телефон містить неприпустимі символи', 16, 1);
            RETURN;
        END

        IF @HireDate > GETDATE()
        BEGIN
            RAISERROR ('Дата найму не може бути у майбутньому', 16, 1);
            RETURN;
        END

        IF @EmployeeID IS NULL
        BEGIN
            INSERT INTO Employees(FullName, PositionID, Phone, HireDate)
            VALUES (@FullName, @PositionID, @Phone, @HireDate);

            SET @EmployeeID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE Employees 
            SET FullName = @FullName,
                PositionID = @PositionID,
                Phone = @Phone,
                HireDate = @HireDate
            WHERE EmployeeID = @EmployeeID;
        END

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

DECLARE @newID INT;

EXEC sp_SetEmployee 
    @EmployeeID = @newID OUTPUT,
    @FullName = N'Симеренко Степан',
    @PositionID = 6,
    @Phone = '447743744',
    @HireDate = '2025-05-10';

SELECT @newID AS NewEmployeeID;
GO

EXEC sp_SetEmployee 
    @EmployeeID = 3,          
    @FullName = N'Іваненко П.',
    @PositionID = 2,
    @Phone = '0987654321',
    @HireDate = '2022-05-10';
GO

--sp_SetContract — створення/оновлення проекту
CREATE OR ALTER PROCEDURE sp_SetProject
    @ProjectID INT = NULL OUTPUT,
    @ProjectName NVARCHAR(200),
    @Address NVARCHAR(255),
    @ContractID INT,
    @StartDate DATE,
    @PlannedEndDate DATE,
    @StatusID INT
AS
BEGIN
    BEGIN TRY

        IF LEN(@ProjectName) = 0
        BEGIN
            RAISERROR ('Назва проекту не може бути порожньою', 16, 1);
            RETURN;
        END

        IF @PlannedEndDate IS NOT NULL AND @PlannedEndDate < @StartDate
        BEGIN
            RAISERROR ('Дата завершення не може бути раніше дати початку', 16, 1);
            RETURN;
        END

        IF @StartDate > GETDATE()
        BEGIN
            RAISERROR ('Дата початку не може бути у майбутньому', 16, 1);
            RETURN;
        END

        IF @ProjectID IS NULL
        BEGIN
            INSERT INTO Projects(ProjectName, Address, ContractID, StartDate, PlannedEndDate, StatusID)
            VALUES (@ProjectName, @Address, @ContractID, @StartDate, @PlannedEndDate, @StatusID);

            SET @ProjectID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE Projects
            SET ProjectName = @ProjectName,
                Address = @Address,
                ContractID = @ContractID,
                StartDate = @StartDate,
                PlannedEndDate = @PlannedEndDate,
                StatusID = @StatusID
            WHERE ProjectID = @ProjectID;
        END

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

DECLARE @pid INT;

EXEC sp_SetProject 
    @ProjectID = @pid OUTPUT,
    @ProjectName = N'Будинок на вулиці Шевченка',
    @Address = N'м. Київ, вул. Шевченка 12',
    @ContractID = 1,
    @StartDate = '2024-01-01',
    @PlannedEndDate = '2024-07-01',
    @StatusID = 1;

SELECT @pid AS NewProjectID;
GO

EXEC sp_SetProject 
    @ProjectID = 1,
    @ProjectName = N'Будинок (оновлено)',
    @Address = N'Київ, вул. Шевченка 12',
    @ContractID = 1,
    @StartDate = '2024-01-01',
    @PlannedEndDate = '2024-09-01',
    @StatusID = 2;
GO


--sp_SetContract — створення/оновлення договору
CREATE OR ALTER PROCEDURE sp_SetContract
    @ContractID INT = NULL OUTPUT,
    @ContractNumber NVARCHAR(50),
    @ContractDate DATE,
    @ContractAmount DECIMAL(15, 2),
    @ClientID INT,
    @Description NVARCHAR(MAX) = NULL
AS
BEGIN
    BEGIN TRY

        IF @ContractAmount <= 0
        BEGIN
            RAISERROR ('Сума договору повинна бути > 0', 16, 1);
            RETURN;
        END

        IF @ContractDate > GETDATE()
        BEGIN
            RAISERROR ('Дата договору не може бути у майбутньому', 16, 1);
            RETURN;
        END

        IF @ContractID IS NULL
        BEGIN
            INSERT INTO Contracts(ContractNumber, ContractDate, ContractAmount, ClientID, Description)
            VALUES (@ContractNumber, @ContractDate, @ContractAmount, @ClientID, @Description);

            SET @ContractID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE Contracts
            SET ContractNumber = @ContractNumber,
                ContractDate = @ContractDate,
                ContractAmount = @ContractAmount,
                ClientID = @ClientID,
                Description = @Description
            WHERE ContractID = @ContractID;
        END
        
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

DECLARE @cid INT;

EXEC sp_SetContract
    @ContractID = @cid OUTPUT,
    @ContractNumber = 'CNT-2024-001',
    @ContractDate = '2024-01-10',
    @ContractAmount = 350000,
    @ClientID = 1,
    @Description = N'Будівництво житлового будинку';

SELECT @cid AS NewContractID;
GO

EXEC sp_SetContract
    @ContractID = 1,
    @ContractNumber = 'CNT-2024-001-UPDATED',
    @ContractDate = '2024-01-10',
    @ContractAmount = 360000,
    @ClientID = 1,
    @Description = N'Оновлений опис';
GO

--sp_SetMaterialUsage — списання матеріалів на проект
CREATE OR ALTER PROCEDURE sp_SetMaterialUsage
    @UsageID INT = NULL OUTPUT,
    @ProjectID INT,
    @MaterialID INT,
    @Quantity DECIMAL(10,2),
    @UsageDate DATE = NULL
AS
BEGIN
    BEGIN TRY

        IF @Quantity <= 0
        BEGIN
            RAISERROR ('Кількість повинна бути > 0', 16, 1);
            RETURN;
        END

        IF @UsageDate IS NULL 
            SET @UsageDate = GETDATE();

        IF @UsageID IS NULL
        BEGIN
            INSERT INTO MaterialUsage(ProjectID, MaterialID, Quantity, UsageDate)
            VALUES (@ProjectID, @MaterialID, @Quantity, @UsageDate);

            SET @UsageID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE MaterialUsage
            SET ProjectID = @ProjectID,
                MaterialID = @MaterialID,
                Quantity = @Quantity,
                UsageDate = @UsageDate
            WHERE UsageID = @UsageID;
        END

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

DECLARE @uid INT;

EXEC sp_SetMaterialUsage
    @UsageID = @uid OUTPUT,
    @ProjectID = 1,
    @MaterialID = 2,
    @Quantity = 150,
    @UsageDate = '2024-02-01';

SELECT @uid AS NewUsageID;
GO

EXEC sp_SetMaterialUsage
    @UsageID = 1,
    @ProjectID = 1,
    @MaterialID = 2,
    @Quantity = 200,
    @UsageDate = '2024-02-02';
GO

--sp_SetTimesheet — табель (хто скільки відпрацював)
CREATE OR ALTER PROCEDURE sp_SetTimesheet
    @RecordID INT = NULL OUTPUT,
    @EmployeeID INT,
    @ProjectID INT,
    @Date DATE,
    @AttendanceTypeID INT,
    @HoursWorked DECIMAL(4,1),
    @Notes NVARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY

        IF @HoursWorked < 0 OR @HoursWorked > 24
        BEGIN
            RAISERROR ('Години роботи повинні бути від 0 до 24', 16, 1);
            RETURN;
        END

        IF @RecordID IS NULL
        BEGIN
            INSERT INTO Timesheets(EmployeeID, ProjectID, Date, AttendanceTypeID, HoursWorked, Notes)
            VALUES (@EmployeeID, @ProjectID, @Date, @AttendanceTypeID, @HoursWorked, @Notes);

            SET @RecordID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE Timesheets
            SET EmployeeID = @EmployeeID,
                ProjectID = @ProjectID,
                Date = @Date,
                AttendanceTypeID = @AttendanceTypeID,
                HoursWorked = @HoursWorked,
                Notes = @Notes
            WHERE RecordID = @RecordID;
        END

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

DECLARE @tid INT;

EXEC sp_SetTimesheet
    @RecordID = @tid OUTPUT,
    @EmployeeID = 1,
    @ProjectID = 1,
    @Date = '2024-02-01',
    @AttendanceTypeID = 1,
    @HoursWorked = 8,
    @Notes = N'Прибув вчасно';

SELECT @tid AS NewRecordID;
GO

EXEC sp_SetTimesheet
    @RecordID = 3,
    @EmployeeID = 1,
    @ProjectID = 1,
    @Date = '2024-02-01',
    @AttendanceTypeID = 2,
    @HoursWorked = 4,
    @Notes = N'Пішов раніше';
GO