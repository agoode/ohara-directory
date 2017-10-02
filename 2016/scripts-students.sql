drop table if exists students20161003;

.mode csv
.import students-20161003.csv students20161003

-- export
.header on
.mode ascii
.once students-20161003.list
select distinct * from students20161003 order by rowid;

.mode csv
