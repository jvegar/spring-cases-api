package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("reviewers")
public class Reviewer {
    @Id
    private String reviewerId;
    private String reviewerRole;
}