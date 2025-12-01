--membuat database
CREATE DATABASE RetailStoreDB_2;
GO

--memakai database
USE RetailStoreDB_2;
GO

/*Schema adalah wadah atau folder khusus di
dalam sebuah database yang digunakan untuk 
mengelompokkan tabel, view, function, dan 
objek-objek lainnya*/

--membuat skema Production
CREATE SCHEMA Production;
GO

--membuat skema Sales
CREATE SCHEMA Sales;
GO

--membuat skema HumanResources
CREATE SCHEMA HumanResources;
GO

--membuat tabel 
CREATE TABLE Production.Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ProductNumber NVARCHAR(50) NOT NULL,
    Color NVARCHAR(20) NULL,
    Size NVARCHAR(10) NULL,
    ListPrice DECIMAL(10,2) NOT NULL DEFAULT 0
);

--membuat tabel Sales.SalesOrderDetail
CREATE TABLE Sales.SalesOrderDetail (
    SalesOrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    SalesOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderQty INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal AS (OrderQty * UnitPrice) PERSISTED,
    SpecialOfferID INT NULL,
    FOREIGN KEY (ProductID) REFERENCES Production.Product(ProductID)
);

--membuat tabel HumanResources.Employee
CREATE TABLE HumanResources.Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    JobTitle NVARCHAR(100) NOT NULL
);

--memasukkan data ke tabel Production.Product
INSERT INTO Production.Product (Name, ProductNumber, Color, Size, ListPrice)
VALUES
('Road Bike Pro', 'RB-001', 'Red', 'L', 3500),
('Road Bike Entry', 'RB-101', 'Red', 'M', 1200),
('Mountain Bike XL', 'MB-500', 'Blue', 'XL', 2100),
('City Bike Small', 'CB-020', 'Black', 'S', 900),
('Helmet Pro', 'HL-001', 'Red', NULL, 150),
('Helmet Basic', 'HL-050', 'Black', NULL, 80),
('Gloves Sport', 'GL-020', 'Blue', NULL, 50),
('Tire Road 700C', 'TR-700', NULL, NULL, 45),
('Water Bottle', 'WB-100', NULL, NULL, 20),
('Cycling Jersey', 'CJ-200', 'Red', 'M', 300),
('Cycling Jersey', 'CJ-300', 'Black', 'L', 320);

--memasukkan data ke tabel Sales.SalesOrderDetail 
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, SpecialOfferID)
VALUES
(1, 1, 3, 3500, 1),
(1, 2, 1, 1200, 1),
(2, 1, 2, 3500, 2),
(3, 3, 4, 2100, 1),
(3, 4, 10, 900, 1),
(4, 5, 2, 150, 3),
(4, 6, 5, 80, 3),
(5, 7, 3, 50, 2),
(6, 8, 20, 45, 1),
(7, 9, 1, 20, 2),
(8, 10, 6, 300, 2),
(8, 11, 7, 320, 1),
(9, 1, 5, 3500, 1),   
(10, 3, 2, 2100, 1);  

-- memasukkan data ke tabel HumanResources.Employee
INSERT INTO HumanResources.Employee (JobTitle)
VALUES
('Sales Representative'),
('Sales Manager'),
('Technician'),
('Technician'),
('Senior Engineer'),
('Engineer');



-- Menampilkan semua data pada tabel produk
SELECT * 
FROM Production.Product;


-- Menampilkan Name, ProductNumber, dan ListPrice
SELECT Name, ProductNumber, ListPrice
FROM Production.Product;

-- Menampilkan data menggunakan alias kolom
SELECT Name AS [Nama Barang], ListPrice AS 'Harga Jual'
FROM Production.Product;


-- Menampilkan HargaBaru = ListPrice * 1.1
SELECT Name, ListPrice, (ListPrice * 1.1) AS HargaBaru 
FROM Production.Product;

-- Menampilkan data dengan menggabungkan string
SELECT Name + '(' + ProductNumber + ')' AS ProductLengkap 
FROM Production.Product;



-- Filterisasi Data

-- Menampilkan Produk yg Berwarna Merah
SELECT Name, Color, ListPrice 
FROM Production.Product 
WHERE Color = 'red';

-- Menampilkan produk yg ListPrice nya leih dari 1000
SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice > 1000;

-- Menampilkan Produk yg berwarna black dan ListPrice nya lebih dari 500
SELECT Name, Color, ListPrice 
FROM Production.Product
WHERE Color = 'black' AND ListPrice > 500;

-- Menampilkan Produk yg berwarna red, blue, atau black
SELECT Name, Color  
FROM Production.Product
WHERE Color IN ('red', 'blue', 'black');

-- Menampilkan produk yg namanya mengandung kata 'Road'
SELECT Name, ProductNumber
FROM Production.Product
WHERE Name Like '%Road%';




-- Agregasi dan Pengelompokan

-- Menghitung total baris
SELECT COUNT(*) AS TotalProduk
FROM Production.Product

-- Menampilkan warna produk dan jumlahnya
SELECT Color, COUNT(*) AS JumlahProduk
FROM Production.Product
GROUP BY Color;

-- Menampilkan ProductID, jumlah OrderQty, dan rata2 UnitPrice
SELECT ProductID, SUM(OrderQty) AS TotalTerjual, AVG(UnitPrice) AS RataRataHarga
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

