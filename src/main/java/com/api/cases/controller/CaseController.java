package com.api.cases.controller;

import com.api.cases.model.Case;
import com.api.cases.service.CaseService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/cases")
@RequiredArgsConstructor
public class CaseController {
    private final CaseService caseService;

    @GetMapping
    public Flux<Case> getAllCases() {
        return caseService.getAllCases();
    }

    @GetMapping("/{id}")
    public Mono<Case> getCaseById(@PathVariable String id) {
        return caseService.getCaseById(id);
    }

    @GetMapping("/status/{status}")
    public Flux<Case> getCasesByStatus(@PathVariable String status) {
        return caseService.getCasesByStatus(status);
    }

    @PostMapping
    public Mono<Case> createCase(@RequestBody Case caseData) {
        return caseService.createCase(caseData);
    }
}