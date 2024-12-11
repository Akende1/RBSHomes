-- Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15),
    NRCNumber VARCHAR(20) UNIQUE,
    Role ENUM('Owner', 'Customer', 'ListingAgent') NOT NULL,
    ProfilePicture VARCHAR(255),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Properties Table
CREATE TABLE Properties (
    PropertyID INT AUTO_INCREMENT PRIMARY KEY,
    OwnerID INT NOT NULL,
    AgentID INT,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    PropertyType ENUM('House', 'Apartment', 'Commercial', 'Land') NOT NULL,
    TransactionType ENUM('Sale', 'Rent') NOT NULL,
    Price DECIMAL(15, 2) NOT NULL,
    Currency ENUM('ZMW', 'USD') DEFAULT 'ZMW',
    Location VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Province VARCHAR(100) NOT NULL,
    Features JSON,
    AvailabilityStatus ENUM('Available', 'Sold', 'Rented') DEFAULT 'Available',
    DateListed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerID) REFERENCES Users(UserID),
    FOREIGN KEY (AgentID) REFERENCES Users(UserID)
);

-- Property Images Table
CREATE TABLE PropertyImages (
    ImageID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT NOT NULL,
    ImageURL VARCHAR(255) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

-- Transactions Table
CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT NOT NULL,
    CustomerID INT NOT NULL,
    AgentID INT,
    TransactionType ENUM('Sale', 'Rent') NOT NULL,
    TransactionAmount DECIMAL(15, 2) NOT NULL,
    Currency ENUM('ZMW', 'USD') DEFAULT 'ZMW',
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID),
    FOREIGN KEY (AgentID) REFERENCES Users(UserID)
);

-- Reviews Table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,  -- Nullable if the review is about a community
    CommunityName VARCHAR(255),  -- Nullable if the review is about a specific property
    ReviewerID INT NOT NULL,  -- Refers to the user writing the review
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    ReviewCategory ENUM('Property', 'Community') DEFAULT 'Property',
    CommuteTime TEXT,  -- Optional details specific to community reviews
    NearbyPlaces TEXT,  -- Includes chill places, night life, etc.
    NearbySchools TEXT, -- Details about nearby schools
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (ReviewerID) REFERENCES Users(UserID)
);

-- Bookings Table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT NOT NULL,
    CustomerID INT NOT NULL,
    AgentID INT,
    BookingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    AppointmentDate DATETIME NOT NULL,
    Status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID),
    FOREIGN KEY (AgentID) REFERENCES Users(UserID)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(15, 2) NOT NULL,
    Currency ENUM('ZMW', 'USD') DEFAULT 'ZMW',
    PaymentMethod ENUM('Bank Transfer', 'Mobile Money', 'Credit Card') NOT NULL,
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);
