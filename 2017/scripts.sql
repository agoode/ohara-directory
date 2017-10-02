drop table if exists import20160915;
drop table if exists import20170818;
drop table if exists merger;
drop table if exists teachers;
drop table if exists grades;

create table grades (GRADE primary key);
create table teachers (TEACHER primary key, GRADE references grades);

insert into grades values ("K");
insert into grades values ("1");
insert into grades values ("2");
insert into grades values ("3");
insert into grades values ("4");
insert into grades values ("5");

.mode csv
.import export-20160915.csv import20160915
.import classlist-20170818-edited.csv import20170818

insert into teachers select distinct TEACHER, GRADE from import20170818;

create table merger(
  "GRADE" TEXT,
  "TEACHER" TEXT,
  "LAST" TEXT,
  "FIRST" TEXT,
  "Str # 1+2" TEXT,
  "St. 1+2" TEXT,
  "ZIP 1+2" TEXT,
  "HOME PHONE 1/2" TEXT,
  "Parent/Guardian 1" TEXT,
  "CELL 1" TEXT,
  "EMAIL 1" TEXT,
  "Parent/Guardian 2" TEXT,
  "CELL 2" TEXT,
  "EMAIL 2" TEXT,
  "Str # 3+4" TEXT,
  "St. 3+4" TEXT,
  "ZIP 3+4" TEXT,
  "HOME PHONE 3+4" TEXT,
  "Parent/Guardian 3" TEXT,
  "CELL 3" TEXT,
  "EMAIL 3" TEXT,
  "Parent/Guardian 4" TEXT,
  "CELL 4" TEXT,
  "EMAIL 4" TEXT,
  constraint p primary key (LAST, FIRST),
  constraint teacher foreign key (TEACHER, GRADE) references teachers
);

insert into merger select
  import20170818."GRADE" TEXT,
  import20170818."TEACHER" TEXT,
  "LAST" TEXT,
  "FIRST" TEXT,
  "Str # 1+2" TEXT,
  "St. 1+2" TEXT,
  "ZIP 1+2" TEXT,
  "HOME PHONE 1/2" TEXT,
  "Parent/Guardian 1" TEXT,
  "CELL 1" TEXT,
  "EMAIL 1" TEXT,
  "Parent/Guardian 2" TEXT,
  "CELL 2" TEXT,
  "EMAIL 2" TEXT,
  "Str # 3+4" TEXT,
  "St. 3+4" TEXT,
  "ZIP 3+4" TEXT,
  "HOME PHONE 3+4" TEXT,
  "Parent/Guardian 3" TEXT,
  "CELL 3" TEXT,
  "EMAIL 3" TEXT,
  "Parent/Guardian 4" TEXT,
  "CELL 4" TEXT,
  "EMAIL 4" TEXT
from import20170818 left join import20160915 using (LAST, FIRST);

-- insert blank for empty form
insert into merger default values;

drop view if exists mergerview;
create view mergerview as select case when LAST notnull then rowid end as "No", substr(upper(LAST), 1, 1) as "1st Letter", *, GRADE || "_" || replace(TEACHER, "/", "-") || "_" || rowid || "_" as FILENAME_PREFIX from merger;

-- export
.header on
.mode csv
.once merged-20170818.csv
select * from merger order by GRADE, TEACHER, LAST, FIRST;

.once missing-20170818.csv
select * from merger where GRADE!='K' and "Parent/Guardian 1" is null order by LAST, FIRST;

.once mergerview-20170818.csv
select * from mergerview order by GRADE, No;

.once teachers.csv
select *, "teacher_" || GRADE || "_" || replace(TEACHER, "/", "-") || "_" as FILENAME_PREFIX from teachers;

-- files
.mode list
.header off
.once teacher-files.txt
select GRADE || "_" || replace(TEACHER, "/", "-") from teachers order by grade, teacher;
