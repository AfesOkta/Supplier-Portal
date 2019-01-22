--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)

-- Started on 2019-01-22 08:40:07 WIB

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 4 (class 2615 OID 25687)
-- Name: dba; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dba;


ALTER SCHEMA dba OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 25688)
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dbo;


ALTER SCHEMA dbo OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--
-- 
-- CREATE SCHEMA public;
-- 
-- 
-- ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3173 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 1 (class 3079 OID 12429)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3175 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 326 (class 1255 OID 26450)
-- Name: aft_insert_entity(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.aft_insert_entity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 -- jika entity belum ada di usergroup
 if not exists(select 1 from dba.usergroup where groupid= new.entityid) then
    insert into dba.usergroup(groupid, description, maxuser, suppgroupid, createuser, createdate, statisticlevel, supplevel)
    values(new.entityid, new.companyname, 10, 0,'system',now(),0,0);
 end if;
  -- create auto user
 if not exists(select 1 from dba.userlogin where groupid= new.entityid and UserId = new.entityid||'001') then
   -- Admin
   INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
     VALUES(new.entityid||'001','',3,new.entityid,'Administrator Company','Admin',0,NULL,'system',now(),'',1,0,1,1,new.entityid,'')ON CONFLICT DO NOTHING;
   -- Staff 
   INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
     VALUES(new.entityid||'002','',2,new.entityid,'Qty DisputeControl','QtyDisputeControl',0,NULL,'system',now(),'',2,0,1,1,new.entityid,'')ON CONFLICT DO NOTHING;
   INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
     VALUES(new.entityid||'003','',2,new.entityid,'Price DisputeControl','PriceDisputeControl',0,NULL,'system',now(),'',3,0,1,1,new.entityid,'')ON CONFLICT DO NOTHING;
   INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
     VALUES(new.entityid||'004','',2,new.entityid,'Staff Company','StaffCompany',0,NULL,'system',now(),'',1,0,1,1,new.entityid,'')ON CONFLICT DO NOTHING;

 end if;
 
 RETURN NEW;   
END;
$$;


ALTER FUNCTION dba.aft_insert_entity() OWNER TO postgres;

--
-- TOC entry 330 (class 1255 OID 26547)
-- Name: aft_insert_usergroup(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.aft_insert_usergroup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare suppid_ varchar(35);
declare oldid_ varchar(15);

BEGIN
 if exists(select 1 From dba.apsupplier where groupa_id = new.groupid) then
   -- create auto user
   if not exists(select 1 from dba.userlogin where groupid= new.groupid and UserId = new.groupid||'002') then
     -- Staff
     select suppid,old_id into suppid_,oldid_ From dba.apsupplier where groupa_id = new.groupid;

     INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
       VALUES(suppid_||'002','',0,new.groupid,'Staff Supplier',oldid_,0,NULL,'system',now(),'',4,0,1,0,new.entityid,'')ON CONFLICT DO NOTHING;
     INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
       VALUES(suppid_||'003','',0,new.groupid,'Staff Supplier',oldid_,0,NULL,'system',now(),'',5,0,1,0,new.entityid,'')ON CONFLICT DO NOTHING;
     INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
       VALUES(suppid_||'004','',0,new.groupid,'Staff Supplier',oldid_,0,NULL,'system',now(),'',6,0,1,0,new.entityid,'')ON CONFLICT DO NOTHING;
     INSERT INTO DBA.UserLogin (UserId,Password,Administrator,GroupId,FirstName,LastName,LoginFlag,StatusLogin,CreateUser,CreateDate,ChangeUser,RoleID,UserAD,AllSiteAccess,MailNotification,entityid,defsiteid)
       VALUES(suppid_||'005','',0,new.groupid,'Staff Supplier',oldid_,0,NULL,'system',now(),'',7,0,1,0,new.entityid,'')ON CONFLICT DO NOTHING;
   end if;
 end if;


 RETURN NEW;
END;
$$;


ALTER FUNCTION dba.aft_insert_usergroup() OWNER TO postgres;

--
-- TOC entry 332 (class 1255 OID 26832)
-- Name: after_insert_grn(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_grn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare isys_ integer;
BEGIN
           --Jika PO belum ada, maka import dulu PO-nya (tidak dicatat di tabel success)
      if not exists(select 1 from dba.pstranshdr where trno = New.orderno) and new.transcode = 1 then
  
        isys_ = coalesce((select Sys+1 from dba.pstranshdr where siteid = new.siteid order by sys desc limit 1),1);
    --raise 'Note: %', isys_;
        insert into dba.pstranshdr( siteid,sys,periodid,entityid,xrperiod,trno,suppid,trdate,expected_dlv,
          trtime,taxable,taxAmt,netamt,transcode,trmanualref,trtype,string1,pdf_file,string4,dlvmtdid, oldsupp, oldsite,ps_ )
          values(new.siteid,iSys_,1,'01',1,cast(new.orderno as varchar(15)),trim(new.suppid),new.trdate,
            new.expected_arv,new.trtime,new.taxable ,new.taxamt,
            new.netamt,51,'','PO' || trim(new.suppid),'New PO',
            to_char(new.trdate,'yyyy-MM-D') || '/PURCHASE ORDER_' || cast(trim(new.orderno) as varchar(15)) || '_' || trim(new.suppid) || '.pdf','','PONew',
        new.oldsupp, new.oldsite,'G');              
      end if;
  
      -- update po
      update dba.pstranshdr as a set string1 = 'Goods Receipt Note',string2 = trim(new.trno),
      expected_arv = (Case when expected_arv is null
        then new.trdate
        else expected_arv end)
        where trno = trim(new.orderno);
      PERFORM dba.b2b_updatestatuspo_grn(trim(new.orderno));
       -- simpan ke table sukses
      INSERT INTO dba.s_intranshdr(siteid,sys,periodid,entityid,xrperiod,trno,trmanualref,trmanualref2,trdate,trtime,trtype,
        transcode,expected_dlv,expected_arv,suppid,custbillto,custsellto,custshipto,custtaxto,top_id,top_days,taxcalc,taxinvoiceno,
        taxinvoicedate,taxsubmitdate,salesrepid,dlvmtdid,shiptonote,headernote,footernote,entrytime,added_by,changed_by,approved,
        xrperiodtax,currencyid,posted,priceid,discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,countercoaid,locationid,
        locationid2,manualcalc_,invoiceno,orderno,projectid,printed,void_,string1,string2,string3,string4,numeric1,invdiscchanged,
        netamt,controltotal,useplcomp,useplreceipt,priceidreceipt,top_id2,listid,mf,mfret,pos_,pos_stationid,pos_shiftid,
        pos_cashierid,ro_,uniquetaxno,taxable,taxamt,taxablesupp,taxamtsupp,oldsupp,oldsite)
        select siteid,sys,periodid,entityid,xrperiod,trno,trmanualref,trmanualref2,trdate,trtime,trtype,transcode,expected_dlv,
          expected_arv,suppid,custbillto,custsellto,custshipto,custtaxto,top_id,top_days,taxcalc,taxinvoiceno,taxinvoicedate,
          taxsubmitdate,salesrepid,dlvmtdid,shiptonote,headernote,footernote,entrytime,added_by,changed_by,approved,xrperiodtax,
          currencyid,posted,priceid,discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,countercoaid,locationid,locationid2,
          manualcalc_,invoiceno,orderno,projectid,printed,void_,string1,string2,string3,string4,numeric1,invdiscchanged,netamt,
          controltotal,useplcomp,useplreceipt,priceidreceipt,top_id2,listid,mf,mfret,pos_,pos_stationid,pos_shiftid,pos_cashierid,
          ro_,uniquetaxno,taxable,taxamt,taxablesupp,taxamtsupp,oldsupp,oldsite
          from dba.intranshdr where siteid = new.siteid and sys = new.sys;
      insert into dba.pxexceptionlog( eventstatus,eventstr,appid,menu,submenu,userid,sessionid)
      values( 0,'input GRN : '||new.trno,'IN','transaction','grn','dba',1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_grn() OWNER TO postgres;

--
-- TOC entry 329 (class 1255 OID 26833)
-- Name: after_insert_grn_dtl(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_grn_dtl() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare isys_ integer;
declare vdecsription_ character varying(1000);
BEGIN
    --Jika PO belum ada, maka import dulu PO-nya (tidak dicatat di tabel success)
    select sys into isys_ from dba.pstranshdr where ps_ = 'G' and
      trno = (select orderno from dba.intranshdr where siteid= new.siteid and sys = new.sys and new.transcode = 1);
      if isys_ > 0 then
        insert into dba.pstransdtl( siteid,sys,lineno,numeric1,giftid,transcode,itemid,periodid,
          description,qt,qty,unitid,unitprice,qty2,remarks,taxable,taxamt,netamt, olditem ) values (
          new.siteID, isys_, new.lineno, new.numeric1, new.giftid, 51, new.itemid, 1,
          new.description, new.qt, new.qty, new.unitid, new.unitprice, new.qty2, new.remarks, new.taxable, new.taxamt, new.netamt, new.olditem)
      ON CONFLICT DO NOTHING ;
      end if;
    -- simpan ke table sukses
    INSERT INTO dba.s_intransdtl(siteid,sys,lineno,transcode,itemid,periodid,locationid,locationid2,projectid,qt,unitid,qty,
      qty2,description,remarks,length_,width_,height,diameter,unitprice,discpct,grossamt,discamt,taxable,taxamt,rounding,netamt,
      qty_inv,qty2_inv,orderno,orderlineno,invoiceno,discpct2,discpct3,discpct4,discpct5,discpct_,invdiscamt,cogsunit,cogsunit2,
      newlot_,linetype,minus_,string1,numeric1,barcode,shippingunit,shippingqty,qtyused,qtysetup,trailertype,reserveid,reasonid,
      rotno,rotlineno,giftlineno,bonus_,giftid,fa_no,string2,olditem)
      select siteid,sys,lineno,transcode,itemid,periodid,locationid,locationid2,projectid,qt,unitid,qty,qty2,description,remarks,
        length_,width_,height,diameter,unitprice,discpct,grossamt,discamt,taxable,taxamt,rounding,netamt,qty_inv,qty2_inv,orderno,
        orderlineno,invoiceno,discpct2,discpct3,discpct4,discpct5,discpct_,invdiscamt,cogsunit,cogsunit2,newlot_,linetype,minus_,
        string1,numeric1,barcode,shippingunit,shippingqty,qtyused,qtysetup,trailertype,reserveid,reasonid,rotno,rotlineno,giftlineno,
        bonus_,giftid,fa_no,string2,olditem from dba.intransdtl where siteid = new.siteid and sys = new.sys and lineno = new.lineno; 

  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_grn_dtl() OWNER TO postgres;

--
-- TOC entry 327 (class 1255 OID 26810)
-- Name: after_insert_initem(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_initem() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- simpan ke table sukses
    INSERT INTO dba.s_initem select * from dba.initem where itemid = new.itemid; 
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_initem() OWNER TO postgres;

--
-- TOC entry 340 (class 1255 OID 26812)
-- Name: after_insert_po_hdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_po_hdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- simpan ke table sukses
  INSERT INTO dba.s_pstranshdr(siteid,sys,periodid,entityid,xrperiod,trno,trmanualref,trmanualref2,trdate,trtime,trtype,transcode,
    expected_dlv,expected_arv,custbillto,custsellto,custshipto,custtaxto,top_id,top_days,taxcalc,salesrepid,dlvmtdid,
    headernote,footernote,entrytime,added_by,changed_by,approved,currencyid,suppid,ps_,priceid,
    discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,projectid,printed,void_,string1,string2,string3,string4,numeric1,
    invdiscchanged,netamt,controltotal,ordertositeid,intransitlocid,destinationlocid,orderno,pdf_file,xml_file,faxstatus,ftpstatus,
    emailstatus,supplydate,faxno,taxable,taxamt,expected_arvtime,oldsupp,oldsite)
    select siteid,sys,periodid,entityid,xrperiod,trno,trmanualref,trmanualref2,trdate,trtime,trtype,transcode,
      expected_dlv,expected_arv,custbillto,custsellto,custshipto,custtaxto,top_id,top_days,taxcalc,salesrepid,dlvmtdid,
      headernote,footernote,entrytime,added_by,changed_by,approved,currencyid,suppid,ps_,priceid,
      discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,projectid,printed,void_,string1,string2,string3,string4,numeric1,
      invdiscchanged,netamt,controltotal,ordertositeid,intransitlocid,destinationlocid,orderno,pdf_file,xml_file,faxstatus,ftpstatus,
      emailstatus,supplydate,faxno,taxable,taxamt,expected_arvtime,oldsupp,oldsite from dba.pstranshdr where siteid = new.siteid and sys = new.sys;
  insert into dba.pxexceptionlog( eventstatus,eventstr,appid,menu,submenu,userid,sessionid)
    values( 0,'input po : '||new.trno,'ps','transaction','po','dba',1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_po_hdr() OWNER TO postgres;

--
-- TOC entry 328 (class 1255 OID 26836)
-- Name: after_insert_podtl(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_podtl() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare trdate_ date;
declare suppid_ varchar(10);
declare suppid2_ varchar(10);
declare entityID_ varchar(10);
declare currentbuyprice_ numeric(19,4);
declare psrec record;
declare aprec record;
BEGIN
  Select suppid,entityID,trdate into psrec--,entityID_,trdate_
    from dba.pstranshdr where siteid = new.siteid and sys = new.sys;
    --RAISE EXCEPTION  'sghgws %',psrec.entityid||psrec.suppid;
  if new.unitprice > 0 then
    select suppid,currentbuyprice into aprec --suppid2_,currentbuyprice_
      from dba.apsupplieritem
       where suppid = psrec.suppid and itemid = new.itemid;
    if coalesce(aprec.suppid,'') = '' then
    --if aprec is null = true then
      INSERT INTO dba.apsupplieritem(suppid,itemid,currentbuyprice,last_modified)
        VALUES (psrec.suppid,new.itemid,new.unitprice,psrec.trdate);  
    else
      if aprec.currentbuyprice <> new.unitprice then
        update dba.apsupplieritem set currentbuyprice = new.unitprice,last_modified = psrec.trdate
        where suppid = psrec.suppid and itemid = new.itemid;
      end if;
    end if;
  end if;
  -- simpan ke table sukses
  INSERT INTO dba.s_pstransdtl(siteid,sys,lineno,transcode,itemid,periodid,locationid,locationid2,projectid,qt,unitid,qty,qty2,
    description,remarks,length_,width_,height,diameter,unitprice,discpct,grossamt,discamt,taxable,taxamt,rounding,netamt,linklineno,
    invoiceno,discpct2,discpct3,discpct4,discpct5,discpct_,wo_,invdiscamt,linetype,salesrepid,string1,numeric1,barcode,prunitprice,
    orderno,orderlineno,po_,giftlineno,bonus_,giftid,linkno,olditem)
    select siteid,sys,lineno,transcode,itemid,periodid,locationid,locationid2,projectid,qt,unitid,qty,qty2,description,remarks,
      length_,width_,height,diameter,unitprice,discpct,grossamt,discamt,taxable,taxamt,rounding,netamt,linklineno,invoiceno,
      discpct2,discpct3,discpct4,discpct5,discpct_,wo_,invdiscamt,linetype,salesrepid,string1,numeric1,barcode,prunitprice,orderno,
      orderlineno,po_,giftlineno,bonus_,giftid,linkno,olditem from dba.pstransdtl where siteid = new.siteid and sys = new.sys and lineno = new.lineno;
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_podtl() OWNER TO postgres;

--
-- TOC entry 333 (class 1255 OID 26823)
-- Name: after_insert_rp_hdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_rp_hdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into dba.pxexceptionlog( eventstatus,eventstr,appid,menu,submenu,userid,sessionid)
      values( 0,'input rp : '||new.trno,'rp','transaction','rp','dba',1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_rp_hdr() OWNER TO postgres;

--
-- TOC entry 331 (class 1255 OID 26437)
-- Name: after_insert_supplier(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_supplier() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare isys_ integer;
declare adminUser_ varchar(255);
BEGIN
    select AdminUser into adminUser_ from dba.UserGroup where SuppGroupID = new.groupa_id LIMIT 1;

    --PO---------------------------------------
    insert into dba.PXTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
      ( 'PO' || new.suppid,'99999',new.suppname,'1',51,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'PO' || new.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      --RCV---------------------------------------
      insert into dba.PXTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'RCV' || new.suppid,'99999',new.suppname,'1',1,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'RCV' || new.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      --INV---------------------------------------
      insert into dba.RPTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'INV' || new.suppid,'99999',new.suppname,'1',1,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.RPTrTypeUsers( TrType,LoginID ) values( 'INV' || new.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      --RETURN---------------------------------------
      insert into dba.PXTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'RET' || new.suppid,'99999',new.suppname,'1',2,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'RET' || new.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      --PAYMENT---------------------------------------
      insert into dba.RPTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax,System_ ) values
        ( 'PMT' || new.suppid,'99999',new.suppname,'1',12,'DEF','DEF','DEF',1 ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.RPTrTypeUsers( TrType,LoginID ) values( 'PMT' || new.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
    if new.groupa_id = 'G' || new.suppid then
      INSERT INTO dba.apsuppliergroupa(groupa_id,description,segment01,segment02,segment03,segment04,segment05,entityid)
       VALUES (new.groupa_id,'Group '||new.suppname,'','','','','',new.entityid) ON CONFLICT DO NOTHING;
    end if; 
--  new.groupa_id = 'G'||new.groupa_id;
--    insert into dba.PXTrTypeUsers( TrType,LoginID )
 --     select TrType,UserID from dba.PXTrType,dba.Userlogin where TrType like '%' || supp_ and GroupID = 'OPERATOR'
  --    ON CONFLICT DO NOTHING;
  --  insert into dba.RPTrTypeUsers( TrType,LoginID )
   --   select TrType,UserID from dba.RPTrType,dba.Userlogin where TrType like '%' || supp_ and GroupID = 'OPERATOR'
    --  ON CONFLICT DO NOTHING;
    if coalesce(new.formsetid,'') <> '' then
      insert into dba.pxformset(id)
       values(new.formsetid) ON CONFLICT DO NOTHING;
    end if;
    -- simpan ke table sukses
    INSERT INTO dba.s_apsupplier select * from dba.apsupplier where suppid = new.suppid;
    insert into dba.pxexceptionlog( eventstatus,eventstr,appid,menu,submenu,userid,sessionid)
      values( 0,'input supplier : '||new.suppid,'sup','master','supplier','dba',1);
   
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_supplier() OWNER TO postgres;

--
-- TOC entry 325 (class 1255 OID 26446)
-- Name: after_insert_userlogin(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_insert_userlogin() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare isys_ integer;
declare adminUser_ varchar(255);
declare Dtl RECORD;
BEGIN
    select AdminUser into adminUser_ from dba.UserGroup where SuppGroupID = new.groupid LIMIT 1;

    FOR Dtl IN SELECT suppid,suppname FROM dba.apsupplier WHERE groupa_id = new.groupid
    LOOP
      --PO---------------------------------------
      insert into dba.PXTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'PO' || Dtl.suppid,'99999',dtl.suppname,'1',51,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'PO' || Dtl.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'PO' || Dtl.suppid,new.userid ) ON CONFLICT DO NOTHING;
      --RCV---------------------------------------
      insert into dba.PXTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'RCV' || Dtl.suppid,'99999',dtl.suppname,'1',1,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'RCV' || Dtl.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'RCV' || Dtl.suppid,new.userid ) ON CONFLICT DO NOTHING;
      --INV---------------------------------------
      insert into dba.RPTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'INV' || Dtl.suppid,'99999',dtl.suppname,'1',1,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.RPTrTypeUsers( TrType,LoginID ) values( 'INV' || Dtl.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      insert into dba.RPTrTypeUsers( TrType,LoginID ) values( 'INV' || Dtl.suppid,new.userid ) ON CONFLICT DO NOTHING;
      --RETURN---------------------------------------
      insert into dba.PXTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax ) values
        ( 'RET' || Dtl.suppid,'99999',dtl.suppname,'1',2,'DEF','DEF','DEF' ) ON CONFLICT DO NOTHING;
      if(adminUser_ is not null) then
        insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'RET' || Dtl.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
      end if;
      insert into dba.PXTrTypeUsers( TrType,LoginID ) values( 'RET' || Dtl.suppid,new.userid ) ON CONFLICT DO NOTHING;
      --PAYMENT---------------------------------------
      insert into dba.RPTrType( TrType,SiteID,Description,Numbering,TransCode,AppSetID,XRType,XRTypeTax,System_ ) values
        ( 'PMT' || Dtl.suppid,'99999',dtl.suppname,'1',12,'DEF','DEF','DEF',1 ) ON CONFLICT DO NOTHING;
     if(adminUser_ is not null) then
       insert into dba.RPTrTypeUsers( TrType,LoginID ) values( 'PMT' || Dtl.suppid,adminUser_ ) ON CONFLICT DO NOTHING;
     end if;
     insert into dba.RPTrTypeUsers( TrType,LoginID ) values( 'PMT' || Dtl.suppid,new.userid ) ON CONFLICT DO NOTHING;
        --RETURN NEXT LoopDtl;
    END LOOP;


--    insert into dba.PXTrTypeUsers( TrType,LoginID )
 --     select TrType,UserID from dba.PXTrType,dba.Userlogin where TrType like '%' || supp_ and GroupID = 'OPERATOR'
  --    ON CONFLICT DO NOTHING;
  --  insert into dba.RPTrTypeUsers( TrType,LoginID )
   --   select TrType,UserID from dba.RPTrType,dba.Userlogin where TrType like '%' || supp_ and GroupID = 'OPERATOR'
    --  ON CONFLICT DO NOTHING;


  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.after_insert_userlogin() OWNER TO postgres;

--
-- TOC entry 341 (class 1255 OID 26874)
-- Name: after_update_groupid(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.after_update_groupid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
  --jika terjadi perubahan di supplier group
  if coalesce(OLD.groupa_id,'') <> coalesce(NEW.groupa_id,'') then
    -- update status admin
    update dba.userLogin set administrator = 0 where administrator = 1 and groupid = OLD.GroupA_ID;
    -- update usergroup
    update dba.userLogin set groupId = NEW.groupa_id where groupid = OLD.groupa_id;
    if not exists(select 1 from dba.UserGroup where GroupId = NEW.GroupA_ID) then
      update dba.UserGroup set GroupId = NEW.GroupA_ID,SuppGroupID = NEW.GroupA_ID where GroupId = OLD.GroupA_ID;
    else
      update dba.UserGroup set SuppGroupID = NEW.GroupA_ID where GroupId = NEW.GroupA_ID;
    end if;
   
  end if;

 
 RETURN NEW;   
END;
$$;


ALTER FUNCTION dba.after_update_groupid() OWNER TO postgres;

--
-- TOC entry 337 (class 1255 OID 26842)
-- Name: afterupd_approved_rptranshdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.afterupd_approved_rptranshdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare topid_ integer;
BEGIN
  if new.Approved = 1 and new.Approved <> old.Approved then
    update dba.INTransHdr set String1 = 'Invoice Receipt' where OrderNo = new.OrderNo;
    update dba.PSTransHdr set String1 = 'Invoice Receipt' where TrNo = new.OrderNo;
    select cast(Top_ID as integer) into topid_ from dba.APSupplier where SuppID = new.SuppID;
    update dba.RPTransHdr set TaxSubmitDate = now(),DeductionSlipDate = now() + Interval '1 day' * topid_,ProjectID = 'Accepted'
      where SiteID = new.SiteID and Sys = new.Sys;
  end if;
 
 RETURN NEW; 
END;
$$;


ALTER FUNCTION dba.afterupd_approved_rptranshdr() OWNER TO postgres;

--
-- TOC entry 319 (class 1255 OID 26436)
-- Name: b2b_copysecurityfromrole(character varying, integer); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b2b_copysecurityfromrole(pgroupid character varying, proleid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  insert into dba.SecurityNode( Action,Checked,GroupID,Form,Description,GroupMenu,GroupForm,Seq )
    select Action,Checked,pGroupID || '~' || RoleID,Form,Description,GroupMenu,GroupForm,Seq
      from dba.SecurityNodeRole where RoleID = pRoleID ON CONFLICT DO NOTHING;
  insert into dba.SecurityNodeItem( GroupID,Form,Description,Element,ElType )
    select pGroupID || '~' || RoleID,Form,Description,Element,ElType
      from dba.SecurityNodeRoleItem where RoleID = pRoleID ON CONFLICT DO NOTHING;
  end;
$$;


ALTER FUNCTION dba.b2b_copysecurityfromrole(pgroupid character varying, proleid integer) OWNER TO postgres;

--
-- TOC entry 321 (class 1255 OID 26414)
-- Name: b2b_generatesecurityrole(integer); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b2b_generatesecurityrole(proleid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  --  master supplier
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'access',1,pRoleID,'Master Supplier List','Master Supplier','Master','Master Supplier',100 )  ON CONFLICT(roleid, form, description) DO NOTHING;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Master Supplier List','Master Supplier','ap/aPSupplier/List.jsp','form' )  ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  master item
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'access',1,pRoleID,'Master Item List','Master Item','Master','Master Item',200 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Master Item List','Master Item','in/iNItem/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  --  PO
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'access',1,pRoleID,'Purchase Order List','Purchase Order','Transaction','Purchase Order',1000 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Order List','Purchase Order','ps/pOTransHdr/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Order List','Price','Transaction','Purchase Order',1001 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Order List','Price','secPrice','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'hidden',0,pRoleID,'Purchase Order List','Print PDF','Transaction','Purchase Order',1002 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Purchase Order List','Print PDF','secPrintPDF','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Order List','Print ASN','Transaction','Purchase Order',1003 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Order List','Print ASN','secPrintASN','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Order List','Save','Transaction','Purchase Order',1004 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Order List','Save','secSave','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Order List','Confirm ASN','Transaction','Purchase Order',1005 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Order List','Confirm ASN','secConfirm','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Order List','Download CSV','Transaction','Purchase Order',1006 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Order List','Download CSV','secDownloadCSV','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  Receiving
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'access',1,pRoleID,'Goods Receipt Note List','Goods Receipt Note','Transaction','Goods Receipt Note',1500 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Goods Receipt Note','in/receiving/iNTransHdr/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Price','Transaction','Goods Receipt Note',1501 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Price','secPrice','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Confirm Qty','Transaction','Goods Receipt Note',1502 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Confirm Qty','secConfirmQty','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Dispute Qty','Transaction','Goods Receipt Note',1503 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Dispute Qty','secSubmitDisputeQty','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Confirm Price','Transaction','Goods Receipt Note',1504 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Confirm Price','secConfirmPrice','table:cell' )ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Dispute Price','Transaction','Goods Receipt Note',1505 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Dispute Price','secSubmitDisputePrice','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Upload','Transaction','Goods Receipt Note',1506 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Upload','secUpload','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','History','Transaction','Goods Receipt Note',1507 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','History','secHistory','table:cell' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Create Invoice','Transaction','Goods Receipt Note',1508 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Create Invoice','secCreateInvoice','table:cell' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Print Proforma Invoice','Transaction','Goods Receipt Note',1509 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Print Proforma Invoice','secPrintProformaInvoice','table:cell' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'hidden',0,pRoleID,'Goods Receipt Note List','Print PDF','Transaction','Goods Receipt Note',1510 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Goods Receipt Note List','Print PDF','secPrintGRN','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Goods Receipt Note List','Download CSV','Transaction','Goods Receipt Note',1511 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Goods Receipt Note List','Download CSV','secDownloadCSV','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  Invoice
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'access',1,pRoleID,'Purchase Invoice List','Purchase Invoice','Transaction','Purchase Invoice',2000 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Invoice List','Purchase Invoice','rp/pITransHdr/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Invoice List','Price','Transaction','Purchase Invoice',2001 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Invoice List','Price','secPrice','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Purchase Invoice List','Download CSV','Transaction','Purchase Invoice',2002 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Purchase Invoice List','Download CSV','secDownloadCSV','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  khusus untuk user Company
  if exists(select 1 from DBA.UserRole where RoleID = pRoleID and InternalRole = 1) then
    insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
      ( 'access',1,pRoleID,'Scan Purchase Invoice','Scan Purchase Invoice','Transaction','Scan Purchase Invoice',2500 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
    insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
      ( pRoleID,'Scan Purchase Invoice','Scan Purchase Invoice','rp/pITransHdr/ScanBarcodeDropBox.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --    ( 'access',1,pRoleID,'Release Print Purchase Invoice','Release Print Purchase Invoice','Transaction','Release Print Purchase Invoice',2600 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --    ( pRoleID,'Release Print Purchase Invoice','Release Print Purchase Invoice','rp/pITransHdr/ReleaseBarcode.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  end if;
  --  Payment
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'access',1,pRoleID,'Payment List','Remittance','Transaction','Payment',2700 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Payment List','Remittance','rp/aPPayment/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Payment List','Price','Transaction','Payment',2701 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Payment List','Price','secPrice','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
    ( 'hidden',0,pRoleID,'Payment List','Download CSV','Transaction','Payment',2702 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
    ( pRoleID,'Payment List','Download CSV','secDownloadCSV','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  -- Deduction
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Deduction List','Deduction','Transaction','Payment',2800 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Deduction List','Deduction','rp/aPPayment/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  -- AP Details
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'AP Detail List','AP Details','Statistic','Statistic',2900 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'AP Detail List','AP Details','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  -- Return
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Return List','Return','Transaction','Return',3000 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Return List','Return','in/pRITransHdr/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'hidden',0,pRoleID,'Return List','Price','Transaction','Return',3001 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Return List','Price','secPrice','table:cell' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'hidden',0,pRoleID,'Return List','Download CSV','Transaction','Return',3002 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Return List','Download CSV','secDownloadCSV','table:cell' ) ON CONFLICT(roleid, form, description, element) DO NOTHING ;

  /* STATISTIC */
  --  Pending Delivery
 -- insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
 --   ( 'access',1,pRoleID,'Pending Delivery','Pending Delivery','Statistic','Pending Delivery',6000 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
 -- insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
 --   ( pRoleID,'Pending Delivery','Pending Delivery','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  Return History
 -- insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
 --   ( 'access',1,pRoleID,'Return History','Return History','Statistic','Return History',6100 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
 -- insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
 --   ( pRoleID,'Return History','Return History','b2b/statistic/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  -- On-going Dispute
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'On-going Dispute','On-going Dispute','Statistic','On-going Dispute',6200 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'On-going Dispute','On-Going Dispute','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  -- payment progress
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Payment Progress List','Payment Progress','Transaction','Payment',6300 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Payment Progress List','Payment Progress','rp/aPPayment/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  Service Level
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Service Level','Service Level','Statistic','Service Level',6600 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Service Level','Service Level','b2b/statistic/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  Promotion Performance
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Promotion Performance','Promotion Performance','Statistic','Promotion Performance',6700 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Promotion Performance','Promotion Performance','b2b/statistic/List.jsp','form' ) ON CONFLICT(roleid, form, description, element) DO NOTHING;
  --  Service Level Contribution vs Category
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Service Level Contribution vs Category','Service Level Contribution vs Category','Statistic','Service Level Contribution vs Category',6200 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Service Level Contribution vs Category','Service Level Contribution vs Category','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  -- Sales Contribution vs Category
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Sales Contribution vs Group','Sales Contribution vs Group','Statistic','Sales Contribution vs Group',6800 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Sales Contribution vs Group','Sales Contribution vs Group','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  -- Market Share vs Category
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Market Share Class vs Customer Group','Market Share Class vs Customer Group','Statistic','Market Share Class vs Customer Group',6900 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Market Share Class vs Customer Group','Market Share Class vs Customer Group','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
  -- Stock Balance
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Stock Balance','Stock Balance','Statistic','Stock Balance',7000 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Stock Balance','Stock Balance','b2b/statistic/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING ;
  -- Sales Item By Store
  --insert into dba.securitynoderole( Action,Checked,RoleID,Form,Description,GroupMenu,GroupForm,Seq ) values
  --  ( 'access',1,pRoleID,'Sales Item By Store','Sales Item By Store','Statistic','Sales Item By Store',7100 ) ON CONFLICT(roleid, form, description) DO NOTHING ;
  --insert into dba.securitynoderoleItem( RoleID,Form,Description,Element,ElType ) values
  --  ( pRoleID,'Sales Item By Store','Sales Item By Store','b2b/serviceLevel/List.jsp','form' )ON CONFLICT(roleid, form, description, element) DO NOTHING;
end;
$$;


ALTER FUNCTION dba.b2b_generatesecurityrole(proleid integer) OWNER TO postgres;

--
-- TOC entry 318 (class 1255 OID 26416)
-- Name: b2b_updatestatuspo_grn(character varying); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b2b_updatestatuspo_grn(porderno character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  update dba.intranshdr as a set dlvmtdid = 'POFulOntime'
    where expected_arv >= trdate and orderno = pOrderNo
    and(select sum(qt) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys) = (select sum(qty) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys);

  update dba.intranshdr as a set dlvmtdid = 'POFulLate'
    where expected_arv < trdate and orderno = pOrderNo
    and(select sum(qt) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys) = (select sum(qty) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys);

  update dba.intranshdr as a set dlvmtdid = 'PONotFulOntime'
    where expected_arv >= trdate and orderno = pOrderNo
    and(select sum(qt) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys) <> (select sum(qty) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys);

  update dba.intranshdr as a set dlvmtdid = 'PONotFulLate'
    where expected_arv < trdate and orderno = pOrderNo
    and(select sum(qt) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys) <> (select sum(qty) from dba.intransdtl as b where a.siteid = b.siteid and a.sys = b.sys);

  update dba.pstranshdr as a set dlvmtdid = b.dlvmtdid from
    dba.intranshdr as b where a.trno = b.orderno and b.orderno = pOrderNo;
END;
$$;


ALTER FUNCTION dba.b2b_updatestatuspo_grn(porderno character varying) OWNER TO postgres;

--
-- TOC entry 324 (class 1255 OID 26452)
-- Name: b4_update_entity(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4_update_entity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 -- jika entity ada di usergroup
 if (new.companyname <> old.companyname) then
    update dba.usergroup set description = new.companyname where groupid=old.entityid;
 end if;
 RETURN NEW;	
END;
$$;


ALTER FUNCTION dba.b4_update_entity() OWNER TO postgres;

--
-- TOC entry 339 (class 1255 OID 26867)
-- Name: b4ins_trans(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4ins_trans() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  BEGIN
   NEW.oldsite := replace(new.siteid,new.entityid,'');
 
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.b4ins_trans() OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 26846)
-- Name: b4upd_approved_return(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4upd_approved_return() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  declare vSys integer;
 BEGIN
  if new.Transcode = 2 and old.Approved = 0 and new.Approved = 1 then
    select coalesce(max(sys),0)+1 into vSys from DBA.B2BNotification;
    new.CounterCOAID = vSys;
    insert into DBA.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
      ( vSys,now(),'GRTN',new.TrNo,new.SuppID,0,'Normal' ) ;
    insert into DBA.B2BNotificationUsers( Sys,UserID,Opened )
      select vSys,a.UserID,0 from DBA.UserLogin as a join DBA.LoginSites as b on UserID = b.LoginID
      where a.Administrator = 2 and MailNotification = 1 and b.SiteID = new.SiteID and a.RoleID = 2;
  end if;
 RETURN NEW; 
END;
$$;


ALTER FUNCTION dba.b4upd_approved_return() OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 25691)
-- Name: b4upd_invoicesupplier(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4upd_invoicesupplier() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  if (NEW.TaxInvoiceNo <> OLD.TaxInvoiceNo OR NEW.TaxInvoiceDate <> OLD.TaxInvoiceDate OR NEW.ShipToNote<>OLD.ShipToNote) then
   update dba.rptranshdr set trmanualref2 = NEW.shiptonote,taxinvoiceno = NEW.taxinvoiceno,taxinvoicedate = NEW.taxinvoicedate
    where trno = NEW.invoiceno and approved = 0;  
  end if;
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.b4upd_invoicesupplier() OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 25692)
-- Name: b4upd_posted_intranshdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4upd_posted_intranshdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  declare vCounter integer;
  declare vDisputeNo varchar(20);
  declare iNextNo integer;
  declare vSys integer;
  declare SuppType_ varchar(10);
  declare iLevel_ integer;
  declare CountDays_ integer;
  declare JobTitle_ varchar(100);
  declare Taxable_ numeric(19,4);
  declare TaxAmt_ numeric(19,4);
  declare NetAmt_ numeric(19,4);
  declare AreaID_ varchar(10);

  BEGIN
  IF (coalesce(new.Posted,0) <> coalesce(old.Posted,0) or coalesce(new.Posted,0) = 6 )then
    -- sebagai penanda ada notifikasi   email
    new.CounterCOAID = 0;
    select formSetID,AreaID into SuppType_,AreaID_ from DBA.APSupplier where SuppID = new.SuppID;
    -- RO_ = 1, update dari supplier,  RO = 2 update dari emporium
    if(old.Posted = 0 and new.Posted = 1) or(old.Posted = 2 and new.Posted = 1) or(new.RO_ = 1 and old.Posted = 2 and new.Posted = 3) then -- dispute qty atau complete dispute qty
      select coalesce(max(Counter),0)+1 into vCounter from DBA.INTransDtlLogDispute where SiteID = new.SiteID and Sys = new.Sys and Dispute = 0;
      --select coalesce(max(Counter),0) into vCounter from DBA.INTransDtlLogDispute where SiteID = SiteId_ and Sys = Sys_;
      insert into DBA.INTransDtlLogDispute
        ( SiteID,Sys,Counter,LineNo,EntryTime,ItemID,Dispute,Qty,Qty2,Comment1,UnitPrice,UnitPrice2,Comment2,LineType,ReasonDisQty,ReasonDisPrice,UpdateTime,LoginID )
        select SiteID,Sys,vCounter,LineNo,Now(),ItemID,0,Qty,Qty2,String1,0,0,'','','','',null,new.Changed_by
          from DBA.INTransDtl where Sys = new.Sys and SiteID = new.SiteID and(Qty <> Qty2 or(Minus_ = 1 and exists(select 1 from DBA.INTransDtlLogDispute as b where b.Dispute = 0 and b.SiteID = new.SiteID and b.Sys = new.Sys and b.LineNo = INTransDtl.LineNo and b.Counter = (vCounter-1) and b.LineType = 'R')));
      select min(Date(EntryTime))-Date(Now()) into CountDays_ from DBA.INTransDtlLogDispute where SiteID = new.SiteId and Sys = new.Sys and Dispute = 0;
      if coalesce(new.TrManualRef,'') = '' then
    select substr(TrManualRef,6,5)
          into iNextNo from DBA.INTransHdr where Transcode = 1 and substr(TrManualRef,2,4) = to_char(Expected_Arv,'YYMM')
          order by 1 desc Limit 1;
        iNextNo = coalesce(iNextNo,0)+1;
        new.TrManualRef = 'Q' || to_char(new.Expected_Arv,'YYMM') || (select lpad(iNextNo::varchar(5), 5, '0'));
      end if;
     
      -- insert b2b notification ke emporium
      if(old.Posted = 0 and new.Posted = 1) or(old.Posted = 2 and new.Posted = 1) then
        select coalesce(Level_,0) into iLevel_ from DBA.B2BLevelJobTitle where Dispute = 0
          and(Days_ < CountDays_ or Count_ < vCounter-1) order by Level_ desc Limit 1;
        if coalesce(AreaID_,'') = '' then -- tidak ikut b2b, akan di tangani oleh level 0
          iLevel_ = 0;
        else
          if coalesce(iLevel_,0) = 0 then
            iLevel_ = 1;
          end if;
    end if;
        update DBA.PSTransHdr set String1 = 'Dispute Qty' where TrNo = new.OrderNo;
        new.String1 = 'Dispute Qty';
        select coalesce(max(sys),0)+1 into vSys from DBA.B2BNotification;
        new.CounterCOAID = vSys;
        insert into DBA.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
          ( vSys,now(),'GRN',new.TrNo,new.SuppID,0,'DisputeQty' ) ;
        insert into DBA.B2BNotificationUsers( Sys,UserID,Opened )
          select vSys,a.UserID,0 from DBA.UserLogin as a join DBA.LoginSites as b on UserID = b.LoginID
            where a.Administrator = 2 and MailNotification = 1 and b.SiteID = new.SiteID;
            --and exists(select 1 from DBA.B2BLevelJobTitle as c where a.LastName = c.JobTitle and c.Level_ = iLevel_ and c.Dispute = 0);
      end if;
    end if;
    if(old.Posted = 1 and new.Posted = 2) or(old.Posted = 1 and new.Posted = 3) then -- respon dispute qty   
      select max(Counter) into vCounter from DBA.INTransDtlLogDispute where SiteID = new.SiteID and Sys = new.Sys and Dispute = 0;
      update DBA.INTransDtlLogDispute as a
        set LineType = b.LineType,
        ReasonDisQty = b.ReserveID,
        UpdateTime = Now(),
        ChangedBy = new.Changed_by from
        DBA.INTransDtl as b where a.Sys = b.Sys and a.SiteID = b.SiteID and a.LineNo = b.LineNo
        and a.Sys = new.Sys and a.SiteID = new.SiteID and a.Counter = vCounter and b.Minus_ = 1 and b.LineType in( 'A','R' ) ;
      -- Update Status PO
      update DBA.PSTransHdr set String1 = 'Dispute Qty' where TrNo = new.OrderNo;
      new.String1 = 'Dispute Qty';
      -- insert b2b notification ke supplier
      select coalesce(max(sys),0)+1 into vSys from DBA.B2BNotification;
      new.CounterCOAID = vSys;
      insert into DBA.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
        ( vSys,now(),'GRN',new.TrNo,new.SuppID,0,'DisputeQty' ) ;
      insert into DBA.B2BNotificationUsers( Sys,UserID,Opened )
        select vSys,a.UserID,0 from DBA.UserLogin as a join DBA.PXTrTypeUsers as b on UserID = b.LoginID
          where b.TrType = new.TrType and a.MailNotification = 1;
    end if;
    if(old.Posted = 3 and new.Posted = 4) or(old.Posted = 5 and new.Posted = 4) or(new.RO_ = 1 and old.Posted = 5 and new.Posted = 6) then -- dispute price
      select coalesce(max(Counter),0)+1 into vCounter from DBA.INTransDtlLogDispute where SiteID = new.SiteID and Sys = new.Sys and Dispute = 1;
      insert into DBA.INTransDtlLogDispute
        ( SiteID,Sys,Counter,LineNo,EntryTime,ItemID,Dispute,Qty,Qty2,Comment1,UnitPrice,UnitPrice2,Comment2,LineType,ReasonDisQty,ReasonDisPrice,UpdateTime,LoginID )
        select SiteID,Sys,vCounter,LineNo,Now(),ItemID,1,0,0,'',UnitPrice,COGSUnit2,String2,'','','',null,new.Changed_by
          from DBA.INTransDtl where Sys = new.Sys and SiteID = new.SiteID and(UnitPrice <> COGSUnit2 or(NewLot_ = 1 and exists(select 1 from DBA.INTransDtlLogDispute as b where b.Dispute = 1 and b.SiteID = new.SiteID and b.Sys = new.Sys and b.LineNo = INTransDtl.LineNo and b.Counter = (vCounter-1) and b.LineType = 'R')));
      select Date(EntryTime)-Date(Now()) into CountDays_ from DBA.INTransDtlLogDispute
        where SiteID = new.SiteId and Sys = new.Sys and Dispute = 1;
      if coalesce(new.TrManualRef2,'') = '' then
        select cast(substr(TrManualRef2,6,5) as integer)
          into iNextNo from DBA.INTransHdr where Transcode = 1 and substr(TrManualRef2,2,4) = to_char(Expected_Arv,'YYMM')
          order by 1 desc Limit 1;
        iNextNo = coalesce(iNextNo,0)+1;
        new.TrManualRef2 = 'P' || to_char(new.Expected_Arv,'YYMM') || (select lpad(iNextNo::varchar(5), 5, '0'));
      end if;
      -- untuk sementara dispute price di samakan dengan dispute qty
      if(old.Posted = 3 and new.Posted = 4) or(old.Posted = 5 and new.Posted = 4) then
        select coalesce(Level_,0) into iLevel_ from DBA.B2BLevelJobTitle as a where Dispute = 1
          and(Days_ < CountDays_ or Count_ < vCounter-1) and exists(select 1 from DBA.B2BSupplierTypeDtl as b
            where SupplierType = SuppType_ and b.JobTitle = a.JobTitle) order by Level_ desc Limit 1;
        if coalesce(AreaID_,'') = '' then -- tidak ikut b2b, akan di tangani oleh level 0
          iLevel_ = 0;
        else
          if coalesce(iLevel_,0) = 0 then
            iLevel_ = 1;
          end if;
    end if;
        -- Update Status PO
        update DBA.PSTransHdr set String1 = 'Dispute Price' where TrNo = new.OrderNo;
        new.String1 = 'Dispute Price';
        -- insert b2b notification ke emporium
        select coalesce(max(sys),0)+1 into vSys from DBA.B2BNotification;
        new.CounterCOAID = vSys;
        insert into DBA.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
          ( vSys,now(),'GRN',new.TrNo,new.SuppID,0,'DisputePrc' ) ;
        insert into DBA.B2BNotificationUsers( Sys,UserID,Opened )
          select vSys,a.UserID,0 from DBA.UserLogin as a join DBA.B2BSupplierTypeDtl as b on a.LastName = b.JobTitle join DBA.APSupplier as x
              on b.SupplierType = x.FormSetID
            where a.Administrator = 2 and MailNotification = 1 and x.SuppID = new.SuppID;
            --and exists(select 1 from DBA.B2BLevelJobTitle as c where a.LastName = c.JobTitle and c.Level_ = iLevel_ and c.Dispute = 1);
      end if;
    end if;   
    if(old.Posted = 4 and new.Posted = 5) or(old.Posted = 4 and new.Posted = 6) then -- respon dispute price
      -- Update Status PO
      update DBA.PSTransHdr set String1 = 'Dispute Price' where TrNo = new.OrderNo;
      new.String1 = 'Dispute Price';
      select max(Counter) into vCounter from DBA.INTransDtlLogDispute where SiteID = new.SiteID and Sys = new.Sys and Dispute = 1;
      update DBA.INTransDtlLogDispute as a
        set LineType = b.LineType,
        ReasonDisPrice = b.ROTNo,
        UpdateTime = Now(),
        ChangedBy = new.Changed_by from
        DBA.INTransDtl as b where a.Sys = b.Sys and a.SiteID = b.SiteID and a.LineNo = b.LineNo
        and a.Sys = new.Sys and a.SiteID = new.SiteID and a.Counter = vCounter and b.NewLot_ = 1 and b.LineType in( 'A','R' ) ;
      -- insert b2b notification ke supplier
      select coalesce(max(sys),0)+1 into vSys from DBA.B2BNotification;
      new.CounterCOAID = vSys;
      insert into DBA.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
        ( vSys,now(),'GRN',new.TrNo,new.SuppID,0,'DisputePrc' ) ;
      insert into DBA.B2BNotificationUsers( Sys,UserID,Opened )
        select vSys,a.UserID,0 from DBA.UserLogin as a join DBA.PXTrTypeUsers as b on UserID = b.LoginID
          where b.TrType = new.TrType and a.MailNotification = 1;
    end if;
    if new.Posted = 3 then
      update DBA.INTransDtl set LineType = 'N' where LineType <> 'N' and Sys = new.Sys and SiteID = new.SiteID;
      update DBA.PSTransHdr set String1 = 'Confirm Qty' where TrNo = new.OrderNo;
      new.String1 = 'Confirm Qty';
    end if;
    if new.Posted = 6 then
      update DBA.PSTransHdr set String1 = 'Confirm Price' where TrNo = new.OrderNo;
      new.String1 = 'Confirm Price';
    end if;
    if new.Posted in( 3,6 ) then
      update DBA.INTransDtl as a set taxable = Round(Qty2*CogsUnit2,0),taxamt = Round(10/100.0*(Qty2*CogsUnit2),0) --from
        --DBA.INTransTaxDtl as b
    where --a.SiteID = b.SiteID and a.Sys = b.Sys and a.numeric1 = b.numeric1 and
    a.SiteID = new.SiteID and a.Sys = new.Sys and(a.newlot_ = 1 or a.minus_ = 1);
      update DBA.INTransDtl as a set NetAmt = taxable+taxamt where a.SiteID = new.SiteID and a.Sys = new.Sys and(a.newlot_ = 1 or a.minus_ = 1);
      select sum(Taxable),sum(TaxAmt),sum(NetAmt) into Taxable_,TaxAmt_,NetAmt_ from DBA.INTransdtl where SiteID = new.SiteID and Sys = new.Sys;
     
      new.Taxable = Taxable_;
      new.TaxAmt = TaxAmt_;
      new.NetAmt = NetAmt_;
    end if;
  end if; 
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.b4upd_posted_intranshdr() OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 25694)
-- Name: b4upd_printed_intranshdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4upd_printed_intranshdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  if (NEW.printed <> OLD.printed and NEW.string1 = 'Confirm Price' and NEW.posted = 6 and coalesce(NEW.HeaderNote,'') <> '') then
    NEW.string1 = 'Proforma Invoice';
    update dba.pstranshdr set string1 = 'Proforma Invoice' where trno = NEW.orderno;
    update dba.rptranshdr set string1 = 'Proforma Invoice',projectid = 'InvoicePrinted' where trno = NEW.invoiceno; 
  end if;
  RETURN NEW;
END;
$$;


ALTER FUNCTION dba.b4upd_printed_intranshdr() OWNER TO postgres;

--
-- TOC entry 336 (class 1255 OID 26841)
-- Name: b4upd_printed_rptranshdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4upd_printed_rptranshdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 if new.printed = 1 then
    --  update status invoice
    new.projectid = 'InvoiceReceived';
 end if;
 RETURN NEW;  
END;
$$;


ALTER FUNCTION dba.b4upd_printed_rptranshdr() OWNER TO postgres;

--
-- TOC entry 334 (class 1255 OID 26539)
-- Name: b4update_approved_pstranshdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.b4update_approved_pstranshdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare vNextNo integer;
declare vDocNo varchar(15);
declare vSys integer;
BEGIN
 
 if new.approved = 1 and old.approved = 0 then
   if coalesce(new.trmanualref,'') = '' then
     select coalesce(max(NextNo),1) as No_--,replace(str(No_,4),' ','0')
       into vNextNo--,vDocNo
       from dba.PXNumbering where TrType = 'POASN' and SeqSet = to_char(Now(),'yyMMdd');
     vDocNo = right('0000'||vNextNo,4); 
   
     insert into dba.PXNumbering( TrType,SeqSet,NextNo ) values
       ( 'POASN',to_char(Now(),'yyMMdd'),(vNextNo+1) )
       ON CONFLICT (TrType,SeqSet) DO UPDATE SET NextNo =  vNextNo+1;
     new.trmanualref = 'A' || to_char(Now(),'yyMMdd') || vDocNo;
     new.string1 = 'Confirm ASN';
   end if;
   -- insert data b2b notification
   select coalesce(max(sys),0)+1 into vSys from dba.B2BNotification;
   -- sebagai penanda nomor notifikasi
   new.Numeric1 = vSys;
   insert into dba.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
     ( vSys,now(),'PO',new.TrNo,new.SuppID,0,'ConfirmASN' ) ;
   insert into dba.B2BNotificationUsers( Sys,UserID,Opened )
     select vSys,a.UserID,0 from dba.UserLogin as a join dba.LoginSites as b on UserID = b.LoginID
       where a.administrator = 2 and MailNotification = 1 and b.SiteID = new.SiteID;
       --and exists(select 1 from dba.B2BLevelJobTitle as c where a.LastName = c.JobTitle and c.Level_ = 1 and c.Dispute = 0)
 end if;
 RETURN NEW;   
END;
$$;


ALTER FUNCTION dba.b4update_approved_pstranshdr() OWNER TO postgres;

--
-- TOC entry 335 (class 1255 OID 26840)
-- Name: beforeupd_posted_rptranshdr(); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.beforeupd_posted_rptranshdr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  declare iLineNo integer;
  declare vSys integer;
 BEGIN
  if old.Posted <> new.Posted then
    -- insert history status   
    select coalesce(max(LineNo),0)+1 into iLineNo from dba.RPTransHdrRejectLog where SiteID = new.SiteID and Sys = new.Sys;
    insert into dba.RPTransHdrRejectLog( SiteID,Sys,LineNo,EntryTime,DocumentNo,Added_by,ReasonCode,ReasonDesc ) values
      ( new.SiteID,new.Sys,iLineNo,Now(),coalesce(new.FromInvoiceNo,''),new.Changed_by,new.String1,new.Note ) ;
    if new.Void_ = 1 then
      new.ProjectID = 'InvoiceRejected';
      select coalesce(max(sys),0)+1 into vSys from dba.B2BNotification;
      new.COAID = vSys;
      insert into dba.B2BNotification( Sys,SysDate,Module,TrNo,SuppID,SendEmail,Type_ ) values
        ( vSys,now(),'INV',new.TrNo,new.SuppID,0,'Normal' ) ;
      insert into dba.B2BNotificationUsers( Sys,UserID,Opened )
        select vSys,a.UserID,0 from dba.UserLogin as a join dba.RPTrTypeUsers as b on UserID = b.LoginID
          where b.TrType = new.TrType and a.MailNotification = 1;
    end if;
  end if;
 
 RETURN NEW;  
END;
$$;


ALTER FUNCTION dba.beforeupd_posted_rptranshdr() OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 26449)
-- Name: getConfig(character varying, character, character varying, character varying); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba."getConfig"(config_ character varying, scope_ character, scopeid_ character varying, defsetting_ character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare Setting_ varchar(255);
begin
  select setting
    into Setting_ from dba.pxconfig
    where Config = Config_ and Scope = Scope_ and ScopeID = ScopeID_;
  if Setting_ is null or Setting_ = '' then
    set Setting_ = DefSetting_;
  end if;
  return trim(Setting_);
end
$$;


ALTER FUNCTION dba."getConfig"(config_ character varying, scope_ character, scopeid_ character varying, defsetting_ character varying) OWNER TO postgres;

--
-- TOC entry 320 (class 1255 OID 25695)
-- Name: i_createinvoice(character varying, integer, character varying); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.i_createinvoice(site_ character varying, sys_ integer, userid_ character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
  declare ccy1_ char(3);
  declare period_ integer;
  declare xrper_ integer;
  declare curr_ char(3);
  declare tc_ integer;
  declare inno_ varchar(15);
  declare invno_ varchar(15);
  declare project_ varchar(11);
  declare intype_ char(40);
  declare sameno_ smallint;
  declare no_ varchar(15);
  declare taxable_ numeric(19,4);
  declare tax_ numeric(19,4);
  declare net_ numeric(19,4);
  declare round_ numeric(19,4);
  declare rpsys_ integer;
  declare net1_ numeric(19,4);
  declare _pos_ smallint;
  declare topid_ varchar(10);
  declare days_ smallint;
  declare customer varchar(10);
  declare orderno_ varchar(15);
  declare prefix_ varchar(6);
  declare lineno_ integer;
  declare seq_ integer;
  declare trno_ varchar(20);
  declare suppid_ varchar(35);

  BEGIN
  --RETURN 12;
   --RETURN 125;
  select currency1 into ccy1_ from dba.pxsetup where id = 1;
  --RETURN 123;
  select periodid,xrperiod,currencyid,transcode,trno,invoiceno,projectid,trtype,orderno,suppid into period_,xrper_,curr_,tc_,inno_,invno_,
    project_,intype_,orderno_,suppid_ from dba.intranshdr where siteid = site_ and sys = sys_;
  --RETURN 11;
  if coalesce(invno_,'') = '' then
    select coalesce(max(nextno),1) as nextno_,lpad(coalesce(max(nextno),1)::varchar(6), 6, '0') into seq_,prefix_ from dba.pxnumbering where trtype = 'BarInv' and seqset = to_char(date(now()),'YYMMDD');
    --RETURN 111;
    if not exists(select 1 from dba.pxnumbering where trtype = 'BarInv' and seqset = to_char(date(now()),'YYMMDD')) then
      insert into dba.pxnumbering( trtype,seqset,nextno ) values( 'BarInv',to_char(date(now()),'YYMMDD'),(seq_+1));

    else
      update dba.pxnumbering Set nextno = (seq_+1) where trtype = 'BarInv' and seqset = to_char(date(now()),'yymmdd');
    end if;
    --RETURN 1111;
    no_ = dba.pxgetean13(to_char(date(now()),'YYMMDD') || prefix_);
    select sum(taxable),sum(taxamt),sum(netamt) into taxable_,tax_,net_ from dba.intransdtl where siteid = site_ and sys = sys_;
    taxable_ = coalesce(taxable_,0);
    tax_ = coalesce(tax_,0);
    net_ = coalesce(net_,0);
    select max(sys)+1 into rpsys_ from dba.rptranshdr where siteid = site_;
    if rpsys_ is null then rpsys_ = 1;
    end if;
    --raise 'asas %',topid_;
    select top_id into topid_ from dba.apsupplier where suppid = suppid_;
    insert into dba.rptranshdr( siteid,sys,periodid,entityid,xrperiod,trno,trmanualref,trmanualref2,trdate,trtype,transcode,
      custid,suppid,top_days,taxcalc,taxinvoiceno,taxinvoicedate,taxsubmitdate,
      salesrepid,currencyid,taxable,tax,netamt,note,entrytime,
      added_by,changed_by,posted,pmtschno,xrperiodtax,approved,ic_,taxpmt,coaid,custtaxto,
      orderno,top_id,priceid,discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,custsellto,autoinvoice,string1,string2,
      string3,string4,numeric1,projectid,oldsupp,oldsite )
      select siteid,rpsys_,periodid,entityid,xrperiod,no_,trno,shiptonote,date(now()),'INV' || suppid,transcode,
        '',suppid,top_days,taxcalc,taxinvoiceno,taxinvoicedate,null,
        '',currencyid,taxable_,tax_,net_,'',date(now()),
        userid_,'',0,0,xrperiodtax,0,0,0,0,custtaxto,
        orderno,topid_,priceid,discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,custsellto,0,string1,string2,
        string3,string4,numeric1,'InvoiceNew',oldsupp,oldsite from dba.intranshdr where siteid = site_ and sys = sys_;
    update dba.intranshdr set invoiceno = no_ where siteid = site_ and sys = sys_;
    update dba.pstranshdr set string3 = no_ where trno = orderno_;
    insert into dba.rptransdtl (siteid,sys,lineno,transcode,itemid,periodid,qt,unitid,qty,qty2,description,remarks,unitprice,
      taxable,taxamt,netamt,cogsunit,cogsunit2,olditem)
      select siteid,sys,lineno,transcode,itemid,periodid,qt,unitid,qty,qty2,description,remarks,unitprice,
        taxable,taxamt,netamt,cogsunit,cogsunit2,olditem from dba.intransdtl where siteid = site_ and sys = sys_;
    RETURN 1;
  end if;
  RETURN 0;
  END;
$$;


ALTER FUNCTION dba.i_createinvoice(site_ character varying, sys_ integer, userid_ character varying) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 25696)
-- Name: pxgetean13(character); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.pxgetean13(tmpcd character) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
  declare ProdCD char(13);
  declare CDigit char(1);
  declare i integer;
  declare step1 integer;
  declare step2 integer;
  declare sum integer;
  declare factor_ integer;
  BEGIN
    ProdCD = '';
    if length(tmpCD) <> 12 then
      ProdCD = tmpCD;
    else
      i = 12; --(len(tmpCD)
      sum = 0;
      factor_ = 3;
      while i >= 1 loop
        sum = sum+(cast(SUBSTRING(tmpCD,i,1) as integer)*factor_);
        i = i-1;
        factor_ = 4-factor_;
      end loop;
      --CDigit = remainder((1000-sum),10);
      CDigit = (1000-sum) % 10;
      ProdCD = tmpCD || cast(CDigit as char(1));
    end if;
    --return length(tmpCD);  
    return ProdCD;
  END;
$$;


ALTER FUNCTION dba.pxgetean13(tmpcd character) OWNER TO postgres;

--
-- TOC entry 322 (class 1255 OID 26448)
-- Name: setpreserved(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.setpreserved(moduleid_ character varying, userid_ character varying, preserved_ character varying, setting_ character varying, grouped_ character varying) RETURNS TABLE(moduleid character, userid character varying, preserved character varying, setting character varying, grouped character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  if not exists(select 1 from dba.pxpreserved as a where a.moduleid = moduleid_ and a.userid = userid_ and a.preserved = preserved_ and a.grouped = grouped_) then
    insert into dba.pxpreserved( moduleid,userid,preserved,setting,grouped ) values( moduleid_,userid_,preserved_,setting_,grouped_ ); 
  else
    update dba.pxpreserved set setting = setting_ where moduleid = moduleid_ and userid = userid_ and preserved = preserved_ and grouped = grouped_;
  end if;
  RETURN QUERY Select a.moduleid,a.userid,a.preserved,a.setting,a.grouped from dba.pxpreserved as a;
END;
$$;


ALTER FUNCTION dba.setpreserved(moduleid_ character varying, userid_ character varying, preserved_ character varying, setting_ character varying, grouped_ character varying) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 25698)
-- Name: setpreserveddefault(character varying); Type: FUNCTION; Schema: dba; Owner: postgres
--

CREATE FUNCTION dba.setpreserveddefault(userid_ character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  Select dba.setpreserved('EOP',userid_,'Glo:CurrentPeriod','1','Preserved');
  --PERFORM dba.setpreserved('EOP',userid_,'Glo:CurrentSiteID','99999','Preserved');
  --PERFORM dba.setpreserved('EOP',userid_,'Glo:SiteID1','0','Preserved');
  --PERFORM dba.setpreserved('EOP',userid_,'Glo:SiteID2','Z','Preserved');
  --PERFORM dba.setpreserved('EOP',userid_,'Glo:CurrentEntityID','04','Preserved');
  --PERFORM dba.setpreserved('EOP',userid_,'Glo:Entity1','0','Preserved');
  --PERFORM dba.setpreserved('EOP',userid_,'Glo:Entity2','Z','Preserved');
END;
$$;


ALTER FUNCTION dba.setpreserveddefault(userid_ character varying) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 25699)
-- Name: add_city(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_city(moduleid_ character varying, userid_ character varying, preserved_ character varying, setting_ character varying, grouped_ character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
      if not exists(select 1 from dba.pxpreserved where moduleid = moduleid_ and userid = userid_ and preserved = preserved_ and grouped = grouped_) then
		insert into dba.pxpreserved( moduleid,userid,preserved,setting,grouped ) values( moduleid_,userid_,preserved_,setting_,grouped_ );
	  else
		update dba.pxpreserved set setting = setting_ where moduleid = moduleid_ and userid = userid_ and preserved = preserved_ and grouped = grouped_;
      end if;
    END;
    $$;


ALTER FUNCTION public.add_city(moduleid_ character varying, userid_ character varying, preserved_ character varying, setting_ character varying, grouped_ character varying) OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 25700)
-- Name: emp_stampags(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.emp_stampags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        -- Check that empname and salary are given
        --IF NEW.empname IS NULL THEN
           -- RAISE EXCEPTION 'empname cannot be null';
        --END IF;
        --IF NEW.salary IS NULL THEN
            --RAISE EXCEPTION '% cannot have null salary', NEW.empname;
        --END IF;

        -- Who works for us when she must pay for it?
        --IF NEW.salary < 0 THEN
           -- RAISE EXCEPTION '% cannot have a negative salary', NEW.empname;
        --END IF;

        -- Remember who changed the payroll when
        NEW.last_modified := current_timestamp;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.emp_stampags() OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 25701)
-- Name: i_createinvoice(character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.i_createinvoice(site_ character varying, sys_ integer, userid_ character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
  declare ccy1_ char(3);
  declare period_ integer;
  declare xrper_ integer;
  declare curr_ char(3);
  declare tc_ integer;
  declare inno_ varchar(15);
  declare invno_ varchar(15);
  declare project_ varchar(11);
  declare intype_ char(5);
  declare sameno_ smallint;
  declare no_ varchar(15);
  declare taxable_ numeric(19,4);
  declare tax_ numeric(19,4);
  declare net_ numeric(19,4);
  declare round_ numeric(19,4);
  declare rpsys_ integer;
  declare net1_ numeric(19,4);
  declare _pos_ smallint;
  declare topid_ varchar(10);
  declare days_ smallint;
  declare customer varchar(10);
  declare orderno_ varchar(15);
  declare prefix_ varchar(6);
  declare lineno_ integer;
  declare seq_ integer;
  declare trno_ varchar(20);
  declare suppid_ varchar(10);
 
  BEGIN
  select currency1 into ccy1_ from dba.pxsetup where id = 1;
  select periodid,xrperiod,currencyid,transcode,trno,invoiceno,projectid,trtype,orderno,suppid into period_,xrper_,curr_,tc_,inno_,invno_,
    project_,intype_,orderno_,suppid_ from dba.intranshdr where siteid = site_ and sys = sys_;
  if not exists(select 1 from dba.rptransdtl where shipmenttrno = inno_) and invno_ = '' then
    select coalesce(max(nextno),1) as nextno_,replace(str(nextno_,6),' ','0') into seq_,prefix_ from dba.pxnumbering where trtype = 'BarInv' and seqset = to_char(date(now()),'YYMMDD');
    if not exists(select 1 from dba.pxnumbering where trtype = 'BarInv' and seqset = to_char(date(now()),'YYMMDD')) then
      insert into dba.pxnumbering( trtype,seqset,nextno ) values( 'BarInv',to_char(date(now()),'YYMMDD'),(seq_+1));      
    else
      update dba.pxnumbering Set nextno = (seq_+1) where trtype = 'BarInv' and seqset = to_char(date(now()),'yymmdd');
    end if;  
    no_ = dba.pxgetean13(to_char(date(now()),'YYMMDD') || prefix_);
    select sum(taxable),sum(taxamt),sum(netamt) into taxable_,tax_,net_ from dba.intransdtl where siteid = site_ and sys = sys_;
    taxable_ = coalesce(taxable_,0);
    tax_ = coalesce(tax_,0);
    net_ = coalesce(net_,0);
    select max(sys)+1 into rpsys_ from dba.rptranshdr where siteid = site_;
    if rpsys_ is null then rpsys_ = 1;
    end if;
    select top_id into topid_ from dba.apsupplier where suppid = suppid_;
    insert into dba.rptranshdr( siteid,sys,periodid,entityid,xrperiod,trno,trmanualref,trmanualref2,trdate,trtype,transcode,
      custid,suppid,top_days,taxcalc,taxinvoiceno,taxinvoicedate,taxsubmitdate,
      salesrepid,currencyid,taxable,tax,netamt,note,entrytime,
      added_by,changed_by,posted,pmtschno,xrperiodtax,approved,ic_,taxpmt,coaid,custtaxto,
      orderno,top_id,priceid,discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,custsellto,autoinvoice,string1,string2,
      string3,string4,numeric1,projectid ) 
      select siteid,rpsys_,periodid,entityid,xrperiod,no_,trno,shiptonote,date(now()),'INV' || suppid,transcode,
        '',suppid,top_days,taxcalc,taxinvoiceno,taxinvoicedate,null,
        '',currencyid,taxable_,tax_,net_,'',date(now()),
        userid_,'',0,0,xrperiodtax,0,0,0,0,custtaxto,
        orderno,topid_,priceid,discpct_,discpct,discpct2,discpct3,discpct4,discpct5,discamt,custsellto,0,string1,string2,
        string3,string4,numeric1,'InvoiceNew' from dba.intranshdr where siteid = site_ and sys = sys_;  
  
    update dba.intranshdr set invoiceno = no_ where siteid = site_ and sys = sys_;
    update dba.pstranshdr set string3 = no_ where trno = orderno_;
  end if;
  RETURN 1;
  END;
$$;


ALTER FUNCTION public.i_createinvoice(site_ character varying, sys_ integer, userid_ character varying) OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 25702)
-- Name: increment(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment(i integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
        BEGIN
                RETURN i + 1;
        END;
$$;


ALTER FUNCTION public.increment(i integer) OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 25703)
-- Name: pxgetean13(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pxgetean13(tmpcd character) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
  declare ProdCD char(13);
  declare CDigit char(1);
  declare i integer;
  declare step1 integer;
  declare step2 integer;
  declare sum integer;
  declare factor_ integer;
  BEGIN
    ProdCD = '';
    if len(tmpCD) <> 12 then
      ProdCD = tmpCD;
    else
      i = 12; --(len(tmpCD)
      sum = 0;
      factor_ = 3;
      while i >= 1 loop
        sum = sum+(cast(SUBSTRING(tmpCD,i,1) as integer)*factor_);
        i = i-1;
        factor_ = 4-factor_;
      end loop;
      CDigit = remainder((1000-sum),10);
      ProdCD = tmpCD+cast(CDigit as char(1));
    end if;
    return ProdCD;
  END;
$$;


ALTER FUNCTION public.pxgetean13(tmpcd character) OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 25704)
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.last_modified = now();
    RETURN NEW;	
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 188 (class 1259 OID 25705)
-- Name: apsupplier; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.c_password_reset_token (
    id character varying(255) NOT NULL,
    expiry_date timestamp without time zone,
    token character varying(255) NOT NULL,
    id_user character varying(255) NOT NULL
);

CREATE TABLE dba.c_security_permission (
    id character varying(255) NOT NULL,
    permission_label character varying(255) NOT NULL,
    permission_value character varying(255) NOT NULL
);

CREATE TABLE dba.c_security_role (
    id character varying(255) NOT NULL,
    description character varying(255),
    name character varying(255) NOT NULL
);

CREATE TABLE dba.c_security_role_permission (
    id_role character varying(255) NOT NULL,
    id_permission character varying(255) NOT NULL
);

CREATE TABLE dba.c_security_user (
    id character varying(255) NOT NULL,
    active boolean NOT NULL,
    user_name character varying(255) NOT NULL,
    id_role character varying(255) NOT NULL
);

CREATE TABLE dba.c_security_user_password (
    id_user character varying(36) NOT NULL,
    password character varying(255) NOT NULL
);

CREATE TABLE dba.apsupplier (
    suppid character varying(35) NOT NULL,
    suppname character varying(100),
    address character varying(200),
    postcode character varying(10),
    phones character varying(25),
    telex character varying(25),
    fax character varying(25),
    email character varying(100),
    taxid character varying(25),
    taxdescription1 character varying(50),
    taxdescription2 character varying(50),
    taxname character varying(100),
    taxaddress character varying(200),
    city character varying(50),
    state character varying(50),
    countryid character(2),
    affiliate_ smallint DEFAULT 0,
    gl_groupid character varying(10),
    parentid character varying(10),
    blockreceive_ smallint DEFAULT 0,
    blockap_ smallint DEFAULT 0,
    blockpurchase_ smallint DEFAULT 0,
    dispatchid character varying(10),
    forwarderid character varying(10),
    areaid character varying(10),
    contact_sales character varying(40),
    contact_acc character varying(40),
    our_id character varying(50),
    pricegroupid character varying(10),
    currencyid character(3),
    groupa_id character varying(35),
    groupb_id integer,
    groupc_id integer,
    groupd_id integer,
    top_id character varying(10),
    deliverymtdid character varying(10),
    formsetid character varying(10),
    suppstatus smallint DEFAULT 0,
    creditstatus smallint DEFAULT 1,
    collectorid character varying(10),
    creditlimit numeric(19,4),
    warehouseid character varying(10),
    registerdate date,
    lasttransdate date,
    ignorecl_ smallint,
    consideroverduedays_ smallint DEFAULT 0,
    creditdays smallint DEFAULT 0,
    invtaxcode character varying(2),
    usexmlreport smallint DEFAULT 0,
    sendporeport smallint DEFAULT 0,
    ftpaddress character varying(30),
    ftpuser character varying(30),
    ftppassword character varying(30),
    email2 character varying(100),
    gln character varying(15),
    servicelevel character varying(3),
    servicelevelgroup character varying(4),
    serviceleveltime character varying(4),
    consignment character(1),
    last_modified timestamp without time zone,
    old_id character varying(15),
    entityid character varying(10),
    siteid character varying(20) DEFAULT ''::character varying
);


ALTER TABLE dba.apsupplier OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 25721)
-- Name: apsupplierbank; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.apsupplierbank (
    suppid character varying(35) NOT NULL,
    no smallint NOT NULL,
    currencyid character(3),
    bankname character varying(50),
    bankaddress character varying(100),
    accountno character varying(50),
    accountholder character varying(50),
    remarks character varying(50)
);


ALTER TABLE dba.apsupplierbank OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 25724)
-- Name: apsupplierdoc; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.apsupplierdoc (
    suppid character varying(15) NOT NULL,
    code character varying(4) NOT NULL,
    document character varying(30),
    outputtype character(2) NOT NULL,
    output character varying(30),
    address character varying(100)
);


ALTER TABLE dba.apsupplierdoc OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 25727)
-- Name: apsuppliergroupa; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.apsuppliergroupa (
    groupa_id character varying(35) NOT NULL,
    description character varying(40),
    segment01 character varying(10),
    segment02 character varying(10),
    segment03 character varying(10),
    segment04 character varying(10),
    segment05 character varying(10),
    entityid character varying(10)
);


ALTER TABLE dba.apsuppliergroupa OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 25730)
-- Name: apsupplieritem; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.apsupplieritem (
    suppid character varying(35) NOT NULL,
    itemid character varying(30) NOT NULL,
    unitid character(5),
    factor numeric(14,7),
    economicorderqty numeric(19,4),
    last_modified timestamp without time zone,
    oribuyprice numeric(19,4),
    disca numeric(19,4),
    discb numeric(19,4),
    discc numeric(19,4),
    currentbuyprice numeric(19,4)
);


ALTER TABLE dba.apsupplieritem OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 25733)
-- Name: apsuppliervat; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.apsuppliervat (
    suppid character varying(15) NOT NULL,
    vat_year integer NOT NULL,
    vat_seq integer NOT NULL,
    vat_status character(1) NOT NULL,
    vat_from numeric(14,0),
    vat_to numeric(14,0),
    vat_date date
);


ALTER TABLE dba.apsuppliervat OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 25736)
-- Name: apsupplierwhse; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.apsupplierwhse (
    suppid character varying(15) NOT NULL,
    whse character varying(4) NOT NULL,
    leadtime integer,
    reorder_w1_1 smallint DEFAULT 0 NOT NULL,
    reorder_w1_2 smallint DEFAULT 0 NOT NULL,
    reorder_w1_3 smallint DEFAULT 0 NOT NULL,
    reorder_w1_4 smallint DEFAULT 0 NOT NULL,
    reorder_w1_5 smallint DEFAULT 0 NOT NULL,
    reorder_w1_6 smallint DEFAULT 0 NOT NULL,
    reorder_w1_7 smallint DEFAULT 0 NOT NULL,
    reorder_w2_1 smallint DEFAULT 0 NOT NULL,
    reorder_w2_2 smallint DEFAULT 0 NOT NULL,
    reorder_w2_3 smallint DEFAULT 0 NOT NULL,
    reorder_w2_4 smallint DEFAULT 0 NOT NULL,
    reorder_w2_5 smallint DEFAULT 0 NOT NULL,
    reorder_w2_6 smallint DEFAULT 0 NOT NULL,
    reorder_w2_7 smallint DEFAULT 0 NOT NULL,
    reorder_w3_1 smallint DEFAULT 0 NOT NULL,
    reorder_w3_2 smallint DEFAULT 0 NOT NULL,
    reorder_w3_3 smallint DEFAULT 0 NOT NULL,
    reorder_w3_4 smallint DEFAULT 0 NOT NULL,
    reorder_w3_5 smallint DEFAULT 0 NOT NULL,
    reorder_w3_6 smallint DEFAULT 0 NOT NULL,
    reorder_w3_7 smallint DEFAULT 0 NOT NULL,
    reorder_w4_1 smallint DEFAULT 0 NOT NULL,
    reorder_w4_2 smallint DEFAULT 0 NOT NULL,
    reorder_w4_3 smallint DEFAULT 0 NOT NULL,
    reorder_w4_4 smallint DEFAULT 0 NOT NULL,
    reorder_w4_5 smallint DEFAULT 0 NOT NULL,
    reorder_w4_6 smallint DEFAULT 0 NOT NULL,
    reorder_w4_7 smallint DEFAULT 0 NOT NULL
);


ALTER TABLE dba.apsupplierwhse OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 25767)
-- Name: arcustomer; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.arcustomer (
    custid character varying(10) NOT NULL,
    custname character varying(200),
    sub_group character varying(3) NOT NULL,
    code character varying(20) NOT NULL,
    description character varying(30) NOT NULL
);


ALTER TABLE dba.arcustomer OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 25770)
-- Name: b2b_logincounter; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2b_logincounter (
    logindate date NOT NULL,
    usercount integer DEFAULT 0
);


ALTER TABLE dba.b2b_logincounter OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 25774)
-- Name: b2b_loginlog; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2b_loginlog (
    userid character varying(50) NOT NULL,
    logintime timestamp without time zone NOT NULL
);


ALTER TABLE dba.b2b_loginlog OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 25777)
-- Name: b2bdeductiondetail; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bdeductiondetail (
    deal_id character varying(10) NOT NULL,
    soorderno character varying(10) NOT NULL,
    siteid character varying(25),
    poorderno integer NOT NULL,
    grdate date,
    gramount numeric(19,4),
    vat numeric(19,4),
    netamount numeric(19,4)
);


ALTER TABLE dba.b2bdeductiondetail OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 25780)
-- Name: b2bempmarketsharevscat; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bempmarketsharevscat (
    sys integer NOT NULL,
    categoryid character varying(4) NOT NULL,
    description character varying(30),
    classid character varying(4) NOT NULL,
    classdesc character varying(30),
    groupdesc character varying(30),
    itemid character varying(30) NOT NULL,
    itemdesc character varying(250),
    channelid character varying(4) NOT NULL,
    channel character varying(20),
    year integer NOT NULL,
    month integer NOT NULL,
    sales numeric(19,4),
    marketshare numeric(19,4),
    salesclass numeric(19,4)
);


ALTER TABLE dba.b2bempmarketsharevscat OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 25783)
-- Name: b2bempmarketsharevscat_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bempmarketsharevscat_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bempmarketsharevscat_sys_seq OWNER TO postgres;

--
-- TOC entry 3176 (class 0 OID 0)
-- Dependencies: 200
-- Name: b2bempmarketsharevscat_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bempmarketsharevscat_sys_seq OWNED BY dba.b2bempmarketsharevscat.sys;


--
-- TOC entry 201 (class 1259 OID 25785)
-- Name: b2bemppromoperformance; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bemppromoperformance (
    sys integer NOT NULL,
    catalogcode character varying(5) NOT NULL,
    description character varying(30),
    type_ character varying(2) NOT NULL,
    typedesc character varying(30),
    year integer NOT NULL,
    startdate date NOT NULL,
    enddate date NOT NULL,
    itemid character varying(30) NOT NULL,
    itemdesc character varying(250),
    qty numeric(19,4),
    qtysold numeric(19,4)
);


ALTER TABLE dba.b2bemppromoperformance OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 25788)
-- Name: b2bemppromoperformance_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bemppromoperformance_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bemppromoperformance_sys_seq OWNER TO postgres;

--
-- TOC entry 3177 (class 0 OID 0)
-- Dependencies: 202
-- Name: b2bemppromoperformance_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bemppromoperformance_sys_seq OWNED BY dba.b2bemppromoperformance.sys;


--
-- TOC entry 203 (class 1259 OID 25790)
-- Name: b2bempsalescontribvscat; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bempsalescontribvscat (
    sys integer NOT NULL,
    classid character varying(4) NOT NULL,
    description character varying(30),
    groupid character varying(4) NOT NULL,
    groupdesc character varying(30),
    itemid character varying(30) NOT NULL,
    itemdesc character varying(250),
    year integer NOT NULL,
    month integer NOT NULL,
    sales numeric(19,4),
    salescontrib numeric(19,4),
    salesgroup numeric(19,4)
);


ALTER TABLE dba.b2bempsalescontribvscat OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 25793)
-- Name: b2bempsalescontribvscat_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bempsalescontribvscat_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bempsalescontribvscat_sys_seq OWNER TO postgres;

--
-- TOC entry 3178 (class 0 OID 0)
-- Dependencies: 204
-- Name: b2bempsalescontribvscat_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bempsalescontribvscat_sys_seq OWNED BY dba.b2bempsalescontribvscat.sys;


--
-- TOC entry 205 (class 1259 OID 25795)
-- Name: b2bempsalesitembystore; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bempsalesitembystore (
    sys integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    siteid character varying(10) NOT NULL,
    itemid character varying(30) NOT NULL,
    qty numeric(19,4)
);


ALTER TABLE dba.b2bempsalesitembystore OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 25798)
-- Name: b2bempsalesitembystore_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bempsalesitembystore_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bempsalesitembystore_sys_seq OWNER TO postgres;

--
-- TOC entry 3179 (class 0 OID 0)
-- Dependencies: 206
-- Name: b2bempsalesitembystore_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bempsalesitembystore_sys_seq OWNED BY dba.b2bempsalesitembystore.sys;


--
-- TOC entry 207 (class 1259 OID 25800)
-- Name: b2bempservicelevel; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bempservicelevel (
    sys integer NOT NULL,
    suppid character varying(15),
    suppname character varying(100),
    year integer,
    month integer,
    orderno character varying(15) NOT NULL,
    caseorder numeric(19,4),
    lineorder numeric(19,4),
    ontimedelivery numeric(19,4),
    totalservicelevel numeric(19,4),
    orderdate timestamp without time zone
);


ALTER TABLE dba.b2bempservicelevel OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 25803)
-- Name: b2bempservicelevel_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bempservicelevel_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bempservicelevel_sys_seq OWNER TO postgres;

--
-- TOC entry 3180 (class 0 OID 0)
-- Dependencies: 208
-- Name: b2bempservicelevel_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bempservicelevel_sys_seq OWNED BY dba.b2bempservicelevel.sys;


--
-- TOC entry 209 (class 1259 OID 25805)
-- Name: b2bempservicelevelcontribvscat; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bempservicelevelcontribvscat (
    sys integer NOT NULL,
    suppid character varying(15) NOT NULL,
    suppname character varying(100),
    year integer NOT NULL,
    month integer NOT NULL,
    categoryitem character varying(10) NOT NULL,
    catdesc character varying(30),
    caseorder numeric(19,4),
    lineorder numeric(19,4),
    ontimedelivery numeric(19,4),
    totalservicelevel numeric(19,4),
    rank numeric(19,4),
    totalorder integer
);


ALTER TABLE dba.b2bempservicelevelcontribvscat OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 25808)
-- Name: b2bempservicelevelcontribvscat_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bempservicelevelcontribvscat_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bempservicelevelcontribvscat_sys_seq OWNER TO postgres;

--
-- TOC entry 3181 (class 0 OID 0)
-- Dependencies: 210
-- Name: b2bempservicelevelcontribvscat_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bempservicelevelcontribvscat_sys_seq OWNED BY dba.b2bempservicelevelcontribvscat.sys;


--
-- TOC entry 211 (class 1259 OID 25810)
-- Name: b2bempstockbalance; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bempstockbalance (
    sys integer NOT NULL,
    siteid character varying(20) NOT NULL,
    itemid character varying(30) NOT NULL,
    qtyonhand numeric(19,4),
    unitid character varying(10)
);


ALTER TABLE dba.b2bempstockbalance OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 25813)
-- Name: b2bempstockbalance_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bempstockbalance_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bempstockbalance_sys_seq OWNER TO postgres;

--
-- TOC entry 3182 (class 0 OID 0)
-- Dependencies: 212
-- Name: b2bempstockbalance_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bempstockbalance_sys_seq OWNED BY dba.b2bempstockbalance.sys;


--
-- TOC entry 213 (class 1259 OID 25815)
-- Name: b2bjobtitle; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bjobtitle (
    jobtitle character varying(100) NOT NULL,
    remarks character varying(255)
);


ALTER TABLE dba.b2bjobtitle OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 25818)
-- Name: b2bleveljobtitle; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bleveljobtitle (
    level_ smallint NOT NULL,
    dispute smallint NOT NULL,
    jobtitle character varying(100) NOT NULL,
    count_ integer DEFAULT 999 NOT NULL,
    days_ integer DEFAULT 1 NOT NULL
);


ALTER TABLE dba.b2bleveljobtitle OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25823)
-- Name: b2bnotification; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bnotification (
    sys integer NOT NULL,
    sysdate timestamp without time zone NOT NULL,
    module character varying(10) NOT NULL,
    trno character varying(30) NOT NULL,
    suppid character varying(35) NOT NULL,
    sendemail smallint NOT NULL,
    type_ character varying(10) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE dba.b2bnotification OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25827)
-- Name: b2bnotificationusers; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bnotificationusers (
    sys integer NOT NULL,
    userid character varying(50) NOT NULL,
    opened smallint NOT NULL
);


ALTER TABLE dba.b2bnotificationusers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25830)
-- Name: b2breason; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2breason (
    reasoncode character varying(10) NOT NULL,
    description character varying(100) NOT NULL,
    approve smallint DEFAULT 0 NOT NULL
);


ALTER TABLE dba.b2breason OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25834)
-- Name: b2bstatisticprocess; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bstatisticprocess (
    sys integer NOT NULL,
    config character varying(100),
    setting character varying(100)
);


ALTER TABLE dba.b2bstatisticprocess OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25837)
-- Name: b2bstatisticprocess_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.b2bstatisticprocess_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.b2bstatisticprocess_sys_seq OWNER TO postgres;

--
-- TOC entry 3183 (class 0 OID 0)
-- Dependencies: 219
-- Name: b2bstatisticprocess_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.b2bstatisticprocess_sys_seq OWNED BY dba.b2bstatisticprocess.sys;


--
-- TOC entry 220 (class 1259 OID 25839)
-- Name: b2bsuppliertypedtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2bsuppliertypedtl (
    suppliertype character varying(10) NOT NULL,
    jobtitle character varying(100) NOT NULL
);


ALTER TABLE dba.b2bsuppliertypedtl OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25842)
-- Name: b2btrainingregistration; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.b2btrainingregistration (
    vendorid character varying(20) NOT NULL,
    vendorname character varying(100) NOT NULL,
    officephone character varying(20),
    officefax character varying(20) NOT NULL,
    contact character varying(50) NOT NULL,
    email character varying(50),
    mobileno character varying(20),
    contact2 character varying(50),
    email2 character varying(50),
    mobileno2 character varying(20),
    expecteddate1 date,
    sessionid smallint,
    note character varying(500),
    registerdate timestamp without time zone DEFAULT now(),
    registerno character varying(50),
    linestatus smallint DEFAULT 0,
    sendemail smallint DEFAULT 0
);


ALTER TABLE dba.b2btrainingregistration OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25851)
-- Name: i_importtablehist; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.i_importtablehist (
    sys integer NOT NULL,
    event_ character(2) NOT NULL,
    start_ timestamp without time zone,
    finish_ timestamp without time zone
);


ALTER TABLE dba.i_importtablehist OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25854)
-- Name: i_importtablelog; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.i_importtablelog (
    sys integer NOT NULL,
    tablename character varying(100),
    lastdate date,
    lasttime time without time zone
);


ALTER TABLE dba.i_importtablelog OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25857)
-- Name: inabcclass; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.inabcclass (
    classid character varying(10) NOT NULL,
    description character varying(30),
    percentage numeric(19,4),
    count_interval integer
);


ALTER TABLE dba.inabcclass OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25860)
-- Name: infkategori; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.infkategori (
    infkategoriid character varying(10) NOT NULL,
    kategori character varying(50),
    status character(5),
    type character(2),
    seq character(3)
);


