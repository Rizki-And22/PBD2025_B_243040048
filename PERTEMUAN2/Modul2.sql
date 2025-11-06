--buat database Toko Ini Abadi
CREATE DATABASE TokoIniAbadi;

--gunakanDB
USE TokoIniAbadi;

--membuat tabel produk
CREATE TABLE KategoriProduk (	
	KategoriID INT IDENTITY(1,1) PRIMARY KEY,
	NamaKategori VARCHAR (100) NOT NULL UNIQUE
	);

-- Table produk
CREATE TABLE Produk (
	ProdukID INT IDENTITY(1001,1) PRIMARY KEY,
	SKU VARCHAR (20) NOT NULL UNIQUE,
	NamaProduk VARCHAR(150) NOT NULL,
	Harga DECIMAL (10,2) NOT NULL,
	Stok INT NOT NULL,
	KategoriID INT NULL,

	--harganya gabole negatif
	CONSTRAINT CHK_hargaPositif CHECK (Harga>=0),
	--stok gabole negatif
	CONSTRAINT CHK_StokPositif CHECK (Stok>=0),
	--Relasikan dengn tabel kategoriproduk
	CONSTRAINT FK_Produk_Kategori
		FOREIGN KEY (KategoriID)
		REFERENCES KategoriProduk(KategoriID)
);

--memasukan data kategori produk
INSERT INTO KategoriProduk (NamaKategori)
VALUES
('Elektronik');

INSERT INTO KategoriProduk (NamaKategori)
VALUES
('Pakaian'),
('Buku');

--menampilkan tabel kategoriproduk
SELECT*
FROM KategoriProduk

--menampilkan hanya nama kategori
SELECT NamaKategori
FROM KategoriProduk

--menambahkan data ke table produk

INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, kategoriID)
VALUES
('ELEC-001', 'Laptop', 15000000.00, 50, 2);

INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, kategoriID)
VALUES
('ELEC-002', 'Handphone', 5000000.00, 50, 1);

--menampilkan table produk
SElECT *
FROM Produk;

--mengurangi stok
UPDATE Produk
SET Stok = 30
WHERE ProdukID = 1001;

--menghapus data handphone
BEGIN TRANSACTION;

DELETE FROM Produk
WHERE ProdukID = 1002;

--menyimpan secara permanen
COMMIT TRANSACTION;

--menambah data lagi ke table produk
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, kategoriID)
VALUES
('BAJU-001', 'Kaos', 50000.00, 50, 3);

INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, kategoriID)
VALUES
('BAJU-002', 'Jaket', 2550000.00, 50, 3);

SELECT *
FROM Produk;

--menghapus kaoas
BEGIN TRANSACTION;

DELETE FROM Produk
WHERE ProdukID = 1004;

--mengembalikan data kaos
ROLLBACK TRANSACTION;
