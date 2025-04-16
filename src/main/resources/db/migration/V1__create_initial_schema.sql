-- Create accounts table
CREATE TABLE accounts (
    account_id VARCHAR(255) PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    account_number VARCHAR(255) NOT NULL,
    account_type VARCHAR(50),
    routing_number VARCHAR(255)
);

-- Create counterparties table
CREATE TABLE counterparties (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    account_number VARCHAR(255) NOT NULL,
    bank_name VARCHAR(255),
    bank_routing_number VARCHAR(255),
    iban VARCHAR(255),
    country VARCHAR(3)
);

-- Create transactions table
CREATE TABLE transactions (
    transaction_id VARCHAR(255) PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    type VARCHAR(50) NOT NULL,
    direction VARCHAR(50) NOT NULL,
    amount DECIMAL(19,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL,
    account_id VARCHAR(255) REFERENCES accounts(account_id),
    counterparty_id UUID REFERENCES counterparties(id)
);

-- Create detection_details table
CREATE TABLE detection_details (
    id UUID PRIMARY KEY,
    detection_reason TEXT,
    confidence_score DOUBLE PRECISION,
    detection_timestamp TIMESTAMP NOT NULL,
    model_version VARCHAR(255)
);

-- Create reviewers table
CREATE TABLE reviewers (
    reviewer_id VARCHAR(255) PRIMARY KEY,
    reviewer_role VARCHAR(255) NOT NULL
);

-- Create cases table
CREATE TABLE cases (
    case_id VARCHAR(255) PRIMARY KEY,
    transaction_id VARCHAR(255) REFERENCES transactions(transaction_id),
    detection_details_id UUID REFERENCES detection_details(id),
    status VARCHAR(50) NOT NULL,
    priority VARCHAR(50) NOT NULL,
    assigned_reviewer_id VARCHAR(255) REFERENCES reviewers(reviewer_id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create review_history table
CREATE TABLE review_history (
    id UUID PRIMARY KEY,
    reviewer_id VARCHAR(255) REFERENCES reviewers(reviewer_id),
    case_id VARCHAR(255) REFERENCES cases(case_id),
    action VARCHAR(255) NOT NULL,
    comments TEXT,
    timestamp TIMESTAMP NOT NULL
);

-- Create tags table
CREATE TABLE tags (
    id UUID PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Create case_tags junction table
CREATE TABLE case_tags (
    case_id VARCHAR(255) REFERENCES cases(case_id),
    tag_id UUID REFERENCES tags(id),
    PRIMARY KEY (case_id, tag_id)
);

-- Create indexes
CREATE INDEX idx_transactions_account ON transactions(account_id);
CREATE INDEX idx_transactions_counterparty ON transactions(counterparty_id);
CREATE INDEX idx_cases_transaction ON cases(transaction_id);
CREATE INDEX idx_cases_detection_details ON cases(detection_details_id);
CREATE INDEX idx_cases_reviewer ON cases(assigned_reviewer_id);
CREATE INDEX idx_review_history_case ON review_history(case_id);
CREATE INDEX idx_review_history_reviewer ON review_history(reviewer_id);