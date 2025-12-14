USE ConstructionCompany;
GO

INSERT INTO dbo.Positions(PositionName, BaseSalary) VALUES
(N'Генеральний директор', 50000.00),
(N'Виконроб', 25000.00),
(N'Муляр', 18000.00),
(N'Водій', 15000.00),
(N'Електрик', 17000.00),
(N'Різноробочий', 12000.00);

INSERT INTO Units (UnitName) VALUES
(N'шт'),
(N'кг'),
(N'м³'),
(N'л'),
(N'м²'),
(N'т');

INSERT INTO MaterialTypes (TypeName) VALUES
(N'Сипучі матеріали'),
(N'Цегла та блоки'),
(N'Пиломатеріали'),
(N'Лакофарбові'),
(N'Електрика');

INSERT INTO ToolTypes (TypeName) VALUES
(N'Електроінструмент'),
(N'Важка техніка'),
(N'Ручний інструмент'),
(N'Вимірювальні прилади');

INSERT INTO ProjectStatuses (StatusName) VALUES
(N'Планується'),
(N'В роботі'),
(N'Призупинено'),
(N'Завершено');

INSERT INTO AttendanceTypes (TypeName, IsPaid) VALUES
(N'Робочий день', 1),
(N'Лікарняний', 1),
(N'Відпустка', 1),
(N'Прогул', 0);

INSERT INTO Clients (ClientName, ContactPerson, Phone, Email, Address) VALUES
(N'ТОВ "Житло-Інвест"', N'Петренко Сергій', '+380501112233', 'info@zhytlo.ua', N'м. Київ, вул. Хрещатик, 1'),
(N'ПП "Захід-Сервіс"', N'Ковальчук Ольга', '+380679998877', 'olga@zahid.com', N'м. Львів, пл. Ринок, 5'),
(N'Григоренко Василь Іванович', N'Григоренко В.І.', '+380635554433', NULL, N'м. Київ, приватний сектор');

INSERT INTO Suppliers (SupplierName, ContactPerson, Phone) VALUES
(N'Епіцентр К', N'Менеджер будматеріалів', '0800500100'),
(N'Цегельний завод №1', N'Сидоренко Андрій', '+380441234567'),
(N'Бетон-Груп', N'Майстер відвантаження', '+380501230099');

INSERT INTO Employees (FullName, PositionID, Phone, HireDate) VALUES
(N'Шевченко Тарас Григорович', 2, '0991111111', '2023-01-15'),
(N'Франко Іван Якович',       3, '0992222222', '2023-02-01'),
(N'Українка Леся',            4, '0993333333', '2023-03-10'),
(N'Стус Василь',              5, '0994444444', '2023-05-20'),
(N'Тичина Павло',             6, '0995555555', '2023-06-01');

INSERT INTO Contracts (ContractNumber, ContractDate, ContractAmount, ClientID, Description) VALUES
(N'№15/Б-2023', '2023-08-01', 1500000.00, 1, N'Будівництво котеджу під ключ'),
(N'№02/Р-2023', '2023-09-10', 50000.00,   3, N'Ремонт даху приватного будинку');

INSERT INTO ProjectPayments (ContractID, PaymentDate, Amount, PaymentType, Notes) VALUES
(1, '2023-08-02', 500000.00, N'Аванс', N'Згідно договору №15/Б-2023');


INSERT INTO Projects (ProjectName, Address, ContractID, StartDate, PlannedEndDate, StatusID) VALUES
(N'Котедж "Лісовий"', N'с. Вишневе, вул. Лісова 5', 1, '2023-08-05', '2023-12-31', 2),
(N'Ремонт даху',       N'м. Київ, вул. Садова 12',   2, '2023-09-15', '2023-09-25', 4);

INSERT INTO ProjectStages (ProjectID, StageName, StartDate, EndDate) VALUES
(1, N'Риття котловану',      '2023-08-05', '2023-08-10'),
(1, N'Заливка фундаменту',   '2023-08-11', '2023-08-25'),
(1, N'Зведення стін',        '2023-08-26', NULL);

INSERT INTO Materials (MaterialName, MaterialTypeID, UnitID) VALUES
(N'Цемент М-500',             1, 2),
(N'Цегла червона рядова',     2, 1),
(N'Пісок річковий',           1, 6),
(N'Кабель мідний 3х2.5',      5, 4),
(N'Фарба фасадна',            4, 4);

INSERT INTO WarehouseStock (MaterialID, SupplierID, Quantity, PricePerUnit, SupplyDate) VALUES
(1, 1, 2000.00, 5.50, '2023-08-01'),
(2, 2, 10000.00, 8.00, '2023-08-02'),
(3, 3, 20.00, 450.00, '2023-08-03');

INSERT INTO MaterialUsage (ProjectID, MaterialID, Quantity, UsageDate) VALUES
(1, 1, 500.00, '2023-08-15'),
(1, 3, 5.00,   '2023-08-15');

INSERT INTO Timesheets (EmployeeID, ProjectID, Date, AttendanceTypeID, HoursWorked, Notes) VALUES
(1, 1, '2023-09-01', 1, 8.0, NULL),
(2, 1, '2023-09-01', 1, 8.0, NULL),
(5, 1, '2023-09-01', 4, 0.0, N'Не вийшов на зв''язок');

INSERT INTO Tools (ToolName, SerialNumber, ToolTypeID, SupplierID, PurchaseDate, CurrentProjectID) VALUES
(N'Перфоратор Bosch 2-26', 'SN-998877', 1, 1, '2023-01-20', 1),
(N'Бетономішалка Forte',   'SN-112233', 2, 1, '2023-02-15', 1),
(N'Рівень лазерний',       'SN-555',    4, 1, '2023-03-01', NULL);

SELECT * FROM Positions;
SELECT * FROM Units;
SELECT * FROM MaterialTypes;
SELECT * FROM ToolTypes;
SELECT * FROM ProjectStatuses;
SELECT * FROM AttendanceTypes;

SELECT * FROM Clients;
SELECT * FROM Suppliers;
SELECT * FROM Employees;

SELECT * FROM Contracts;
SELECT * FROM ProjectPayments;

SELECT * FROM Materials;
SELECT * FROM WarehouseStock;

SELECT * FROM Projects;
SELECT * FROM ProjectStages;

SELECT * FROM MaterialUsage;
SELECT * FROM Timesheets;

SELECT * FROM Tools;