ALTER TABLE dba.infkategori OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25863)
-- Name: infkategoridtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.infkategoridtl (
    infkategoridid integer NOT NULL,
    infkategoriid character varying(10),
    createdate date,
    createby character varying(30),
    filename character varying(255),
    destinationfile character varying(280),
    status character(5),
    htmlfile character varying(32000),
    enddate date DEFAULT ('now'::text)::date
);


ALTER TABLE dba.infkategoridtl OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25870)
-- Name: initem; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.initem (
    itemid character varying(30) NOT NULL,
    old_id character varying(30),
    description character varying(250),
    cust_itemid character varying(30),
    cust_desc character varying(50),
    supp_itemid character varying(30),
    supp_desc character varying(50),
    unitsetid character varying(10),
    inventory_unit character varying(10),
    unit2 character varying(10),
    storage_unit character varying(10),
    purchase_unit character varying(10),
    purchase_price numeric(19,4),
    purchase_ccy character(3),
    sales_unit character varying(10),
    sales_price numeric(19,4),
    sales_ccy character(3),
    itemtype smallint DEFAULT 0,
    lot_ smallint DEFAULT 0 NOT NULL,
    itemgroupid integer DEFAULT 0,
    itemcategoryid integer DEFAULT 0,
    itembrandid integer DEFAULT 0,
    itemmodelid integer DEFAULT 0,
    classid character varying(10),
    gl_groupid character varying(10),
    tax_groupid character varying(10),
    size_ character varying(25),
    color character varying(25),
    material character varying(25),
    motif character varying(25),
    weight double precision,
    weight_unit character varying(10),
    length_ double precision,
    width_ double precision,
    height double precision,
    dim_unit character varying(10),
    vol_ smallint DEFAULT 0 NOT NULL,
    volume double precision,
    volume_unit character varying(10),
    valuemtd character(4),
    remarks character varying(1000),
    lasttransdate date,
    lasttranscode smallint,
    std_cost numeric(19,4),
    inspect_ smallint,
    weightingfactor double precision,
    reorderpoint double precision,
    minstockqty double precision,
    minorderqty double precision,
    dateexpired date,
    barcode character varying(30),
    prioritysuppid character varying(30),
    leadtimedays smallint DEFAULT 0 NOT NULL,
    supply_ smallint,
    master_ smallint,
    fence double precision,
    orderhorz integer,
    planhorz integer,
    planmethod smallint,
    maxqty double precision,
    safetyqty double precision,
    fixedorderqty double precision,
    production_unit character(5),
    blocked smallint,
    obsolete smallint,
    sqttolerance numeric(19,4),
    pqttolerance numeric(19,4),
    protectstdcost_ smallint DEFAULT 0,
    sminqttol numeric(19,4) DEFAULT 0,
    pminqttol numeric(19,4) DEFAULT 0,
    updatelastpurchaseprice_ smallint DEFAULT 0,
    useqty2calc_ smallint DEFAULT 0 NOT NULL,
    internalprocess integer DEFAULT 0,
    backflush smallint DEFAULT 0,
    qtyordermultiply numeric(19,4) DEFAULT 0,
    maxorderqty double precision DEFAULT 0,
    deflocid character varying(10),
    basecomp1 integer,
    basecomp2 integer,
    basecomp3 integer,
    basecomp4 integer,
    entityid character varying(10),
    siteid character varying(20)
);