SELECT *
FROM Sales.SalesOrderDetail;

-- Menampilkan data dengan grouping lebih dari satu kolom
SELECT Color, Size, COUNT(*) AS Jumlah
FROM Production.Product
GROUP BY Color, Size;

SELECT * 
FROM Production.Product;




-- Filter Hasil Agregasi

-- Menampilkan warna produk yg jumlahnya lebih dari 20
SELECT Color, COUNT(*) AS Jumlah
FROM Production.Product
GROUP BY Color
HAVING COUNT(*) > 2;

-- Menampilkan warna produk yg ListPrice nya > 500 dan jumlah nya < 10
SELECT Color, COUNT(*) AS Jumlah
FROM Production.Product
WHERE ListPrice > 500
GROUP BY Color
HAVING COUNT(*) < 10;

-- Menampilkan ProductID yg jumlah OrderQty nya lebih dari 100
SELECT ProductID , SUM(OrderQty) AS RataRataBEli
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(OrderQty) > 10;

-- Menampilkan SpecialOfferID yyg rata2 OrderQty nya > 2
SELECT SpecialOfferID, AVG(OrderQty) AS RataRataBeli
FROM Sales.SalesOrderDetail
GROUP BY SpecialOfferID
HAVING SUM(OrderQty) > 2;

-- Menampilkan warna yg ListPrice nya > 3000 menggunakan MAX
SELECT Color
FROM Production.Product
GROUP BY Color
HAVING MAX(ListPrice) > 300;




-- Advanced SELECT dan ORDER BY

-- Menampilkan JobTitle tanpa duplikat
SELECT  DISTINCT JobTitle
FROM HumanResources.Employee;

-- Menampilkan 5 nama produk termahal
SELECT TOP 5 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

SELECT TOP 5 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice ASC;

-- OFFSET FETCH
SELECT Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC
OFFSET 2 ROWS
FETCH NEXT 4 ROWS ONLY;

SELECT TOP 3 Color, SUM(ListPrice) AS TotalNilaiStok
FROM Production.Product
WHERE ListPrice > 0
GROUP BY Color
ORDER BY TotalNilaiStok DESC;



-- Tugas Mandiri

-- 1.
SELECT ProductID,SUM(LineTotal) AS TotalUang -- menampilkan ProductID & LineTotal AS TotalUang dan setiap kelompok produk, SQL melakukan SUM(LineTotal)
FROM Sales.SalesOrderDetail -- SQL mengambil semua data dari kolom SalesOrderDetail
GROUP BY ProductID; -- Mengelompok kan baris berdasarkan ProductID

-- 2. 
SELECT ProductID, SUM(LineTotal) AS TotalUang -- Menampilkan ProductID dan total uangnya, lalu menghitung total uang per produk dari baris yang sudah lolos filter
FROM Sales.SalesOrderDetail -- Ambil semua data dari SalesOrderDetail
WHERE OrderQty >= 2 -- SQL menyaring baris – hanya transaksi dengan OrderQty minimal 2 yang diproses
GROUP BY ProductID; -- Setelah disaring, data dikelompokkan berdasarkan ProductID

-- 3.
SELECT ProductID, SUM(LineTotal) AS TotalUang -- Menampilkan total uang dari tiap produk
FROM Sales.SalesOrderDetail -- Mengambil data dari SalesOrderDetail
WHERE OrderQty >= 2 -- Filter OrderQty >= 2
GROUP BY ProductID; -- Kelompokkan berdasarkan ProductID


-- 4.
SELECT ProductID, SUM(LineTotal) AS TotalUang -- Menampilkan ProductID & total uang dan Hitung total uang (SUM).
FROM Sales.SalesOrderDetail -- Ambil seluruh data
WHERE OrderQty >= 2 -- Hanya transaksi dengan jumlah pembelian ≥2
GROUP BY ProductID -- SQL mengelompokkan baris berdasarkan ProductID
HAVING SUM(LineTotal) > 50000; -- Filter hasil agregasi, hanya produk dengan pendapatan > 50.000 ditampilkan.


-- 5.
SELECT ProductID, SUM(LineTotal) AS TotalUang -- Menampilkan ProductID & total pendapatan lalu hitung SUM
FROM Sales.SalesOrderDetail -- Sumber data SalesOrderDetail.
WHERE OrderQty >= 2 -- Filter OrderQty >= 2
GROUP BY ProductID -- Kelompokkan per produk sesuai ProductID
HAVING SUM(LineTotal) > 50000 -- Filter pendapatan > 50.000
ORDER BY TotalUang DESC; -- Mengurutkan dari pendapatan terbesar ke terkecil


-- 6.
SELECT TOP 10 ProductID, SUM(LineTotal) AS TotalUang -- Menampilkan 10 produk dengan pendapatan tertinggi dan menghitung LineTotal sebagai TotalUang
FROM Sales.SalesOrderDetail -- Mengambil semua data transaksi
WHERE OrderQty >= 2 -- Filter transaksi dengan OrderQty minimal 2 ke atas
GROUP BY ProductID -- Mengelompokkan baris berdasarkan ProductID
HAVING SUM(LineTotal) > 50000 -- Filter produk dengan hanya total uang > 50.000
ORDER BY TotalUang DESC; -- Urutkan dari total pendapatan tertinggi