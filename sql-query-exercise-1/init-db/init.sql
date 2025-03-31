-- Create departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
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

-- Insert departments (3 unique ones from image)
INSERT INTO departments (department_name) VALUES
('Administration'),  -- id 1
('Marketing'),       -- id 2
('Purchasing');      -- id 3

-- Insert job titles (6 from image)
INSERT INTO jobs (job_title) VALUES
('Administration Assistant'),       -- id 1
('Marketing Manager'),              -- id 2
('Marketing Representative'),       -- id 3
('Purchasing Manager'),             -- id 4
('Purchasing Clerk');               -- id 5

-- Insert employees exactly as per the image
INSERT INTO employees (first_name, last_name, job_id, department_id) VALUES
('Jennifer', 'Whalen', 1, 1),         -- Administration
('Michael', 'Hartstein', 2, 2),       -- Marketing
('Pat', 'Fay', 3, 2),                 -- Marketing
('Den', 'Raphaely', 4, 3),            -- Purchasing
('Alexander', 'Khoo', 5, 3),          -- Purchasing
('Shelli', 'Baida', 5, 3),            -- Purchasing
('Sigal', 'Tobias', 5, 3),            -- Purchasing
('Guy', 'Himuro', 5, 3),              -- Purchasing
('Karen', 'Colmenares', 5, 3);        -- Purchasing