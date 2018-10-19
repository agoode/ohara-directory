drop view if exists export;
drop table if exists responses;
drop table if exists teachers;

-- teachers
.mode csv
.import teachers.csv teachers

-- responses
.mode csv
.import combined-20181018.csv responses

-- export view
create view export as
 select
  responses.rowid + 1 as "no",
  "Student First Name" AS "first",
  "Student Last Name" AS "last",
  "Student Grade Level" AS "grade",
  "normalized" AS "teacher",
  "Apartment/PO Box" AS "apt",
  "Student Street" AS "street",
  "Student City" AS "city",
  "Student State" AS "state",
  "Student Zip" AS "zip",
  "Student Home Phone" AS "home0",
  -- pg1
  trim(printf('%s %s', "Parent/Guardian 1 First name",
                       "Parent/Guardian 1 Last Name")) AS "pg1",
  "Parent/Guardian 1 Home Phone" AS "home1",
  "Parent/Guardian 1 Mobile Phone" AS "cell1",
  "Parent/Guardian 1 Email" AS "email1",
  -- pg2
  trim(printf('%s %s', "Parent/Guardian 2 First name",
                       "Parent/Guardian 2 Last Name")) AS "pg2",
  "Parent/Guardian 2 Home Phone" AS "home2",
  "Parent/Guardian 2 Mobile Phone" AS "cell2",
  "Parent/Guardian 2 Email" AS "email2",
  -- pg3
  trim(printf('%s %s', "Parent/Guardian 3 First name",
                       "Parent/Guardian 3 Last Name")) AS "pg3",
  "Parent/Guardian 3 Home Phone" AS "home3",
  "Parent/Guardian 3 Mobile Phone" AS "cell3",
  "Parent/Guardian 3 Email" AS "email3"
 from responses LEFT OUTER JOIN teachers USING ("teacher");

-- run export
.header on
.mode ascii
.once export-20181018.list
select * from export order by rowid;
.mode csv
.once export-20181018.csv
select * from export order by grade, teacher, last, first;

-- run student export
.header on
.mode ascii
.once students-20181018.list
select distinct
  replace(grade, 'K', '0') as grade, TEACHER, first, last
  from export order by 1,2,4,3;
