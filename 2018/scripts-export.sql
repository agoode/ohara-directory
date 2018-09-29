drop view if exists export;
drop table if exists responses;
drop table if exists teachers;

-- teachers
.mode csv
.import teachers.csv teachers

-- import
.mode csv
.import Ohara_pto_9_27_2018.csv responses

create view export as
 select
  "Student First Name" AS "first",
  "Student Last Name" AS "last",
  "Student Grade Level" AS "grade",
  "normalized" AS "teacher",
  "Apartment/PO Box" AS "apt",
  "Student Street" AS "street",
  "Student City" AS "city",
  "Student State" AS "state",
  "Student Zip" AS "zip",
  "Student Home Phone" AS "homephone",
  "Parent/Guardian 1 First name" AS "pg1first",
  "Parent/Guardian 1 Last Name" AS "pg1last",
  "Parent/Guardian 1 Home Phone" AS "pg1home",
  "Parent/Guardian 1 Mobile Phone" AS "pg1mobile",
  "Parent/Guardian 1 Email" AS "pg1email",
  "Parent/Guardian 2 First name" AS "pg2first",
  "Parent/Guardian 2 Last Name" AS "pg2last",
  "Parent/Guardian 2 Home Phone" AS "pg2home",
  "Parent/Guardian 2 Mobile Phone" AS "pg2mobile",
  "Parent/Guardian 2 Email" AS "pg2email",
  "Parent/Guardian 3 First name" AS "pg3first",
  "Parent/Guardian 3 Last Name" AS "pg3last",
  "Parent/Guardian 3 Home Phone" AS "pg3home",
  "Parent/Guardian 3 Mobile Phone" AS "pg3mobile",
  "Parent/Guardian 3 Email" AS "pg3email"
 from responses JOIN teachers USING ("teacher");

-- export
.header on
.mode ascii
.once responses-20180927.list
select * from export order by rowid;

.header on
.mode csv
.once export-20180927.csv
select * from export
  order by grade, teacher, last, first;

-- students
.header on
.mode ascii
.once students-20180927.list
select distinct
  replace(grade, 'K', '0') as grade, TEACHER, first, last
  from export order by 1,2,3,4;
