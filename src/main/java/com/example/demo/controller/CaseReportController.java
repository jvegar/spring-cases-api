package com.example.demo.controller;

import com.example.demo.model.CaseReport;
import com.example.demo.service.CaseReportingService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import java.time.Instant;

@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class CaseReportController {
    private final CaseReportingService reportingService;

    @GetMapping("/date-range")
    public Flux<CaseReport> getReportsByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant endDate) {
        return reportingService.getReportsByDateRange(startDate, endDate);
    }

    @GetMapping("/high-risk")
    public Flux<CaseReport> getHighRiskCases() {
        return reportingService.getHighRiskCases();
    }

    @GetMapping("/high-value")
    public Flux<CaseReport> getHighValueTransactions(
            @RequestParam Double minAmount,
            @RequestParam String currency) {
        return reportingService.getHighValueTransactions(minAmount, currency);
    }
}