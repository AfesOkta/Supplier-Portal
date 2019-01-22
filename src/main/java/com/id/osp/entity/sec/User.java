/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.entity.sec;

import com.fasterxml.jackson.annotation.JsonIgnore;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;
import org.hibernate.annotations.GenericGenerator;

/**
 *
 * @author Afes
 */
@Entity
@Table(name = "c_security_user", schema = "dba")
@Data
public class User implements Serializable{
    @Id
    @GeneratedValue(generator = "system-uuid")
    @GenericGenerator(name = "system-uuid", strategy = "uuid2")
    @Getter @Setter    
    private String id;
    
    @Column(nullable = false, unique = true)
    @Getter @Setter
    private String userName;
    
    @Transient
    @Getter @Setter
    private Boolean active = Boolean.TRUE;
    
    @Transient
    @Getter @Setter
    private String password;
    
    @JsonIgnore
    @OneToOne(mappedBy = "user", optional = true)
    @Cascade(CascadeType.ALL)
    @Getter @Setter
    private UserPassword userPassword;
    
    @ManyToOne
    @JoinColumn(name = "id_role", nullable = false)
    @Getter @Setter
    private Role role;
}
