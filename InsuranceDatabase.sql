--Creating Database
CREATE DATABASE IF NOT EXISTS insurance_demo;
--Using Database
 use insurance_demo;

-- Creating Tables
-- Customers: policy holders
 CREATE TABLE customers (
    customer_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    email            VARCHAR(120) UNIQUE,
    phone            VARCHAR(20),
    dob              DATE,
    gender           ENUM('F','M','Other') DEFAULT 'Other',
    address_line1    VARCHAR(120),
    address_line2    VARCHAR(120),
    city             VARCHAR(60),
    state_province   VARCHAR(60),
    postal_code      VARCHAR(15),
    country          VARCHAR(60) DEFAULT 'India',
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Agents: selling agents/brokers
CREATE TABLE agents (
    agent_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(120) UNIQUE,
    phone         VARCHAR(20),
    branch        VARCHAR(80),
    active        TINYINT(1) DEFAULT 1,
    hired_date    DATE
) ENGINE=InnoDB;

-- Policy types / products (e.g., term life, motor, health, home)
CREATE TABLE policy_types (
    policy_type_id   INT AUTO_INCREMENT PRIMARY KEY,
    code             VARCHAR(20) UNIQUE NOT NULL,
    name             VARCHAR(100) NOT NULL,
    description      VARCHAR(255),
    min_term_years   INT DEFAULT 1,
    max_term_years   INT DEFAULT 30
) ENGINE=InnoDB;

-- Policies: one policy belongs to a customer and a policy type, optionally sold by an agent
CREATE TABLE policies (
    policy_id        INT AUTO_INCREMENT PRIMARY KEY,
    policy_number    VARCHAR(30) UNIQUE NOT NULL,
    customer_id      INT NOT NULL,
    policy_type_id   INT NOT NULL,
    agent_id         INT,
    start_date       DATE NOT NULL,
    end_date         DATE,
    premium_amount   DECIMAL(12,2) NOT NULL,
    premium_freq     ENUM('Monthly','Quarterly','Semi-Annual','Annual') DEFAULT 'Annual',
    sum_assured      DECIMAL(14,2),
    status           ENUM('Active','Lapsed','Cancelled','Expired','Matured') DEFAULT 'Active',
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_policies_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_policies_type
        FOREIGN KEY (policy_type_id) REFERENCES policy_types(policy_type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_policies_agent
        FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- Beneficiaries for a policy (mostly used in Life)
CREATE TABLE beneficiaries (
    beneficiary_id    INT AUTO_INCREMENT PRIMARY KEY,
    policy_id         INT NOT NULL,
    full_name         VARCHAR(120) NOT NULL,
    relationship      VARCHAR(50),
    share_percent     DECIMAL(5,2) CHECK (share_percent >= 0 AND share_percent <= 100),
    CONSTRAINT fk_beneficiaries_policy
        FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Claims: filed against a policy
CREATE TABLE claims (
    claim_id        INT AUTO_INCREMENT PRIMARY KEY,
    policy_id       INT NOT NULL,
    claim_number    VARCHAR(30) UNIQUE NOT NULL,
    incident_date   DATE NOT NULL,
    report_date     DATE NOT NULL,
    claim_reason    VARCHAR(200),
    claim_amount    DECIMAL(12,2) NOT NULL,
    status          ENUM('Submitted','Under Review','Approved','Rejected','Paid','Closed') DEFAULT 'Submitted',
    CONSTRAINT fk_claims_policy
        FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Payments: premium payments made toward a policy
CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    policy_id       INT NOT NULL,
    payment_date    DATE NOT NULL,
    amount          DECIMAL(12,2) NOT NULL,
    method          ENUM('UPI','Card','NetBanking','Cash','Cheque') DEFAULT 'UPI',
    receipt_number  VARCHAR(40) UNIQUE,
    CONSTRAINT fk_payments_policy
        FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Helpful indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_policies_customer ON policies(customer_id);
CREATE INDEX idx_policies_status ON policies(status);
CREATE INDEX idx_claims_policy ON claims(policy_id);
CREATE INDEX idx_payments_policy ON payments(policy_id);

-- Inserting data into tables

INSERT INTO customers
(first_name, last_name, email, phone, dob, gender, address_line1, city, state_province, postal_code)
VALUES
('Aarav', 'Sharma', 'aarav.sharma@example.com', '+91-9810010101', '1990-03-15', 'M', '12 FC Road', 'Pune', 'Maharashtra', '411004'),
('Isha', 'Verma', 'isha.verma@example.com', '+91-9810010102', '1988-07-22', 'F', '45 MG Road', 'Bengaluru', 'Karnataka', '560001'),
('Rohan', 'Patil', 'rohan.patil@example.com', '+91-9810010103', '1995-11-05', 'M', '220 Baner', 'Pune', 'Maharashtra', '411045'),
('Meera', 'Iyer', 'meera.iyer@example.com', '+91-9810010104', '1982-02-01', 'F', '7 Anna Nagar', 'Chennai', 'Tamil Nadu', '600040'),
('Vikram', 'Singh', 'vikram.singh@example.com', '+91-9810010105', '1979-09-19', 'M', '88 Civil Lines', 'Prayagraj', 'Uttar Pradesh', '211001'),
('Neha', 'Kulkarni', 'neha.kulkarni@example.com', '+91-9810010106', '1993-12-30', 'F', '34 JM Road', 'Pune', 'Maharashtra', '411005'),
('Anil', 'Gupta', 'anil.gupta@example.com', '+91-9810010107', '1986-04-12', 'M', '5 Park Street', 'Kolkata', 'West Bengal', '700016'),
('Sara', 'Khan', 'sara.khan@example.com', '+91-9810010108', '1991-06-18', 'F', '14 Bandra West', 'Mumbai', 'Maharashtra', '400050'),
('Kabir', 'Nair', 'kabir.nair@example.com', '+91-9810010109', '1984-01-25', 'M', '3 Vyttila', 'Kochi', 'Kerala', '682019'),
('Priya', 'Deshmukh', 'priya.deshmukh@example.com', '+91-9810010110', '1997-08-09', 'F', '10 FC Road', 'Pune', 'Maharashtra', '411004');

INSERT INTO agents (first_name, last_name, email, phone, branch, active, hired_date)
VALUES
('Dinesh', 'Kale', 'dinesh.kale@insureco.example', '+91-9021000001', 'Pune - Shivajinagar', 1, '2018-04-10'),
('Rita', 'Mehta', 'rita.mehta@insureco.example', '+91-9021000002', 'Mumbai - Andheri', 1, '2020-01-15'),
('Harish', 'Rao', 'harish.rao@insureco.example', '+91-9021000003', 'Bengaluru - MG Road', 1, '2017-09-01');

INSERT INTO policy_types (code, name, description, min_term_years, max_term_years)
VALUES
('TERM_LIFE', 'Term Life Insurance', 'Pure protection for a fixed term with death benefit', 5, 40),
('HLT_INDV',  'Health Insurance - Individual', 'Covers hospitalization expenses for an individual', 1, 3),
('MOTOR_PRI', 'Motor Insurance - Private Car', 'Comprehensive coverage for private cars', 1, 1),
('HOME_OWN',  'Home Insurance - Owner', 'Covers structure and contents for homeowners', 1, 5);

INSERT INTO policies
(policy_number, customer_id, policy_type_id, agent_id, start_date, end_date, premium_amount, premium_freq, sum_assured, status)
VALUES
('POL-0001', 1, 1, 1, '2022-04-01', '2042-03-31', 15000.00, 'Annual', 5000000.00, 'Active'),
('POL-0002', 2, 2, 3, '2025-01-01', '2026-12-31', 18000.00, 'Annual', 0.00, 'Active'),
('POL-0003', 3, 3, 1, '2025-06-01', '2026-05-31', 12000.00, 'Annual', 0.00, 'Active'),
('POL-0004', 4, 4, 2, '2024-09-15', '2029-09-14', 8000.00,  'Annual', 2000000.00, 'Active'),
('POL-0005', 5, 1, 2, '2015-02-01', '2035-01-31', 22000.00, 'Annual', 7500000.00, 'Lapsed'),
('POL-0006', 6, 2, 1, '2023-07-01', '2026-06-30', 20000.00, 'Annual', 0.00, 'Active'),
('POL-0007', 7, 3, 3, '2025-03-20', '2026-03-19', 9000.00,  'Annual', 0.00, 'Cancelled'),
('POL-0008', 8, 1, 2, '2021-11-01', '2041-10-31', 18000.00, 'Annual', 4000000.00, 'Active'),
('POL-0009', 9, 4, 3, '2024-01-10', '2029-01-09', 7000.00,  'Annual', 1500000.00, 'Active'),
('POL-0010',10, 2, 1, '2025-02-01', '2026-01-31', 16000.00, 'Annual', 0.00, 'Active');

INSERT INTO beneficiaries (policy_id, full_name, relationship, share_percent)
VALUES
(1, 'Isha Sharma', 'Spouse', 60.00),
(1, 'Ananya Sharma', 'Daughter', 40.00),
(5, 'Ritika Singh', 'Spouse', 100.00),
(8, 'Ayaan Khan', 'Son', 100.00);

INSERT INTO claims
(policy_id, claim_number, incident_date, report_date, claim_reason, claim_amount, status)
VALUES
(3, 'CLM-1001', '2025-08-10', '2025-08-11', 'Rear-end collision at signal', 45000.00, 'Approved'),
(6, 'CLM-1002', '2024-12-05', '2024-12-06', 'Hospitalization due to dengue', 120000.00, 'Paid'),
(9, 'CLM-1003', '2025-06-18', '2025-06-19', 'Water leakage damage to ceiling', 75000.00, 'Under Review'),
(7, 'CLM-1004', '2025-04-03', '2025-04-04', 'Minor bumper damage', 15000.00, 'Rejected');

INSERT INTO payments (policy_id, payment_date, amount, method, receipt_number)
VALUES
(1, '2024-04-01', 15000.00, 'NetBanking', 'RCT-0001'),
(1, '2025-04-01', 15000.00, 'UPI',        'RCT-0035'),
(2, '2025-01-01', 18000.00, 'Card',       'RCT-0101'),
(3, '2025-06-01', 12000.00, 'UPI',        'RCT-0201'),
(4, '2024-09-15',  8000.00, 'Cash',       'RCT-0300'),
(6, '2023-07-01', 20000.00, 'NetBanking', 'RCT-0401'),
(8, '2024-11-01', 18000.00, 'UPI',        'RCT-0509'),
(9, '2024-01-10',  7000.00, 'Card',       'RCT-0602'),
(10,'2025-02-01', 16000.00, 'UPI',        'RCT-0701');
