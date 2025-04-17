package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.time.Instant;

@Data
@Table("review_history")
public class ReviewHistory {
    @Id
    private String id;
    private String reviewerId;
    private String caseId;
    private String action;
    private String comments;
    private Instant timestamp;
}