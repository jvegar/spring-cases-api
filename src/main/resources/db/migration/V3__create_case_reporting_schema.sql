-- Create materialized view for case reporting
CREATE MATERIALIZED VIEW case_reports AS
SELECT 
    c.case_id,
    c.status,
    c.priority,
    c.created_at,
    c.updated_at,
    t.transaction_id,
    t.date as transaction_date,
    t.type as transaction_type,
    t.amount,
    t.currency,
    t.direction,
    cp.name as counterparty_name,
    cp.country as counterparty_country,
    dd.detection_reason,
    dd.confidence_score,
    dd.model_version,
    r.reviewer_id,
    r.reviewer_role,
    string_agg(DISTINCT tags.name, ',') as tag_names
FROM cases c
LEFT JOIN transactions t ON c.transaction_id = t.transaction_id
LEFT JOIN counterparties cp ON t.counterparty_id = cp.id
LEFT JOIN detection_details dd ON c.detection_details_id = dd.id
LEFT JOIN reviewers r ON c.assigned_reviewer_id = r.reviewer_id
LEFT JOIN case_tags ct ON c.case_id = ct.case_id
LEFT JOIN tags ON ct.tag_id = tags.id
GROUP BY 
    c.case_id, c.status, c.priority, c.created_at, c.updated_at,
    t.transaction_id, t.date, t.type, t.amount, t.currency, t.direction,
    cp.name, cp.country, dd.detection_reason, dd.confidence_score,
    dd.model_version, r.reviewer_id, r.reviewer_role;

-- Create indexes for common query patterns
CREATE INDEX idx_case_reports_date ON case_reports(created_at);
CREATE INDEX idx_case_reports_status ON case_reports(status);
CREATE INDEX idx_case_reports_priority ON case_reports(priority);
CREATE INDEX idx_case_reports_amount ON case_reports(amount);


-- Function to refresh materialized view
CREATE OR REPLACE FUNCTION refresh_case_reports()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY case_reports;
END;
$$ LANGUAGE plpgsql;