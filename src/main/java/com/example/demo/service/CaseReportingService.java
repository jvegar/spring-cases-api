package com.example.demo.service;

import com.example.demo.model.CaseReport;
import com.example.demo.repository.CaseReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.r2dbc.core.DatabaseClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.Instant;

@Service
@RequiredArgsConstructor
public class CaseReportingService {
    private final CaseReportRepository reportRepository;
    private final DatabaseClient databaseClient;

    @Scheduled(cron = "0 */5 * * * *") // Every 5 minutes
    public Mono<Void> refreshReportingView() {
        return databaseClient
            .sql("SELECT refresh_case_reports()")
            .fetch()
            .all()
            .then();
    }

    @KafkaListener(topics = "case-updates")
    public void handleCaseUpdate(String caseId) {
        refreshReportingView()
            .subscribe();
    }

    public Flux<CaseReport> getReportsByDateRange(Instant startDate, Instant endDate) {
        return reportRepository.findByDateRange(startDate, endDate);
    }

    public Flux<CaseReport> getHighRiskCases() {
        return reportRepository.findByPriority("HIGH");
    }

    public Flux<CaseReport> getHighValueTransactions(Double minAmount, String currency) {
        return reportRepository.findHighValueTransactions(minAmount, currency);
    }
}