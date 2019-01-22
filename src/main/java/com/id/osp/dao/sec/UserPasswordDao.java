/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.dao.sec;

import com.id.osp.entity.sec.UserPassword;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Afes
 */
@Repository
public interface UserPasswordDao extends PagingAndSortingRepository<UserPassword, String>{    
    
}
