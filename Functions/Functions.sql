DROP DATABASE IF EXISTS bookstore; 
CREATE DATABASE bookstore; 
USE bookstore;
CREATE TABLE authors ( author_id INT AUTO_INCREMENT PRIMARY KEY, author_name VARCHAR(50), country VARCHAR(30) );
CREATE TABLE books ( book_id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(100), author_id INT, price DECIMAL(10,2), stock INT, published_year INT, FOREIGN KEY (author_id) REFERENCES authors(author_id) );
INSERT INTO authors (author_name, country) VALUES ('Chetan Bhagat', 'India'), ('J.K. Rowling', 'UK'), ('George R.R. Martin', 'USA'), ('R.K. Narayan', 'India'), ('Agatha Christie', 'UK');
INSERT INTO books (title, author_id, price, stock, published_year) VALUES ('Five Point Someone', 1, 250, 10, 2004), ('2 States', 1, 300, 5, 2009), ('Harry Potter', 2, 800, 15, 1997), ('Game of Thrones', 3, 1200, 8, 1996), ('Malgudi Days', 4, 200, 12, 1943), ('Murder on the Orient Express', 5, 500, 6, 1934);


DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(50),
  country VARCHAR(30)
);

CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100),
  author_id INT,
  price DECIMAL(10,2),
  stock INT,
  published_year INT,
  FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

INSERT INTO authors (author_name, country) VALUES
('Chetan Bhagat', 'India'),
('J.K. Rowling', 'UK'),
('George R.R. Martin', 'USA'),
('R.K. Narayan', 'India'),
('Agatha Christie', 'UK');

INSERT INTO books (title, author_id, price, stock, published_year) VALUES
('Five Point Someone', 1, 250, 10, 2004),
('2 States', 1, 300, 5, 2009),
('Harry Potter', 2, 800, 15, 1997),
('Game of Thrones', 3, 1200, 8, 1996),
('Malgudi Days', 4, 200, 12, 1943),
('Murder on the Orient Express', 5, 500, 6, 1934);

-- ============================================
-- Question 1: Total number of books in stock
-- ============================================
DROP FUNCTION IF EXISTS total_books_in_stock;
DELIMITER //
CREATE FUNCTION total_books_in_stock()
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT SUM(stock) INTO total FROM books;
  RETURN total;
END //
DELIMITER ;
SELECT total_books_in_stock() AS Total_Books_In_Stock;

-- ============================================
-- Question 2: Price of a given book title
-- ============================================
DROP FUNCTION IF EXISTS get_book_price;
DELIMITER //
CREATE FUNCTION get_book_price(bookTitle VARCHAR(100))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE price DECIMAL(10,2);
  SELECT price INTO price FROM books WHERE title = bookTitle;
  RETURN price;
END //
DELIMITER ;
SELECT get_book_price('Harry Potter') AS Book_Price;

-- ============================================
-- Question 3: Count books by a given author
-- ============================================
DROP FUNCTION IF EXISTS books_by_author;
DELIMITER //
CREATE FUNCTION books_by_author(authorName VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total
  FROM books b JOIN authors a ON b.author_id = a.author_id
  WHERE a.author_name = authorName;
  RETURN total;
END //
DELIMITER ;
SELECT books_by_author('Chetan Bhagat') AS Books_By_Author;

-- ============================================
-- Question 4: Book is "Old" or "New"
-- ============================================
DROP FUNCTION IF EXISTS book_age_status;
DELIMITER //
CREATE FUNCTION book_age_status(bookTitle VARCHAR(100))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  DECLARE year INT;
  DECLARE status VARCHAR(10);
  SELECT published_year INTO year FROM books WHERE title = bookTitle;
  IF year < 2000 THEN
    SET status = 'Old';
  ELSE
    SET status = 'New';
  END IF;
  RETURN status;
END //
DELIMITER ;
SELECT book_age_status('Game of Thrones') AS Status;

-- ============================================
-- Question 5: 10% discount on book price
-- ============================================
DROP FUNCTION IF EXISTS discounted_price;
DELIMITER //
CREATE FUNCTION discounted_price(bookTitle VARCHAR(100))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE price DECIMAL(10,2);
  DECLARE discount DECIMAL(10,2);
  SELECT price INTO price FROM books WHERE title = bookTitle;
  SET discount = price * 0.10;
  RETURN price - discount;
END //
DELIMITER ;
SELECT discounted_price('Harry Potter') AS Discounted_Price;

-- ============================================
-- Question 6: Author's country for a given book
-- ============================================
DROP FUNCTION IF EXISTS author_country_for_book;
DELIMITER //
CREATE FUNCTION author_country_for_book(bookTitle VARCHAR(100))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
  DECLARE country VARCHAR(30);
  SELECT a.country INTO country
  FROM authors a
  JOIN books b ON a.author_id = b.author_id
  WHERE b.title = bookTitle;
  RETURN country;
END //
DELIMITER ;
SELECT author_country_for_book('Malgudi Days') AS Author_Country;

-- ============================================
-- Question 7: Total stock value (price × stock)
-- ============================================
DROP FUNCTION IF EXISTS total_stock_value;
DELIMITER //
CREATE FUNCTION total_stock_value()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(price * stock) INTO total FROM books;
  RETURN total;
END //
DELIMITER ;
SELECT total_stock_value() AS Total_Stock_Value;

-- ============================================
-- Question 8: Oldest book title
-- ============================================
DROP FUNCTION IF EXISTS oldest_book;
DELIMITER //
CREATE FUNCTION oldest_book()
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE oldestTitle VARCHAR(100);
  SELECT title INTO oldestTitle
  FROM books
  ORDER BY published_year ASC
  LIMIT 1;
  RETURN oldestTitle;
END //
DELIMITER ;
SELECT oldest_book() AS Oldest_Book;

-- ============================================
-- Question 9: Check if book is in stock
-- ============================================
DROP FUNCTION IF EXISTS is_book_in_stock;
DELIMITER //
CREATE FUNCTION is_book_in_stock(bookTitle VARCHAR(100))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  DECLARE qty INT;
  DECLARE status VARCHAR(10);
  SELECT stock INTO qty FROM books WHERE title = bookTitle;
  IF qty > 0 THEN
    SET status = 'Yes';
  ELSE
    SET status = 'No';
  END IF;
  RETURN status;
END //
DELIMITER ;
SELECT is_book_in_stock('2 States') AS In_Stock;

-- ============================================
-- Question 10: Total books by authors from country
-- ============================================
DROP FUNCTION IF EXISTS books_by_country;
DELIMITER //
CREATE FUNCTION books_by_country(authorCountry VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT SUM(b.stock) INTO total
  FROM books b
  JOIN authors a ON b.author_id = a.author_id
  WHERE a.country = authorCountry;
  RETURN total;
END //
DELIMITER ;
SELECT books_by_country('India') AS Books_From_Country;

