SELECT  
    e.first_name,  
    e.last_name,  
    j.job_title,  
    d.department_name  
FROM  
    employees e  
JOIN  
    jobs j ON e.job_id = j.job_id 
JOIN  
    departments d ON e.department_id = d.department_id;
