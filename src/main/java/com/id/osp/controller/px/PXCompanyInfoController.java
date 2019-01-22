/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.controller.px;

import com.id.osp.dao.px.PXCompanyInfoDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author ods-dev
 */
@Controller
public class PXCompanyInfoController {

    private final PXCompanyInfoDao dao;

    public PXCompanyInfoController(PXCompanyInfoDao infoDao) {
        this.dao = infoDao;
    }

    @GetMapping("/entity/list")
    public ModelMap listBank() {
        return new ModelMap()
                .addAttribute("daftarEntity", dao.findAll(new Sort(Sort.Direction.ASC, "entityId")))
                .addAttribute("pageTitle", "Daftar Entity");
    }

}
