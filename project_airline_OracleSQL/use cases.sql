
/*
Find departments where the average salary is higher than the average salary of employees from the Help Desk department (dep_id=5)
Display the department ID, its name and the average salary of its employees. Sort the results in ascending order by department ID.
*/

SELECT e.dep_id, d.name, ROUND(AVG(e.salary),2)"average salary" FROM employees e JOIN departments d ON e.dep_id=d.dep_id WHERE e.dep_id IS NOT NULL
GROUP BY e.dep_id, d.name HAVING ROUND(AVG(e.salary),2) > (SELECT ROUND(AVG(salary),2) FROM employees WHERE dep_id=5) ORDER BY e.dep_id;




/*
Display the names of the departure and arrival airports, flight length, date of departure, aircraft models for flights departing from
the USA, Turkey and the UK. Present the flight length in the form Hours:minutes
*/

SELECT a_dep.name "DEPARTURE",a_arr.name "ARRIVAL", c.name "COUNTRY",
TO_CHAR( FLOOR (r.duration / 60))|| ':'||TO_CHAR(MOD(r.duration, 60),'FM00')"DURATION",
f.departure"DATE",aplanes.model 
FROM flights f 
JOIN routes r ON f.route_id=r.route_id 
JOIN airports a_dep ON a_dep.airport_id=r.departure_id
JOIN airports a_arr ON a_arr.airport_id=r.arrival_id
JOIN countries c ON c.country_id = a_dep.country_id 
JOIN airplanes aplanes ON aplanes.airplane_id = r.airplane_id 
WHERE a_dep.country_id IN ('US', 'TR','UK') ;




/*
For each employee, show employee ID, the combined first and last name, the name 
of the department he/she works in, and the number of flights he/she has been on.
*/


SELECT e.emp_id, SUBSTR(e.name,1,1) ||'. ' || e.surname "Employee",d.name"department", (       
	SELECT COUNT(fe.emp_id) 
	FROM flight_employee fe
	WHERE  fe.emp_id = e.emp_id   
) as Flights_Count
FROM employees e 
JOIN departments d ON e.dep_id=d.dep_id 
ORDER BY Flights_Count desc;



/*
For tickets with fees, show their ID, departure and arrival place, flight class name and whether there is VIP included .
*/

SELECT t.ticket_id, apr.name "departure",apa.name"arrival",tc.name"travel class", NVL(tc.vip_lounge,'N')"VIP included" FROM tickets t 
JOIN travel_classes tc ON t.tc_id=tc.tc_id
JOIN flights f ON f.flight_id = t.flight_id
JOIN routes r ON r.route_id = f.route_id
JOIN airports apa ON apa.airport_id = r.arrival_id
JOIN airports apr ON r.departure_id=apr.airport_id
WHERE t.ticket_id in (SELECT  DISTINCT ticket_id FROM ticket_charge);



/*
Select flights operated by Boening aircraft, only performed by the end of February 2022. 
 */

SELECT f.flight_id, r.airplane_id,a.manufacturer,ad.name"DEPARTURE",f.departure"DATE"
FROM routes r 
JOIN airports ad ON r.departure_id= ad.airport_id
JOIN flights f ON f.route_id=r.route_id
JOIN airplanes a ON r.airplane_id = a.airplane_id
WHERE a.manufacturer='Boeing' AND f.departure <  to_date('01 MAR 2022', 'DD MON YYYY');

/*
Which employees receive the highest salary among employees assigned to the same group department?
Display the department, employee's name, salary and job seniority in months.

*/

SELECT 
d.name"Department",e.name, e.surnSame, e.salary, ROUND(MONTHS_BETWEEN (SYSDATE, hire_date),0)"work exp(months)" 
FROM employees e 
JOIN departments d ON e.dep_id = d.dep_id
WHERE salary = (SELECT MAX(salary) FROM employees WHERE dep_id = e.dep_id);



/*
Find passengers who have flown to or landed in their country of origin.
Display first name, last name, ticket_id, country,airport names covering the route from the ticket. 
*/


SELECT p.surname, t.ticket_id, p.country_id"country", aport_dep.name"departure", aport_arr.name"arrival" FROM flights f
JOIN tickets t ON t.flight_id = f.flight_id
JOIN routes r ON r.route_id = f.route_id
JOIN passengers p ON t.p_id = p.p_id
JOIN airports aport_dep ON r.departure_id = aport_dep.airport_id
JOIN airports aport_arr ON r.arrival_id = aport_arr.airport_id
WHERE p.country_id=aport_dep.country_id OR p.country_id=aport_arr.country_id;



/*
For each flight, enter the flight id, the initials of the pilot who operated the flight, the number of tickets purchased. 
Sort the results in descending order of the number of tickets purchased.
*/


SELECT f.flight_id, SUBSTR(e.name,1,1)|| '.'|| SUBSTR(e.surname,1,1)||'.'"Pilot", (
SELECT COUNT(t.ticket_id)
FROM tickets t 
WHERE t.flight_id = f.flight_id
)as Tickets_Count
FROM flights f 
JOIN flight_employee fe ON f.flight_id = fe.flight_id
JOIN employees e ON e.emp_id = fe.emp_id 
JOIN departments d ON d.dep_id = e.dep_id 
WHERE e.dep_id =3 ORDER BY Tickets_Count desc;