ALTER TABLE dba.initem OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25893)
-- Name: initemgroup; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.initemgroup (
    itemgroupid integer NOT NULL,
    description character varying(25),
    segment01 character varying(10),
    segment02 character varying(10),
    segment03 character varying(10),
    segment04 character varying(10),
    segment05 character varying(10)
);


ALTER TABLE dba.initemgroup OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25896)
-- Name: initemmaterial; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.initemmaterial (
    id character(10) NOT NULL,
    description character(40)
);


ALTER TABLE dba.initemmaterial OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25899)
-- Name: initemstop; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.initemstop (
    itemid character varying(30) NOT NULL,
    startdate date NOT NULL,
    enddate date NOT NULL,
    reasoncode character varying(4),
    updateby character varying(30),
    date_time timestamp without time zone
);


ALTER TABLE dba.initemstop OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25902)
-- Name: intransdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.intransdtl (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    transcode smallint,
    itemid character varying(30),
    periodid integer,
    locationid character varying(10),
    locationid2 character varying(10),
    projectid character varying(10),
    qt numeric(19,4) DEFAULT 0 NOT NULL,
    unitid character(10),
    qty numeric(19,4) DEFAULT 0 NOT NULL,
    qty2 numeric(19,4) DEFAULT 0,
    description character varying(1000),
    remarks character varying(60),
    length_ numeric(19,4),
    width_ numeric(19,4),
    height numeric(19,4),
    diameter numeric(19,4),
    unitprice numeric(19,4) DEFAULT 0,
    discpct numeric(7,4),
    grossamt numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    rounding numeric(19,4) DEFAULT 0,
    netamt numeric(19,4) DEFAULT 0,
    qty_inv numeric(19,4) DEFAULT 0,
    qty2_inv numeric(19,4) DEFAULT 0,
    orderno character varying(20),
    orderlineno integer,
    invoiceno character varying(20),
    discpct2 numeric(19,4),
    discpct3 numeric(19,4),
    discpct4 numeric(19,4),
    discpct5 numeric(19,4),
    discpct_ smallint DEFAULT 0 NOT NULL,
    invdiscamt numeric(19,4) DEFAULT 0,
    cogsunit numeric(19,4) DEFAULT 0,
    cogsunit2 numeric(19,4) DEFAULT 0,
    newlot_ smallint DEFAULT 0 NOT NULL,
    linetype character(1),
    minus_ smallint DEFAULT 0 NOT NULL,
    string1 character varying(500),
    numeric1 double precision,
    barcode character varying(30),
    shippingunit character(5),
    shippingqty numeric(19,4),
    qtyused numeric(19,4),
    qtysetup numeric(19,4),
    trailertype smallint DEFAULT 0,
    reserveid character varying(500),
    reasonid integer,
    rotno character varying(500),
    rotlineno integer,
    giftlineno integer,
    bonus_ smallint,
    giftid character varying(10),
    fa_no character varying(15),
    string2 character varying(80) DEFAULT ''::character varying,
    olditem character varying(30)
);


