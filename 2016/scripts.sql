drop table if exists import20150924;
drop table if exists import20160823;
drop table if exists import20160825;
drop table if exists import20160829;
drop table if exists import20160830;
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
.import 20150924-2.csv import20150924
.import 20160830.csv import20160830

insert into teachers select distinct TEACHER, GRADE from import20160830;

create table merger(
  "LAST" TEXT,
  "FIRST" TEXT,
  "TEACHER" TEXT,
  "GRADE" TEXT,
  "Primary Parent/Guardian 1" TEXT,
  "Primary Parent/Guardian 2" TEXT,
  "HOME PHONE" TEXT,
  "PP1 CELL" TEXT,
  "PP2 CELL" TEXT,
  "Str #" TEXT,
  "St." TEXT,
  "ZIP" TEXT,
  "PP1 EMAIL" TEXT,
  "PP2 EMAIL" TEXT,
  "Secondary Parent/Guardian 1" TEXT,
  "Secondary Parent/Guardian 2" TEXT,
  "SP HOME PHONE" TEXT,
  "SP CELL PHONE" TEXT,
  "Sec Str #" TEXT,
  "Sec St." TEXT,
  "Sec Zip" TEXT,
  "SP E-MAIL" TEXT,
  constraint p primary key (LAST, FIRST),
  constraint teacher foreign key (TEACHER, GRADE) references teachers
);

insert into merger select * from import20160830 left join import20150924 using (LAST, FIRST);

-- insert blank for empty form
insert into merger default values;

drop view if exists mergerview;
create view mergerview as select case when LAST notnull then rowid end as "No", substr(upper(LAST), 1, 1) as "1st Letter", *, GRADE || "_" || replace(TEACHER, "/", "-") || "_" || rowid || "_" as FILENAME_PREFIX from merger;

-- export
.header on
.mode csv
.once merged-20160830.csv
select * from merger order by GRADE, TEACHER, LAST, FIRST;

.once missing-20160830.csv
select * from merger where GRADE!='K' and "Primary Parent/Guardian 1" is null order by LAST, FIRST;

.once mergerview-20160830.csv
select * from mergerview order by GRADE, No;

.once teachers.csv
select *, "teacher_" || GRADE || "_" || replace(TEACHER, "/", "-") || "_" as FILENAME_PREFIX from teachers;

-- files
.mode list
.header off
.once teacher-files.txt
select GRADE || "_" || replace(TEACHER, "/", "-") from teachers order by grade, teacher;
