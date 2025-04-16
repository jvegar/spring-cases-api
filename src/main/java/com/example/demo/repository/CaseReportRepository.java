package com.example.demo.repository;

import com.example.demo.model.CaseReport;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import java.time.Instant;

public interface CaseReportRepository extends R2dbcRepository<CaseReport, String> {
    Flux<CaseReport> findByStatus(String status);
    Flux<CaseReport> findByPriority(String priority);
    
    @Query("SELECT * FROM case_reports WHERE created_at BETWEEN :startDate AND :endDate")
    Flux<CaseReport> findByDateRange(Instant startDate, Instant endDate);
    
    @Query("SELECT * FROM case_reports WHERE amount >= :minAmount AND currency = :currency")
    Flux<CaseReport> findHighValueTransactions(Double minAmount, String currency);
}