package com.example.demo.repository;

import com.example.demo.model.Case;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;

public interface CaseRepository extends R2dbcRepository<Case, String> {
    Flux<Case> findByStatus(String status);
    Flux<Case> findByAssignedReviewerId(String reviewerId);
}