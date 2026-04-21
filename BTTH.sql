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

-- Em dùng id của hotel để lọc ra, rate cũng đi theo hotel, tổng doanh thu dùng hàm SUM và vì booking id cũng được link với id của hotel từ đó tính toán SUM chính xác. Booking lại là khóa ngoại và cũng được link với USERID, từ đó 1 người dùng hay doanh thu từ người dùng đó có thể xuất hiện trên nhiều khách sạn tùy thuộc vào người dùng đó book khách sạn nào
-- Mặc định nó đã không được tính vào doanh thu vì đơn giản nó đã bị CANCELLED, em đã lọc ra COMPLETED để tính. Thế nhưng nếu phải lọc thì em sẽ lọc ở WHERE, vì nó đơn giản và tối ưu hơn thay vì gom lại rồi lọc. Hơn nữa, với INNER JOIN, các trường hợp không hợp lệ đều đã bị clean.