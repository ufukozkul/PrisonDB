
CREATE TABLE convicts (
  id serial Unique,
  prefix char(1) default 'c' check(prefix = 'c'),
  name varchar(50),
  incarcerationDate timestamp,
  releasedate timestamp,
  hasChild boolean,
  sex char(6) CHECK (sex = 'male' OR sex = 'female'),
  birthdate date,
  phoneNumber varchar(20),
  educationdegree varchar(15) CHECK (educationdegree = 'primary' OR educationdegree = 'secondary' OR educationdegree = 'bachelors' OR educationdegree = 'masters' OR educationdegree = 'doctorate'),
  height int NOT NULL,
  weight int NOT null,
  primary key(id, prefix)

);



CREATE TABLE crime (
  id serial,
  crimeName  varchar(30) Unique,
  punishmentDuration int,
  primary key(id)
);

CREATE TABLE hasCrime(
	convict_id int,
	crime_id int,
	constraint FK_convictToHasCrime foreign key(convict_id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE,
	constraint FK_crimeToHasCrime foreign key(crime_id) references crime(id) ON UPDATE CASCADE ON DELETE CASCADE
	
);


CREATE TABLE visitors (
  id serial,
  name varchar(50),
  kinshipDegree int,
  phoneNumber varchar(20),
  primary key(id)
);


create table visits(

convict_id int,
visitor_id int,
 application timestamp,
 approval timestamp,
 arrival timestamp,
visitDuration time,
constraint FK_convictToVisit foreign key(convict_id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE,
constraint FK_visitorToVisit foreign key(visitor_id) references visitors(id) ON UPDATE CASCADE ON DELETE CASCADE

);

 

CREATE TABLE building (
  block char(1) Unique,
  floor int,
  primary key(block, floor)
);


create table imprisonmentPlace(
	convict_id int,
	cell_id varchar(5),
	block_id char,
	floor_id int,
	constraint FK_convictToImprisonmentPlace foreign key(convict_id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE,
	constraint FK_blockToImprisonmentPlace foreign key(block_id) references building(block) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE guards (
  id serial Unique,
  prefix char(1) default 'g' check(prefix = 'g'),
    name varchar(50),
  salary int,
  phoneNumber varchar(20),
  rank varchar(15),
  primary key(id, prefix)
);


CREATE TABLE address (
  convict_id int,
  address char(255),
  startDate date,
  endDate date,
  constraint FK_convictToAddress foreign key(convict_id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE

);


CREATE TABLE doctors (
  id serial Unique,
  prefix char(1) default 'd' check(prefix = 'd'),
  name varchar(50),
  salary int,
  phoneNumber varchar(20),
  expertise char(40),
  primary key(id, prefix)
  
);

CREATE TABLE schedules (
  id int,
  prefix char,
  block char,
  floor int,
  weekDay varchar(9) CHECK(weekDay = 'Monday' OR weekDay = 'Tuesday' OR weekDay = 'Wednesday' OR weekDay = 'Thursday' OR weekDay = 'Friday' OR weekDay = 'Saturday' OR weekDay = 'Sunday'),
  startTime time,
  endTime time,
  constraint FK_doctorToSchedule foreign key(id) references doctors(id) ON UPDATE CASCADE ON DELETE CASCADE,
  constraint FK_convictToSchedule foreign key(id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE,
  constraint FK_guardToSchedule foreign key(id) references guards(id) ON UPDATE CASCADE ON DELETE CASCADE
);


create table transfer(

id varchar(10),
convict_id int,
place varchar(50),
transfer_dateStart timestamp,
transfer_dateEnd timestamp,
vehicle_id varchar(7),
guard_id int,
primary key(id),
constraint FK_guardsToTranser foreign key(guard_id) references guards(id) ON UPDATE CASCADE ON DELETE CASCADE,
constraint FK_convictsToTranser foreign key(convict_id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE

);

create table victims(
id serial,
convicts_id int,
crime_id int,
name varchar(30),
phone varchar(20),
primary key(id, convicts_id, crime_id),
constraint FK_convictsToVictims foreign key(convicts_id) references convicts(id) ON UPDATE CASCADE ON DELETE CASCADE,
constraint FK_crimeToVictims foreign key(crime_id) references crime(id) ON UPDATE CASCADE ON DELETE CASCADE
);


/*-------------View Sample-----------------------------*/

create view transfers_2005 as
select t.id,t.transfer_datestart, t.transfer_dateend, t.place
from transfer t 
where date_part('year', (SELECT t.transfer_datestart _timestamp)) = 2005;


insert into transfers_2005 
values(166782, '2005-03-10 14:00:00', '2005-03-11 18:40:56', 'Ireland');




/*---------------SAMPLE UPDATES-----------------------*/

/*

update doctors 
set salary = 80000
where id = 1; /* where salary < 50000; */


update doctors 
set salary = 250000
where name = 'Seden Dora Acık';

update guards 
set salary = 80000
where id = 5; 

update transfer 
set place = 'Karadeniz'
where convict_id = 5; 

update schedules 
set floor = 2
where id = 5; 

update convicts 
set height = 193
where id = 5; 

update crime 
set punishmentduration = 5600
where id = 5; 

update visitors 
set kinshipdegree = 5
where id = 5; 

update visits 
set visitduration = '01:16:46'
where convict_id = 5; 

update imprisonmentplace 
set floor_id = 1
where convict_id = 5; 

update building 
set floor = 9
where block = 'E'; 

update address 
set address = 'East Tokyo 5th street'
where convict_id = 5; 

update transfers_2005
set place = 'Doras house'
where id = '166783';

*/

/*-----------SAMPLE DELETE-------------------------*/

/*
delete from doctors 
where salary < 11000;

delete from guards 
where salary < 10005; 

delete from transfer 
where convict_id = 5; 

delete from schedules 
where id = 5; 

delete from convicts 
where height < 150; 

delete from crime 
where id = 5; 

delete from visitors 
where id = 9; 

delete from visits 
where convict_id = 5; 

delete from imprisonmentplace 
where convict_id = 5; 

delete from building 
where block = 'E'; 

delete from address 
where convict_id = 5; 

delete from transfers_2005
where id = '166783';

*/


/*------------SAMPLE ALTER TABLE-----------------*/

/*
alter table doctors 
add zodiac varchar(50);

*/

/*--------------------Doctors Data-----------------------------*/

insert into doctors (name, salary, phonenumber, expertise)
values ('Seden Dora Acik' ,185000, '184 657 89 10', 'Brain Surgeon');

insert into doctors (name, salary, phonenumber, expertise)
values ('John Smith' ,120000, '190 751 05 18', 'Heart Surgeon');

insert into doctors (name, salary, phonenumber, expertise)
values ('Shang Yuu' ,140000, '465 752 01 97', 'Eye Surgeon');

insert into doctors (name, salary, phonenumber, expertise)
values ('Olph Brown' ,95000, '126 482 15 07', 'Psychlogist');

insert into doctors (name, salary, phonenumber, expertise)
values ('Adrian Brown' ,100000, '126 874 61 36', 'Physician');

insert into doctors (name, salary, phonenumber, expertise)
values ('Aria Chi' ,110000, '698 746 85 07', 'Physician');

insert into doctors (name, salary, phonenumber, expertise)
values ('Calla Green' ,98000, '594 419 21 60', 'Cardiologists');

insert into doctors (name, salary, phonenumber, expertise)
values ('Amelie Yellow' ,163000, '154 874 06 43', 'Anesthesiologists');

insert into doctors (name, salary, phonenumber, expertise)
values ('Bette Guetta' ,115000, '145 246 07 45', 'Immunologists');

insert into doctors (name, salary, phonenumber, expertise)
values ('Cassia Gamey' ,105000, '178 987 19 10', 'Dermatologists');

/*--------------------Guards Data-----------------------------*/


insert into guards (name, salary, phonenumber, rank)
values ('Ufuk Ozkul', 380000, '180 987 36 45', 'Fleet Admiral');

insert into guards (name, salary, phonenumber, rank)
values ('Alexander Smith', 146000, '180 946 16 95', 'Rear Admiral');

insert into guards (name, salary, phonenumber, rank)
values ('Andrew Johnson', 135000, '180 954 17 81', 'Captain');

insert into guards (name, salary, phonenumber, rank)
values ('Arnold Williams', 126000, '180 913 34 49', 'Commander');

insert into guards (name, salary, phonenumber, rank)
values ('Barrett Jones', 123000, '180 974 54 67', 'Lieutenant ');

insert into guards (name, salary, phonenumber, rank)
values ('Charles Garcia', 119000, '180 941 67 10', 'Chief');

insert into guards (name, salary, phonenumber, rank)
values ('Everett Miller', 114000, '180 919 56 87', 'Chief ');

insert into guards (name, salary, phonenumber, rank)
values ('Grant Davis', 111000, '180 914 04 69', 'Seaman ');

insert into guards (name, salary, phonenumber, rank)
values ('Kendrick Rodriguez', 109000, '180 905 78 90', 'Officer');

insert into guards (name, salary, phonenumber, rank)
values ('Ulric Martinez', 90000, '180 960 49 88', 'Officer');



/*--------------------Convicts Data-----------------------------*/



insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Tolgay Atinc Uzun', '2000-06-22 20:35:46', '2012-06-27 20:35:46', 'false', 'male', '1970-03-13', '463 216 15 78', 'masters', 182, 83);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Aurora Lopez', '2005-08-10 21:30:46', '2017-06-20 20:35:46', 'true', 'female', '1980-01-10', '463 215 16 20', 'secondary', 188, 72);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Beckett Gonzales', '2004-01-16 16:35:40', '2013-07-27 20:35:46', 'true', 'female', '1972-02-21', '463 269 21 22', 'primary', 173, 106);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Daisy Taylor', '2003-10-26 04:10:28', '2014-10-27 20:35:46', 'true', 'female', '1975-12-07', '463 210 65 55', 'bachelors', 175, 97);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Dune Moore', '2002-06-11 06:20:14', '2010-06-27 20:35:46', 'false', 'male', '1960-02-18', '463 265 45 55', 'primary', 160, 95);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Julian Martin', '2001-05-15 10:30:16', '2009-06-27 20:35:46', 'true', 'male', '1962-01-13', '463 211 57 89', 'secondary', 165, 81);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Kai Lee', '2007-04-25 15:43:36', '2009-06-27 20:35:46', 'true', 'male', '1964-04-07', '463 230 56 00', 'primary', 170, 85);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Leo White', '2008-06-09 23:52:26', '2012-06-27 20:35:46', 'false', 'male', '1966-08-20', '463 287 78 80', 'doctorate', 176, 90);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Luna Young', '2009-08-13 22:59:41', '2019-06-27 20:35:46', 'false', 'female', '1985-10-13', '463 247 87 77', 'masters', 185, 69);

insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)
values ('Skye Walker', '2010-12-05 14:19:40', '2018-06-27 20:35:46', 'false', 'female', '1988-05-13', '463 216 87 70', 'primary', 190, 73);

/*--------------------Schedules Data-----------------------------*/

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'g', 'A', 4, 'Monday', '10:00:00', '16:00:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'g', 'A', 2, 'Wednesday', '11:30:00', '16:30:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'g', 'B', 1, 'Friday', '12:20:00', '18:30:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'd', 'A', 4, 'Monday', '09:00:00', '19:00:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'd', 'A', 4, 'Tuesday', '09:30:00', '16:50:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'd', 'A', 4, 'Friday', '10:00:00', '18:00:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'c', 'C', 2, 'Monday', '18:00:00', '19:00:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (1, 'c', 'A', 1, 'Thursday', '19:30:00', '21:10:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (2, 'g', 'B', 3, 'Monday', '16:00:00', '23:30:00');

insert into schedules (id, prefix, block, floor, weekday, starttime, endtime)
values (3, 'g', 'A', 2, 'Friday', '17:30:00', '23:50:00');



/*--------------------Transfer Data-----------------------------*/


insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (156741, 1, 2, '15 AC 4', 'Norway', '2005-02-13 15:00:00', '2005-02-13 20:00:13');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (197541, 1, 3, '22 ZC 2', 'England', '2003-04-10 15:00:00', '2003-04-10 20:00:00');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (136491, 1, 5, '15 AC 4', 'Sweden', '2005-06-23 15:00:00', '2005-06-23 22:00:51');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (123485, 1, 1, '64 XD 0', 'England', '2006-08-20 11:30:00', '2006-08-20 18:30:00');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (112344, 2, 6, '36 KC 2', 'Denmark', '2008-08-15 15:00:00', '2008-08-15 23:00:40');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (111588, 2, 3, '15 AC 4', 'Ireland', '2012-04-26 15:00:00', '2012-04-26 22:00:00');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (194664, 6, 7, '36 KC 2', 'Norway', '2003-09-13 14:00:00', '2003-09-13 18:40:56');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (187002, 6, 8, '22 ZC 2', 'Ireland', '2007-02-13 10:00:00', '2007-02-13 19:10:00');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (198703, 8, 8, '36 KC 2', 'Sweden', '2010-02-13 09:00:00', '2010-02-13 15:50:15');

insert into transfer (id, convict_id, guard_id, vehicle_id, place, transfer_datestart, transfer_dateend)
values (164889, 9, 4, '22 ZC 2', 'Denmark', '2015-11-20 08:00:00', '2015-11-20 16:20:20');

/*--------------------Crime Data-----------------------------*/

insert into crime (crimename, punishmentduration)
values ('Arson', 4560);

insert into crime (crimename, punishmentduration)
values ('Bribery', 4650);

insert into crime (crimename, punishmentduration)
values ('Burglary', 4730);

insert into crime (crimename, punishmentduration)
values ('Child Abuse', 5130);

insert into crime (crimename, punishmentduration)
values ('Computer Crime', 4746);

insert into crime (crimename, punishmentduration)
values ('Cyberbullying', 4963);

insert into crime (crimename, punishmentduration)
values ('Drug Trafficking', 4489);

insert into crime (crimename, punishmentduration)
values ('Harassment', 4584);

insert into crime (crimename, punishmentduration)
values ('Forgery', 4397);

insert into crime (crimename, punishmentduration)
values ('Embezzlement', 4496);



/*--------------------HasCrime Data-----------------------------*/

insert into hascrime (convict_id, crime_id)
values (1, 1);

insert into hascrime (convict_id, crime_id)
values (1, 2);

insert into hascrime (convict_id, crime_id)
values (2, 1);

insert into hascrime (convict_id, crime_id)
values (3, 6);

insert into hascrime (convict_id, crime_id)
values (4, 7);

insert into hascrime (convict_id, crime_id)
values (5, 8);

insert into hascrime (convict_id, crime_id)
values (6, 9);

insert into hascrime (convict_id, crime_id)
values (7, 4);

insert into hascrime (convict_id, crime_id)
values (8, 1);

insert into hascrime (convict_id, crime_id)
values (9, 4);

insert into hascrime (convict_id, crime_id)
values (10, 10);


/*--------------------Victim Data-----------------------------*/

insert into victims (convicts_id, crime_id, name, phone)
values (1, 1, 'Adeline Flores', '468 016 49 02');

insert into victims (convicts_id, crime_id, name, phone)
values (1, 1, 'Bryce Adams', '498 579 10 00');

insert into victims (convicts_id, crime_id, name, phone)
values (1, 2, 'Dylan Hall', '487 400 54 67');

insert into victims (convicts_id, crime_id, name, phone)
values (2, 1, 'Ebril Rivera', '789 751 58 03');

insert into victims (convicts_id, crime_id, name, phone)
values (3, 6, 'Edie Carter', '484 678 10 69');

insert into victims (convicts_id, crime_id, name, phone)
values (4, 7, 'Georgina Evans', '445 889 16 77');

insert into victims (convicts_id, crime_id, name, phone)
values (5, 8, 'Henrietta Cruz', '687 871 87 01');

insert into victims (convicts_id, crime_id, name, phone)
values (6, 9, 'Joleen Reyes', '789 484 89 33');

insert into victims (convicts_id, crime_id, name, phone)
values (7, 4, 'Marlena Morris', '498 878 99 87');

insert into victims (convicts_id, crime_id, name, phone)
values (8, 1, 'Rosie Morales', '137 987 89 00');

insert into victims (convicts_id, crime_id, name, phone)
values (9, 4, 'Steve Rogers', '698 789 26 30');

insert into victims (convicts_id, crime_id, name, phone)
values (10, 10, 'Sheoldon Cooper', '496 979 87 11');

/*--------------------Visitors Data-----------------------------*/

insert into visitors (name, kinshipdegree, phonenumber)
values ('Starling Bailey', 3, '498 788 74 45');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Olivia Wood', 3, '498 900 10 00');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Diana Reed', 2, '444 789 71 04');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Kara Kelly', 1, '455 666 98 88 99');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Emma James', 1, NULL);

