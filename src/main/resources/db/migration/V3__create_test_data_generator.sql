-- Function to check if a value exists in a table
CREATE OR REPLACE FUNCTION value_exists(
    table_name text,
    column_name text,
    value text
) RETURNS boolean AS $$
DECLARE
    query text;
    result boolean;
BEGIN
    query := format('SELECT EXISTS(SELECT 1 FROM %I WHERE %I = %L)', table_name, column_name, value);
    EXECUTE query INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to generate random string
CREATE OR REPLACE FUNCTION random_string(length integer) RETURNS text AS $$
DECLARE
    chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}';
    result text := '';
    i integer := 0;
BEGIN
    FOR i IN 1..length LOOP
        result := result || chars[1+random()*(array_length(chars, 1)-1)];
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Main function to generate test data
CREATE OR REPLACE FUNCTION generate_test_data(
    num_cases integer DEFAULT 100,
    reset_tables boolean DEFAULT false
) RETURNS void AS $$
DECLARE
    account_data json := '[
        {"name": "Main Account", "number": "1234567890", "type": "CHECKING", "routing": "987654321"},
        {"name": "Savings Account", "number": "0987654321", "type": "SAVINGS", "routing": "123456789"}
    ]';
    counterparty_data json := '[
        {"name": "Tech Corp", "account": "11111111", "bank": "Bank A", "routing": "55555", "country": "USA"},
        {"name": "Global Ltd", "account": "22222222", "bank": "Bank B", "routing": "66666", "country": "GBR"}
    ]';
    transaction_types text[] := '{"WIRE", "ACH", "INTERNAL"}';
    priorities text[] := '{"HIGH", "MEDIUM", "LOW"}';
    statuses text[] := '{"NEW", "IN_REVIEW", "CLOSED"}';
    detection_reasons text[] := '{"UNUSUAL_AMOUNT", "SUSPICIOUS_PATTERN", "HIGH_RISK_COUNTRY"}';
    reviewer_roles text[] := '{"ANALYST", "SUPERVISOR", "MANAGER"}';
    tag_names text[] := '{"URGENT", "SUSPICIOUS", "CLEARED", "NEEDS_ATTENTION"}';
    
    v_account_id text;
    v_counterparty_id uuid;
    v_transaction_id text;
    v_detection_id uuid;
    v_reviewer_id text;
    v_case_id text;
    v_tag_id uuid;
    account record;
    cp record;
    tag_record record;
BEGIN
    -- Reset tables if requested
    IF reset_tables THEN
        TRUNCATE case_tags, review_history, cases, tags, 
                 transactions, detection_details, reviewers, 
                 counterparties, accounts CASCADE;
    END IF;

    -- Insert base data
    -- Accounts
    FOR account IN SELECT value FROM json_array_elements(account_data) as value LOOP
        v_account_id := random_string(10);
        IF NOT value_exists('accounts', 'account_id', v_account_id) THEN
            INSERT INTO accounts (account_id, account_name, account_number, account_type, routing_number)
            VALUES (
                v_account_id,
                account.value->>'name',
                account.value->>'number',
                account.value->>'type',
                account.value->>'routing'
            );
        END IF;
    END LOOP;

    -- Counterparties
    FOR cp IN SELECT value FROM json_array_elements(counterparty_data) as value LOOP
        v_counterparty_id := gen_random_uuid();
        INSERT INTO counterparties (id, name, account_number, bank_name, bank_routing_number, country)
        VALUES (
            v_counterparty_id,
            cp.value->>'name',
            cp.value->>'account',
            cp.value->>'bank',
            cp.value->>'routing',
            cp.value->>'country'
        );
    END LOOP;

    -- Generate test cases
    FOR i IN 1..num_cases LOOP
        -- Create transaction
        v_transaction_id := random_string(12);
        INSERT INTO transactions (
            transaction_id, date, type, direction, amount, currency, 
            status, account_id, counterparty_id
        )
        SELECT
            v_transaction_id,
            NOW() - (random() * interval '90 days'),
            transaction_types[1 + floor(random() * array_length(transaction_types, 1))],
            CASE WHEN random() > 0.5 THEN 'OUTGOING' ELSE 'INCOMING' END,
            random() * 1000000,
            'USD',
            'COMPLETED',
            account_id,
            id
        FROM accounts, counterparties
        ORDER BY random()
        LIMIT 1;

        -- Create detection details
        v_detection_id := gen_random_uuid();
        INSERT INTO detection_details (
            id, detection_reason, confidence_score, detection_timestamp, model_version
        )
        VALUES (
            v_detection_id,
            detection_reasons[1 + floor(random() * array_length(detection_reasons, 1))],
            random(),
            NOW() - (random() * interval '30 days'),
            'v1.0.0'
        );

        -- Create reviewer if needed
        v_reviewer_id := random_string(8);
        IF NOT value_exists('reviewers', 'reviewer_id', v_reviewer_id) THEN
            INSERT INTO reviewers (reviewer_id, reviewer_role)
            VALUES (
                v_reviewer_id,
                reviewer_roles[1 + floor(random() * array_length(reviewer_roles, 1))]
            );
        END IF;

        -- Create case
        v_case_id := random_string(10);
        INSERT INTO cases (
            case_id, transaction_id, detection_details_id, status, priority,
            assigned_reviewer_id, created_at, updated_at
        )
        VALUES (
            v_case_id,
            v_transaction_id,
            v_detection_id,
            statuses[1 + floor(random() * array_length(statuses, 1))],
            priorities[1 + floor(random() * array_length(priorities, 1))],
            v_reviewer_id,
            NOW() - (random() * interval '60 days'),
            NOW() - (random() * interval '30 days')
        );

        -- Create review history (1-3 entries per case)
        FOR j IN 1..floor(random() * 3 + 1) LOOP
            INSERT INTO review_history (
                id, reviewer_id, case_id, action, comments, timestamp
            )
            VALUES (
                gen_random_uuid(),
                v_reviewer_id,
                v_case_id,
                CASE j
                    WHEN 1 THEN 'ASSIGNED'
                    WHEN 2 THEN 'REVIEWED'
                    ELSE 'UPDATED'
                END,
                'Test comment ' || j,
                NOW() - (random() * interval '30 days')
            );
        END LOOP;

        -- Create tags and case_tags (1-2 tags per case)
        FOR tag_record IN 
            SELECT unnest(tag_names) as tag_name 
            LIMIT floor(random() * 2 + 1)
        LOOP
            -- Create tag if it doesn't exist
            IF NOT EXISTS (SELECT 1 FROM tags WHERE name = tag_record.tag_name) THEN
                INSERT INTO tags (id, name)
                VALUES (gen_random_uuid(), tag_record.tag_name)
                RETURNING id INTO v_tag_id;
            ELSE
                SELECT id INTO v_tag_id FROM tags WHERE name = tag_record.tag_name;
            END IF;

            -- Create case_tag
            INSERT INTO case_tags (case_id, tag_id)
            VALUES (v_case_id, v_tag_id)
            ON CONFLICT DO NOTHING;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;