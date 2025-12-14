USE ConstructionCompany;
GO

-- 1. Імена та Текст
ALTER TABLE Employees DROP CONSTRAINT IF EXISTS CK_Employees_FullName_NoDigits;
ALTER TABLE Employees WITH CHECK ADD CONSTRAINT CK_Employees_FullName_NoDigits CHECK (FullName NOT LIKE '%[0-9]%');
GO

ALTER TABLE Projects DROP CONSTRAINT IF EXISTS CK_Projects_Name_NotEmpty;
ALTER TABLE Projects WITH CHECK ADD CONSTRAINT CK_Projects_Name_NotEmpty CHECK (LEN(ProjectName) > 0);
GO

ALTER TABLE Materials DROP CONSTRAINT IF EXISTS CK_Materials_Name_NotEmpty;
ALTER TABLE Materials WITH CHECK ADD CONSTRAINT CK_Materials_Name_NotEmpty CHECK (LEN(MaterialName) > 0);
GO

ALTER TABLE Tools DROP CONSTRAINT IF EXISTS CK_Tools_Name_NotEmpty;
ALTER TABLE Tools WITH CHECK ADD CONSTRAINT CK_Tools_Name_NotEmpty CHECK (LEN(ToolName) > 0);
GO

ALTER TABLE Tools DROP CONSTRAINT IF EXISTS CK_Tools_Serial_NotEmpty;
ALTER TABLE Tools WITH CHECK ADD CONSTRAINT CK_Tools_Serial_NotEmpty CHECK (LEN(SerialNumber) > 0);
GO

-- 2. Контакти
ALTER TABLE Employees DROP CONSTRAINT IF EXISTS CK_Employees_Phone_Valid;
ALTER TABLE Employees WITH CHECK ADD CONSTRAINT CK_Employees_Phone_Valid CHECK (Phone NOT LIKE '%[^0-9+ ]%');
GO

ALTER TABLE Clients DROP CONSTRAINT IF EXISTS CK_Clients_Phone_Valid;
ALTER TABLE Clients WITH CHECK ADD CONSTRAINT CK_Clients_Phone_Valid CHECK (Phone NOT LIKE '%[^0-9+ ]%');
GO

ALTER TABLE Suppliers DROP CONSTRAINT IF EXISTS CK_Suppliers_Phone_Valid;
ALTER TABLE Suppliers WITH CHECK ADD CONSTRAINT CK_Suppliers_Phone_Valid CHECK (Phone NOT LIKE '%[^0-9+ ]%');
GO

ALTER TABLE Clients DROP CONSTRAINT IF EXISTS CK_Clients_Email_Valid;
ALTER TABLE Clients WITH CHECK ADD CONSTRAINT CK_Clients_Email_Valid CHECK (Email IS NULL OR Email LIKE '%_@_%._%');
GO

-- 3. Фінанси та Кількість
ALTER TABLE Positions DROP CONSTRAINT IF EXISTS CK_Positions_Salary_Positive;
ALTER TABLE Positions WITH CHECK ADD CONSTRAINT CK_Positions_Salary_Positive CHECK (BaseSalary > 0);
GO

ALTER TABLE Contracts DROP CONSTRAINT IF EXISTS CK_Contracts_Amount_Positive;
ALTER TABLE Contracts WITH CHECK ADD CONSTRAINT CK_Contracts_Amount_Positive CHECK (ContractAmount > 0);
GO

ALTER TABLE ProjectPayments DROP CONSTRAINT IF EXISTS CK_ProjectPayments_Amount_Positive;
ALTER TABLE ProjectPayments WITH CHECK ADD CONSTRAINT CK_ProjectPayments_Amount_Positive CHECK (Amount > 0);
GO

ALTER TABLE WarehouseStock DROP CONSTRAINT IF EXISTS CK_Warehouse_Quantity_Positive;
ALTER TABLE WarehouseStock WITH CHECK ADD CONSTRAINT CK_Warehouse_Quantity_Positive CHECK (Quantity >= 0);
GO

