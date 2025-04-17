package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.time.Instant;

@Data
@Table("detection_details")
public class DetectionDetails {
    @Id
    private String id;
    private String detectionReason;
    private Double confidenceScore;
    private Instant detectionTimestamp;
    private String modelVersion;
}