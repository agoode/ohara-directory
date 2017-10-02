drop view if exists export;
drop view if exists missing;
drop table if exists responses20160911;
drop table if exists teachers;
drop table if exists grades;

.mode csv
.import responses-20160911.csv responses20160911

create view missing as select * from responses20160911 where "Returned?"=="";

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
 from responses20160911 where "Returned?"!=""
 UNION
 select
  GRADE,
  TEACHER,
  LAST,
  FIRST,
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
 from responses20160911 where "Returned?"=="";

-- export
.header on
.mode csv
.once missing-20160915.csv
select * from missing order by GRADE, TEACHER, LAST, FIRST;

.header on
.mode ascii
.once responses-20160915.list
select * from responses20160911 order by rowid;

.header on
.mode csv
.once export-20160915.csv
select * from export order by GRADE, TEACHER, LAST, FIRST;
