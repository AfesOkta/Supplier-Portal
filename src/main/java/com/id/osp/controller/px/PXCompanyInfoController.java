/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.controller.px;

import com.id.osp.dao.px.PXCompanyInfoDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author ods-dev
 */
@Controller
public class PXCompanyInfoController {
    
    @Autowired private PXCompanyInfoDao dao;
    
    @RequestMapping("entity/list")
    public String daftarKartu(Model m, @PageableDefault(size = 10) Pageable pageable,
            @RequestParam(name = "value", required = false) String value) {

        if (value != null) {
            m.addAttribute("key", value);
            m.addAttribute("data", dao.findByCompanyNameContainingIgnoreCase(value, pageable));
        } else {
            m.addAttribute("data", dao.findAll(pageable));
        }
        return "entity/list";
}
}
