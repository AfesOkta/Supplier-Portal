package com.id.osp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
@EnableKafka
public class SupplierPortalApplication {

    private static final Logger LOGGER = LoggerFactory.getLogger(SupplierPortalApplication.class);

//    @Autowired
//    private RunningNumberService runningNumberService;
//
//    @Override
//    public void run(String... args) throws Exception {
//        LOGGER.debug("Inisialisasi Running Number");
//        runningNumberService.getNumber();
//    }
    public static void main(String[] args) {
        SpringApplication.run(SupplierPortalApplication.class, args);
    }   

    }
