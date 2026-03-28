-- 03_insert_data.sql
-- Insertion des données de test

-- 1. Insertion des départements
INSERT INTO departments (dept_id, dept_name, location, budget) VALUES
(seq_dept_id.NEXTVAL, 'Informatique', 'Casablanca', 500000),
(seq_dept_id.NEXTVAL, 'Ressources Humaines', 'Rabat', 200000),
(seq_dept_id.NEXTVAL, 'Marketing', 'Casablanca', 300000),
(seq_dept_id.NEXTVAL, 'Finance', 'Tanger', 400000),
(seq_dept_id.NEXTVAL, 'Commercial', 'Marrakech', 350000);

-- 2. Insertion des employés (Utilise les IDs de la séquence)
INSERT INTO employees (emp_id, first_name, last_name, email, phone, hire_date, job_title, salary, dept_id) VALUES
(seq_emp_id.NEXTVAL, 'Ahmed', 'Benali', 'ahmed.benali@company.com', '0612345678', DATE '2020-01-15', 'Directeur Informatique', 80000, 10),
(seq_emp_id.NEXTVAL, 'Fatima', 'Zahra', 'fatima.zahra@company.com', '0623456789', DATE '2020-03-20', 'Développeur Senior', 60000, 10),
(seq_emp_id.NEXTVAL, 'Mohamed', 'El Amrani', 'mohamed.elamrani@company.com', '0634567890', DATE '2021-06-10', 'Développeur', 45000, 10),
(seq_emp_id.NEXTVAL, 'Khadija', 'Mansouri', 'khadija.mansouri@company.com', '0645678901', DATE '2021-01-05', 'Responsable RH', 55000, 11),
(seq_emp_id.NEXTVAL, 'Youssef', 'Karimi', 'youssef.karimi@company.com', '0656789012', DATE '2022-02-15', 'Chargé RH', 38000, 11);

-- 3. Mise à jour des managers (Maintenant que les employés existent)
UPDATE employees SET manager_id = 100 WHERE emp_id IN (101, 102);

-- 4. Insertion des projets
INSERT INTO projects (project_id, project_name, start_date, budget, status) VALUES
(seq_project_id.NEXTVAL, 'Migration Cloud', DATE '2024-01-01', 250000, 'ACTIVE'),
(seq_project_id.NEXTVAL, 'Application Mobile', DATE '2024-02-01', 150000, 'ACTIVE'),
(seq_project_id.NEXTVAL, 'Formation RH', DATE '2024-03-01', 50000, 'PLANNED');

-- 5. Affectation des employés aux projets
INSERT INTO employee_projects (emp_id, project_id, role, hours_allocated) VALUES
(101, 1000, 'Chef de projet', 160),
(102, 1000, 'Développeur', 140),
(101, 1001, 'Architecte', 80),
(104, 1002, 'Responsable Formation', 100);

COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('✅ Données de test insérées avec succès');
END;
/