ALTER TABLE dba.intransdtl OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25928)
-- Name: intransdtllogdispute; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.intransdtllogdispute (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    counter integer NOT NULL,
    lineno integer NOT NULL,
    entrytime timestamp without time zone DEFAULT now(),
    itemid character varying(30),
    dispute smallint DEFAULT 0 NOT NULL,
    qty numeric(19,4) DEFAULT 0 NOT NULL,
    qty2 numeric(19,4) DEFAULT 0,
    comment1 character varying(500),
    unitprice numeric(19,4) DEFAULT 0,
    unitprice2 numeric(19,4) DEFAULT 0,
    comment2 character varying(500),
    linetype character(1),
    reasondisqty character varying(500),
    reasondisprice character varying(500),
    loginid character varying(100),
    updatetime timestamp without time zone,
    changedby character varying(100)
);


ALTER TABLE dba.intransdtllogdispute OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 25940)
-- Name: intranshdr; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.intranshdr (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    periodid integer,
    entityid character varying(10),
    xrperiod integer,
    trno character varying(20),
    trmanualref character varying(25),
    trmanualref2 character varying(25),
    trdate date,
    trtime time without time zone,
    trtype character varying(35),
    transcode smallint,
    expected_dlv date,
    expected_arv date,
    suppid character varying(35),
    custbillto character varying(10),
    custsellto character varying(10),
    custshipto character varying(10),
    custtaxto character varying(10),
    top_id character varying(10),
    top_days smallint,
    taxcalc character(1),
    taxinvoiceno character varying(25),
    taxinvoicedate date,
    taxsubmitdate date,
    salesrepid character varying(10),
    dlvmtdid character varying(15),
    shiptonote character varying(15),
    headernote character varying(100),
    footernote character varying(150),
    entrytime timestamp without time zone DEFAULT now(),
    added_by character varying(100),
    changed_by character varying(100),
    approved smallint DEFAULT 0 NOT NULL,
    xrperiodtax integer,
    currencyid character(3),
    posted smallint DEFAULT 0 NOT NULL,
    priceid character varying(10),
    discpct_ smallint DEFAULT 0 NOT NULL,
    discpct numeric(7,4),
    discpct2 numeric(7,4),
    discpct3 numeric(7,4),
    discpct4 numeric(7,4),
    discpct5 numeric(7,4),
    discamt numeric(19,4),
    countercoaid integer DEFAULT 0,
    locationid character varying(10),
    locationid2 character varying(10),
    manualcalc_ smallint DEFAULT 0 NOT NULL,
    invoiceno character varying(20),
    orderno character varying(50),
    projectid character varying(10),
    printed smallint DEFAULT 0 NOT NULL,
    void_ smallint DEFAULT 0 NOT NULL,
    string1 character varying(80),
    string2 character varying(80),
    string3 character varying(200),
    string4 character varying(80),
    numeric1 double precision,
    invdiscchanged smallint DEFAULT 0,
    netamt numeric(19,4),
    controltotal numeric(19,4),
    useplcomp smallint DEFAULT 0,
    useplreceipt smallint DEFAULT 0,
    priceidreceipt character varying(10),
    top_id2 character varying(10),
    listid character varying(10),
    mf smallint DEFAULT 0,
    mfret smallint DEFAULT 0,
    pos_ smallint DEFAULT 0,
    pos_stationid character varying(10),
    pos_shiftid integer,
    pos_cashierid character varying(10),
    ro_ smallint DEFAULT 0,
    uniquetaxno character varying(65),
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    taxablesupp numeric(19,4) DEFAULT 0 NOT NULL,
    taxamtsupp numeric(19,4) DEFAULT 0 NOT NULL,
    oldsupp character varying(10),
    oldsite character varying(20)
);


