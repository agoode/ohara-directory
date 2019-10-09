drop view if exists export;
drop table if exists responses;
drop table if exists teachers;

-- teachers
.mode csv
.import teachers.csv teachers

-- responses
.mode csv
.import "OH-PTO-Directory 2.csv" responses

-- export view
create view export as
with
  t as (select
          trim(substr(student, 1, instr(student, ',')-1)) as last,
          trim(substr(student, instr(student, ',')+1)) as first,
          grade,
          teacher,
          "contact priority order" as contact_order,
          trim(substr("contact full name", instr("contact full name", '. ')+1)) as contact_name,
          phone as contact_phone,
          email as contact_email,
          replace(replace(address, ',', ' '), '  ', ' ') as contact_address
        from responses left outer join teachers using (homeroom)),
  t1 as (select
          last,
          first,
          grade,
          teacher,
          contact_name as contact_name1,
          contact_phone as contact_phone1,
          contact_email as contact_email1,
          contact_address as contact_address1
         from t where contact_order = 1),
  t2 as (select
          last,
          first,
          grade,
          teacher,
          contact_name as contact_name2,
          contact_phone as contact_phone2,
          contact_email as contact_email2,
          contact_address as contact_address2
         from t where contact_order = 2)
select distinct * from t1 join t2 using (last, first, teacher, grade);

-- run export
.header on
.mode ascii
.once export-20191008.list
select * from export order by last, first, grade, teacher;
.mode csv
.once export-20191008.csv
select * from export order by grade, teacher, last, first;

-- run student export
.header on
.mode ascii
.once students-20191008.list
select distinct
  replace(grade, 'K', '0') as grade, TEACHER, first, last
  from export order by 1,2,4,3;
