USE ConstructionCompany;
GO

-- 1. Ім'я працівника містить цифри CK_Employees_FullName_NoDigits
INSERT INTO Employees (FullName, PositionID, Phone, HireDate)
VALUES (N'Петренко123', 1, '0991234567', '2023-01-01');
GO

-- 2. Телефон працівника містить літери CK_Employees_Phone_Valid
INSERT INTO Employees (FullName, PositionID, Phone, HireDate)
VALUES (N'Тест Телефон', 1, '099A234567', '2023-01-01');
GO

-- 3. Телефон клієнта містить літери CK_Clients_Phone_Valid
INSERT INTO Clients (ClientName, ContactPerson, Phone)
VALUES (N'Клієнт з поганим телефоном', N'Тест', '380ABCD999');
GO

-- 4. Невалідний email клієнта CK_Clients_Email_Valid
INSERT INTO Clients (ClientName, Phone, Email)
VALUES (N'Клієнт з поганим email', '0999999999', 'ne_pravylnoemail');
GO

-- 5. Негативна зарплата CK_Positions_Salary_Positive
INSERT INTO Positions (PositionName, BaseSalary)
VALUES (N'Фейкова посада', -1000.00);
GO

-- 6. Негативна кількість на складі CK_Warehouse_Quantity_Positive
INSERT INTO WarehouseStock (MaterialID, SupplierID, Quantity, PricePerUnit, SupplyDate)
VALUES (1, 1, -10.0, 5.50, GETDATE());
GO

-- 7. Негативна ціна на складі CK_Warehouse_Price_Positive
INSERT INTO WarehouseStock (MaterialID, SupplierID, Quantity, PricePerUnit, SupplyDate)
VALUES (1, 1, 10.0, -5.50, GETDATE());
GO

-- 8. Дата найму в майбутньому CK_Employees_HireDate_Past
INSERT INTO Employees (FullName, PositionID, Phone, HireDate)
VALUES (N'Працівник з майбутнього', 1, '0997777777', DATEADD(DAY, 10, GETDATE()));
GO

-- 9. Дата початку проєкту в майбутньому CK_Projects_StartDate_Valid
INSERT INTO Projects (ProjectName, Address, ContractID, StartDate, PlannedEndDate, StatusID)
VALUES (N'Проєкт з майбутнього', N'Адреса', 1, DATEADD(DAY, 5, GETDATE()), DATEADD(DAY, 10, GETDATE()), 1);
GO

-- 10. Дата завершення раніше за дату початку CK_Projects_PlannedEnd
INSERT INTO Projects (ProjectName, Address, ContractID, StartDate, PlannedEndDate, StatusID)
VALUES (N'Проєкт з кривими датами', N'Адреса', 1, '2024-05-10', '2024-05-01', 1);
GO

-- 11. EndDate < StartDate CK_ProjectStages_DateRange
INSERT INTO ProjectStages (ProjectID, StageName, StartDate, EndDate)
VALUES (1, N'Кривий етап', '2024-05-10', '2024-05-01');
GO

-- 12. Неприпустима кількість годин у табелі (>24) порушення CK_Timesheets_HoursRange
INSERT INTO Timesheets (EmployeeID, ProjectID, Date, AttendanceTypeID, HoursWorked)
VALUES (1, 1, '2024-05-01', 1, 25.0);
GO

-- 13. Порожня назва матеріалу CK_Materials_Name_NotEmpty
INSERT INTO Materials (MaterialName, MaterialTypeID, UnitID)
VALUES (N'', 1, 1);
GO

-- 14. Нульова/негативна витрата матеріалу CK_MaterialUsage_Positive
INSERT INTO MaterialUsage (ProjectID, MaterialID, Quantity, UsageDate)
VALUES (1, 1, 0.0, GETDATE());
GO

-- 15. Порожній серійний номер інструменту CK_Tools_Serial_NotEmpty
INSERT INTO Tools (ToolName, SerialNumber, ToolTypeID, IsWorking)
VALUES (N'Тестовий інструмент', '', 1, 1);
GO

-- 16. Негативна сума договору CK_Contracts_Amount_Positive
INSERT INTO Contracts (ContractNumber, ContractDate, ContractAmount, ClientID)
VALUES (N'NEG-001', '2024-01-01', -5000.00, 1);
GO


-- 17. Негативна сума платежу CK_ProjectPayments_Amount_Positive
INSERT INTO ProjectPayments (ContractID, PaymentDate, Amount, PaymentType)
VALUES (1, '2024-01-10', -1000.00, N'Оплата');
GO

-- 18. Дублікат номера договору
INSERT INTO Contracts (ContractNumber, ContractDate, ContractAmount, ClientID)
VALUES (N'№15/Б-2023', '2024-02-01', 1000.00, 1);
GO

-- 19. Дублікат серійного номера інструменту
INSERT INTO Tools (ToolName, SerialNumber, ToolTypeID, IsWorking)
VALUES (N'Ще один перфоратор', N'SN-998877', 1, 1);
GO

-- 20. Дублікат номера телефону працівника
INSERT INTO Employees (FullName, PositionID, Phone, HireDate)
VALUES (N'Дублікат телефону', 1, '+380991111111', '2023-01-01');
GO
