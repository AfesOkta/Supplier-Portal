DROP TABLE dba.pxcompanyinfo Cascade;

CREATE TABLE dba.pxcompanyinfo (
    id character varying(255) NOT NULL,
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
    passauth character varying DEFAULT ''::character varying,
    CONSTRAINT pxcompanyinfo_pkey PRIMARY KEY (id),
    CONSTRAINT pxcompanyinfo_unique UNIQUE (entityid)
);


ALTER TABLE dba.pxcompanyinfo OWNER TO postgres;