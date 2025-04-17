package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.time.Instant;

@Data
@Table("cases")
public class Case {
    @Id
    private String caseId;
    private String transactionId;
    private String detectionDetailsId;
    private String status;
    private String priority;
    private String assignedReviewerId;
    private Instant createdAt;
    private Instant updatedAt;
}