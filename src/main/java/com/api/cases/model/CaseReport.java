package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.math.BigDecimal;
import java.time.Instant;

@Data
@Table("case_reports")
public class CaseReport {
    @Id
    private String caseId;
    private String status;
    private String priority;
    private Instant createdAt;
    private Instant updatedAt;
    private String transactionId;
    private Instant transactionDate;
    private String transactionType;
    private BigDecimal amount;
    private String currency;
    private String direction;
    private String counterpartyName;
    private String counterpartyCountry;
    private String detectionReason;
    private Double confidenceScore;
    private String modelVersion;
    private String reviewerId;
    private String reviewerRole;
    private String tagNames;
}