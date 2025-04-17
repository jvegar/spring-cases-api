package com.api.cases.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("counterparties")
public class Counterparty {
    @Id
    private String id;
    private String name;
    private String accountNumber;
    private String bankName;
    private String bankRoutingNumber;
    private String iban;
    private String country;
}