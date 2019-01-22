/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.dao.px;

import com.id.osp.entity.px.PXCompanyInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author ods-dev
 */
@Repository
public interface PXCompanyInfoDao extends PagingAndSortingRepository<PXCompanyInfo, String>{
    
    PXCompanyInfo findByEntityId(String entityId);
    
    Page<PXCompanyInfo> findByCompanyNameContainingIgnoreCase(String companyName, Pageable pageable);
}
