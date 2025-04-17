package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("accounts")
public class Account {
    @Id
    private String accountId;
    private String accountName;
    private String accountNumber;
    private String accountType;
    private String routingNumber;
}