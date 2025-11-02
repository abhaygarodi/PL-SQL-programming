-- ============================================
-- 🧩 Question 1: Update total_amount in orders using product price
-- ============================================
DELIMITER //
CREATE PROCEDURE update_orders_total_amount()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE oid INT;
    DECLARE pid INT;
    DECLARE qty INT;
    DECLARE pr DECIMAL(10,2);
    DECLARE cur CURSOR FOR SELECT order_id, product_id, quantity FROM orders;
    DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    cur_loop: LOOP
        FETCH cur INTO oid, pid, qty;
        IF done THEN
            LEAVE cur_loop;
        END IF;
        SELECT price INTO pr FROM products WHERE product_id = pid;
        UPDATE orders SET total_amount = pr * qty WHERE order_id = oid;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL update_orders_total_amount();


-- ============================================
-- 🧩 Question 2: Fetch all product names using a cursor
-- ============================================
DELIMITER //
CREATE PROCEDURE fetch_product_names()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE pname VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT product_name FROM products;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    CREATE TEMPORARY TABLE names(name VARCHAR(50));

    OPEN cur;
    cur_loop: LOOP
        FETCH cur INTO pname;
        IF done THEN
            LEAVE cur_loop;
        END IF;
        INSERT INTO names VALUES (pname);
    END LOOP;
    CLOSE cur;

    SELECT * FROM names;
    DROP TEMPORARY TABLE IF EXISTS names;
END //
DELIMITER ;

CALL fetch_product_names();


-- ============================================
-- 🧩 Question 3: Copy all orders into order_audit table using cursor
-- ============================================
DELIMITER //
CREATE PROCEDURE copy_orders_to_audit()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE oid INT;
    DECLARE pid INT;
    DECLARE tamt DECIMAL(10,2);
    DECLARE cur CURSOR FOR SELECT order_id, product_id, total_amount FROM orders;
    DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    loop1: LOOP
        FETCH cur INTO oid, pid, tamt;
        IF done THEN
            LEAVE loop1;
        END IF;
        INSERT INTO order_audit VALUES (oid, pid, tamt);
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL copy_orders_to_audit();


-- ============================================
-- 🧩 Question 4: Reduce stock after each order processed
-- ============================================
DROP PROCEDURE IF EXISTS reduce_stock_after_orders;
DELIMITER //
CREATE PROCEDURE reduce_stock_after_orders()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE pid INT;
    DECLARE qty INT;
    DECLARE cur CURSOR FOR SELECT product_id, quantity FROM orders;
    DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    stock_loop: LOOP
        FETCH cur INTO pid, qty;
        IF done THEN
            LEAVE stock_loop;
        END IF;
        UPDATE products SET stock = stock - qty WHERE product_id = pid;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL reduce_stock_after_orders();


-- ============================================
-- 🧩 Question 5: Display products that are out of stock using cursor
-- ============================================
DELIMITER //
CREATE PROCEDURE display_out_of_stock()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE pname VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT product_name FROM products WHERE stock <= 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO pname;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT(pname, ' is out of stock') AS message;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL display_out_of_stock();


-- ============================================
-- 🧩 Question 6: Calculate and show average price of all products
-- ============================================
DELIMITER //
CREATE PROCEDURE avg_product_price()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE pr DECIMAL(10,2);
    DECLARE total DECIMAL(10,2) DEFAULT 0;
    DECLARE countp INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT price FROM products;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    loop_prices: LOOP
        FETCH cur INTO pr;
        IF done THEN
            LEAVE loop_prices;
        END IF;
        SET total = total + pr;
        SET countp = countp + 1;
    END LOOP;
    CLOSE cur;

    SELECT total / countp AS 'Average Product Price';
END //
DELIMITER ;

CALL avg_product_price();


-- ============================================
-- 🧩 Question 7: Print orders greater than ₹10000
-- ============================================
DELIMITER //
CREATE PROCEDURE high_value_orders()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE oid INT;
    DECLARE amt DECIMAL(10,2);
    DECLARE cur CURSOR FOR SELECT order_id, total_amount FROM orders WHERE total_amount > 10000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    hv_loop: LOOP
        FETCH cur INTO oid, amt;
        IF done THEN
            LEAVE hv_loop;
        END IF;
        SELECT CONCAT('Order ', oid, ' amount ₹', amt, ' is a high-value order') AS message;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL high_value_orders();


-- ============================================
-- 🧩 Question 8: Create a summary table with product and total quantity sold
-- ============================================
CREATE TABLE IF NOT EXISTS product_sales_summary (
    product_id INT,
    total_quantity INT
);

DELIMITER //
CREATE PROCEDURE create_sales_summary()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE pid INT;
    DECLARE qty INT;
    DECLARE cur CURSOR FOR SELECT product_id, quantity FROM orders;
    DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;

    TRUNCATE TABLE product_sales_summary;

    OPEN cur;
    sum_loop: LOOP
        FETCH cur INTO pid, qty;
        IF done THEN
            LEAVE sum_loop;
        END IF;
        INSERT INTO product_sales_summary(product_id, total_quantity)
        VALUES (pid, qty)
        ON DUPLICATE KEY UPDATE total_quantity = total_quantity + qty;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL create_sales_summary();
SELECT * FROM product_sales_summary;


-- ============================================
-- 🧩 Question 9: Increase price of low-stock products (<5) by 10%
-- ============================================
DELIMITER //
CREATE PROCEDURE increase_low_stock_price()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE pid INT;
    DECLARE pr DECIMAL(10,2);
    DECLARE cur CURSOR FOR SELECT product_id, price FROM products WHERE stock < 5;
    DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    lp_loop: LOOP
        FETCH cur INTO pid, pr;
        IF done THEN
            LEAVE lp_loop;
        END IF;
        UPDATE products SET price = pr * 1.10 WHERE product_id = pid;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL increase_low_stock_price();


-- ================================================================
-- 🧩 Question 10: Show all orders with corresponding product names
-- ================================================================
DELIMITER //
CREATE PROCEDURE show_orders_with_product_names()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE oid INT;
    DECLARE pname VARCHAR(50);
    DECLARE qty INT;
    DECLARE cur CURSOR FOR
        SELECT o.order_id, p.product_name, o.quantity
        FROM orders o JOIN products p ON o.product_id = p.product_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO oid, pname, qty;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Order ', oid, ': ', qty, ' x ', pname) AS details;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;
CALL show_orders_with_product_names();
