-- 01_create_schema.sql
-- Création du schéma et de l'utilisateur

-- Connexion en tant que SYSTEM pour créer l'utilisateur
ALTER SESSION SET CONTAINER = XEPDB1;


-- Accorder les privilèges de base
GRANT CONNECT, RESOURCE, CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, 
CREATE SEQUENCE, CREATE TRIGGER TO mon_user;
GRANT UNLIMITED TABLESPACE TO mon_user;

-- Se connecter en tant que l'utilisateur créé pour la suite
ALTER SESSION SET CURRENT_SCHEMA = mon_user;

-- Message de confirmation
BEGIN
 DBMS_OUTPUT.PUT_LINE('✅ Schema créé avec succès pour mon_user');
END;
/