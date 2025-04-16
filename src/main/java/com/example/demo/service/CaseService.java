package com.example.demo.service;

import com.example.demo.model.Case;
import com.example.demo.repository.CaseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.Instant;  // Add this import

@Service
@RequiredArgsConstructor
public class CaseService {
    private final CaseRepository caseRepository;

    public Flux<Case> getAllCases() {
        return caseRepository.findAll();
    }

    public Mono<Case> getCaseById(String id) {
        return caseRepository.findById(id);
    }

    public Flux<Case> getCasesByStatus(String status) {
        return caseRepository.findByStatus(status);
    }

    public Mono<Case> createCase(Case caseData) {
        caseData.setCreatedAt(Instant.now());
        caseData.setUpdatedAt(Instant.now());
        return caseRepository.save(caseData);
    }
}