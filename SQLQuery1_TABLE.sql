USE ConstructionCompany;
GO

/* 1. ДОВІДНИКИ */

-- 1. Посади
CREATE TABLE Positions (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    PositionName NVARCHAR(100) NOT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL
);

-- 2. Одиниці виміру
CREATE TABLE Units (
    UnitID INT IDENTITY(1,1) PRIMARY KEY,
    UnitName NVARCHAR(20) NOT NULL
);

-- 3. Типи матеріалів
CREATE TABLE MaterialTypes (
    MaterialTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL
);

-- 4. Типи інструментів
CREATE TABLE ToolTypes (
    ToolTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL
);

-- 5. Статуси проектів
CREATE TABLE ProjectStatuses (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL
);

-- 6. Типи відвідувань (явка, прогул, лікарняний)
CREATE TABLE AttendanceTypes (
    AttendanceTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    IsPaid BIT NOT NULL DEFAULT 1
);

/* 2. КОНТРАГЕНТИ ТА ПЕРСОНАЛ */

-- 7. Клієнти
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    ClientName NVARCHAR(150) NOT NULL,
    ContactPerson NVARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address NVARCHAR(255)
);

-- 8. Постачальники
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(150) NOT NULL,
    ContactPerson NVARCHAR(100),
    Phone VARCHAR(20)
);

-- 9. Працівники
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    PositionID INT NOT NULL,
    Phone VARCHAR(20),
    HireDate DATE NOT NULL,
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID)
);

/* 3. ЮРИДИЧНИЙ БЛОК */

-- 10. Договори
CREATE TABLE Contracts (
    ContractID INT IDENTITY(1,1) PRIMARY KEY,
    ContractNumber NVARCHAR(50) NOT NULL,
    ContractDate DATE NOT NULL,
    ContractAmount DECIMAL(15,2) NOT NULL,
    ClientID INT NOT NULL,
    Description NVARCHAR(MAX),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

-- 11. Платежі по договорах
CREATE TABLE ProjectPayments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    ContractID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    PaymentType NVARCHAR(50),
    Notes NVARCHAR(255),
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID)
);

/* 5. ПРОЕКТИ */

-- 15. Проекти
CREATE TABLE Projects (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(200) NOT NULL,
    Address NVARCHAR(255),
    ContractID INT NOT NULL,
    StartDate DATE NOT NULL,
    PlannedEndDate DATE,
    StatusID INT NOT NULL,
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID),
    FOREIGN KEY (StatusID) REFERENCES ProjectStatuses(StatusID)
);

-- 16. Етапи робіт 
CREATE TABLE ProjectStages (
    StageID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT NOT NULL,
    StageName NVARCHAR(150) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

/* 4. РЕСУРСИ */

-- 12. Матеріали
CREATE TABLE Materials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialName NVARCHAR(150) NOT NULL,
    MaterialTypeID INT NOT NULL,
    UnitID INT NOT NULL,
    FOREIGN KEY (MaterialTypeID) REFERENCES MaterialTypes(MaterialTypeID),
    FOREIGN KEY (UnitID) REFERENCES Units(UnitID)
);

-- 13. Склад (закупівлі)
CREATE TABLE WarehouseStock (
    StockID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialID INT NOT NULL,
    SupplierID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,
    PricePerUnit DECIMAL(10,2) NOT NULL,
    SupplyDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 14. Інструменти (без обліку видачі!)
CREATE TABLE Tools (
    ToolID INT IDENTITY(1,1) PRIMARY KEY,
    ToolName NVARCHAR(150) NOT NULL,
    SerialNumber VARCHAR(50) UNIQUE,
    ToolTypeID INT NOT NULL,
    SupplierID INT,
    PurchaseDate DATE,
    IsWorking BIT DEFAULT 1,
    CurrentProjectID INT NULL,
    FOREIGN KEY (ToolTypeID) REFERENCES ToolTypes(ToolTypeID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CurrentProjectID) REFERENCES Projects(ProjectID)
);

/* 6. ОПЕРАЦІЙНІ ТАБЛИЦІ */

-- 17. Витрати матеріалів
CREATE TABLE MaterialUsage (
    UsageID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT NOT NULL,
    StageID INT,
    MaterialID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,
    UsageDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (StageID) REFERENCES ProjectStages(StageID),
    FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);

-- 18. Табель робочого часу
CREATE TABLE Timesheets (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    Date DATE NOT NULL,
    AttendanceTypeID INT NOT NULL,
    HoursWorked DECIMAL(4,1) DEFAULT 8.0,
    Notes NVARCHAR(255),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (AttendanceTypeID) REFERENCES AttendanceTypes(AttendanceTypeID)
);
