/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.entity.px;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.GenericGenerator;

/**
 *
 * @author ods-dev
 */
@Entity @Data
@Table(name = "pxcompanyinfo", schema = "dba")
public class PXCompanyInfo implements Serializable {

    private static final int EXPIRATION = 60 * 24;
    private static final long serialVersionUID = -7371610187321351709L;

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid2")
    @Column(name = "entityid", columnDefinition = "character varying(10)")
    @Getter @Setter
    private String entityId;
    @Column(name = "companyid", columnDefinition = "character varying(10)")
    @Getter @Setter        
    private String companyId;
    @Column(name = "companyname", columnDefinition = "character varying(100)")
    @Getter @Setter
    private String companyName;
    @Column(name = "companydesc", columnDefinition = "character varying(200)")
    @Getter @Setter
    private String companyDesc;
    @Column(name = "companyaddress", columnDefinition = "character varying(100)")
    @Getter @Setter
    private String companyAddress;
    @Column(name = "city", columnDefinition = "character varying(25)")
    @Getter @Setter
    private String city;
    @Column(name = "state", columnDefinition = "character varying(25)")
    @Getter @Setter
    private String state;
    @Column(name = "country", columnDefinition = "character varying(25)")
    @Getter @Setter    
    private String country;
    @Column(name = "postcode", columnDefinition = "character varying(10)")
    @Getter @Setter
    private String postCode;
    @Column(name = "phone", columnDefinition = "character varying(25)")
    @Getter @Setter
    private String phone;
    @Column(name = "fax", columnDefinition = "character varying(25)")
    @Getter @Setter
    private String fax;
    @Column(name = "email", columnDefinition = "character varying(40)")
    @Getter @Setter
    private String email;
    @Column(name = "website", columnDefinition = "character varying(50)")
    @Getter @Setter
    private String website;
    @Column(name = "worksector", columnDefinition = "character varying(25)")
    @Getter @Setter
    private String workSector;
    @Column(name = "yearfounded", columnDefinition = "smallint")
    @Getter @Setter    
    private short yearFounded;
    @Column(name = "taxid", columnDefinition = "character varying(40)")
    @Getter @Setter    
    private String taxId;
    @Column(name = "taxaddress", columnDefinition = "character varying(500)")
    @Getter @Setter    
    private String taxAddress;
    @Column(name = "last_modified", columnDefinition = "timestamp without time zone")
    @Getter @Setter
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModified;
    @Column(name = "maxrounding", columnDefinition = "numeric(19,4)")
    @Getter @Setter
    private BigDecimal maxRounding;        
    @Column(name = "prefix_", columnDefinition = "character varying(5)")
    @Getter @Setter
    private String prefix1;
    @Column(name = "oldentity", columnDefinition = "character varying(10)")
    @Getter @Setter
    private String oldEntity;
    @Column(name = "path_image", columnDefinition = "character varying(254)")
    @Getter @Setter
    private String pathImage;
    @Column(name = "server_address", columnDefinition = "character varying(100)")
    @Getter @Setter
    private String serverAddress;
    @Column(name = "userauth", columnDefinition = "character varying(100)")
    @Getter @Setter
    private String userAuth;
    @Column(name = "passauth", columnDefinition = "character varying(100)")
    @Getter @Setter
    private String passAuth;
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (entityId != null ? entityId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PXCompanyInfo)) {
            return false;
        }
        PXCompanyInfo other = (PXCompanyInfo) object;
        if ((this.entityId == null && other.entityId != null) || (this.entityId != null && !this.entityId.equals(other.entityId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.id.osp.entity.px.PXCompanyInfo[ id=" + entityId + " ]";
    }
    
}
