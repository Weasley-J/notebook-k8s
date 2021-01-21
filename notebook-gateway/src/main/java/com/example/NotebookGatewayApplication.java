package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
import org.springframework.web.bind.annotation.RestController;

@RestController
@EnableZuulProxy
@SpringBootApplication
public class NotebookGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(NotebookGatewayApplication.class, args);
    }

}
