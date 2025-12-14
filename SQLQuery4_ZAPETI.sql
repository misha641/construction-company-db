USE ConstructionCompany;
GO 
-- Працівники та їхні посади
SELECT 
    e.EmployeeID,
    e.FullName,
    p.PositionName,
    p.BaseSalary
FROM Employees AS e
JOIN Positions AS p
    ON e.PositionID = p.PositionID;

--Працівники, які ще не працювали на жодному
SELECT 
    e.EmployeeID,
    e.FullName,
    p.ProjectName
FROM Employees e
LEFT JOIN Timesheets t 
    ON e.EmployeeID = t.EmployeeID
LEFT JOIN Projects p 
    ON t.ProjectID = p.ProjectID
WHERE t.EmployeeID IS NULL; 

--Проекти + клієнти + статуси проектів
SELECT 
    pr.ProjectID,
    pr.ProjectName,
    s.StatusName AS ProjectStatus,
    c.ClientName,
    c.Phone AS ClientPhone
FROM Projects AS pr
JOIN ProjectStatuses AS s 
    ON pr.StatusID = s.StatusID
JOIN Contracts AS co 
    ON pr.ContractID = co.ContractID
JOIN Clients AS c 
    ON co.ClientID = c.ClientID;

--Витрати матеріалів на проектах
SELECT
    pr.ProjectName,
    m.MaterialName,
    mu.Quantity,
    mu.UsageDate
FROM MaterialUsage AS mu
JOIN Projects AS pr 
    ON mu.ProjectID = pr.ProjectID
JOIN Materials AS m 
    ON mu.MaterialID = m.MaterialID;

--Табель робочого часу хто де працював
SELECT 
    e.FullName,
    p.ProjectName,
    t.Date,
    t.HoursWorked,
    at.TypeName AS AttendanceStatus
FROM Timesheets AS t
JOIN Employees AS e 
    ON t.EmployeeID = e.EmployeeID
JOIN Projects AS p 
    ON t.ProjectID = p.ProjectID
JOIN AttendanceTypes AS at
    ON t.AttendanceTypeID = at.AttendanceTypeID;

--Складські запаси + постачальники + матеріали
SELECT 
    ws.StockID,
    m.MaterialName,
    ws.Quantity,
    ws.PricePerUnit,
    s.SupplierName,
    ws.SupplyDate
FROM WarehouseStock AS ws
JOIN Materials AS m 
    ON ws.MaterialID = m.MaterialID
JOIN Suppliers AS s 
    ON ws.SupplierID = s.SupplierID;

--Гроші (Платежі по договорах)
SELECT 
    Con.ContractNumber AS ContractNumber,
    Cl.ClientName AS ClientName,
    PP.PaymentDate AS PaymentDate,
    PP.Amount AS Amount,
    PP.PaymentType AS PaymentType
FROM ProjectPayments AS PP
JOIN Contracts AS Con 
    ON PP.ContractID = Con.ContractID
JOIN Clients AS Cl 
    ON Con.ClientID = Cl.ClientID
ORDER BY PP.PaymentDate DESC;