ALTER TABLE WarehouseStock DROP CONSTRAINT IF EXISTS CK_Warehouse_Price_Positive;
ALTER TABLE WarehouseStock WITH CHECK ADD CONSTRAINT CK_Warehouse_Price_Positive CHECK (PricePerUnit >= 0);
GO

ALTER TABLE MaterialUsage DROP CONSTRAINT IF EXISTS CK_MaterialUsage_Positive;
ALTER TABLE MaterialUsage WITH CHECK ADD CONSTRAINT CK_MaterialUsage_Positive CHECK (Quantity > 0);
GO

-- 4. Дати
ALTER TABLE Employees DROP CONSTRAINT IF EXISTS CK_Employees_HireDate_Past;
ALTER TABLE Employees WITH CHECK ADD CONSTRAINT CK_Employees_HireDate_Past CHECK (HireDate <= GETDATE());
GO

ALTER TABLE WarehouseStock DROP CONSTRAINT IF EXISTS CK_Warehouse_SupplyDate_Past;
ALTER TABLE WarehouseStock WITH CHECK ADD CONSTRAINT CK_Warehouse_SupplyDate_Past CHECK (SupplyDate <= GETDATE());
GO

ALTER TABLE Projects DROP CONSTRAINT IF EXISTS CK_Projects_StartDate_Valid;
ALTER TABLE Projects WITH CHECK ADD CONSTRAINT CK_Projects_StartDate_Valid CHECK (StartDate <= GETDATE());
GO

ALTER TABLE Projects DROP CONSTRAINT IF EXISTS CK_Projects_PlannedEnd;
ALTER TABLE Projects WITH CHECK ADD CONSTRAINT CK_Projects_PlannedEnd CHECK (PlannedEndDate IS NULL OR PlannedEndDate >= StartDate);
GO

ALTER TABLE ProjectStages DROP CONSTRAINT IF EXISTS CK_ProjectStages_DateRange;
ALTER TABLE ProjectStages WITH CHECK ADD CONSTRAINT CK_ProjectStages_DateRange CHECK (StartDate IS NULL OR EndDate IS NULL OR StartDate <= EndDate);
GO

-- 5. Години роботи
ALTER TABLE Timesheets DROP CONSTRAINT IF EXISTS CK_Timesheets_HoursRange;
ALTER TABLE Timesheets WITH CHECK ADD CONSTRAINT CK_Timesheets_HoursRange CHECK (HoursWorked >= 0 AND HoursWorked <= 24);
GO

-- 6. UNIQUE 
ALTER TABLE Contracts DROP CONSTRAINT IF EXISTS UQ_Contracts_Number;
ALTER TABLE Contracts ADD CONSTRAINT UQ_Contracts_Number UNIQUE (ContractNumber);
GO

ALTER TABLE Tools DROP CONSTRAINT IF EXISTS UQ_Tools_Serial;
ALTER TABLE Tools ADD CONSTRAINT UQ_Tools_Serial UNIQUE (SerialNumber);
GO

ALTER TABLE Employees DROP CONSTRAINT IF EXISTS UQ_Employees_Phone;
ALTER TABLE Employees ADD CONSTRAINT UQ_Employees_Phone UNIQUE (Phone);
GO

-- 7. DEFAULT 
ALTER TABLE Tools DROP CONSTRAINT IF EXISTS DF_Tools_IsAvailable;
ALTER TABLE Tools ADD CONSTRAINT DF_Tools_IsAvailable DEFAULT (1) FOR IsAvailable;
GO

ALTER TABLE WarehouseStock DROP CONSTRAINT IF EXISTS DF_Warehouse_SupplyDate;
ALTER TABLE WarehouseStock ADD CONSTRAINT DF_Warehouse_SupplyDate DEFAULT (GETDATE()) FOR SupplyDate;
GO

ALTER TABLE Timesheets DROP CONSTRAINT IF EXISTS DF_Timesheets_Hours;
ALTER TABLE Timesheets ADD CONSTRAINT DF_Timesheets_Hours DEFAULT (8) FOR HoursWorked;
GO

SELECT name AS [Constraint Name], type_desc AS [Type]
FROM sys.check_constraints
UNION
SELECT name, type_desc 
FROM sys.key_constraints
WHERE type = 'UQ'
ORDER BY [Constraint Name];