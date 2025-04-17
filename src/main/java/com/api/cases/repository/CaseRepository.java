package com.api.cases.repository;

import org.springframework.data.r2dbc.repository.R2dbcRepository;

import com.api.cases.model.Case;

import reactor.core.publisher.Flux;

public interface CaseRepository extends R2dbcRepository<Case, String> {
    Flux<Case> findByStatus(String status);
    Flux<Case> findByAssignedReviewerId(String reviewerId);
}