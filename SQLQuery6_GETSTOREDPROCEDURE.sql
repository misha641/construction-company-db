USE ConstructionCompany;
GO

CREATE OR ALTER PROCEDURE sp_GetEmployees
    @Search       NVARCHAR(100) = NULL,     
    @PositionID   INT = NULL,               
    @HireDateFrom DATE = NULL,              
    @HireDateTo   DATE = NULL,              
    @PageSize     INT = 10,                 
    @PageNumber   INT = 1,
    @SortColumn   VARCHAR(50) = 'EmployeeID',
    @SortDirection BIT = 0                  
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH EMP AS 
    (
        SELECT 
            e.EmployeeID,
            e.FullName,
            p.PositionName,
            e.Phone,
            e.HireDate
        FROM Employees e
        JOIN Positions p 
            ON e.PositionID = p.PositionID
        WHERE 
            (@Search IS NULL OR e.FullName LIKE '%' + @Search + '%')
            AND (@PositionID IS NULL OR e.PositionID = @PositionID)
            AND (@HireDateFrom IS NULL OR e.HireDate >= @HireDateFrom)
            AND (@HireDateTo IS NULL OR e.HireDate <= @HireDateTo)
    )

    SELECT 
        *,
        (SELECT COUNT(*) FROM EMP) AS TotalCount
    FROM EMP
    ORDER BY 
        CASE WHEN @SortDirection = 0 THEN
            CASE @SortColumn
                WHEN 'EmployeeID' THEN CAST(EmployeeID AS VARCHAR(50))
                WHEN 'FullName' THEN FullName
                WHEN 'PositionName' THEN PositionName
                WHEN 'HireDate' THEN CONVERT(VARCHAR(50), HireDate, 23)
            END
        END ASC,
        CASE WHEN @SortDirection = 1 THEN
            CASE @SortColumn
                WHEN 'EmployeeID' THEN CAST(EmployeeID AS VARCHAR(50))
                WHEN 'FullName' THEN FullName
                WHEN 'PositionName' THEN PositionName
                WHEN 'HireDate' THEN CONVERT(VARCHAR(50), HireDate, 23)
            END
        END DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

EXEC sp_GetEmployees;
EXEC sp_GetEmployees @Search = N'Іван';
EXEC sp_GetEmployees @PositionID = 4;
EXEC sp_GetEmployees @HireDateFrom = '2023-01-01';
EXEC sp_GetEmployees @SortColumn = 'FullName', @SortDirection = 1;
EXEC sp_GetEmployees @PageNumber = 2, @PageSize = 3;
go



CREATE OR ALTER PROCEDURE sp_GetWarehouseStock
    @MaterialID INT = NULL,
    @SupplierID INT = NULL,
    @Search NVARCHAR(100) = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(50) = 'StockID',
    @SortDirection NVARCHAR(4) = 'ASC'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX) = '
        SELECT 
            ws.StockID,
            m.MaterialName,
            ws.Quantity,
            ws.PricePerUnit,
            s.SupplierName,
            ws.SupplyDate
        FROM WarehouseStock ws
        JOIN Materials m ON ws.MaterialID = m.MaterialID
        JOIN Suppliers s ON ws.SupplierID = s.SupplierID
        WHERE ( @MaterialID IS NULL OR ws.MaterialID = @MaterialID )
          AND ( @SupplierID IS NULL OR ws.SupplierID = @SupplierID )
          AND ( @Search IS NULL OR m.MaterialName LIKE ''%'' + @Search + ''%'' )
        ORDER BY ' + QUOTENAME(@SortColumn) + ' ' + @SortDirection + '
        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    ';

    EXEC sp_executesql 
        @Sql,
        N'@MaterialID INT, @SupplierID INT, @Search NVARCHAR(100), @PageSize INT, @PageNumber INT',
        @MaterialID = @MaterialID, 
        @SupplierID = @SupplierID,
        @Search = @Search,
        @PageSize = @PageSize,
        @PageNumber = @PageNumber;
END;
GO

EXEC sp_GetWarehouseStock;
EXEC sp_GetWarehouseStock @Search = N'цемент';
EXEC sp_GetWarehouseStock @PageNumber = 1, @PageSize = 2;
EXEC sp_GetWarehouseStock @MaterialID = 3;
GO 

CREATE OR ALTER PROCEDURE sp_GetPayments
    @ClientID INT = NULL,
    @ContractID INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH PAY AS
    (
        SELECT
            pp.PaymentID,
            c.ClientName,
            ct.ContractNumber,
            pp.Amount,
            pp.PaymentType,
            pp.PaymentDate
        FROM ProjectPayments pp
        JOIN Contracts ct ON pp.ContractID = ct.ContractID
        JOIN Clients c ON ct.ClientID = c.ClientID
        WHERE
            (@ClientID IS NULL OR c.ClientID = @ClientID)
            AND (@ContractID IS NULL OR ct.ContractID = @ContractID)
            AND (@DateFrom IS NULL OR pp.PaymentDate >= @DateFrom)
            AND (@DateTo IS NULL OR pp.PaymentDate <= @DateTo)
    )

    SELECT *,
        (SELECT COUNT(*) FROM PAY) AS TotalCount
    FROM PAY
    ORDER BY PaymentDate DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

EXEC sp_GetPayments;
EXEC sp_GetPayments @ClientID = 1;
EXEC sp_GetPayments @DateFrom = '2023-01-01';
EXEC sp_GetPayments @PageSize = 2, @PageNumber = 1;
GO 

CREATE OR ALTER PROCEDURE sp_GetMaterialUsage
    @ProjectID INT = NULL,
    @MaterialID INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH MU AS
    (
        SELECT
            pr.ProjectName,
            m.MaterialName,
            mu.Quantity,
            mu.UsageDate
        FROM MaterialUsage mu
        JOIN Projects pr ON mu.ProjectID = pr.ProjectID
        JOIN Materials m ON mu.MaterialID = m.MaterialID
        WHERE
            (@ProjectID IS NULL OR mu.ProjectID = @ProjectID)
            AND (@MaterialID IS NULL OR mu.MaterialID = @MaterialID)
            AND (@DateFrom IS NULL OR mu.UsageDate >= @DateFrom)
            AND (@DateTo IS NULL OR mu.UsageDate <= @DateTo)
    )

    SELECT *,
        (SELECT COUNT(*) FROM MU) AS TotalCount
    FROM MU
    ORDER BY UsageDate DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

EXEC sp_GetMaterialUsage;
EXEC sp_GetMaterialUsage @ProjectID = 1;
EXEC sp_GetMaterialUsage @MaterialID = 3;
EXEC sp_GetMaterialUsage @PageNumber = 1, @PageSize = 2;
