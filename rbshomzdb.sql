-- USERS TABLE
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15),
    role ENUM('Owner', 'Customer', 'ListingAgent', 'CommunityUser') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROPERTIES TABLE
CREATE TABLE Properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT,
    agent_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    property_type ENUM('House', 'Apartment', 'Commercial', 'Land') NOT NULL,
    transaction_type ENUM('Sale', 'Rent') NOT NULL,
    location VARCHAR(255),
    status ENUM('Available', 'Sold', 'Rented') DEFAULT 'Available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(user_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id)
);

-- PROPERTY IMAGES TABLE
CREATE TABLE PropertyImages (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id)
);

-- TRANSACTIONS TABLE
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    customer_id INT,
    agent_id INT,
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    FOREIGN KEY (customer_id) REFERENCES Users(user_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id)
);

-- PAYMENTS TABLE
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    payment_method ENUM('MobileMoney', 'BankTransfer', 'CreditCard') NOT NULL,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);

-- SHARED RENT TABLE
CREATE TABLE SharedRent (
    shared_rent_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    tenant_1_id INT,
    tenant_2_id INT,
    preferences TEXT,
    status ENUM('Pending', 'Approved') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    FOREIGN KEY (tenant_1_id) REFERENCES Users(user_id),
    FOREIGN KEY (tenant_2_id) REFERENCES Users(user_id)
);

-- COMMUNITY SECTION TABLE
CREATE TABLE CommunityPosts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(255),
    content TEXT,
    location VARCHAR(255),
    tags VARCHAR(100),  -- For categories like 'Schools', 'Commute', 'Safety', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- COMMUNITY COMMENTS TABLE
CREATE TABLE CommunityComments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES CommunityPosts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