ALTER TABLE dba.intranshdr OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25965)
-- Name: intranshdrupload; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.intranshdrupload (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    entrytime timestamp without time zone DEFAULT now(),
    dispute smallint DEFAULT 0,
    filename character varying(100) NOT NULL,
    comment_ character varying(255),
    loginid character varying(100)
);


ALTER TABLE dba.intranshdrupload OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25970)
-- Name: intranstaxdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.intranstaxdtl (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    typeid character varying(10) NOT NULL,
    taxamt numeric(19,4),
    taxrate numeric(19,4) DEFAULT 0,
    numeric1 double precision
);


ALTER TABLE dba.intranstaxdtl OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 25974)
-- Name: loginsites; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.loginsites (
    loginid character varying(255) NOT NULL,
    siteid character varying(20) NOT NULL,
    default_ integer NOT NULL
);


ALTER TABLE dba.loginsites OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 25977)
-- Name: pstransdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pstransdtl (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    transcode smallint,
    itemid character varying(30),
    periodid integer,
    locationid character varying(10),
    locationid2 character varying(10),
    projectid character varying(10),
    qt numeric(19,4) DEFAULT 0 NOT NULL,
    unitid character(10),
    qty numeric(19,4) DEFAULT 0 NOT NULL,
    qty2 numeric(19,4) DEFAULT 0,
    description character varying(1000),
    remarks character varying(60),
    length_ numeric(19,4),
    width_ numeric(19,4),
    height numeric(19,4),
    diameter numeric(19,4),
    unitprice numeric(19,4) DEFAULT 0,
    discpct numeric(19,4),
    grossamt numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    rounding numeric(19,4) DEFAULT 0,
    netamt numeric(19,4) DEFAULT 0,
    linklineno integer,
    invoiceno character varying(15),
    discpct2 numeric(19,4),
    discpct3 numeric(19,4),
    discpct4 numeric(19,4),
    discpct5 numeric(19,4),
    discpct_ smallint DEFAULT 0 NOT NULL,
    wo_ smallint DEFAULT 0 NOT NULL,
    invdiscamt numeric(19,4) DEFAULT 0,
    linetype character(1),
    salesrepid character varying(10),
    string1 character varying(80),
    numeric1 double precision,
    barcode character varying(30),
    prunitprice numeric(19,4),
    orderno character varying(20),
    orderlineno smallint DEFAULT 0,
    po_ smallint DEFAULT 0,
    giftlineno integer,
    bonus_ smallint,
    giftid character varying(20),
    linkno character varying(30),
    olditem character varying(30)
);


ALTER TABLE dba.pstransdtl OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25998)
-- Name: pstransdtl_lineno_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.pstransdtl_lineno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.pstransdtl_lineno_seq OWNER TO postgres;

--
-- TOC entry 3184 (class 0 OID 0)
-- Dependencies: 238
-- Name: pstransdtl_lineno_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.pstransdtl_lineno_seq OWNED BY dba.pstransdtl.lineno;


--
-- TOC entry 239 (class 1259 OID 26000)
-- Name: pstranshdr; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pstranshdr (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    periodid integer,
    entityid character varying(10),
    xrperiod integer,
    trno character varying(20),
    trmanualref character varying(25),
    trmanualref2 character varying(25),
    trdate date,
    trtime time without time zone,
    trtype character varying(35),
    transcode smallint,
    expected_dlv date,
    expected_arv date,
    custbillto character varying(10),
    custsellto character varying(10),
    custshipto character varying(10),
    custtaxto character varying(10),
    top_id character varying(10),
    top_days smallint,
    taxcalc character(1),
    salesrepid character varying(10),
    dlvmtdid character varying(15),
    headernote character varying(500),
    footernote character varying(500),
    entrytime timestamp without time zone DEFAULT now(),
    added_by character varying(100),
    changed_by character varying(100),
    approved smallint DEFAULT 0 NOT NULL,
    currencyid character(3),
    suppid character varying(35),
    ps_ character(1),
    priceid character varying(10),
    discpct_ smallint DEFAULT 0 NOT NULL,
    discpct numeric(19,4) DEFAULT 0,
    discpct2 numeric(19,4) DEFAULT 0,
    discpct3 numeric(19,4) DEFAULT 0,
    discpct4 numeric(19,4) DEFAULT 0,
    discpct5 numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    projectid character varying(11),
    printed smallint DEFAULT 0 NOT NULL,
    void_ smallint DEFAULT 0 NOT NULL,
    string1 character varying(80),
    string2 character varying(80),
    string3 character varying(80),
    string4 character varying(80),
    numeric1 double precision,
    invdiscchanged smallint DEFAULT 0,
    netamt numeric(19,4),
    controltotal numeric(19,4),
    ordertositeid character varying(10),
    intransitlocid character varying(30),
    destinationlocid character varying(10),
    orderno character varying(20),
    pdf_file character varying(200),
    xml_file character varying(200),
    faxstatus smallint DEFAULT 0,
    ftpstatus smallint DEFAULT 0,
    emailstatus smallint DEFAULT 0,
    supplydate date,
    faxno character varying(15),
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    expected_arvtime time without time zone,
    oldsupp character varying(10),
    oldsite character varying(20)
);


ALTER TABLE dba.pstranshdr OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 26023)
-- Name: pstranstaxdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pstranstaxdtl (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    typeid character varying(10) NOT NULL,
    taxamt numeric(19,4),
    taxrate numeric(19,4) DEFAULT 0,
    numeric1 double precision
);


ALTER TABLE dba.pstranstaxdtl OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 26027)
-- Name: pxapprovalset; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxapprovalset (
    appsetid character varying(10) NOT NULL,
    description character varying(40) NOT NULL,
    valid_ smallint
);


ALTER TABLE dba.pxapprovalset OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 26030)
-- Name: pxcompanyinfo; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxcompanyinfo (
    entityid character varying(10) NOT NULL,
    companyid character varying(10),
    companyname character varying(100),
    companydesc character varying(200),
    companyaddress character varying(100),
    city character varying(25),
    state character varying(25),
    country character varying(25),
    postcode character varying(10),
    phone character varying(25),
    fax character varying(25),
    email character varying(40),
    website character varying(50),
    worksector character varying(25),
    yearfounded smallint,
    taxid character varying(40),
    taxaddress character varying(500),
    last_modified timestamp without time zone,
    maxrounding numeric(19,4) DEFAULT 0,
    prefix_ character varying(5) DEFAULT ''::character varying,
    oldentity character varying(10) DEFAULT ''::character varying,
    path_image character varying(254) DEFAULT ''::character varying,
    server_address character varying(100) DEFAULT ''::character varying,
    userauth character varying(100) DEFAULT ''::character varying,
    passauth character varying DEFAULT ''::character varying
);


ALTER TABLE dba.pxcompanyinfo OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 26036)
-- Name: pxconfig; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxconfig (
    config character varying(30) NOT NULL,
    scope character(1) NOT NULL,
    scopeid character varying(10) NOT NULL,
    setting character varying(255),
    description character varying(255),
    moduleid character(2)
);


ALTER TABLE dba.pxconfig OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 26042)
-- Name: pxcurrency; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxcurrency (
    currencyid character(3) NOT NULL,
    description character varying(25),
    formattype character varying(10),
    localsymbol character(5)
);


ALTER TABLE dba.pxcurrency OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 26045)
-- Name: pxdeliverymtd; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxdeliverymtd (
    deliverymtdid character varying(10) NOT NULL,
    description character varying(30)
);


ALTER TABLE dba.pxdeliverymtd OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 26048)
-- Name: pxentity; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxentity (
    entityid character varying(10) NOT NULL,
    description character varying(50),
    taxid character varying(25),
    re_account integer,
    lyre_account integer,
    fx_gl_account integer,
    ic_account integer,
    syserr_acc integer,
    invgainloss integer,
    round_acc integer,
    maxuser smallint NOT NULL,
    shortdescription character varying(10),
    address character varying(100),
    address2 character varying(100),
    city character varying(15),
    officephone character varying(30)
);


ALTER TABLE dba.pxentity OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 26816)
-- Name: pxexceptionlog; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxexceptionlog (
    sys integer NOT NULL,
    eventdate timestamp without time zone DEFAULT now(),
    eventstatus smallint,
    eventstr character varying(255),
    appid character(3),
    menu character varying(50),
    submenu character varying(50),
    userid character varying(50),
    sessionid integer,
    loginid character varying(20)
);


ALTER TABLE dba.pxexceptionlog OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 26814)
-- Name: pxexceptionlog_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.pxexceptionlog_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.pxexceptionlog_sys_seq OWNER TO postgres;

--
-- TOC entry 3185 (class 0 OID 0)
-- Dependencies: 291
-- Name: pxexceptionlog_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.pxexceptionlog_sys_seq OWNED BY dba.pxexceptionlog.sys;


--
-- TOC entry 247 (class 1259 OID 26051)
-- Name: pxformset; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxformset (
    id character varying(10) NOT NULL,
    description character varying(30)
);


ALTER TABLE dba.pxformset OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 26825)
-- Name: pxloginstatus; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxloginstatus (
    loginid character varying(25) NOT NULL,
    lastlogin timestamp without time zone,
    lastchangepwd timestamp without time zone,
    blocked smallint DEFAULT 0,
    last_modified timestamp without time zone
);


ALTER TABLE dba.pxloginstatus OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 26054)
-- Name: pxnumbering; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxnumbering (
    trtype character varying(35) NOT NULL,
    seqset character(6) NOT NULL,
    nextno integer
);


