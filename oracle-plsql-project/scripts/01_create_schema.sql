-- 01_create_schema.sql
-- Création du schéma et de l'utilisateur

-- Connexion en tant que SYSTEM pour créer l'utilisateur
ALTER SESSION SET CONTAINER = XEPDB1;

-- Créer l'utilisateur principal (sera utilisé par l'application)
-- Note : les variables APP_USER et APP_USER_PASSWORD de Docker créent déjà l'user, 
-- mais ce script assure les droits et la configuration.
CREATE USER mon_user IDENTIFIED BY mon_mdp
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

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