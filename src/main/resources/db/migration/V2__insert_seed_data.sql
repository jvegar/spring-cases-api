-- Insert sample accounts
INSERT INTO accounts (account_id, account_name, account_number, account_type, routing_number)
VALUES 
    ('acc_67890', 'Business Checking', '****7890', 'CHECKING', 'ROUTING-9876'),
    ('acc_67891', 'Personal Savings', '****7891', 'SAVINGS', 'ROUTING-9877');

-- Insert sample counterparties
INSERT INTO counterparties (id, name, account_number, bank_name, bank_routing_number, iban, country)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174000', 'TechCorp LLC', 'TC-456789', 'Global Bank Switzerland', 'CH-123456789', 'CH9300762011623852957', 'CHE'),
    ('123e4567-e89b-12d3-a456-426614174001', 'Digital Solutions Inc', 'DS-789012', 'US National Bank', 'US-987654321', NULL, 'USA');

-- Insert sample reviewers
INSERT INTO reviewers (reviewer_id, reviewer_role)
VALUES 
    ('fraud_team_lead', 'Senior Fraud Analyst'),
    ('fraud_analyst_1', 'Fraud Analyst');

-- Insert sample detection details
INSERT INTO detection_details (id, detection_reason, confidence_score, detection_timestamp, model_version)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174002', 'High-Risk Country & Unusual Amount', 0.95, '2023-10-05 03:15:00', 'fraud-detection-v3'),
    ('123e4567-e89b-12d3-a456-426614174003', 'Unusual Transaction Pattern', 0.85, '2023-10-05 04:15:00', 'fraud-detection-v3');

-- Insert sample transactions
INSERT INTO transactions (transaction_id, date, type, direction, amount, currency, description, status, account_id, counterparty_id)
VALUES 
    ('txn_98765', '2023-10-05 03:10:00', 'TRANSFER', 'DEBIT', 2500.00, 'USD', 'International Wire Transfer to TechCorp LLC', 'COMPLETED', 'acc_67890', '123e4567-e89b-12d3-a456-426614174000'),
    ('txn_98766', '2023-10-05 04:10:00', 'TRANSFER', 'CREDIT', 1500.00, 'USD', 'Payment from Digital Solutions', 'COMPLETED', 'acc_67891', '123e4567-e89b-12d3-a456-426614174001');

-- Insert sample cases
INSERT INTO cases (case_id, transaction_id, detection_details_id, status, priority, assigned_reviewer_id, created_at, updated_at)
VALUES 
    ('case_2023xyz', 'txn_98765', '123e4567-e89b-12d3-a456-426614174002', 'UNDER_REVIEW', 'HIGH', 'fraud_team_lead', '2023-10-05 03:20:00', '2023-10-05 09:30:00'),
    ('case_2023abc', 'txn_98766', '123e4567-e89b-12d3-a456-426614174003', 'OPEN', 'MEDIUM', 'fraud_analyst_1', '2023-10-05 04:20:00', '2023-10-05 04:20:00');

-- Insert sample tags
INSERT INTO tags (id, name)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174004', 'international'),
    ('123e4567-e89b-12d3-a456-426614174005', 'business-account'),
    ('123e4567-e89b-12d3-a456-426614174006', 'high-value');

-- Insert sample case tags
INSERT INTO case_tags (case_id, tag_id)
VALUES 
    ('case_2023xyz', '123e4567-e89b-12d3-a456-426614174004'),
    ('case_2023xyz', '123e4567-e89b-12d3-a456-426614174005'),
    ('case_2023xyz', '123e4567-e89b-12d3-a456-426614174006'),
    ('case_2023abc', '123e4567-e89b-12d3-a456-426614174005');

-- Insert sample review history
INSERT INTO review_history (id, reviewer_id, case_id, action, comments, timestamp)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174007', 'fraud_team_lead', 'case_2023xyz', 'FLAGGED_FOR_URGENT_REVIEW', 'Transaction to high-risk jurisdiction (Switzerland). Verify business purpose.', '2023-10-05 09:30:00'),
    ('123e4567-e89b-12d3-a456-426614174008', 'fraud_analyst_1', 'case_2023abc', 'INITIAL_REVIEW', 'Standard transaction pattern, requires basic verification.', '2023-10-05 04:25:00');