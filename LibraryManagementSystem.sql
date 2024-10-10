-- Create Database
CREATE DATABASE LibraryManagement;
USE LibraryManagement;
-- Create Tables
-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    Category VARCHAR(100),
    Price DECIMAL(10, 2),
    Status ENUM('Available', 'Issued') DEFAULT 'Available',
    Quantity INT DEFAULT 1
);
-- Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15)
);
-- Transactions Table
CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    BookID INT,
    IssueDate DATE,
    ReturnDate DATE,
    Status ENUM('Issued', 'Returned') DEFAULT 'Issued',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
-- Insert Sample Data
-- Insert Books
INSERT INTO Books (Title, Author, Category, Price, Quantity)
VALUES 
    ('The Alchemist', 'Paulo Coelho', 'Fiction', 9.99, 5),
    ('Clean Code', 'Robert C. Martin', 'Programming', 35.99, 3),
    ('Introduction to Algorithms', 'Thomas H. Cormen', 'Education', 75.50, 2);
-- Insert Users
INSERT INTO Users (Name, Email, PhoneNumber)
VALUES 
    ('John Doe', 'john@example.com', '1234567890'),
    ('Jane Smith', 'jane@example.com', '9876543210');
--  Issue a Book
-- Step 1: Issue the book (add a transaction)
INSERT INTO Transactions (UserID, BookID, IssueDate)
VALUES (
    (SELECT UserID FROM Users WHERE Name = 'John Doe'),
    (SELECT BookID FROM Books WHERE Title = 'The Alchemist'),
    CURDATE()
);
SET SQL_SAFE_UPDATES = 0;
-- Step 2: Update the book status and reduce quantity
UPDATE Books
SET Status = 'Issued', Quantity = Quantity - 1
WHERE Title = 'The Alchemist' AND Quantity > 0;
-- Returning a Book
-- Step 1: Update the transaction status and add return date
UPDATE Transactions
SET ReturnDate = CURDATE(), Status = 'Returned'
WHERE UserID = (SELECT UserID FROM Users WHERE Name = 'John Doe')
  AND BookID = (SELECT BookID FROM Books WHERE Title = 'The Alchemist')
  AND Status = 'Issued';

-- Step 2: Update the book's status and increase quantity
UPDATE Books
SET Status = 'Available', Quantity = Quantity + 1
WHERE Title = 'The Alchemist';
-- Query to View Books by Category
SELECT * FROM Books WHERE Category = 'Programming';
-- Query to View Issued Books
SELECT b.Title, u.Name, t.IssueDate
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
JOIN Users u ON t.UserID = u.UserID
WHERE t.Status = 'Issued';
-- Query to Track Book Availability
SELECT Title, Quantity
FROM Books
WHERE Title = 'The Alchemist';



