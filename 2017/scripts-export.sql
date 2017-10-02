drop view if exists export;
drop view if exists missing;
drop table if exists responses;
drop table if exists teachers;
drop table if exists grades;

-- Import the CSV in already sorted order.
-- Students must be adjacent in the file to be in the same household.
-- In some cases, this means the responses will have duplicate rows
--  when students with different last names are in the same household,
--  so that they will be indexed by both last names.
.mode csv
.import responses-20170926.csv responses

create view missing as select * from responses where "Returned?"=="";

create table grades (GRADE primary key);
insert into grades values ("K");
insert into grades values ("1");
insert into grades values ("2");
insert into grades values ("3");
insert into grades values ("4");
insert into grades values ("5");

create table teachers (TEACHER primary key, GRADE references grades);
insert into teachers select distinct TEACHER, GRADE from missing;

create view export as
 select
  GRADE,
  TEACHER,
  LAST,
  FIRST,
  Suffix,
  "Str # 1+2",
  "St. 1+2",
  "ZIP 1+2",
  "HOME PHONE 1/2",
  "Parent/Guardian 1",
  "CELL 1",
  "EMAIL 1",
  "Parent/Guardian 2",
  "CELL 2",
  "EMAIL 2",
  "Str # 3+4",
  "St. 3+4",
  "ZIP 3+4",
  "HOME PHONE 3+4",
  "Parent/Guardian 3",
  "CELL 3",
  "EMAIL 3",
  "Parent/Guardian 4",
  "CELL 4",
  "EMAIL 4"
 from responses where "Returned?"!=""
 UNION
 select
  GRADE,
  TEACHER,
  LAST,
  FIRST,
  Suffix,
  NULL as "Str # 1+2",
  NULL as "St. 1+2",
  NULL as "ZIP 1+2",
  NULL as "HOME PHONE 1/2",
  NULL as "Parent/Guardian 1",
  NULL as "CELL 1",
  NULL as "EMAIL 1",
  NULL as "Parent/Guardian 2",
  NULL as "CELL 2",
  NULL as "EMAIL 2",
  NULL as "Str # 3+4",
  NULL as "St. 3+4",
  NULL as "ZIP 3+4",
  NULL as "HOME PHONE 3+4",
  NULL as "Parent/Guardian 3",
  NULL as "CELL 3",
  NULL as "EMAIL 3",
  NULL as "Parent/Guardian 4",
  NULL as "CELL 4",
  NULL as "EMAIL 4"
 from responses where "Returned?"=="";

-- export
.header on
.mode csv
.once missing-20170926.csv
select * from missing order by GRADE, TEACHER, LAST, FIRST;

.header on
.mode ascii
.once responses-20170926.list
select * from responses order by rowid;

.header on
.mode csv
.once export-20170926.csv
select * from export order by GRADE, TEACHER, LAST, FIRST;

-- students
.header on
.mode ascii
.once students-20170926.list
select distinct replace(GRADE, "K", "0") as GRADE,TEACHER,FIRST,LAST,Suffix from export order by GRADE, TEACHER, LAST, FIRST;
