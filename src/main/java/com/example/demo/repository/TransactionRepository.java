package com.example.demo.repository;

import com.example.demo.model.Transaction;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;

public interface TransactionRepository extends R2dbcRepository<Transaction, String> {
    // Add some common query methods
    Flux<Transaction> findByAccountId(String accountId);
    Flux<Transaction> findByStatus(String status);
    Flux<Transaction> findByCounterpartyId(String counterpartyId);
}