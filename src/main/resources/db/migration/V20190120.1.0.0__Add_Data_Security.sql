INSERT INTO dba.c_security_permission (id, permission_label, permission_value) VALUES
('USER_LOGGED_IN', 'Get User Loggin Information', 'ROLE_USER_LOGGED_IN'),
('MASTER_ENTITY','Get Entity and Site Information','ROLE_MASTER_ENTITY');

INSERT INTO dba.c_security_role (id, description, name) VALUES
('SYSADMIN', 'System Admin', 'System Admin'),
('ADMINISTRATOR', 'Application Administrator Entity', 'Administrator Entity'),
('USER-ENTITY', 'Application User Entity', 'User Entity'),
('ADMIN-SUPPLIER', 'Application Administrator Supplier', 'Administrator Supplier'),
('USER-SUPPLIER', 'Application User Supplier', 'User Supplier');

INSERT INTO dba.c_security_role_permission (id_role, id_permission) VALUES
('SYSADMIN', 'USER_LOGGED_IN'),
('SYSADMIN', 'MASTER_ENTITY'),
('ADMINISTRATOR', 'USER_LOGGED_IN'),
('USER-ENTITY', 'USER_LOGGED_IN'),
('ADMIN-SUPPLIER', 'USER_LOGGED_IN'),
('USER-SUPPLIER', 'USER_LOGGED_IN');


INSERT INTO dba.c_security_user (id, active, user_name, id_role) VALUES
('admin', true,'admin', 'SYSADMIN');

INSERT INTO dba.c_security_user_password (id_user, password) VALUES
('admin', '$2a$08$LS3sz9Ft014MNaIGCEyt4u6VflkslOW/xosyRbinIF9.uaVLpEhB6');