--- VIEWS   

--- ex 1 view

CREATE VIEW v_ex1(dep_id,name,avg_salary) AS SELECT 
e.dep_id, d.name, ROUND(AVG(e.salary),2)AS avg_salary FROM employees e JOIN departments d ON e.dep_id=d.dep_id WHERE e.dep_id IS NOT NULL
group by e.dep_id, d.name HAVING ROUND(AVG(e.salary),2) > (SELECT ROUND(AVG(salary),2) FROM employees WHERE dep_id=5);

CREATE SYNONYM z1 FOR  v_ex1;

--- ex 2

CREATE VIEW v_ex2 AS SELECT 
a_dep.name "DEPARTURE",a_arr.name "ARRIVAL", c.name "COUNTRY",
TO_CHAR(FLOOR(r.duration / 60))|| ':'||TO_CHAR(MOD(r.duration, 60),'FM00')"DURATION",
f.departure"DATE", aplanes.model"AIRPLANE_MODEL"
FROM flights f 
JOIN routes r ON f.route_id=r.route_id 
JOIN airports a_dep ON a_dep.airport_id=r.departure_id
JOIN airports a_arr ON a_arr.airport_id=r.arrival_id
JOIN countries c ON c.country_id = a_dep.country_id 
JOIN airplanes aplanes ON aplanes.airplane_id = r.airplane_id 
WHERE a_dep.country_id IN ('US', 'TR','UK') ;

CREATE SYNONYM z2 FOR  v_ex2;

--- ex 3

CREATE VIEW v_ex3 AS SELECT 
e.emp_id, SUBSTR(e.name,1,1) ||'. ' || e.surname "Employee",d.name"department", (       
 	SELECT COUNT(fe.emp_id) 
	FROM flight_employee fe
	WHERE  fe.emp_id = e.emp_id   
) as Flights_Count
FROM employees e 
JOIN departments d ON e.dep_id=d.dep_id;

CREATE SYNONYM z3 FOR    v_ex3;



--- ex 4

CREATE VIEW v_ex4 AS
SELECT t.ticket_id, apr.name "departure",apa.name"arrival",tc.name"travel class", NVL(tc.vip_lounge,'N')"VIP included" FROM tickets t 
JOIN travel_classes tc ON t.tc_id=tc.tc_id
JOIN flights f ON f.flight_id = t.flight_id
JOIN routes r ON r.route_id = f.route_id
JOIN airports apa ON apa.airport_id = r.arrival_id
JOIN airports apr ON r.departure_id=apr.airport_id
WHERE t.ticket_id in (SELECT  DISTINCT ticket_id FROM ticket_charge);

CREATE SYNONYM z4 FOR    v_ex4;


--- ex 5

CREATE VIEW v_ex5 AS
SELECT f.flight_id, r.airplane_id,a.manufacturer,ad.name"DEPARTURE",f.departure"DATE"
FROM routes r 
JOIN airports ad ON r.departure_id= ad.airport_id
JOIN flights f ON f.route_id=r.route_id
JOIN airplanes a ON r.airplane_id = a.airplane_id
WHERE a.manufacturer='Boeing' AND f.departure <=  to_date('01 MAR 2022', 'DD MON YYYY');

CREATE SYNONYM z5 FOR    v_ex5;
--- ex 6


CREATE VIEW v_zad6 AS SELECT 
d.name"Department",e.name, e.surname, e.salary, ROUND(MONTHS_BETWEEN (SYSDATE, hire_date),0)"work exp(months)" 
FROM employees e 
JOIN departments d ON e.dep_id = d.dep_id
WHERE salary = (SELECT MAX(salary) FROM employees WHERE dep_id = e.dep_id);

CREATE SYNONYM z6 FOR   v_ex6;

--- ex 7

CREATE VIEW v_ex7 AS SELECT 
p.surname, t.ticket_id, p.country_id"country", aport_dep.name"departure", aport_arr.name"arrival" 
FROM flights f
JOIN tickets t ON t.flight_id = f.flight_id
JOIN routes r ON r.route_id = f.route_id
JOIN passengers p ON t.p_id = p.p_id
JOIN airports aport_dep ON r.departure_id = aport_dep.airport_id
JOIN airports aport_arr ON r.arrival_id = aport_arr.airport_id
WHERE p.country_id=aport_dep.country_id OR p.country_id=aport_arr.country_id;

CREATE SYNONYM z7 FOR   v_ex7;
--- ex 8

CREATE VIEW v_ex8 AS SELECT 
f.flight_id, SUBSTR(e.name,1,1)|| '.'|| SUBSTR(e.surname,1,1)||'.'"Pilot", (
SELECT COUNT(t.ticket_id)
FROM tickets t 
WHERE t.flight_id = f.flight_id
)as Tickets_Count
FROM flights f 
JOIN flight_employee fe ON f.flight_id = fe.flight_id
JOIN employees e ON e.emp_id = fe.emp_id 
JOIN departments d ON d.dep_id = e.dep_id 
WHERE e.dep_id =3;


CREATE SYNONYM z8 FOR    v_ex8;