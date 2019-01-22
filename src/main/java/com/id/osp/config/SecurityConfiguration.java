/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.config;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.thymeleaf.extras.springsecurity5.dialect.SpringSecurityDialect;

/**
 *
 * @author ods-dev
 */
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    @Autowired
    private DataSource dataSource;
    @Autowired
    private PasswordEncoder passwordEncoder;

    private static final String SQL_ROLE
            = "select u.user_name, p.permission_value as authority "
            + "from dba.c_security_user u "
            + "inner join dba.c_security_role r on u.id_role = r.id "
            + "inner join dba.c_security_role_permission rp on rp.id_role = r.id "
            + "inner join dba.c_security_permission p on rp.id_permission = p.id "
            + "where u.user_name = ?";

    private static final String SQL_LOGIN
            = "select u.user_name as username,p.password as password, active "
            + "from dba.c_security_user u "
            + "inner join dba.c_security_user_password p on p.id_user = u.id "
            + "where user_name = ?";
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(13);
    }

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(daoAuthenticationProvider());
    }

    @Bean
    public AuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setPasswordEncoder(passwordEncoder);
        provider.setUserDetailsService(userDetailsService());
        return provider;
    }

    @Bean
    @Override
    public UserDetailsService userDetailsService() {
        JdbcDaoImpl userDetails = new JdbcDaoImpl();
        userDetails.setDataSource(dataSource);
        userDetails.setUsersByUsernameQuery(SQL_LOGIN);
        userDetails.setAuthoritiesByUsernameQuery(SQL_ROLE);
        return userDetails;
    }

    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable();
        http
                .authorizeRequests()                
                .antMatchers("/forgot_password/**").permitAll()
                .antMatchers("/reset_password/**").permitAll()                
//                .antMatchers("/kegiatan/**").hasAnyRole("KEGIATAN")
//                .antMatchers("/institusi/**").hasAnyRole("MASTER_INSTITUSI")
//                .antMatchers("/jenissurat/**").hasAnyRole("MASTER_JENIS_SURAT")
//                .antMatchers("/jabatan/**").hasAnyRole("MASTER_JABATAN")
//                .antMatchers("/dosen/**").hasAnyRole("MASTER_DOSEN")
//                .antMatchers("/programstudi/**").hasAnyRole("MASTER_PROGRAM_STUDI")
//                .antMatchers("/matakuliah/**").hasAnyRole("MASTER_MATA_KULIAH")
//                .antMatchers("/surattugas/**").hasAnyRole("MASTER_SURAT_TUGAS")
//                .antMatchers("/kategorikegiatan/**").hasAnyRole("MASTER_KATEGORI_KEGIATAN")
//                .antMatchers("/jeniskegiatan/**").hasAnyRole("MASTER_JENIS_KEGIATAN")
//                .antMatchers("/kategoribuktikegiatan/**").hasAnyRole("MASTER_KATEGORI_BUKTI_KEGIATAN")
//                .antMatchers("/jenisbuktikegiatan/**").hasAnyRole("MASTER_JENIS_BUKTI_KEGIATAN")
//                .antMatchers("/poinkegiatan/**").hasAnyRole("MASTER_POIN_KEGIATAN")
//                .antMatchers("/jenisDokumenPengajuan/**").hasAnyRole("MASTER_JENIS_DOKUMEN_PENGAJUAN")
//                .antMatchers("/pengajuan/**").hasAnyRole("PENGAJUAN")
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/login")
                .permitAll()
                .and()
                .logout()
                .permitAll();
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring()
                .antMatchers("/api/callback/bni/payment")
                .antMatchers("/info")
                .antMatchers("/js/*")
                .antMatchers("/img/*")
                .antMatchers("/css/*")
                .antMatchers("/vendor/*");
    }

    @Configuration
    @Order(1)
    public static class ApiWebSecurityConfigurationAdapter extends WebSecurityConfigurerAdapter {

        @Override
        protected void configure(HttpSecurity http) throws Exception {
            http.antMatcher("/api/client/**")
                    .authorizeRequests()
                    .anyRequest().authenticated().and().httpBasic()
                    .and().csrf().disable();
        }
    }

    @Bean
    public SpringSecurityDialect springSecurityDialect() {
        return new SpringSecurityDialect();
    }
}
