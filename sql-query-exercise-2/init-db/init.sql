-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- Create jobs table
CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    job_title VARCHAR(100) NOT NULL
);

-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    job_id INT REFERENCES jobs(job_id),
    department_id INT REFERENCES departments(department_id)
);

-- Insert dummy job titles (they are irrelevant for this query)
INSERT INTO jobs (job_title) VALUES
('Job A'), ('Job B'), ('Job C');

-- Insert departments based on the image
INSERT INTO departments (department_id, department_name) VALUES
(5, 'Shipping'),
(3, 'Purchasing'),
(10, 'Finance'),
(8, 'Sales'),
(6, 'IT'),
(9, 'Executive'),
(11, 'Accounting'),
(2, 'Marketing'),
(7, 'Public Relations'),
(1, 'Administration'),
(4, 'Human Resources');

-- Insert employees (only job_id is needed to satisfy FK)
-- We'll distribute employees to match the headcount per department

-- Shipping (7 employees)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Shipping' || i, 1, 5 FROM generate_series(1,7) i;

-- Purchasing (6)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Purchasing' || i, 1, 3 FROM generate_series(1,6) i;

-- Finance (6)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Finance' || i, 1, 10 FROM generate_series(1,6) i;

-- Sales (6)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Sales' || i, 1, 8 FROM generate_series(1,6) i;

-- IT (5)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'IT' || i, 1, 6 FROM generate_series(1,5) i;

-- Executive (3)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Exec' || i, 1, 9 FROM generate_series(1,3) i;

-- Accounting (2)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Acc' || i, 1, 11 FROM generate_series(1,2) i;

-- Marketing (2)
INSERT INTO employees (first_name, last_name, job_id, department_id)
SELECT 'Emp', 'Mkt' || i, 1, 2 FROM generate_series(1,2) i;

-- Public Relations (1)
INSERT INTO employees (first_name, last_name, job_id, department_id)
VALUES ('Emp', 'PR1', 1, 7);

-- Administration (1)
INSERT INTO employees (first_name, last_name, job_id, department_id)
VALUES ('Emp', 'Admin', 1, 1);

-- Human Resources (1)
INSERT INTO employees (first_name, last_name, job_id, department_id)
VALUES ('Emp', 'HR1', 1, 4);
