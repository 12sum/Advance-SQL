USE student;
create table products (
product_id int primary key,
product_name varchar(100),
category varchar(50),
price decimal(10,2));

insert into products values
(1, 'keyboard', 'electronics', 1200),
(2, 'mouse', 'electronics', 800),
(3, 'chair', 'furniture', 2500),
(4, 'desk', 'furniture', 5500);

select * from products;

create table sales (
sales_id int primary key,
product_id int,
quantity int,
sale_date date,
foreign key (product_id) references products(product_id));

insert into sales values
(1,1,4,'2024-01-05'),
(2,2,10,'2024-01-06'),
(3,3,2,'2024-01-10'),
(4,4,1,'2024-01-11');

select * from sales;

## Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?

##   A Common Table Expression (CTE) is a temporary named result set in SQL that you define using the WITH keyword and reference within a query.
##   It helps break complex queries into smaller, readable parts.

## Q2. Why are some views updatable while others are read-only? Explain with an example.?

##  A view in SQL is a virtual table created from a query.
##  Some views are updatable, meaning you can use INSERT, UPDATE, or DELETE on them, while others are read-only because
##  SQL cannot safely determine how changes should affect the original tables.

## Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?

## Stored procedures are reusable SQL programs stored in the database that reduce the need to write the same queries repeatedly.
## They improve performance because they are precompiled and execute faster than raw SQL queries.
## They also provide better security and easier maintenance by centralizing database logic.

## Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.

## Triggers are database objects that automatically execute when events like INSERT, UPDATE, or DELETE occur on a table.
## They are used to enforce rules, maintain data integrity, and automate actions.
## Example: A trigger can automatically save deleted employee records into a backup/audit table before deletion.

## Q5. Explain the need for data modelling and normalization when designing a database.

## Data modelling helps organize database structure by defining tables, relationships, and data flow clearly.
## Normalization reduces data redundancy and improves data consistency by organizing data into related tables.
## Together, they make the database efficient, accurate, and easier to maintain.

## Q6. Write a CTE to calculate the total revenue for each product 
## (Revenues = Price × Quantity), and return only products where  revenue > 3000.

WITH revenue_cte AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.price,
        s.quantity,
        (p.price * s.quantity) AS revenue
    FROM products p
    JOIN sales s
    ON p.product_id = s.product_id
)

SELECT product_name, revenue
FROM revenue_cte
WHERE revenue > 3000;

## Q7. Create a view named that shows:  Category, TotalProducts, AveragePrice.

CREATE VIEW category_summary AS
SELECT 
    category,
    COUNT(*) AS TotalProducts,
    AVG(price) AS AveragePrice
FROM products
GROUP BY category;

SELECT * FROM category_summary;

## Q8. Create an updatable view containing ProductID, ProductName, and Price.  Then update the price of ProductID = 1 using the view.

CREATE VIEW product_view AS
SELECT 
    product_id,
    product_name,
    price
FROM products;

UPDATE product_view
SET price = 1500
WHERE product_id = 1;

## Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.

DELIMITER //

CREATE PROCEDURE GetProductsByCategory(
    IN cat_name VARCHAR(50)
)
BEGIN
    SELECT *
    FROM products
    WHERE category = cat_name;
END //

DELIMITER ;

CALL GetProductsByCategory('electronics');

## Q10. Create an AFTER DELETE trigger on the Product table that archives deleted product rows into a new
##  table ProductArchive. The archive should store ProductID, ProductName, Category, Price, and DeletedAt
## timestamp.

CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_after_delete_product
AFTER DELETE ON products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive
    VALUES (
        OLD.product_id,
        OLD.product_name,
        OLD.category,
        OLD.price,
        NOW()
    );
END //

DELIMITER ;

DELETE FROM products
WHERE product_id = 1;

SELECT * FROM ProductArchive;
