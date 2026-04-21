DROP DATABASE booking_management;
CREATE DATABASE booking_management;

USE booking_management;

CREATE TABLE users(
	id int primary key auto_increment,
    name varchar(255)
);

CREATE TABLE hotels(
	id int primary key auto_increment,
    name varchar(255),
    rate int
);

CREATE TABLE bookings(
	id int primary key auto_increment,
    revenue int,
    status varchar(255),
    userID int,
    hotelID int,
    FOREIGN KEY(userID) REFERENCES users(id),
    FOREIGN KEY(hotelID) REFERENCES hotels(id)
);

DROP DATABASE IF EXISTS booking_management;
CREATE DATABASE booking_management;
USE booking_management;

-- ======================
-- USERS
-- ======================
CREATE TABLE users(
	id int primary key auto_increment,
    name varchar(255)
);

-- ======================
-- HOTELS
-- ======================
CREATE TABLE hotels(
	id int primary key auto_increment,
    name varchar(255),
    rate int
);

-- ======================
-- BOOKINGS
-- ======================
CREATE TABLE bookings(
	id int primary key auto_increment,
    revenue int,
    status varchar(255),
    userID int,
    hotelID int,
    FOREIGN KEY(userID) REFERENCES users(id),
    FOREIGN KEY(hotelID) REFERENCES hotels(id)
);

-- ======================
-- DATA USERS
-- ======================
INSERT INTO users (name) VALUES
('An'),
('Bình'),
('Chi'),
('Dũng'),
('Hà');

-- ======================
-- DATA HOTELS
-- ======================
INSERT INTO hotels (name, rate) VALUES
('Sunrise Hotel', 5),
('Ocean View', 4),
('Mountain Lodge', 3),
('City Center Inn', 4),
('Budget Stay', 2);

-- ======================
-- DATA BOOKINGS (REALISTIC + NULL + MIXED)
-- ======================
INSERT INTO bookings (revenue, status, userID, hotelID) VALUES

-- An
(1200000, 'COMPLETED', 1, 1),
(250000000, 'COMPLETED', 1, 2),
(1800000, 'CANCELLED', 1, 3),
(900000,  'COMPLETED', 1, 4),

-- Bình
(3200000, 'COMPLETED', 2, 2),
(1500000, 'CANCELLED', 2, 1),
(2100000, 'COMPLETED', 2, 4),
(800000,  'COMPLETED', 2, 5),

-- Chi
(50000000,  'COMPLETED', 3, 5),
(-1100000, 'CANCELLED', 3, 2),
(50000000, 'COMPLETED', 3, 1),
(700000,  'COMPLETED', 3, 4),

-- Dũng
(2700000, 'COMPLETED', 4, 4),
(3000000, 'COMPLETED', 4, 2),
(500000000, 'CANCELLED', 4, 5),
(1500000, 'COMPLETED', 4, 1),

-- Hà
(2200000, 'COMPLETED', 5, 1),
(-2600000, 'CANCELLED', 5, 3),
(500000000, 'COMPLETED', 5, 2),
(-1000000, 'COMPLETED', 5, 4),

-- DATA BẨN (NULL CASES)
(NULL,    'COMPLETED', 1, 5),
(5000000,  NULL,        2, 3),
(1800000, 'COMPLETED', NULL, 2),
(1400000, 'CANCELLED', 3, NULL),
(NULL,    NULL,        NULL, NULL);

SELECT users.name AS "Khách hàng", hotels.rate AS "Hạng sao", SUM(bookings.revenue) AS "Tổng chi tiêu"
FROM users
JOIN bookings ON bookings.userID = users.id
JOIN hotels ON hotels.id = bookings.hotelID
WHERE bookings.status = 'COMPLETED'AND bookings.revenue IS NOT NULL
GROUP BY users.id, hotels.rate
HAVING SUM(bookings.revenue) > 50000000
ORDER BY hotels.rate DESC, SUM(bookings.revenue) DESC;

-- Tính tổng chi tiêu của từng khách hàng theo từng hạng sao khách sạn bằng cách JOIN users, bookings và hotels qua khóa ngoại, sau đó GROUP BY users.id và hotels.rate để tránh gộp sai dữ liệu giữa các hạng sao.  
-- Chỉ tính các đơn COMPLETED (lọc bằng WHERE để tối ưu), loại bỏ dữ liệu không hợp lệ qua INNER JOIN, và chỉ giữ các nhóm có tổng chi tiêu lớn hơn 50tr (HAVING), sắp xếp theo hạng sao giảm dần và tổng chi tiêu giảm dần.