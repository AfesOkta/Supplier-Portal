/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.service.sec;

import com.id.osp.dao.sec.PasswordResetDao;
import com.id.osp.entity.sec.PasswordReset;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

/**
 *
 * @author Afes
 */
@Service
@Transactional
@EnableScheduling
public class PasswordResetTokenService {

    @Autowired
    private PasswordResetDao passwordResetDao;

    private Logger logger = LoggerFactory.getLogger(PasswordResetTokenService.class);
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");

    public String validatePasswordResetToken(String token) {
        PasswordReset passToken = passwordResetDao.findByToken(token);
        if (passToken == null) {
            return "Token tidak ditemukan";
        }
        Calendar cal = Calendar.getInstance();
        if ((passToken.getExpiryDate()
                .getTime() - cal.getTime()
                        .getTime()) <= 0) {
            return "Token telah kadaluarsa";
        }
        return null;
    }

    @Scheduled(cron = "0 1 0 * * ?")
    public void reportCurrentTime() {
        long now = System.currentTimeMillis();
        logger.info("Scheduler run on {}", dateFormat.format(new Timestamp(now)));

        passwordResetDao.deleteExpiredToken(new Date());
    }
}
