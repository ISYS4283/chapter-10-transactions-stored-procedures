DROP TABLE c10_products;
CREATE TABLE c10_products (
	id INT IDENTITY PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	price MONEY NOT NULL CHECK(price > 0)
);

SELECT * FROM c10_products;

INSERT INTO c10_products
	(name, price)
SELECT TOP 100 [Primary_Desc],
	AVG([Unit_Retail_Amount]) AS 'Price'
FROM [UA_SAMSCLUB].[dbo].[ITEM_DESC_old] i
JOIN [UA_SAMSCLUB].[dbo].[ITEM_SCAN] s
  ON i.[Item_Nbr] = s.[Item_Nbr]
GROUP BY [Primary_Desc]


CREATE TABLE c10_customers (
	id INT IDENTITY PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL
);

INSERT INTO c10_customers
(first_name, last_name)
SELECT DISTINCT TOP 1000 [First_Name]
      ,[Last_Name]
FROM [UA_HALLUX].[dbo].[Customer]
WHERE first_name IS NOT NULL
  AND Last_Name IS NOT NULL

SELECT * FROM c10_customers;

DROP TABLE c10_orderhead
CREATE TABLE c10_orderhead (
	id INT IDENTITY PRIMARY KEY,
	customer_id INT NOT NULL FOREIGN KEY REFERENCES c10_customers(id),
	ordered_at DATETIME2 DEFAULT GETDATE()
);

INSERT INTO c10_orderhead (customer_id) VALUES (1);
SELECT * FROM c10_orderhead;

DROP TABLE c10_orderitem;
CREATE TABLE c10_orderitem (
	id INT IDENTITY PRIMARY KEY,
	orderhead_id INT NOT NULL FOREIGN KEY REFERENCES c10_orderhead(id),
	quantity INT NOT NULL CHECK(quantity > 0),
	product_id INT NOT NULL FOREIGN KEY REFERENCES c10_products(id)
);


INSERT INTO c10_orderitem (orderhead_id, quantity, product_id) VALUES (1, 3, 7);

SELECT * FROM c10_orderitem;


SELECT *
FROM c10_orderhead h
FULL JOIN c10_orderitem i
  ON h.id = i.orderhead_id




BEGIN TRANSACTION;

INSERT INTO c10_orderhead (customer_id) VALUES (1);
INSERT INTO c10_orderitem (orderhead_id, quantity, product_id)
VALUES (3, 20, 12);

COMMIT;

ROLLBACK;






SELECT *
FROM c10_orderhead h
FULL JOIN c10_orderitem i
  ON h.id = i.orderhead_id

DROP PROCEDURE c10_orderproduct;
-- header // customer
-- item // product, quantity
CREATE PROCEDURE c10_orderproduct
	@customer_id INT,
	@product_id  INT,
	@quantity    INT
AS
SET NOCOUNT ON;

DECLARE @orderhead_id INT;

BEGIN TRY
	BEGIN TRANSACTION;
		INSERT INTO c10_orderhead (customer_id) VALUES (@customer_id);

		SET @orderhead_id = SCOPE_IDENTITY();

		INSERT INTO c10_orderitem (orderhead_id, quantity, product_id)
		VALUES (@orderhead_id, @quantity, @product_id);
	COMMIT;
END TRY

BEGIN CATCH
	ROLLBACK;
	THROW;
END CATCH
GO


EXEC c10_orderproduct @customer_id = 1, @product_id = 1001, @quantity = 13

SELECT *
FROM c10_orderhead h
FULL JOIN c10_orderitem i
  ON h.id = i.orderhead_id


---
--- CROSS JOIN
---

CREATE TABLE c10_months (
	name VARCHAR(9) PRIMARY KEY
);


INSERT INTO c10_months (name)
VALUES ('January'), ('February'),('March'),('April'),('May'),('June'),('July'),('August'),('September'),('October'),('November'),('December');


SELECT * FROM c10_months;

CREATE TABLE c10_years (
	[year] SMALLINT PRIMARY KEY
);

INSERT INTO c10_years ([year]) VALUES (2017),(2018),(2019),(2020),(2021);


SELECT * FROM c10_months;
SELECT * FROM c10_years;

CREATE TABLE c10_datedim (
	id INT IDENTITY PRIMARY KEY,
	[month] VARCHAR(9),
	[year] SMALLINT
);


SELECT * FROM c10_datedim;

INSERT INTO c10_datedim ([month], [year])
SELECT name, [year]
FROM c10_months
CROSS JOIN c10_years;