ALTER TABLE dba.pxnumbering OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 26057)
-- Name: pxperiod; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxperiod (
    periodid integer NOT NULL,
    description character varying(25),
    startdate date,
    enddate date,
    gl_status smallint,
    ca_status smallint,
    ar_status smallint,
    ap_status smallint,
    in_status smallint,
    gl_bal_tfr smallint,
    ca_bal_tfr smallint,
    ar_bal_tfr smallint,
    ap_bal_tfr smallint,
    in_bal_tfr smallint,
    yearid smallint,
    monthcode smallint,
    start_ smallint,
    closingrateid integer,
    has_xfr_bal smallint DEFAULT 0 NOT NULL,
    fiscalyearend_ smallint DEFAULT 0,
    fa_status smallint DEFAULT 0
);


ALTER TABLE dba.pxperiod OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 26063)
-- Name: pxpreserved; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxpreserved (
    moduleid character(3) NOT NULL,
    userid character varying(255) NOT NULL,
    preserved character varying(50) NOT NULL,
    setting character varying(255) NOT NULL,
    descpreserved character varying(255),
    grouped character varying(255) NOT NULL
);


ALTER TABLE dba.pxpreserved OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 26069)
-- Name: pxreason; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxreason (
    reasonid character varying(10) NOT NULL,
    description character varying(100) NOT NULL,
    trans smallint DEFAULT 0 NOT NULL
);


ALTER TABLE dba.pxreason OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 26073)
-- Name: pxsetup; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxsetup (
    id smallint NOT NULL,
    currency1 character(3),
    currency2 character(3),
    coaformat character varying(100),
    column_5 character varying(10),
    urlpath character varying(255),
    hdr1name character varying(25),
    hdr2name character varying(25),
    hdr3name character varying(25),
    hdr4name character varying(25),
    hdr5name character varying(25),
    lookup1 smallint DEFAULT 0,
    lookup2 smallint DEFAULT 0,
    lookup3 smallint DEFAULT 0,
    lookup4 smallint DEFAULT 0,
    dtl1name character varying(25),
    dtl2name character varying(25),
    lookupdtl1 smallint,
    itemsize character varying(25),
    itemcolor character varying(25),
    itemmaterial character varying(25),
    itemmotif character varying(25),
    lookup5 smallint DEFAULT 0,
    lookup6 smallint DEFAULT 0,
    lookup7 smallint DEFAULT 0,
    lookup8 smallint DEFAULT 0,
    resetpl smallint DEFAULT 1,
    overrideprj smallint,
    useglitemaccounts_ smallint DEFAULT 0,
    unique1name character varying(25) NOT NULL,
    unique2name character varying(25),
    ncs smallint,
    last_update timestamp without time zone,
    months_keep_paid_inv integer,
    ipaddressaccessdropbox character varying(1000),
    maxrounding numeric(19,4) DEFAULT 0 NOT NULL
);


ALTER TABLE dba.pxsetup OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 26090)
-- Name: pxsite; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxsite (
    siteid character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    custidprefix character varying(5),
    custidnextno integer,
    custidcl smallint,
    appnoprefix character varying(5),
    appnocl smallint,
    appnonextno integer,
    shortdescription character varying(20),
    entityid character varying(10),
    oldsite character varying(20),
    invtrtype character varying(40) DEFAULT ''::character varying
);


ALTER TABLE dba.pxsite OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 26093)
-- Name: pxtrtype; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxtrtype (
    trtype character varying(40) NOT NULL,
    siteid character varying(20),
    description character varying(80),
    numbering character(1),
    transcode smallint,
    io smallint,
    appsetid character varying(10),
    xrtype character(5),
    xrtypetax character(5),
    usepricelist smallint DEFAULT 0 NOT NULL,
    autoinvoice smallint DEFAULT 0 NOT NULL,
    autotaxinvoice smallint DEFAULT 0 NOT NULL,
    useorder smallint DEFAULT 0 NOT NULL,
    shipmenttrtype character(5),
    autoship smallint DEFAULT 0 NOT NULL,
    multipleorder smallint DEFAULT 0 NOT NULL,
    invoicetrtype character(5),
    cl integer,
    budget_ smallint DEFAULT 0 NOT NULL,
    taxcalc character(1),
    useproject smallint DEFAULT 0 NOT NULL,
    entityid character varying(10),
    sameinvoiceno_ smallint DEFAULT 0,
    deflocid character varying(10),
    ro_ smallint DEFAULT 0,
    useinvsch smallint DEFAULT 0,
    usedropshipment smallint DEFAULT 0
);


ALTER TABLE dba.pxtrtype OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 26108)
-- Name: pxtrtypeusers; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxtrtypeusers (
    trtype character varying(35) NOT NULL,
    loginid character varying(255) NOT NULL
);


ALTER TABLE dba.pxtrtypeusers OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 26111)
-- Name: pxxrate; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxxrate (
    xrperiod integer NOT NULL,
    ccy1 character(3) NOT NULL,
    ccy2 character(3) NOT NULL,
    rate double precision
);


ALTER TABLE dba.pxxrate OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 26114)
-- Name: pxxrperiod; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxxrperiod (
    xrperiod integer NOT NULL,
    date1 date,
    date2 date,
    xrtype character(5)
);


ALTER TABLE dba.pxxrperiod OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 26117)
-- Name: pxxrtype; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxxrtype (
    xrtype character(5) NOT NULL,
    description character varying(25)
);


ALTER TABLE dba.pxxrtype OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 26120)
-- Name: pxyear; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.pxyear (
    yearid smallint NOT NULL,
    reserved character varying(25)
);


ALTER TABLE dba.pxyear OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 26123)
-- Name: rppmtallocation; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.rppmtallocation (
    siteid character varying(20) NOT NULL,
    catrsys integer NOT NULL,
    ca_detsys integer NOT NULL,
    no_ integer NOT NULL,
    trno character varying(20),
    trdate date,
    schsiteid character varying(10),
    schsys integer,
    schno_ integer,
    amount numeric(19,4),
    dateallocated date,
    frommovt smallint DEFAULT 0 NOT NULL,
    gljournalno character varying(20) DEFAULT ''::character varying,
    principalamt numeric(19,4),
    interestamt numeric(19,4),
    fxgl_amt1 numeric(19,4) DEFAULT 0,
    fxgl_amt2 numeric(19,4) DEFAULT 0,
    adv_ smallint DEFAULT 0,
    ufxrev_amt1 numeric(19,4) DEFAULT 0,
    ufxrev_amt2 numeric(19,4) DEFAULT 0,
    ns_ smallint DEFAULT 1,
    orderno character varying(20),
    remarks character varying(100),
    invoiceno character varying(20),
    accountno character varying(20),
    branchname character varying(100),
    branchid character varying(100),
    accountname character varying(100),
    remarks2 character varying(200),
    suppid character varying(35) DEFAULT ''::character varying
);


ALTER TABLE dba.rppmtallocation OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 26138)
-- Name: rppmtallocation_no__seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.rppmtallocation_no__seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.rppmtallocation_no__seq OWNER TO postgres;

--
-- TOC entry 3186 (class 0 OID 0)
-- Dependencies: 261
-- Name: rppmtallocation_no__seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.rppmtallocation_no__seq OWNED BY dba.rppmtallocation.no_;


--
-- TOC entry 294 (class 1259 OID 26848)
-- Name: rptransdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.rptransdtl (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    transcode smallint,
    itemid character varying(30),
    periodid integer,
    locationid character varying(10),
    projectid character varying(10),
    qt numeric(19,4) DEFAULT 0 NOT NULL,
    unitid character(10),
    qty numeric(19,4) DEFAULT 0 NOT NULL,
    qty2 numeric(19,4) DEFAULT 0,
    description character varying(1000),
    remarks character varying(25),
    length_ numeric(19,4),
    width_ numeric(19,4),
    height numeric(19,4),
    diameter numeric(19,4),
    unitprice numeric(19,4),
    discpct numeric(7,4),
    grossamt numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    rounding numeric(19,4) DEFAULT 0,
    netamt numeric(19,4) DEFAULT 0,
    orderno character varying(20),
    orderlineno integer,
    invoiceno character varying(20),
    discpct2 numeric(19,4),
    discpct3 numeric(19,4),
    discpct4 numeric(19,4),
    discpct5 numeric(19,4),
    discpct_ smallint DEFAULT 0 NOT NULL,
    invdiscamt numeric(19,4) DEFAULT 0,
    cogsunit numeric(19,4),
    cogsunit2 numeric(19,4),
    linetype character(1),
    shipmenttrno character varying(20),
    shipmentlineno integer,
    string1 character varying(80),
    numeric1 double precision,
    barcode character varying(30),
    giftid character varying(20),
    giftlineno integer,
    bonus_ smallint,
    olditem character varying(30)
);


ALTER TABLE dba.rptransdtl OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 26140)
-- Name: rptranshdr; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.rptranshdr (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    periodid integer,
    entityid character varying(10),
    xrperiod integer,
    trno character varying(20),
    trmanualref character varying(25),
    trmanualref2 character varying(25),
    trdate date,
    trtype character varying(35),
    transcode smallint,
    custid character varying(10),
    suppid character varying(35),
    top_days smallint,
    taxcalc character(1),
    taxinvoiceno character varying(25),
    taxinvoicedate date,
    taxsubmitdate date,
    salesrepid character varying(10),
    currencyid character(3),
    taxable numeric(19,4),
    tax numeric(19,4),
    netamt numeric(19,4),
    note character varying(500),
    entrytime timestamp without time zone DEFAULT now(),
    added_by character varying(100),
    changed_by character varying(100),
    posted smallint DEFAULT 0 NOT NULL,
    pmtschno integer,
    xrperiodtax integer,
    approved smallint DEFAULT 0 NOT NULL,
    ic_ smallint DEFAULT 0 NOT NULL,
    taxpmt smallint DEFAULT 0 NOT NULL,
    coaid integer,
    custtaxto character varying(10),
    orderno character varying(20),
    top_id character varying(10),
    priceid character varying(10),
    discpct_ smallint DEFAULT 0 NOT NULL,
    discpct numeric(7,4),
    discpct2 numeric(7,4),
    discpct3 numeric(7,4),
    discpct4 numeric(7,4),
    discpct5 numeric(7,4),
    discamt numeric(19,4),
    custsellto character varying(10),
    autoinvoice smallint DEFAULT 0 NOT NULL,
    printed smallint DEFAULT 0 NOT NULL,
    void_ smallint DEFAULT 0 NOT NULL,
    projectid character varying(15),
    fxgl_amt1 numeric(19,4),
    fxgl_dc1 character(1),
    fxgl_amt2 numeric(19,4),
    fxgl_dc2 character(1),
    string1 character varying(80),
    string2 character varying(80),
    string3 character varying(200),
    string4 character varying(80),
    numeric1 double precision,
    invdiscchanged smallint DEFAULT 0,
    ufxgl_amt1 numeric(19,4),
    ufxgl_amt2 numeric(19,4),
    ufxgl_dc1 character(1),
    ufxgl_dc2 character(1),
    listid character varying(10),
    previoustaxno character varying(25),
    taxnochanged_ smallint DEFAULT 0 NOT NULL,
    previoustrno character varying(20),
    frominvoiceno character varying(20),
    taxdeductionslip character varying(25),
    deductionslipdate date,
    uniquetaxno character varying(65),
    supptaxto character varying(10),
    remarks character varying(25),
    csv_file character varying(200),
    oldsupp character varying(35),
    oldsite character varying(20),
    erpinvoiceno character varying(15)
);


ALTER TABLE dba.rptranshdr OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 26157)
-- Name: rptranshdrrejectlog; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.rptranshdrrejectlog (
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    entrytime timestamp without time zone DEFAULT now(),
    documentno character varying(15) NOT NULL,
    added_by character varying(100),
    reasoncode character varying(10),
    reasondesc character varying(100)
);


ALTER TABLE dba.rptranshdrrejectlog OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 26161)
-- Name: rptrtype; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.rptrtype (
    trtype character varying(40) NOT NULL,
    siteid character varying(20),
    description character varying(40),
    numbering character(1),
    transcode smallint,
    rp_ smallint,
    appsetid character varying(10),
    system_ smallint,
    xrtype character(5),
    dc character(1),
    useorder smallint DEFAULT 0 NOT NULL,
    xrtypetax character(5),
    cl integer,
    taxcalc character(1),
    useproject smallint DEFAULT 0 NOT NULL,
    entityid character varying(10)
);


ALTER TABLE dba.rptrtype OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 26166)
-- Name: rptrtypeusers; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.rptrtypeusers (
    trtype character varying(35) NOT NULL,
    loginid character varying(255) NOT NULL
);


ALTER TABLE dba.rptrtypeusers OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 26648)
-- Name: s_apsupplier; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.s_apsupplier (
    suppid character varying(35) NOT NULL,
    suppname character varying(100),
    address character varying(200),
    postcode character varying(10),
    phones character varying(25),
    telex character varying(25),
    fax character varying(25),
    email character varying(100),
    taxid character varying(25),
    taxdescription1 character varying(50),
    taxdescription2 character varying(50),
    taxname character varying(100),
    taxaddress character varying(200),
    city character varying(50),
    state character varying(50),
    countryid character(2),
    affiliate_ smallint DEFAULT 0,
    gl_groupid character varying(10),
    parentid character varying(10),
    blockreceive_ smallint DEFAULT 0,
    blockap_ smallint DEFAULT 0,
    blockpurchase_ smallint DEFAULT 0,
    dispatchid character varying(10),
    forwarderid character varying(10),
    areaid character varying(10),
    contact_sales character varying(40),
    contact_acc character varying(40),
    our_id character varying(50),
    pricegroupid character varying(10),
    currencyid character(3),
    groupa_id character varying(35),
    groupb_id integer,
    groupc_id integer,
    groupd_id integer,
    top_id character varying(10),
    deliverymtdid character varying(10),
    formsetid character varying(10),
    suppstatus smallint DEFAULT 0,
    creditstatus smallint DEFAULT 1,
    collectorid character varying(10),
    creditlimit numeric(19,4),
    warehouseid character varying(10),
    registerdate date,
    lasttransdate date,
    ignorecl_ smallint,
    consideroverduedays_ smallint DEFAULT 0,
    creditdays smallint DEFAULT 0,
    invtaxcode character varying(2),
    usexmlreport smallint DEFAULT 0,
    sendporeport smallint DEFAULT 0,
    ftpaddress character varying(30),
    ftpuser character varying(30),
    ftppassword character varying(30),
    email2 character varying(100),
    gln character varying(15),
    servicelevel character varying(3),
    servicelevelgroup character varying(4),
    serviceleveltime character varying(4),
    consignment character(1),
    last_modified timestamp without time zone,
    old_id character varying(15),
    entityid character varying(10),
    siteid character varying(20) DEFAULT ''::character varying,
    adddate timestamp without time zone DEFAULT now()
);


ALTER TABLE dba.s_apsupplier OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 26666)
-- Name: s_initem; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.s_initem (
    itemid character varying(30) NOT NULL,
    old_id character varying(30),
    description character varying(250),
    cust_itemid character varying(30),
    cust_desc character varying(50),
    supp_itemid character varying(30),
    supp_desc character varying(50),
    unitsetid character varying(10),
    inventory_unit character varying(10),
    unit2 character varying(10),
    storage_unit character varying(10),
    purchase_unit character varying(10),
    purchase_price numeric(19,4),
    purchase_ccy character(3),
    sales_unit character varying(10),
    sales_price numeric(19,4),
    sales_ccy character(3),
    itemtype smallint DEFAULT 0,
    lot_ smallint DEFAULT 0 NOT NULL,
    itemgroupid integer DEFAULT 0,
    itemcategoryid integer DEFAULT 0,
    itembrandid integer DEFAULT 0,
    itemmodelid integer DEFAULT 0,
    classid character varying(10),
    gl_groupid character varying(10),
    tax_groupid character varying(10),
    size_ character varying(25),
    color character varying(25),
    material character varying(25),
    motif character varying(25),
    weight double precision,
    weight_unit character varying(10),
    length_ double precision,
    width_ double precision,
    height double precision,
    dim_unit character varying(10),
    vol_ smallint DEFAULT 0 NOT NULL,
    volume double precision,
    volume_unit character varying(10),
    valuemtd character(4),
    remarks character varying(1000),
    lasttransdate date,
    lasttranscode smallint,
    std_cost numeric(19,4),
    inspect_ smallint,
    weightingfactor double precision,
    reorderpoint double precision,
    minstockqty double precision,
    minorderqty double precision,
    dateexpired date,
    barcode character varying(30),
    prioritysuppid character varying(30),
    leadtimedays smallint DEFAULT 0 NOT NULL,
    supply_ smallint,
    master_ smallint,
    fence double precision,
    orderhorz integer,
    planhorz integer,
    planmethod smallint,
    maxqty double precision,
    safetyqty double precision,
    fixedorderqty double precision,
    production_unit character(5),
    blocked smallint,
    obsolete smallint,
    sqttolerance numeric(19,4),
    pqttolerance numeric(19,4),
    protectstdcost_ smallint DEFAULT 0,
    sminqttol numeric(19,4) DEFAULT 0,
    pminqttol numeric(19,4) DEFAULT 0,
    updatelastpurchaseprice_ smallint DEFAULT 0,
    useqty2calc_ smallint DEFAULT 0 NOT NULL,
    internalprocess integer DEFAULT 0,
    backflush smallint DEFAULT 0,
    qtyordermultiply numeric(19,4) DEFAULT 0,
    maxorderqty double precision DEFAULT 0,
    deflocid character varying(10),
    basecomp1 integer,
    basecomp2 integer,
    basecomp3 integer,
    basecomp4 integer,
    entityid character varying(10),
    siteid character varying(20),
    adddate timestamp without time zone DEFAULT now()
);


ALTER TABLE dba.s_initem OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 26723)
-- Name: s_intransdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.s_intransdtl (
    id bigint NOT NULL,
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    transcode smallint,
    itemid character varying(30),
    periodid integer,
    locationid character varying(10),
    locationid2 character varying(10),
    projectid character varying(10),
    qt numeric(19,4) DEFAULT 0 NOT NULL,
    unitid character(10),
    qty numeric(19,4) DEFAULT 0 NOT NULL,
    qty2 numeric(19,4) DEFAULT 0,
    description character varying(1000),
    remarks character varying(60),
    length_ numeric(19,4),
    width_ numeric(19,4),
    height numeric(19,4),
    diameter numeric(19,4),
    unitprice numeric(19,4) DEFAULT 0,
    discpct numeric(7,4),
    grossamt numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    rounding numeric(19,4) DEFAULT 0,
    netamt numeric(19,4) DEFAULT 0,
    qty_inv numeric(19,4) DEFAULT 0,
    qty2_inv numeric(19,4) DEFAULT 0,
    orderno character varying(20),
    orderlineno integer,
    invoiceno character varying(20),
    discpct2 numeric(19,4),
    discpct3 numeric(19,4),
    discpct4 numeric(19,4),
    discpct5 numeric(19,4),
    discpct_ smallint DEFAULT 0 NOT NULL,
    invdiscamt numeric(19,4) DEFAULT 0,
    cogsunit numeric(19,4) DEFAULT 0,
    cogsunit2 numeric(19,4) DEFAULT 0,
    newlot_ smallint DEFAULT 0 NOT NULL,
    linetype character(1),
    minus_ smallint DEFAULT 0 NOT NULL,
    string1 character varying(500),
    numeric1 double precision,
    barcode character varying(30),
    shippingunit character(5),
    shippingqty numeric(19,4),
    qtyused numeric(19,4),
    qtysetup numeric(19,4),
    trailertype smallint DEFAULT 0,
    reserveid character varying(500),
    reasonid integer,
    rotno character varying(500),
    rotlineno integer,
    giftlineno integer,
    bonus_ smallint,
    giftid character varying(10),
    fa_no character varying(15),
    string2 character varying(80) DEFAULT ''::character varying,
    olditem character varying(30),
    adddate timestamp without time zone DEFAULT now()
);


ALTER TABLE dba.s_intransdtl OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 26721)
-- Name: s_intransdtl_id_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.s_intransdtl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.s_intransdtl_id_seq OWNER TO postgres;

--
-- TOC entry 3187 (class 0 OID 0)
-- Dependencies: 284
-- Name: s_intransdtl_id_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.s_intransdtl_id_seq OWNED BY dba.s_intransdtl.id;


--
-- TOC entry 283 (class 1259 OID 26692)
-- Name: s_intranshdr; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.s_intranshdr (
    id bigint NOT NULL,
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    periodid integer,
    entityid character varying(10),
    xrperiod integer,
    trno character varying(20),
    trmanualref character varying(25),
    trmanualref2 character varying(25),
    trdate date,
    trtime time without time zone,
    trtype character varying(35),
    transcode smallint,
    expected_dlv date,
    expected_arv date,
    suppid character varying(35),
    custbillto character varying(10),
    custsellto character varying(10),
    custshipto character varying(10),
    custtaxto character varying(10),
    top_id character varying(10),
    top_days smallint,
    taxcalc character(1),
    taxinvoiceno character varying(25),
    taxinvoicedate date,
    taxsubmitdate date,
    salesrepid character varying(10),
    dlvmtdid character varying(15),
    shiptonote character varying(15),
    headernote character varying(100),
    footernote character varying(150),
    entrytime timestamp without time zone DEFAULT now(),
    added_by character varying(100),
    changed_by character varying(100),
    approved smallint DEFAULT 0 NOT NULL,
    xrperiodtax integer,
    currencyid character(3),
    posted smallint DEFAULT 0 NOT NULL,
    priceid character varying(10),
    discpct_ smallint DEFAULT 0 NOT NULL,
    discpct numeric(7,4),
    discpct2 numeric(7,4),
    discpct3 numeric(7,4),
    discpct4 numeric(7,4),
    discpct5 numeric(7,4),
    discamt numeric(19,4),
    countercoaid integer DEFAULT 0,
    locationid character varying(10),
    locationid2 character varying(10),
    manualcalc_ smallint DEFAULT 0 NOT NULL,
    invoiceno character varying(20),
    orderno character varying(50),
    projectid character varying(10),
    printed smallint DEFAULT 0 NOT NULL,
    void_ smallint DEFAULT 0 NOT NULL,
    string1 character varying(80),
    string2 character varying(80),
    string3 character varying(200),
    string4 character varying(80),
    numeric1 double precision,
    invdiscchanged smallint DEFAULT 0,
    netamt numeric(19,4),
    controltotal numeric(19,4),
    useplcomp smallint DEFAULT 0,
    useplreceipt smallint DEFAULT 0,
    priceidreceipt character varying(10),
    top_id2 character varying(10),
    listid character varying(10),
    mf smallint DEFAULT 0,
    mfret smallint DEFAULT 0,
    pos_ smallint DEFAULT 0,
    pos_stationid character varying(10),
    pos_shiftid integer,
    pos_cashierid character varying(10),
    ro_ smallint DEFAULT 0,
    uniquetaxno character varying(65),
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    taxablesupp numeric(19,4) DEFAULT 0 NOT NULL,
    taxamtsupp numeric(19,4) DEFAULT 0 NOT NULL,
    oldsupp character varying(10),
    oldsite character varying(20),
    adddate timestamp without time zone DEFAULT now()
);


