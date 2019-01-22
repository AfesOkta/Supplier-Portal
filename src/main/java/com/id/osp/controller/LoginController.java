/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.controller;

import com.id.osp.dao.sec.PasswordResetDao;
import com.id.osp.dao.sec.UserDao;
import com.id.osp.entity.sec.PasswordReset;
import com.id.osp.entity.sec.User;
import com.id.osp.service.sec.MailService;
import com.id.osp.service.sec.PasswordResetTokenService;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import org.flywaydb.core.internal.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessagingException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author ods-dev
 */
@Controller
public class LoginController {

    private final Logger log = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    private MailService mailService;
    
    @Autowired
    private PasswordResetTokenService tokenService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserDao dao;

    @Autowired
    private PasswordResetDao passwordResetDao;

    @GetMapping("/login")
    public String getLoging() {
        return "login";
    }

    @GetMapping(value = "/forgor_password")
    public void getForgotPassword(Model model) {

    }

    @PostMapping(value = "/forgot_password") 
    public String saveForgotPassword(@RequestParam("email") String email, Model model, HttpServletRequest rq) throws javax.mail.MessagingException {
        Map<String, String> msg = new HashMap<>();

        if (!StringUtils.hasText(email)) {
            log.error("Forgot Password Error, Email is null!");
            msg.put("EmailIsNull", "Email harus diisi!");
        }

        User user = dao.findByUserName(email);

        if (user == null) {
            log.error("Forgot Password Error, User Not Found With Email : [{}] ", email);
            msg.put("UserNotFound", "Maaf, Email yang anda masukkan tidak valid");
        } else {
            String token = UUID.randomUUID().toString().replaceAll("-", "");
            PasswordReset passwordReset = passwordResetDao.findByUser(user);

            if (passwordReset != null) {
                passwordReset.setToken(token);
                passwordReset.setExpiryDate(passwordReset.calculateExpiryDate());
            } else {
                passwordReset = new PasswordReset(token, user);
            }

            passwordResetDao.save(passwordReset);

            String link = getAppUrl(rq) + "/reset_password?token=" + token;

            try {
                mailService.send(user.getUserName(), "Reset Password", "Link Reset Password : <a href='" + link + "'>" + token + "</a>");
            } catch (MessagingException ex) {
                log.error(ex.getMessage());
            } catch (IOException ex) {
                log.error(ex.getMessage());
            }

            //kirim email notif disini
            msg.put("success", "Link Reset Password Telah Dikiriman ke email yang terdaftar");
        }
        model.addAttribute("message", msg);
        return "forgot_password";
    }

    @RequestMapping(value = "/reset_password", method = RequestMethod.GET)
    public String getResetPassword(@RequestParam("token") String token, Model mm, RedirectAttributes redir) {
        Map<String, String> message = new HashMap<>();

        if (!StringUtils.hasText(token)) {
            log.error("Error Reset Password, token is null");
            message.put("ErrorTokenNull", "Terjadi Kesalahan dalam reset password, {Token Is NUll}");
            redir.addFlashAttribute("message", message);
            return "redirect:signin";
        }

        String result = tokenService.validatePasswordResetToken(token);
        if (result != null) {
            message.put("ErrResetToken", result);
            redir.addFlashAttribute("message", message);
            return "redirect:signin";
        }

        mm.addAttribute("message", message);
        return "reset_password";
    }

    @RequestMapping(value = "/reset_password", method = RequestMethod.POST)
    public String resetPassword(String newPassword, String token, Model mm, RedirectAttributes redirectAttributes) {
        Map<String, String> message = new HashMap<>();

        if (!StringUtils.hasText(newPassword) && !StringUtils.hasText(token)) {
            log.error("Error Reset Password, PASSWORD OR TOKEN IS NULL");
            message.put("TokenOrPasswordNull", "Terjadi Kesalahan Dalam Reset Password");
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:signin";
        }

        PasswordReset prt = passwordResetDao.findByToken(token);

        if (prt == null) {
            message.put("tokenNofFound", "token tidak ditemukan / akses token sudah kadaluarsa");
            mm.addAttribute(message);
            return "reset_password?token=" + token;
        }

        User u = prt.getUser();
        u.getUserPassword().setPassword(passwordEncoder.encode(newPassword));
        dao.save(u);
        passwordResetDao.delete(prt);
        message.put("success", "Password Anda Berhasil di Rubah, Silahkan Login Kembali");
        redirectAttributes.addFlashAttribute("message", message);

        return "redirect:signin";
    }

    private String getAppUrl(HttpServletRequest request) {
        return "https://" + request.getServerName() + request.getContextPath();
    }
}
