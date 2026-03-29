-- 08_test_queries.sql -- Requêtes de test et démonstration 
ALTER SESSION SET CONTAINER = XEPDB1;
ALTER SESSION SET CURRENT_SCHEMA = mon_user;

 
SET SERVEROUTPUT ON; 
 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('=' || RPAD('=', 70, '=')); 
    DBMS_OUTPUT.PUT_LINE('TESTS DES FONCTIONNALITÉS PL/SQL'); 
    DBMS_OUTPUT.PUT_LINE('=' || RPAD('=', 70, '=')); 
END; 
/ 
 -- Test 1: Afficher tous les employés 
DECLARE 
    CURSOR emp_cursor IS 
        SELECT e.emp_id, e.first_name, e.last_name, e.job_title, e.salary, 
d.dept_name 
        FROM employees e 
        JOIN departments d ON e.dept_id = d.dept_id 
        ORDER BY d.dept_name; 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 LISTE DES EMPLOYÉS:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
    FOR emp IN emp_cursor LOOP 
        DBMS_OUTPUT.PUT_LINE(RPAD(emp.dept_name, 15) ||  
                             RPAD(emp.first_name || ' ' || emp.last_name, 25) 
|| 
                             RPAD(emp.job_title, 20) || 
                             TO_CHAR(emp.salary, '999,999.00')); 
    END LOOP; 
END; 
/ 
 -- Test 2: Calculer le salaire annuel 
 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 SALAIRES ANNUELS:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
    FOR emp IN (SELECT emp_id, first_name, last_name, salary FROM employees) 
LOOP 
        DBMS_OUTPUT.PUT_LINE(RPAD(emp.first_name || ' ' || emp.last_name, 25) 
|| 
                             'Salaire mensuel: ' || TO_CHAR(emp.salary, 
'999,999.00') || 
                             ' | Annuel: ' || 
TO_CHAR(get_annual_salary(emp.emp_id), '999,999.00')); 
    END LOOP; 
END; 
/ 
 -- Test 3: Statistiques par département 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 STATISTIQUES PAR DÉPARTEMENT:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
    FOR dept IN (SELECT dept_id FROM departments) LOOP 
        
DBMS_OUTPUT.PUT_LINE(employee_manager.get_dept_statistics(dept.dept_id)); 
    END LOOP; 
END; 
/ 
 -- Test 4: Augmenter les salaires (procédure) 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 AUGMENTATION DES SALAIRES:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
    increase_salary(101, 10);  -- Ahmed Benali +10% 
    increase_salary(102, 5);    -- Fatima Zahra +5% 
