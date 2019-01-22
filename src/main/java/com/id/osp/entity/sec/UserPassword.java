/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.entity.sec;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.MapsId;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author Afes
 */
@Entity
@Table(name = "c_security_user_password", schema = "dba")
@Data
public class UserPassword implements Serializable{
    private static final long serialVersionUID = -7371610187321351709L;
    
    @Id
    @Column(name = "id_user")
    @Getter @Setter
    private String id;
    
    @OneToOne
    @MapsId
    @JoinColumn(name = "id_user", nullable = false)
    private User user;
    
    @NotNull
    @NotEmpty
    @Column
    @Getter @Setter
    private String password;
    
    public UserPassword() {}
    
    public UserPassword(User user, String password) {
        this.user = user;
        this.password = password;
    }
}
