package com.api.cases;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;

import com.api.cases.config.TestKafkaConfig;

@SpringBootTest
@Import(TestKafkaConfig.class)
@ActiveProfiles("test")
class CasesApplicationTests {
    @Test
    void contextLoads() {
    }
}