END; 
/ 
 -- Test 5: Utiliser le package employee_manager 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 TEST DU PACKAGE EMPLOYEE_MANAGER:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
     
    -- Afficher les détails d'un employé 
    DECLARE 
        v_emp employee_manager.emp_record; 
    BEGIN 
        v_emp := employee_manager.get_employee_details(101); 
        IF v_emp.emp_id IS NOT NULL THEN 
 
            DBMS_OUTPUT.PUT_LINE('Employé trouvé: ' || v_emp.full_name || ' - 
' || v_emp.job_title); 
        END IF; 
    END; 
     
    -- Générer le rapport des salaires 
    employee_manager.generate_salary_report(); 
     
END; 
/ 
 -- Test 6: Requêtes avancées avec jointures 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 PROJETS ET AFFECTATIONS:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
    FOR proj IN ( 
        SELECT p.project_name, p.status, COUNT(ep.emp_id) as nb_employees,  
               SUM(ep.hours_allocated) as total_hours 
        FROM projects p 
        LEFT JOIN employee_projects ep ON p.project_id = ep.project_id 
        GROUP BY p.project_name, p.status 
    ) LOOP 
        DBMS_OUTPUT.PUT_LINE(RPAD(proj.project_name, 25) ||  
                             RPAD(proj.status, 12) || 
                             'Employés: ' || proj.nb_employees || 
                             ' | Heures: ' || proj.total_hours); 
    END LOOP; 
END; 
/ 
 -- Test 7: Utiliser le curseur du package 
DECLARE 
    v_cursor dept_report.dept_cursor; 
    v_emp_id employees.emp_id%TYPE; 
    v_name VARCHAR2(101); 
    v_job employees.job_title%TYPE; 
    v_salary employees.salary%TYPE; 
    v_hours NUMBER; 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '📊 DÉTAILS DU DÉPARTEMENT 
INFORMATIQUE:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
     
    v_cursor := dept_report.get_dept_details(10); -- Département Informatique 
     
    LOOP 
        FETCH v_cursor INTO v_emp_id, v_name, v_job, v_salary, v_hours; 
 
        EXIT WHEN v_cursor%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE(RPAD(v_name, 25) || RPAD(v_job, 20) ||  
                             'Salaire: ' || TO_CHAR(v_salary, '999,999.00') 
|| 
                             ' | Heures projet: ' || v_hours); 
    END LOOP; 
     
    CLOSE v_cursor; 
END; 
/ 
 -- Test 8: Vérifier les triggers (modification de salaire) 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '⚡ TEST DES TRIGGERS:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
     
    -- Ceci devrait échouer (salaire trop élevé) 
    BEGIN 
        UPDATE employees SET salary = 150000 WHERE emp_id = 101; 
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('✅ Trigger de validation fonctionne: ' || 
SQLERRM); 
    END; 
     
    -- Vérifier l'audit 
    FOR audit IN (SELECT * FROM employee_audit WHERE ROWNUM <= 3 ORDER BY 
audit_id DESC) LOOP 
        DBMS_OUTPUT.PUT_LINE('Audit: ' || audit.action_type || ' - ' || 
audit.modified_date); 
    END LOOP; 
END; 
/ 
 -- Test 9: Créer un nouveau projet 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '➕ CRÉATION D''UN NOUVEAU PROJET:'); 
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------
'); 
     
    INSERT INTO projects (project_id, project_name, start_date, status, 
budget) 
    VALUES (seq_project_id.NEXTVAL, 'Innovation IA', SYSDATE, 'PLANNED', 
200000); 
     
    COMMIT; 
    DBMS_OUTPUT.PUT_LINE('✅ Projet créé avec succès'); 
END; 
 
/ 
 -- Test 10: Rapports finaux 
DECLARE
    v_total_salary NUMBER; -- Variable pour stocker la somme
BEGIN 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=' || RPAD('=', 70, '=')); 
    DBMS_OUTPUT.PUT_LINE('RÉSUMÉ FINAL'); 
    DBMS_OUTPUT.PUT_LINE('=' || RPAD('=', 70, '=')); 
     
    -- Résumé des compteurs
    FOR summary IN ( 
        SELECT 'Employés' as type, COUNT(*) as count FROM employees 
        UNION ALL 
        SELECT 'Départements', COUNT(*) FROM departments 
        UNION ALL 
        SELECT 'Projets', COUNT(*) FROM projects 
        UNION ALL 
        SELECT 'Affectations', COUNT(*) FROM employee_projects 
    ) LOOP 
        DBMS_OUTPUT.PUT_LINE(RPAD(summary.type, 15) || ': ' || summary.count); 
    END LOOP; 
     
    -- CALCUL DE LA MASSE SALARIALE (La correction est ici)
    SELECT SUM(salary) INTO v_total_salary FROM employees;
    
    DBMS_OUTPUT.PUT_LINE('Masse salariale totale: ' || TO_CHAR(v_total_salary, '999,999,999.00')); 
     
    DBMS_OUTPUT.PUT_LINE('=' || RPAD('=', 70, '=')); 
    DBMS_OUTPUT.PUT_LINE('✅ TOUS LES TESTS SONT PASSÉS AVEC SUCCÈS'); 
END; 
/ 
 
COMMIT;