/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.service.sec;

import com.id.osp.dao.sec.RoleDao;
import com.id.osp.dao.sec.UserDao;
import com.id.osp.entity.sec.Role;
import com.id.osp.entity.sec.User;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

/**
 *
 * @author Afes
 */
@Service("userService")
public class UserService {

    private UserDao penggunaDao;
    private RoleDao roleDao;
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    public UserService(UserDao penggunaDao,
            RoleDao roleDao,
            BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.penggunaDao = penggunaDao;
        this.roleDao = roleDao;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    public User findUserByUserName(String userName) {
        return penggunaDao.findByUserName(userName);
    }

    public User saveUser(User user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        user.setActive(true);
        Optional<Role> userRole = roleDao.findById("ADMIN");
        user.setRole(userRole.get());
        return penggunaDao.save(user);
    }
}
