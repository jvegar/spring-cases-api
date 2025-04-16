package com.example.demo;

import com.example.demo.config.TestKafkaConfig;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@Import(TestKafkaConfig.class)
@ActiveProfiles("test")
class DemoApplicationTests {
    @Test
    void contextLoads() {
    }
}