ALTER TABLE dba.s_intranshdr OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 26690)
-- Name: s_intranshdr_id_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.s_intranshdr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.s_intranshdr_id_seq OWNER TO postgres;

--
-- TOC entry 3188 (class 0 OID 0)
-- Dependencies: 282
-- Name: s_intranshdr_id_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.s_intranshdr_id_seq OWNED BY dba.s_intranshdr.id;


--
-- TOC entry 290 (class 1259 OID 26786)
-- Name: s_pstransdtl; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.s_pstransdtl (
    id bigint NOT NULL,
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    lineno integer NOT NULL,
    transcode smallint,
    itemid character varying(30),
    periodid integer,
    locationid character varying(10),
    locationid2 character varying(10),
    projectid character varying(10),
    qt numeric(19,4) DEFAULT 0 NOT NULL,
    unitid character(10),
    qty numeric(19,4) DEFAULT 0 NOT NULL,
    qty2 numeric(19,4) DEFAULT 0,
    description character varying(1000),
    remarks character varying(60),
    length_ numeric(19,4),
    width_ numeric(19,4),
    height numeric(19,4),
    diameter numeric(19,4),
    unitprice numeric(19,4) DEFAULT 0,
    discpct numeric(19,4),
    grossamt numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    rounding numeric(19,4) DEFAULT 0,
    netamt numeric(19,4) DEFAULT 0,
    linklineno integer,
    invoiceno character varying(15),
    discpct2 numeric(19,4),
    discpct3 numeric(19,4),
    discpct4 numeric(19,4),
    discpct5 numeric(19,4),
    discpct_ smallint DEFAULT 0 NOT NULL,
    wo_ smallint DEFAULT 0 NOT NULL,
    invdiscamt numeric(19,4) DEFAULT 0,
    linetype character(1),
    salesrepid character varying(10),
    string1 character varying(80),
    numeric1 double precision,
    barcode character varying(30),
    prunitprice numeric(19,4),
    orderno character varying(20),
    orderlineno smallint DEFAULT 0,
    po_ smallint DEFAULT 0,
    giftlineno integer,
    bonus_ smallint,
    giftid character varying(20),
    linkno character varying(30),
    olditem character varying(30),
    adddate timestamp without time zone DEFAULT now()
);


ALTER TABLE dba.s_pstransdtl OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 26782)
-- Name: s_pstransdtl_id_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.s_pstransdtl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.s_pstransdtl_id_seq OWNER TO postgres;

--
-- TOC entry 3189 (class 0 OID 0)
-- Dependencies: 288
-- Name: s_pstransdtl_id_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.s_pstransdtl_id_seq OWNED BY dba.s_pstransdtl.id;


--
-- TOC entry 289 (class 1259 OID 26784)
-- Name: s_pstransdtl_lineno_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.s_pstransdtl_lineno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.s_pstransdtl_lineno_seq OWNER TO postgres;

--
-- TOC entry 3190 (class 0 OID 0)
-- Dependencies: 289
-- Name: s_pstransdtl_lineno_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.s_pstransdtl_lineno_seq OWNED BY dba.s_pstransdtl.lineno;


--
-- TOC entry 287 (class 1259 OID 26755)
-- Name: s_pstranshdr; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.s_pstranshdr (
    id bigint NOT NULL,
    siteid character varying(20) NOT NULL,
    sys integer NOT NULL,
    periodid integer,
    entityid character varying(10),
    xrperiod integer,
    trno character varying(20),
    trmanualref character varying(25),
    trmanualref2 character varying(25),
    trdate date,
    trtime time without time zone,
    trtype character varying(35),
    transcode smallint,
    expected_dlv date,
    expected_arv date,
    custbillto character varying(10),
    custsellto character varying(10),
    custshipto character varying(10),
    custtaxto character varying(10),
    top_id character varying(10),
    top_days smallint,
    taxcalc character(1),
    salesrepid character varying(10),
    dlvmtdid character varying(15),
    headernote character varying(500),
    footernote character varying(500),
    entrytime timestamp without time zone DEFAULT now(),
    added_by character varying(100),
    changed_by character varying(100),
    approved smallint DEFAULT 0 NOT NULL,
    currencyid character(3),
    suppid character varying(35),
    ps_ character(1),
    priceid character varying(10),
    discpct_ smallint DEFAULT 0 NOT NULL,
    discpct numeric(19,4) DEFAULT 0,
    discpct2 numeric(19,4) DEFAULT 0,
    discpct3 numeric(19,4) DEFAULT 0,
    discpct4 numeric(19,4) DEFAULT 0,
    discpct5 numeric(19,4) DEFAULT 0,
    discamt numeric(19,4) DEFAULT 0,
    projectid character varying(11),
    printed smallint DEFAULT 0 NOT NULL,
    void_ smallint DEFAULT 0 NOT NULL,
    string1 character varying(80),
    string2 character varying(80),
    string3 character varying(80),
    string4 character varying(80),
    numeric1 double precision,
    invdiscchanged smallint DEFAULT 0,
    netamt numeric(19,4),
    controltotal numeric(19,4),
    ordertositeid character varying(10),
    intransitlocid character varying(30),
    destinationlocid character varying(10),
    orderno character varying(20),
    pdf_file character varying(200),
    xml_file character varying(200),
    faxstatus smallint DEFAULT 0,
    ftpstatus smallint DEFAULT 0,
    emailstatus smallint DEFAULT 0,
    supplydate date,
    faxno character varying(15),
    taxable numeric(19,4) DEFAULT 0,
    taxamt numeric(19,4) DEFAULT 0,
    expected_arvtime time without time zone,
    oldsupp character varying(10),
    oldsite character varying(20),
    adddate timestamp without time zone DEFAULT now()
);


ALTER TABLE dba.s_pstranshdr OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 26753)
-- Name: s_pstranshdr_id_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.s_pstranshdr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.s_pstranshdr_id_seq OWNER TO postgres;

--
-- TOC entry 3191 (class 0 OID 0)
-- Dependencies: 286
-- Name: s_pstranshdr_id_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.s_pstranshdr_id_seq OWNED BY dba.s_pstranshdr.id;


--
-- TOC entry 266 (class 1259 OID 26169)
-- Name: securitynode; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.securitynode (
    action character varying(20),
    checked smallint,
    groupid character varying(255) NOT NULL,
    form character varying(50) NOT NULL,
    description character varying(50) NOT NULL,
    groupmenu character varying(50),
    groupform character varying(50),
    seq integer
);


ALTER TABLE dba.securitynode OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 26172)
-- Name: securitynodeitem; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.securitynodeitem (
    groupid character varying(255) NOT NULL,
    form character varying(50) NOT NULL,
    description character varying(50) NOT NULL,
    element character varying(50) NOT NULL,
    eltype character varying(15)
);


ALTER TABLE dba.securitynodeitem OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 26175)
-- Name: securitynoderole; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.securitynoderole (
    action character varying(20),
    checked smallint,
    roleid smallint NOT NULL,
    form character varying(50) NOT NULL,
    description character varying(50) NOT NULL,
    groupmenu character varying(50),
    groupform character varying(50),
    seq integer
);


ALTER TABLE dba.securitynoderole OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 26178)
-- Name: securitynoderoleitem; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.securitynoderoleitem (
    roleid smallint NOT NULL,
    form character varying(50) NOT NULL,
    description character varying(50) NOT NULL,
    element character varying(50) NOT NULL,
    eltype character varying(15)
);


ALTER TABLE dba.securitynoderoleitem OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 26181)
-- Name: tempupdateevent; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.tempupdateevent (
    descevent character varying(255),
    string1 character varying(255),
    string2 character varying(255),
    string3 character varying(255),
    string4 character varying(255),
    string5 character varying(255),
    num1 numeric(19,4),
    num2 numeric(19,4),
    num3 numeric(19,4),
    num4 numeric(19,4),
    num5 numeric(19,4)
);


ALTER TABLE dba.tempupdateevent OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 26187)
-- Name: useractivedirectory; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.useractivedirectory (
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    department character varying(255),
    jobtitle character varying(255),
    sys integer NOT NULL,
    sysdate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dba.useractivedirectory OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 26194)
-- Name: useractivedirectory_sys_seq; Type: SEQUENCE; Schema: dba; Owner: postgres
--

CREATE SEQUENCE dba.useractivedirectory_sys_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dba.useractivedirectory_sys_seq OWNER TO postgres;

--
-- TOC entry 3192 (class 0 OID 0)
-- Dependencies: 272
-- Name: useractivedirectory_sys_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: postgres
--

ALTER SEQUENCE dba.useractivedirectory_sys_seq OWNED BY dba.useractivedirectory.sys;


--
-- TOC entry 273 (class 1259 OID 26196)
-- Name: usergroup; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.usergroup (
    groupid character varying(35) NOT NULL,
    description character varying(200) NOT NULL,
    maxuser integer,
    suppgroupid character varying(35),
    adminuser character varying(255),
    createuser character varying(255),
    createdate date DEFAULT ('now'::text)::date,
    changeuser character varying(255),
    changedate date DEFAULT ('now'::text)::date,
    statisticlevel smallint DEFAULT 0 NOT NULL,
    supplevel smallint DEFAULT 0 NOT NULL,
    entityid character varying(10),
    email character varying(200)
);


ALTER TABLE dba.usergroup OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 26206)
-- Name: userlogin; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.userlogin (
    userid character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    administrator smallint DEFAULT 0 NOT NULL,
    groupid character varying(35) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    loginflag smallint,
    statuslogin character varying(200),
    createuser character varying(255),
    createdate date DEFAULT ('now'::text)::date,
    changeuser character varying(255),
    changedate date,
    roleid smallint DEFAULT 0,
    userad smallint DEFAULT 0,
    allsiteaccess smallint DEFAULT 0,
    mailnotification smallint DEFAULT 1,
    entityid character varying(10),
    defsiteid character varying(20),
    lastchangepwd timestamp without time zone DEFAULT now(),
    email character varying(200) DEFAULT ''::character varying
);


ALTER TABLE dba.userlogin OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 26218)
-- Name: userlogin_delete; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.userlogin_delete (
    userid character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    administrator smallint NOT NULL,
    groupid character varying(35) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    loginflag smallint,
    statuslogin character varying(200),
    createuser character varying(255),
    createdate date,
    changeuser character varying(255),
    changedate date,
    roleid smallint,
    userad smallint,
    allsiteaccess smallint,
    mailnotification smallint
);


ALTER TABLE dba.userlogin_delete OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 26224)
-- Name: userrole; Type: TABLE; Schema: dba; Owner: postgres
--

CREATE TABLE dba.userrole (
    roleid smallint NOT NULL,
    description character varying(100) NOT NULL,
    internalrole smallint DEFAULT 0 NOT NULL
);


ALTER TABLE dba.userrole OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 26564)
-- Name: vb2bsuppliergroup; Type: VIEW; Schema: dba; Owner: postgres
--

CREATE VIEW dba.vb2bsuppliergroup AS
 SELECT a.groupa_id,
    a.description,
    b.suppid,
    b.suppname,
    COALESCE(( SELECT max((c.address)::text) AS max
           FROM dba.apsupplierdoc c
          WHERE ((c.outputtype = 'TB'::bpchar) AND ((c.suppid)::text = (b.suppid)::text))), ''::text) AS email,
    ((a.groupa_id)::text || COALESCE((b.suppid)::text, ''::text)) AS pk,
    b.old_id
   FROM (dba.apsuppliergroupa a
     LEFT JOIN dba.apsupplier b ON (((a.groupa_id)::text = (b.groupa_id)::text)));


ALTER TABLE dba.vb2bsuppliergroup OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 26233)
-- Name: usersession; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.usersession (
    userid character varying(255) NOT NULL,
    sessionid character varying(255) NOT NULL,
    servername character varying(50)
);


ALTER TABLE dbo.usersession OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 26239)
-- Name: ccy1_; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ccy1_ (
    currency1 character(3)
);


ALTER TABLE public.ccy1_ OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 25677)
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- TOC entry 2540 (class 2604 OID 26242)
-- Name: b2bempmarketsharevscat sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempmarketsharevscat ALTER COLUMN sys SET DEFAULT nextval('dba.b2bempmarketsharevscat_sys_seq'::regclass);


--
-- TOC entry 2541 (class 2604 OID 26243)
-- Name: b2bemppromoperformance sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bemppromoperformance ALTER COLUMN sys SET DEFAULT nextval('dba.b2bemppromoperformance_sys_seq'::regclass);


--
-- TOC entry 2542 (class 2604 OID 26244)
-- Name: b2bempsalescontribvscat sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempsalescontribvscat ALTER COLUMN sys SET DEFAULT nextval('dba.b2bempsalescontribvscat_sys_seq'::regclass);


--
-- TOC entry 2543 (class 2604 OID 26245)
-- Name: b2bempsalesitembystore sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempsalesitembystore ALTER COLUMN sys SET DEFAULT nextval('dba.b2bempsalesitembystore_sys_seq'::regclass);


--
-- TOC entry 2544 (class 2604 OID 26246)
-- Name: b2bempservicelevel sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempservicelevel ALTER COLUMN sys SET DEFAULT nextval('dba.b2bempservicelevel_sys_seq'::regclass);


--
-- TOC entry 2545 (class 2604 OID 26247)
-- Name: b2bempservicelevelcontribvscat sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempservicelevelcontribvscat ALTER COLUMN sys SET DEFAULT nextval('dba.b2bempservicelevelcontribvscat_sys_seq'::regclass);


--
-- TOC entry 2546 (class 2604 OID 26248)
-- Name: b2bempstockbalance sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempstockbalance ALTER COLUMN sys SET DEFAULT nextval('dba.b2bempstockbalance_sys_seq'::regclass);


--
-- TOC entry 2551 (class 2604 OID 26249)
-- Name: b2bstatisticprocess sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bstatisticprocess ALTER COLUMN sys SET DEFAULT nextval('dba.b2bstatisticprocess_sys_seq'::regclass);


--
-- TOC entry 2636 (class 2604 OID 26250)
-- Name: pstransdtl lineno; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pstransdtl ALTER COLUMN lineno SET DEFAULT nextval('dba.pstransdtl_lineno_seq'::regclass);


--
-- TOC entry 2839 (class 2604 OID 26819)
-- Name: pxexceptionlog sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxexceptionlog ALTER COLUMN sys SET DEFAULT nextval('dba.pxexceptionlog_sys_seq'::regclass);


--
-- TOC entry 2698 (class 2604 OID 26251)
-- Name: rppmtallocation no_; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rppmtallocation ALTER COLUMN no_ SET DEFAULT nextval('dba.rppmtallocation_no__seq'::regclass);


--
-- TOC entry 2780 (class 2604 OID 26726)
-- Name: s_intransdtl id; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_intransdtl ALTER COLUMN id SET DEFAULT nextval('dba.s_intransdtl_id_seq'::regclass);


--
-- TOC entry 2759 (class 2604 OID 26695)
-- Name: s_intranshdr id; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_intranshdr ALTER COLUMN id SET DEFAULT nextval('dba.s_intranshdr_id_seq'::regclass);


--
-- TOC entry 2821 (class 2604 OID 26789)
-- Name: s_pstransdtl id; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_pstransdtl ALTER COLUMN id SET DEFAULT nextval('dba.s_pstransdtl_id_seq'::regclass);


--
-- TOC entry 2822 (class 2604 OID 26790)
-- Name: s_pstransdtl lineno; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_pstransdtl ALTER COLUMN lineno SET DEFAULT nextval('dba.s_pstransdtl_lineno_seq'::regclass);


--
-- TOC entry 2802 (class 2604 OID 26758)
-- Name: s_pstranshdr id; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_pstranshdr ALTER COLUMN id SET DEFAULT nextval('dba.s_pstranshdr_id_seq'::regclass);


--
-- TOC entry 2714 (class 2604 OID 26252)
-- Name: useractivedirectory sys; Type: DEFAULT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.useractivedirectory ALTER COLUMN sys SET DEFAULT nextval('dba.useractivedirectory_sys_seq'::regclass);


--
-- TOC entry 2857 (class 2606 OID 26511)
-- Name: apsupplier apsupplier_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsupplier
    ADD CONSTRAINT apsupplier_pkey PRIMARY KEY (suppid);


--
-- TOC entry 2859 (class 2606 OID 26588)
-- Name: apsupplierbank apsupplierbank_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsupplierbank
    ADD CONSTRAINT apsupplierbank_pkey PRIMARY KEY (suppid, no);


--
-- TOC entry 2861 (class 2606 OID 26425)
-- Name: apsupplierdoc apsupplierdoc_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsupplierdoc
    ADD CONSTRAINT apsupplierdoc_pkey PRIMARY KEY (suppid, code, outputtype);


--
-- TOC entry 2863 (class 2606 OID 26559)
-- Name: apsuppliergroupa apsuppliergroupa_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsuppliergroupa
    ADD CONSTRAINT apsuppliergroupa_pkey PRIMARY KEY (groupa_id);


--
-- TOC entry 2865 (class 2606 OID 26590)
-- Name: apsupplieritem apsupplieritem_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsupplieritem
    ADD CONSTRAINT apsupplieritem_pkey PRIMARY KEY (suppid, itemid);


--
-- TOC entry 2867 (class 2606 OID 26429)
-- Name: apsuppliervat apsuppliervat_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsuppliervat
    ADD CONSTRAINT apsuppliervat_pkey PRIMARY KEY (suppid, vat_year, vat_seq, vat_status);


--
-- TOC entry 2869 (class 2606 OID 26431)
-- Name: apsupplierwhse apsupplierwhse_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.apsupplierwhse
    ADD CONSTRAINT apsupplierwhse_pkey PRIMARY KEY (suppid, whse);


--
-- TOC entry 2871 (class 2606 OID 26268)
-- Name: arcustomer arcustomer_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.arcustomer
    ADD CONSTRAINT arcustomer_pkey PRIMARY KEY (custid);


--
-- TOC entry 2873 (class 2606 OID 26270)
-- Name: b2b_logincounter b2b_logincounter_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2b_logincounter
    ADD CONSTRAINT b2b_logincounter_pkey PRIMARY KEY (logindate);


--
-- TOC entry 2875 (class 2606 OID 26272)
-- Name: b2b_loginlog b2b_loginlog_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2b_loginlog
    ADD CONSTRAINT b2b_loginlog_pkey PRIMARY KEY (userid, logintime);


--
-- TOC entry 2877 (class 2606 OID 26274)
-- Name: b2bdeductiondetail b2bdeductiondetail_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bdeductiondetail
    ADD CONSTRAINT b2bdeductiondetail_pkey PRIMARY KEY (deal_id, soorderno, poorderno);


--
-- TOC entry 2879 (class 2606 OID 26276)
-- Name: b2bempmarketsharevscat b2bempmarketsharevscat_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempmarketsharevscat
    ADD CONSTRAINT b2bempmarketsharevscat_pkey PRIMARY KEY (categoryid, classid, channelid, year, month, itemid);


--
-- TOC entry 2881 (class 2606 OID 26278)
-- Name: b2bemppromoperformance b2bemppromoperformance_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bemppromoperformance
    ADD CONSTRAINT b2bemppromoperformance_pkey PRIMARY KEY (catalogcode, type_, year, itemid, startdate, enddate);


--
-- TOC entry 2883 (class 2606 OID 26280)
-- Name: b2bempsalescontribvscat b2bempsalescontribvscat_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempsalescontribvscat
    ADD CONSTRAINT b2bempsalescontribvscat_pkey PRIMARY KEY (classid, year, month, itemid, groupid);


--
-- TOC entry 2885 (class 2606 OID 26282)
-- Name: b2bempsalesitembystore b2bempsalesitembystore_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempsalesitembystore
    ADD CONSTRAINT b2bempsalesitembystore_pkey PRIMARY KEY (year, month, siteid, itemid);


--
-- TOC entry 2887 (class 2606 OID 26284)
-- Name: b2bempservicelevel b2bempservicelevel_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempservicelevel
    ADD CONSTRAINT b2bempservicelevel_pkey PRIMARY KEY (orderno);


--
-- TOC entry 2889 (class 2606 OID 26433)
-- Name: b2bempservicelevelcontribvscat b2bempservicelevelcontribvscat_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempservicelevelcontribvscat
    ADD CONSTRAINT b2bempservicelevelcontribvscat_pkey PRIMARY KEY (suppid, year, month, categoryitem);


