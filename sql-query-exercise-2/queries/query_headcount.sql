SELECT  
    d.department_id,  
    d.department_name,  
    COUNT(e.employee_id) AS headcount  
FROM  
    departments d  
LEFT JOIN  
    employees e ON d.department_id = e.department_id  
GROUP BY  
    d.department_id, d.department_name  
ORDER BY  
    headcount DESC;
