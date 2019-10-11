drop view if exists export;
drop table if exists responses;
drop table if exists teachers;

-- teachers
.mode csv
.import teachers.csv teachers

-- responses
.mode csv
.import "Copy of PTO-Directory-OH-100919.csv" responses

-- export view
create view export as
with
  t as (select
          trim(substr("Stu Lastfirst", 1, instr("Stu Lastfirst", ',')-1)) as last,
          trim(substr("Stu Lastfirst", instr("Stu Lastfirst", ',')+1)) as first,
          "Stu Grade Level" as grade,
          teacher,
          "contact priority order" as corder,
          --trim(substr("contact full name", instr("contact full name", '. ')+1)) as cname,
          "contact full name" as cname,
          phone as cphone,
          email as cemail,
          replace(replace(address, ',', ' '), '  ', ' ') as caddress
        from responses left outer join teachers using ("Stu homeroom")),
  t1 as (select
          last,
          first,
          grade,
          teacher,
          cname as cname1,
          cphone as cphone1,
          cemail as cemail1,
          caddress as caddress1
         from t where corder = 1),
  t2 as (select
          last,
          first,
          grade,
          teacher,
          cname as cname2,
          cphone as cphone2,
          cemail as cemail2,
          caddress as caddress2
         from t where corder = 2)
select distinct * from t1 left outer join t2 using (last, first, teacher, grade);

-- run export
.header on
.mode ascii
.once export-20191010.list
select * from export order by last, first, grade, teacher;
.mode csv
.once export-20191010.csv
select * from export order by grade, teacher, last, first;

-- run student export
.header on
.mode ascii
.once students-20191010.list
select distinct
  replace(grade, 'K', '0') as grade, TEACHER, first, last
  from export order by 1,2,4,3;