--
-- TOC entry 2891 (class 2606 OID 26459)
-- Name: b2bempstockbalance b2bempstockbalance_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bempstockbalance
    ADD CONSTRAINT b2bempstockbalance_pkey PRIMARY KEY (siteid, itemid);


--
-- TOC entry 2893 (class 2606 OID 26290)
-- Name: b2bjobtitle b2bjobtitle_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bjobtitle
    ADD CONSTRAINT b2bjobtitle_pkey PRIMARY KEY (jobtitle);


--
-- TOC entry 2895 (class 2606 OID 26292)
-- Name: b2bleveljobtitle b2bleveljobtitle_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bleveljobtitle
    ADD CONSTRAINT b2bleveljobtitle_pkey PRIMARY KEY (level_, dispute, jobtitle);


--
-- TOC entry 2897 (class 2606 OID 26294)
-- Name: b2bnotification b2bnotification_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bnotification
    ADD CONSTRAINT b2bnotification_pkey PRIMARY KEY (sys);


--
-- TOC entry 2899 (class 2606 OID 26296)
-- Name: b2bnotificationusers b2bnotificationusers_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bnotificationusers
    ADD CONSTRAINT b2bnotificationusers_pkey PRIMARY KEY (sys, userid);


--
-- TOC entry 2901 (class 2606 OID 26298)
-- Name: b2breason b2breason_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2breason
    ADD CONSTRAINT b2breason_pkey PRIMARY KEY (reasoncode);


--
-- TOC entry 2903 (class 2606 OID 26300)
-- Name: b2bstatisticprocess b2bstatisticprocess_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bstatisticprocess
    ADD CONSTRAINT b2bstatisticprocess_pkey PRIMARY KEY (sys);


--
-- TOC entry 2905 (class 2606 OID 26302)
-- Name: b2bsuppliertypedtl b2bsuppliertypedtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2bsuppliertypedtl
    ADD CONSTRAINT b2bsuppliertypedtl_pkey PRIMARY KEY (suppliertype, jobtitle);


--
-- TOC entry 2907 (class 2606 OID 26304)
-- Name: b2btrainingregistration b2btrainingregistration_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.b2btrainingregistration
    ADD CONSTRAINT b2btrainingregistration_pkey PRIMARY KEY (vendorid);


--
-- TOC entry 2909 (class 2606 OID 26306)
-- Name: i_importtablehist i_importtablehist_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.i_importtablehist
    ADD CONSTRAINT i_importtablehist_pkey PRIMARY KEY (sys);


--
-- TOC entry 2911 (class 2606 OID 26308)
-- Name: i_importtablelog i_importtablelog_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.i_importtablelog
    ADD CONSTRAINT i_importtablelog_pkey PRIMARY KEY (sys);


--
-- TOC entry 2913 (class 2606 OID 26310)
-- Name: inabcclass inabcclass_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.inabcclass
    ADD CONSTRAINT inabcclass_pkey PRIMARY KEY (classid);


--
-- TOC entry 2915 (class 2606 OID 26312)
-- Name: infkategori infkategori_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.infkategori
    ADD CONSTRAINT infkategori_pkey PRIMARY KEY (infkategoriid);


--
-- TOC entry 2917 (class 2606 OID 26314)
-- Name: infkategoridtl infkategoridtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.infkategoridtl
    ADD CONSTRAINT infkategoridtl_pkey PRIMARY KEY (infkategoridid);


--
-- TOC entry 2919 (class 2606 OID 26316)
-- Name: initem initem_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.initem
    ADD CONSTRAINT initem_pkey PRIMARY KEY (itemid);


--
-- TOC entry 2921 (class 2606 OID 26318)
-- Name: initemgroup initemgroup_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.initemgroup
    ADD CONSTRAINT initemgroup_pkey PRIMARY KEY (itemgroupid);


--
-- TOC entry 2923 (class 2606 OID 26320)
-- Name: initemmaterial initemmaterial_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.initemmaterial
    ADD CONSTRAINT initemmaterial_pkey PRIMARY KEY (id);


--
-- TOC entry 2925 (class 2606 OID 26322)
-- Name: initemstop initemstop_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.initemstop
    ADD CONSTRAINT initemstop_pkey PRIMARY KEY (itemid, startdate, enddate);


--
-- TOC entry 2927 (class 2606 OID 26475)
-- Name: intransdtl intransdtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.intransdtl
    ADD CONSTRAINT intransdtl_pkey PRIMARY KEY (siteid, sys, lineno);


--
-- TOC entry 2929 (class 2606 OID 26481)
-- Name: intransdtllogdispute intransdtllogdispute_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.intransdtllogdispute
    ADD CONSTRAINT intransdtllogdispute_pkey PRIMARY KEY (siteid, sys, counter, lineno, dispute);


--
-- TOC entry 2931 (class 2606 OID 26455)
-- Name: intranshdr intranshdr_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.intranshdr
    ADD CONSTRAINT intranshdr_pkey PRIMARY KEY (siteid, sys);


--
-- TOC entry 2933 (class 2606 OID 26465)
-- Name: intranshdrupload intranshdrupload_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.intranshdrupload
    ADD CONSTRAINT intranshdrupload_pkey PRIMARY KEY (siteid, sys, lineno);


--
-- TOC entry 2935 (class 2606 OID 26461)
-- Name: intranstaxdtl intranstaxdtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.intranstaxdtl
    ADD CONSTRAINT intranstaxdtl_pkey PRIMARY KEY (siteid, sys, lineno, typeid);


--
-- TOC entry 2937 (class 2606 OID 26457)
-- Name: loginsites loginsites_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.loginsites
    ADD CONSTRAINT loginsites_pkey PRIMARY KEY (loginid, siteid);


--
-- TOC entry 2939 (class 2606 OID 26477)
-- Name: pstransdtl pstransdtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pstransdtl
    ADD CONSTRAINT pstransdtl_pkey PRIMARY KEY (siteid, sys, lineno);


--
-- TOC entry 2941 (class 2606 OID 26473)
-- Name: pstranshdr pstranshdr_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pstranshdr
    ADD CONSTRAINT pstranshdr_pkey PRIMARY KEY (siteid, sys);


--
-- TOC entry 2943 (class 2606 OID 26463)
-- Name: pstranstaxdtl pstranstaxdtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pstranstaxdtl
    ADD CONSTRAINT pstranstaxdtl_pkey PRIMARY KEY (siteid, sys, lineno, typeid);


--
-- TOC entry 2945 (class 2606 OID 26342)
-- Name: pxapprovalset pxapprovalset_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxapprovalset
    ADD CONSTRAINT pxapprovalset_pkey PRIMARY KEY (appsetid);


--
-- TOC entry 2947 (class 2606 OID 26344)
-- Name: pxcompanyinfo pxcompanyinfo_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxcompanyinfo
    ADD CONSTRAINT pxcompanyinfo_pkey PRIMARY KEY (entityid);


--
-- TOC entry 2949 (class 2606 OID 26346)
-- Name: pxconfig pxconfig_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxconfig
    ADD CONSTRAINT pxconfig_pkey PRIMARY KEY (config, scope, scopeid);


--
-- TOC entry 2951 (class 2606 OID 26348)
-- Name: pxcurrency pxcurrency_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxcurrency
    ADD CONSTRAINT pxcurrency_pkey PRIMARY KEY (currencyid);


--
-- TOC entry 2953 (class 2606 OID 26350)
-- Name: pxdeliverymtd pxdeliverymtd_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxdeliverymtd
    ADD CONSTRAINT pxdeliverymtd_pkey PRIMARY KEY (deliverymtdid);


--
-- TOC entry 2955 (class 2606 OID 26352)
-- Name: pxentity pxentity_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxentity
    ADD CONSTRAINT pxentity_pkey PRIMARY KEY (entityid);


--
-- TOC entry 3019 (class 2606 OID 26822)
-- Name: pxexceptionlog pxexceptionlog_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxexceptionlog
    ADD CONSTRAINT pxexceptionlog_pkey PRIMARY KEY (sys);


--
-- TOC entry 2957 (class 2606 OID 26354)
-- Name: pxformset pxformset_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxformset
    ADD CONSTRAINT pxformset_pkey PRIMARY KEY (id);


--
-- TOC entry 3021 (class 2606 OID 26830)
-- Name: pxloginstatus pxloginstatus_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxloginstatus
    ADD CONSTRAINT pxloginstatus_pkey PRIMARY KEY (loginid);


--
-- TOC entry 2959 (class 2606 OID 26570)
-- Name: pxnumbering pxnumbering_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxnumbering
    ADD CONSTRAINT pxnumbering_pkey PRIMARY KEY (trtype, seqset);


--
-- TOC entry 2961 (class 2606 OID 26358)
-- Name: pxperiod pxperiod_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxperiod
    ADD CONSTRAINT pxperiod_pkey PRIMARY KEY (periodid);


--
-- TOC entry 2963 (class 2606 OID 26360)
-- Name: pxpreserved pxpreserved_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxpreserved
    ADD CONSTRAINT pxpreserved_pkey PRIMARY KEY (moduleid, userid, preserved, grouped);


--
-- TOC entry 2965 (class 2606 OID 26362)
-- Name: pxreason pxreason_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxreason
    ADD CONSTRAINT pxreason_pkey PRIMARY KEY (reasonid);


--
-- TOC entry 2967 (class 2606 OID 26364)
-- Name: pxsetup pxsetup_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxsetup
    ADD CONSTRAINT pxsetup_pkey PRIMARY KEY (id);


--
-- TOC entry 2969 (class 2606 OID 26469)
-- Name: pxsite pxsite_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxsite
    ADD CONSTRAINT pxsite_pkey PRIMARY KEY (siteid);


--
-- TOC entry 2971 (class 2606 OID 26521)
-- Name: pxtrtype pxtrtype_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxtrtype
    ADD CONSTRAINT pxtrtype_pkey PRIMARY KEY (trtype);


--
-- TOC entry 2973 (class 2606 OID 26576)
-- Name: pxtrtypeusers pxtrtypeusers_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxtrtypeusers
    ADD CONSTRAINT pxtrtypeusers_pkey PRIMARY KEY (trtype, loginid);


--
-- TOC entry 2975 (class 2606 OID 26372)
-- Name: pxxrate pxxrate_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxxrate
    ADD CONSTRAINT pxxrate_pkey PRIMARY KEY (xrperiod, ccy1, ccy2);


--
-- TOC entry 2977 (class 2606 OID 26374)
-- Name: pxxrperiod pxxrperiod_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxxrperiod
    ADD CONSTRAINT pxxrperiod_pkey PRIMARY KEY (xrperiod);


--
-- TOC entry 2979 (class 2606 OID 26376)
-- Name: pxxrtype pxxrtype_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxxrtype
    ADD CONSTRAINT pxxrtype_pkey PRIMARY KEY (xrtype);


--
-- TOC entry 2981 (class 2606 OID 26378)
-- Name: pxyear pxyear_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.pxyear
    ADD CONSTRAINT pxyear_pkey PRIMARY KEY (yearid);


--
-- TOC entry 2983 (class 2606 OID 26479)
-- Name: rppmtallocation rppmtallocation_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rppmtallocation
    ADD CONSTRAINT rppmtallocation_pkey PRIMARY KEY (siteid, catrsys, ca_detsys, no_);


--
-- TOC entry 3023 (class 2606 OID 26866)
-- Name: rptransdtl rptransdtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rptransdtl
    ADD CONSTRAINT rptransdtl_pkey PRIMARY KEY (siteid, sys, lineno);


--
-- TOC entry 2985 (class 2606 OID 26471)
-- Name: rptranshdr rptranshdr_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rptranshdr
    ADD CONSTRAINT rptranshdr_pkey PRIMARY KEY (siteid, sys);


--
-- TOC entry 2987 (class 2606 OID 26467)
-- Name: rptranshdrrejectlog rptranshdrrejectlog_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rptranshdrrejectlog
    ADD CONSTRAINT rptranshdrrejectlog_pkey PRIMARY KEY (siteid, sys, lineno);


--
-- TOC entry 2989 (class 2606 OID 26527)
-- Name: rptrtype rptrtype_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rptrtype
    ADD CONSTRAINT rptrtype_pkey PRIMARY KEY (trtype);


--
-- TOC entry 2991 (class 2606 OID 26582)
-- Name: rptrtypeusers rptrtypeusers_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.rptrtypeusers
    ADD CONSTRAINT rptrtypeusers_pkey PRIMARY KEY (trtype, loginid);


--
-- TOC entry 3015 (class 2606 OID 26752)
-- Name: s_intransdtl s_intransdtl_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_intransdtl
    ADD CONSTRAINT s_intransdtl_pkey PRIMARY KEY (id);


--
-- TOC entry 3013 (class 2606 OID 26720)
-- Name: s_intranshdr s_intranshdr_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_intranshdr
    ADD CONSTRAINT s_intranshdr_pkey PRIMARY KEY (id);


--
-- TOC entry 3017 (class 2606 OID 26781)
-- Name: s_pstranshdr s_pstranshdr_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.s_pstranshdr
    ADD CONSTRAINT s_pstranshdr_pkey PRIMARY KEY (id);


--
-- TOC entry 2993 (class 2606 OID 26390)
-- Name: securitynode securitynode_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.securitynode
    ADD CONSTRAINT securitynode_pkey PRIMARY KEY (groupid, form, description);


--
-- TOC entry 2995 (class 2606 OID 26392)
-- Name: securitynodeitem securitynodeitem_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.securitynodeitem
    ADD CONSTRAINT securitynodeitem_pkey PRIMARY KEY (groupid, form, description, element);


--
-- TOC entry 2997 (class 2606 OID 26394)
-- Name: securitynoderole securitynoderole_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.securitynoderole
    ADD CONSTRAINT securitynoderole_pkey PRIMARY KEY (roleid, form, description);


--
-- TOC entry 2999 (class 2606 OID 26396)
-- Name: securitynoderoleitem securitynoderoleitem_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.securitynoderoleitem
    ADD CONSTRAINT securitynoderoleitem_pkey PRIMARY KEY (roleid, form, description, element);


--
-- TOC entry 3001 (class 2606 OID 26398)
-- Name: useractivedirectory useractivedirectory_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.useractivedirectory
    ADD CONSTRAINT useractivedirectory_pkey PRIMARY KEY (sys);


--
-- TOC entry 3003 (class 2606 OID 26550)
-- Name: usergroup usergroup_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.usergroup
    ADD CONSTRAINT usergroup_pkey PRIMARY KEY (groupid);


--
-- TOC entry 3007 (class 2606 OID 26402)
-- Name: userlogin_delete userlogin_delete_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.userlogin_delete
    ADD CONSTRAINT userlogin_delete_pkey PRIMARY KEY (userid);


--
-- TOC entry 3005 (class 2606 OID 26404)
-- Name: userlogin userlogin_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.userlogin
    ADD CONSTRAINT userlogin_pkey PRIMARY KEY (userid);


--
-- TOC entry 3009 (class 2606 OID 26406)
-- Name: userrole userrole_pkey; Type: CONSTRAINT; Schema: dba; Owner: postgres
--

ALTER TABLE ONLY dba.userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (roleid);


--
-- TOC entry 3011 (class 2606 OID 26408)
-- Name: usersession usersession_pkey; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.usersession
    ADD CONSTRAINT usersession_pkey PRIMARY KEY (userid);


--
-- TOC entry 2854 (class 2606 OID 25685)
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- TOC entry 2855 (class 1259 OID 25686)
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- TOC entry 3039 (class 2620 OID 26451)
-- Name: pxcompanyinfo aft_insert_entity; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER aft_insert_entity BEFORE INSERT ON dba.pxcompanyinfo FOR EACH ROW EXECUTE PROCEDURE dba.aft_insert_entity();


--
-- TOC entry 3046 (class 2620 OID 26548)
-- Name: usergroup aft_insert_usergroup; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER aft_insert_usergroup AFTER INSERT ON dba.usergroup FOR EACH ROW EXECUTE PROCEDURE dba.aft_insert_usergroup();


--
-- TOC entry 3042 (class 2620 OID 26843)
-- Name: rptranshdr afterUpd_Approved_RPTransHdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER "afterUpd_Approved_RPTransHdr" AFTER UPDATE OF approved ON dba.rptranshdr FOR EACH ROW EXECUTE PROCEDURE dba.afterupd_approved_rptranshdr();


--
-- TOC entry 3036 (class 2620 OID 26813)
-- Name: pstranshdr after_insert_PO_Hdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER "after_insert_PO_Hdr" AFTER INSERT ON dba.pstranshdr FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_po_hdr();


--
-- TOC entry 3032 (class 2620 OID 26835)
-- Name: intranshdr after_insert_grn; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_grn AFTER INSERT ON dba.intranshdr FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_grn();


--
-- TOC entry 3028 (class 2620 OID 26834)
-- Name: intransdtl after_insert_grn_dtl; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_grn_dtl AFTER INSERT ON dba.intransdtl FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_grn_dtl();


--
-- TOC entry 3027 (class 2620 OID 26811)
-- Name: initem after_insert_initem; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_initem AFTER INSERT ON dba.initem FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_initem();


--
-- TOC entry 3035 (class 2620 OID 26837)
-- Name: pstransdtl after_insert_podtl; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_podtl AFTER INSERT ON dba.pstransdtl FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_podtl();


--
-- TOC entry 3041 (class 2620 OID 26824)
-- Name: rptranshdr after_insert_rp_hdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_rp_hdr AFTER INSERT ON dba.rptranshdr FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_rp_hdr();


--
-- TOC entry 3025 (class 2620 OID 26438)
-- Name: apsupplier after_insert_supplier; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_supplier AFTER INSERT ON dba.apsupplier FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_supplier();


--
-- TOC entry 3047 (class 2620 OID 26447)
-- Name: userlogin after_insert_userlogin; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_insert_userlogin AFTER INSERT ON dba.userlogin FOR EACH ROW EXECUTE PROCEDURE dba.after_insert_userlogin();


--
-- TOC entry 3026 (class 2620 OID 26875)
-- Name: apsupplier after_update_groupid; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER after_update_groupid AFTER UPDATE OF groupa_id ON dba.apsupplier FOR EACH ROW EXECUTE PROCEDURE dba.after_update_groupid();


--
-- TOC entry 3033 (class 2620 OID 26847)
-- Name: intranshdr b4Upd_Approved_Return; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER "b4Upd_Approved_Return" BEFORE UPDATE OF approved ON dba.intranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4upd_approved_return();


--
-- TOC entry 3043 (class 2620 OID 26844)
-- Name: rptranshdr b4Upd_Printed_RPTransHdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER "b4Upd_Printed_RPTransHdr" BEFORE UPDATE OF printed ON dba.rptranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4upd_printed_rptranshdr();


--
-- TOC entry 3037 (class 2620 OID 26839)
-- Name: pstranshdr b4Update_Approved_PSTranshdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER "b4Update_Approved_PSTranshdr" BEFORE UPDATE ON dba.pstranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4update_approved_pstranshdr();


--
-- TOC entry 3040 (class 2620 OID 26453)
-- Name: pxcompanyinfo b4_update_entity; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4_update_entity BEFORE UPDATE ON dba.pxcompanyinfo FOR EACH ROW EXECUTE PROCEDURE dba.b4_update_entity();


--
-- TOC entry 3038 (class 2620 OID 26868)
-- Name: pstranshdr b4ins_trans; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4ins_trans BEFORE INSERT OR UPDATE ON dba.pstranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4ins_trans();


--
-- TOC entry 3034 (class 2620 OID 26869)
-- Name: intranshdr b4ins_trans; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4ins_trans BEFORE INSERT OR UPDATE ON dba.intranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4ins_trans();


--
-- TOC entry 3045 (class 2620 OID 26870)
-- Name: rptranshdr b4ins_trans; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4ins_trans BEFORE INSERT OR UPDATE ON dba.rptranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4ins_trans();


--
-- TOC entry 3029 (class 2620 OID 26411)
-- Name: intranshdr b4upd_invoicesupplier; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4upd_invoicesupplier BEFORE UPDATE ON dba.intranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4upd_invoicesupplier();


--
-- TOC entry 3030 (class 2620 OID 26412)
-- Name: intranshdr b4upd_posted_intranshdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4upd_posted_intranshdr BEFORE UPDATE ON dba.intranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4upd_posted_intranshdr();


--
-- TOC entry 3031 (class 2620 OID 26413)
-- Name: intranshdr b4upd_printed_intranshdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER b4upd_printed_intranshdr BEFORE UPDATE ON dba.intranshdr FOR EACH ROW EXECUTE PROCEDURE dba.b4upd_printed_intranshdr();


--
-- TOC entry 3044 (class 2620 OID 26845)
-- Name: rptranshdr beforeUpd_Posted_RPTransHdr; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER "beforeUpd_Posted_RPTransHdr" BEFORE UPDATE OF posted ON dba.rptranshdr FOR EACH ROW EXECUTE PROCEDURE dba.beforeupd_posted_rptranshdr();


--
-- TOC entry 3048 (class 2620 OID 26831)
-- Name: pxloginstatus update_modified_column; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER update_modified_column BEFORE INSERT OR UPDATE ON dba.pxloginstatus FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- TOC entry 3024 (class 2620 OID 26434)
-- Name: apsupplier update_supplier_modtime; Type: TRIGGER; Schema: dba; Owner: postgres
--

CREATE TRIGGER update_supplier_modtime BEFORE INSERT OR UPDATE ON dba.apsupplier FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- TOC entry 3174 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2019-01-22 08:40:07 WIB

--
-- PostgreSQL database dump complete
--

