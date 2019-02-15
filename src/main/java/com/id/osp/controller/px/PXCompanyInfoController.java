/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.id.osp.controller.px;

import com.id.osp.dao.px.PXCompanyInfoDao;
import com.id.osp.entity.px.PXCompanyInfo;
import java.security.SecureRandom;
import javax.validation.Valid;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;

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
    public String daftarEntity(Model m, @PageableDefault(size = 10) Pageable pageable,
            @RequestParam(name = "search", required = false) String search) {

        if (search != null) {
            m.addAttribute("search", search);
            m.addAttribute("entity", dao.findByCompanyNameContainingIgnoreCase(search, pageable));
        } else {
            m.addAttribute("entity", dao.findAll(pageable));
        }
        return "entity/list";
    }
    
    @GetMapping("/entity/edit")
    public ModelMap getFormEdit(@RequestParam(value = "id", required = false) String id) {
        PXCompanyInfo companyInfo = null;
        if(id!=null) {
            companyInfo = dao.findById(id).orElse(new PXCompanyInfo());
        }
        
        return new ModelMap("companyInfo", companyInfo);
    }
    
    @GetMapping("/entity/new")
    public ModelMap getFormNew() {
        PXCompanyInfo companyInfo = new PXCompanyInfo();
        companyInfo.setPrefix1(randomString(5));
        companyInfo.setServerAddress("https://127.0.0.1/");
        return new ModelMap("companyInfo", companyInfo);
    }
    
    String randomString(int len) {
        String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(AB.charAt(rnd.nextInt(AB.length())));
        }
        return sb.toString();
    }
    
    @PostMapping("/entity/new")
    public String processEntity(@ModelAttribute @Valid PXCompanyInfo entity, BindingResult errors, SessionStatus status) {
        if (errors.hasErrors()) {
            return "entity/new";
        }        
        if (entity.getEntityId() == null || entity.getEntityId().isEmpty()) {
            entity.setEntityId(entity.getPrefix1().concat(entity.getOldEntity()));
            entity.setCompanyId(entity.getEntityId());
        }
        dao.save(entity);
        status.setComplete();
        return "redirect:list";
    }
}
