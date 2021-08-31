--Special Queries
--SpecialQuery1; to list male prisoners less than a year before their release, their unit and visiting days.
select distinct name, cell_id ,releasedate
from convicts c, imprisonmentPlace ip, crime c2, hascrime h2 
where date_part('year', (SELECT releasedate _timestamp))= date_part('year', (SELECT current_timestamp)) 
and c.id = ip.convict_id and c.id = h2.convict_id;

--SpecialQuery2; to list information about female prisoners who were.
--imprisoned before 2008 and who had children.
select *
from convicts c, crime c2, hascrime h2 
where c2.id = h2.crime_id and c.id = h2.convict_id and c.sex = 'female' and date_part('year', (SELECT c.releasedate _timestamp)) < 2008 and haschild = true;

--All convicts with their all crimes(three table join).
select  distinct (c.id, name), c3.crimename
from convicts c, hascrime h2, crime c3
natural join hascrime , crime 
where c.id = h2.convict_id and h2.crime_id = c3.id;

--Query to list all female convicts' name and surname.
select name
from convicts c
where c.sex = 'female';

--Query to list guards whose salary is greater than 45000 and group by their ranks in descending order.
select rank, salary  
from guards g
where g.salary > 130000
group by rank, salary 
order by rank desc;

--Query to list the union of convicts that had crime Arson or Bribery.
--also means all convicts that had murder crime.
(select name, c.id, cr.crimename from convicts c, crime cr where c.id = cr.id and cr.crimename = 'Arson') 
union 
(select name, c.id, cr.crimename from convicts c, crime cr where c.id = cr.id and cr.crimename = 'Bribery');

--Query to list the tranfer where the guard id is 8 and vehicle_id is 36 KC 2.
(select * from transfer t2 where t2.guard_id = '8') 
intersect 
(select * from transfer t2 where t2.vehicle_id = '36 KC 2' );

--Query to list guards who works on Friday but not on Wednesday.
select distinct (g2.name)
from guards g2 , doctors d2 , convicts c2
where  g2.id  in(
(select s2.id from schedules s2 natural join guards
where  s2.weekday = 'Friday') 
except 
(select id from schedules s2 where s2.weekday = 'Wednesday'));


--Query to list the average salary of doctors' whose expertise is Physician.
select avg(salary) as Physician_avgSalary
from doctors d 
where d.expertise = 'Physician';

--Query to list blocks where the count of convicts is greater than 3.
select count(convict_id), block_id 
from imprisonmentPlace ip, building b 
where ip.block_id = b.block 
group by block_id 
having count(convict_id) > 3;

--SUBQUERIES

--Query to list all male convicts with bachelor degree and having child.
select *
from convicts 
where  haschild = 'true' and sex = 'female' and 
id in (select id 
       from convicts
       where educationdegree = 'bachelors'
       );

--Query to list all convicts whose degree is neither primary nor secondary.
select distinct name, id
from convicts c 
where educationdegree not in ('primary','secondary');

--Find all transfers with both the given id and place.
select *
from transfer t    
where t.vehicle_id = '15 AC 4'and 
exists (select *
   		from transfer t2
   		where t2.place = 'Sweden'
   		and t.id = t2.id);

--Query to list all convicts who is not in the block A.
select c2.name, c2.id 
from imprisonmentplace i, convicts c2  
where c2.id = i.convict_id  and not exists (select *
		          from imprisonmentplace i 
		          where c2.id = i.convict_id and i.block_id = 'A');


--List all blocks along with the number of convicts in each block.
   	--Scalar subquery
select block, 
		(select count(*)
		 from convicts c2, imprisonmentPlace ip
		 where c2.id = ip.convict_id and ip.block_id = building.block 
		) as num_convicts
from building;

--Query to list all ranks' avg salaries that are greater than 120000.
select rank, avg_salary 
from(select rank, avg(g2.salary)
	 from guards g2
	 group by rank )
	 as rank_avg(rank, avg_salary)
where avg_salary > 120000;

--Query to list visitors who do not have phone number.
select name, v.phonenumber, v.kinshipdegree 
from visitors v 
where phonenumber is NULL;


--Query to list all visitings  where the duration is between 3 min and 20 min.
select *
from visits v 
where v.visitduration between '00:03:00' and '00:20:00';

--Query to list the visitors who arrived in the given range.
select *
from visits v 
where v.arrival between '2006-10-10' and '2011-12-12';

--Query to return the largest guard salary.
select max(salary) as largest_gsalary
from guards g;

--Query to return smallest punishment duration in days.
select min(punishmentduration) as min_punishment
from crime;

--Query to list names with the desired start. 
select d.name as doctor_name, g.name as guard_name, c.name as convict_name
from doctors d, guards g, convicts c 
where d.name like 'Se%' and g.name like 'Uf%' and c.name like 'T%';

--Query to list all vehicle which includes string 'AC'.--OK
select vehicle_id, id 
from transfer t 
where t.vehicle_id like '%AC%';

--Query to list convicts who stays at cell where cell_id starts with A and at least 4 characters in length.
select convict_id, cell_id 
from imprisonmentplace 
where cell_id in (select i.cell_id 
from imprisonmentplace i
where i.cell_id like '%A___');

/*Query to list all transfers where the transfer place name starts with N,D OR E.
select place ,id 
from transfer 
where place like '[E-S]%'; This operation is not working on postgres.
*/
--Query to list all some visitors whose kinshipdegree is equal to 1.
select v2.id, v2.name, v2.kinshipdegree 
from visitors v2 
where v2.id = some
  (select id 
  from visitors v2 
  where v2.kinshipdegree = 1);
 
 --Query to list doctors whose salary is equal to all doctors' salary in the subquery.
select d2.name, d2.expertise 
from doctors d2 
where d2.id = all
  (select id
   from doctors d2
   where d2.salary = 100000);


--All visits with the name of convicts and ids' of visitors.
select name, v2.visitor_id, v2.arrival 
from convicts c natural join visits v2 
where c.id = v2.convict_id ;

--Query to list all convicts with their addresses.
select *
from convicts c left outer join address a2
on c.id = a2.convict_id;

--Query to list all transfers with all information.
select * 
from convicts c right outer join transfer t2 
on c.id = t2.convict_id;

--Query to list all visits along with the vsitors, where some of them did not visit.
select name, v2.arrival 
from visits v2 full outer join visitors v
on v2.visitor_id = v.id;

--Query to list paid workers with the schedule who works on Friday but not on Wednesday.
select idnpre, name
from
((select  distinct (g.id, g.prefix) as idnpre, g.name
from guards g
right join  doctors  on g.id > 0
)
union
(select  distinct (d.id, d.prefix) as dname, d.name 
from guards g, doctors d 
left join  doctors guards on d.id > 0)) as y
where idnpre in 
(select (s2.id, s2.prefix) as out  from schedules s2
where  s2.weekday = 'Friday' 
except select (id, prefix) from schedules s3 where s3.weekday = 'Wednesday');