insert into visitors (name, kinshipdegree, phonenumber)
values ('Mysa Ramos', 2, '789 999 04 64');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Sophia Gray', 2, '999 741 01 10');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Isabella Ruiz', 2, '416 878 87 44');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Sage Ward', 1, '987 877 88 24');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Scarlet Brooks', 4, '788 741 11 45');

insert into visitors (name, kinshipdegree, phonenumber)
values ('Levi Ackerman', 1, NULL);

/*--------------------Visits Data-----------------------------*/

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (1, 1, '00:05:30', '2001-02-11 13:00:00', '2001-02-12 15:00:00', '2001-02-16 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (1, 1, '00:35:30', '2001-05-20 13:00:00', '2001-05-22 15:00:00', '2001-05-27 19:30:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (1, 2, '01:00:30', '2001-07-11 13:00:00', '2001-07-14 15:00:00', '2001-07-20 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (1, 3, '01:30:30', '2001-09-01 13:00:00', '2001-09-07 15:00:00', '2001-09-11 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (1, 3, '01:30:30', '2001-11-16 13:00:00', '2001-11-19 15:00:00', '2001-11-25 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (2, 4, '01:15:26', '2006-09-11 13:00:00', '2006-09-12 15:00:00', '2006-09-16 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (2, 4, '00:45:56', '2006-12-11 13:00:00', '2006-12-12 15:00:00', '2006-12-16 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (2, 4, '00:50:30', '2007-01-11 13:00:00', '2007-01-12 15:00:00', '2007-01-16 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (3, 5, '00:10:30', '2011-08-11 13:00:00', '2011-08-12 15:00:00', '2011-08-16 12:00:00');

insert into visits (convict_id, visitor_id, visitduration, application, approval, arrival)
values (4, 6, '00:25:40', '2009-11-11 13:00:00', '2009-11-12 15:00:00', '2009-11-16 12:00:00');


/*--------------------Address Data-----------------------------*/

insert into address (convict_id, address, startdate, enddate)
values (1, '777 Brockton Avenue, Abington MA 2351', '1990-06-15', '1990-09-15');

insert into address (convict_id, address, startdate, enddate)
values (1, '30 Memorial Drive, Avon MA 2322', '1990-09-15', '1991-02-15');

insert into address (convict_id, address, startdate, enddate)
values (1, '250 Hartford Avenue, Bellingham MA 2019', '1991-02-15', '1991-04-15');

insert into address (convict_id, address, startdate, enddate)
values (1, '700 Oak Street, Brockton MA 2301', '1991-04-15', '1991-10-15');

insert into address (convict_id, address, startdate, enddate)
values (1, '66-4 Parkhurst Rd, Chelmsford MA 1824', '1991-10-15', '1995-09-15');

insert into address (convict_id, address, startdate, enddate)
values (3, '591 Memorial Dr, Chicopee MA 1020', '1999-06-15', '1999-09-10');

insert into address (convict_id, address, startdate, enddate)
values (7, '55 Brooksby Village Way, Danvers MA 1923', '1993-06-15', '1993-12-20');

insert into address (convict_id, address, startdate, enddate)
values (7, '137 Teaticket Hwy, East Falmouth MA 2536', '1993-12-15', '1995-05-15');

insert into address (convict_id, address, startdate, enddate)
values (9, '42 Fairhaven Commons Way, Fairhaven MA 2719', '1991-01-15', '1991-04-15');

insert into address (convict_id, address, startdate, enddate)
values (9, NULL, '1991-04-15', '1991-10-15');



/*--------------------Building Data-----------------------------*/

insert into building (block, floor)
values ('A', 5);

insert into building (block, floor)
values ('B', 4);

insert into building (block, floor)
values ('C', 4);

insert into building (block, floor)
values ('D', 4);

insert into building (block, floor)
values ('E', 4);

insert into building (block, floor)
values ('F', 5);

insert into building (block, floor)
values ('G', 5);

insert into building (block, floor)
values ('H', 3);

insert into building (block, floor)
values ('I', 1);

insert into building (block, floor)
values ('J', 2);



/*--------------------Imprisoment Place Data-----------------------------*/

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (1, 'A101', 'A', 1);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (2, 'A102', 'A', 1);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (3, 'A103', 'A', 1);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (4, 'A201', 'A', 2);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (5, 'B201', 'B', 2);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (6, 'B301', 'B', 3);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (7, 'B302', 'B', 3);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (8, 'C301', 'C', 3);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (9, 'C401', 'C', 4);

insert into imprisonmentplace (convict_id, cell_id, block_id, floor_id)
values (10, 'C402', 'C', 4);



