package com.example.demo.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.math.BigDecimal;
import java.time.Instant;

@Data
@Table("transactions")
public class Transaction {
    @Id
    private String transactionId;
    private Instant date;
    private String type;  // Will store enum as String
    private String direction;  // Will store enum as String
    private BigDecimal amount;
    private String currency;
    private String description;
    private String status;  // Will store enum as String
    private String accountId;  // Instead of @ManyToOne relationship
    private String counterpartyId;  // Instead of @ManyToOne relationship
}

// Keep enums separate
enum TransactionType {
    TRANSFER, PAYMENT, DEPOSIT, WITHDRAWAL
}

enum TransactionDirection {
    CREDIT, DEBIT
}

enum TransactionStatus {
    PENDING, COMPLETED, FAILED, CANCELLED
}