package com.example.demo.model;

import lombok.Data;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("case_tags")
public class CaseTag {
    private String caseId;
    private String tagId;
}