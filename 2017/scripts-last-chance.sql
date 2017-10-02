drop table if exists returned;

-- create the table, because returned.txt does not have a header
create table returned(
  "No" TEXT primary key
);
.mode csv
.import returned.txt returned

-- export
.header on
.mode csv
.once last-chance-20170917.csv
select * from mergerview where "No" not in (select "No" from returned) order by GRADE, No;
