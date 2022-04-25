select * from pg_stat_activity


SELECT name, default_version,installed_version
FROM pg_available_extensions WHERE name LIKE 'postgis%' or name LIKE 'address%';


CREATE EXTENSION postgis;

CREATE EXTENSION fuzzystrmatch; --needed for postgis_tiger_geocoder

CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION postgis_topology;

CREATE EXTENSION address_standardizer_data_us;

SELECT postgis_full_version();



select version()


CREATE TABLE r0 (
	rid serial primary key,
	rast raster
)

select * from public.r2


CREATE TABLE  (
	rid serial primary key,
	rast raster
)


create table t (
	id int not null
)

SELECT ST_AsText(rast) 
       FROM r2;
       
      
select ST_Value(rast, ST_Transform(ST_SetSRID(ST_MakePoint(37.56,55.77),4326),3035)) from r2


select ST_Value(rast, ST_MakePoint(37.56,58.78)),
ST_Value(rast, ST_MakePoint(37.57,58.78))
from r0


select ST_Transform(ST_SetSRID(ST_MakePoint(37.56,55.77),4326),3035)

select ST_SetSRID(ST_MakePoint(37.56,55.77),4326)


select ST_MakePoint(37.56,55.77)


SELECT ST_SRID(rast) As srid from r2


select ST_SummaryStats(rast) from r2

select ST_Envelope(rast) from r2




insert into levels (hpa, meters) values
(500,5570),
(400,7180),
(350,8110),
(300,9160),
(275,9740),
(250,10360),
(225,11030),
(200,11770),
(175,12590),
(150,13500),
(100,15790);


create table levels (
hpa int not null,
meters int not null
)



select * from levels

--------------------
CREATE TABLE u500 (
	rid serial primary key,
	rast raster
);


CREATE TABLE u400 (
	rid serial primary key,
	rast raster
);

CREATE TABLE u350 (
	rid serial primary key,
	rast raster
);

CREATE TABLE u300 (
	rid serial primary key,
	rast raster
);

CREATE TABLE u275 (
	rid serial primary key,
	rast raster
);

CREATE TABLE u250 (
	rid serial primary key,
	rast raster
);

CREATE TABLE u225 (
	rid serial primary key,
	rast raster
);

CREATE TABLE u200 (
	rid serial primary key,
	rast raster
);
CREATE TABLE u175 (
	rid serial primary key,
	rast raster
);


CREATE TABLE u150 (
	rid serial primary key,
	rast raster
);


CREATE TABLE u100 (
	rid serial primary key,
	rast raster
);

--------------------



CREATE TABLE v500 (
	rid serial primary key,
	rast raster
);


CREATE TABLE v400 (
	rid serial primary key,
	rast raster
);

CREATE TABLE v350 (
	rid serial primary key,
	rast raster
);

CREATE TABLE v300 (
	rid serial primary key,
	rast raster
);

CREATE TABLE v275 (
	rid serial primary key,
	rast raster
);

CREATE TABLE v250 (
	rid serial primary key,
	rast raster
);

CREATE TABLE v225 (
	rid serial primary key,
	rast raster
);

CREATE TABLE v200 (
	rid serial primary key,
	rast raster
);
CREATE TABLE v175 (
	rid serial primary key,
	rast raster
);


CREATE TABLE v150 (
	rid serial primary key,
	rast raster
);


CREATE TABLE v100 (
	rid serial primary key,
	rast raster
);





 

select ST_Value(a.rast, ST_MakePoint(37.56,58.78)),
ST_Value(b.rast, ST_MakePoint(37.57,58.78))
from u200 a, u175 b






select ST_Value(ua.rast, ST_MakePoint(-49.7003,-16.0455)), 
ST_Value(va.rast, ST_MakePoint(-49.7003,-16.0455)), 
ST_Value(ub.rast, ST_MakePoint(-49.7003,-16.0455)), 
ST_Value(vb.rast, ST_MakePoint(-49.7003,-16.0455)) 
from u350 ua


, v350 va, u300 ub, v300 vb


select ST_Value(ua.rast, ST_MakePoint(-49.7003,-16.0455))
from r350 ua


truncate u500


CREATE TABLE r350 (
	rid serial primary key,
	rast raster
)


select count(*) from r350


explain (analyze, buffers, verbose)
select ST_Value(ua.rast, p) from u250 ua, 
(select ST_MakePoint(-74.4139,41.0165) as p)p


drop table planes






insert into planes (t, z, v, geom) values
('2021-11-15 13:30:21'::timestamp, 9000, 1, ST_MakePoint(-74.4139,41.0165))



select count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp from planes 


select * from planes



select * from u300 

truncate planes


select ST_Value(ua.rast, ST_MakePoint(-49.7003,-16.0455)) as val
from u300 ua where val is not null


select st_xmax(ST_Envelope(rast)) from u300

select ST_PointN(ST_Boundary(ST_Envelope(rast)),1) as lt, ST_PointN(ST_Boundary(ST_Envelope(rast)),3) as rb from u300


select ST_Boundary(ST_Envelope(rast))from u300

alter table u300 add column minx float null;
alter table u300 add column maxx float null;
alter table u300 add column miny float null;
alter table u300 add column maxy float null;


truncate u300

update u300 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));


explain(verbose, analyze, buffers)

select val from (
select ST_Value(rast, ST_MakePoint(-49.7003,-16.0455)) as val
from u300)t where val is not null


explain(verbose, analyze, buffers)
with d as (
select rid from u300 ua where -49.7003>=minx and -49.7003<=maxx and -16.0455>=miny and -16.0455<=maxy
)
select ST_Value(rast, ST_MakePoint(-49.7003,-16.0455)) as val from u300 join d using (rid)


explain(verbose, analyze, buffers)
select rid from u300 ua where -49.7003>=minx and -49.7003<=maxx and -16.0455>=miny and -16.0455<=maxy


create index u300_geo_indx on u300 using btree (minx, miny, maxx, maxy, rid);

analyze u300


function  r()

analyze u300



CREATE OR REPLACE FUNCTION public.r2(raster)
 RETURNS raster
 LANGUAGE plpgsql
 STABLE STRICT
AS $function$
	begin
	return $1;
	end;
	$function$
;



CREATE OR REPLACE FUNCTION public._raster_constraint_info_pixel_types(rastschema name, rasttable name, rastcolumn name)
 RETURNS text[]
 LANGUAGE sql
 STABLE STRICT
AS $function$
	SELECT
		trim(
			both '''' from split_part(
				regexp_replace(
					split_part(s.consrc, ' = ', 2),
					'[\(\)]', '', 'g'
				),
				'::', 1
			)
		)::text[]
	FROM pg_class c, pg_namespace n, pg_attribute a
		, (SELECT connamespace, conrelid, conkey, pg_get_constraintdef(oid) As consrc
			FROM pg_constraint) AS s
	WHERE n.nspname = $1
		AND c.relname = $2
		AND a.attname = $3
		AND a.attrelid = c.oid
		AND s.connamespace = n.oid
		AND s.conrelid = c.oid
		AND a.attnum = ANY (s.conkey)
		AND s.consrc LIKE '%_raster_constraint_pixel_types(%';
	$function$
;


select ua.val, va.val, ub.val, vb.val from 
(select ST_Value(rast, {point}) as val from u{l1})ua,
(select ST_Value(rast, {point}) as val from v{l1})va,
(select ST_Value(rast, {point}) as val from u{l2})ub,
(select ST_Value(rast, {point}) as val from v{l2})vb
where ua.val is not null and 
ub.val is not null and 
va.val is not null and 
vb.val is not null


explain(verbose, analyze, buffers)

with d as (
select ua.rid as ua, ub.rid as ub, va.rid as va, vb.rid as vb
from u300 ua join u350 ub using (minx, miny, maxx, maxy)
join v300 va using (minx, miny, maxx, maxy)
join v350 vb using (minx, miny, maxx, maxy)
where {x}>=minx and {x}<=maxx and {y}>=miny and {y}<=maxy
)
select ST_Value(ua.rast, {point}), 
ST_Value(va.rast, {point}),
ST_Value(ub.rast, {point}),
ST_Value(vb.rast, {point})
from d 
join u300 ua on ua.rid=ua
join v300 va on va.rid=va
join u350 ub on ub.rid=ub
join v350 vb on vb.rid=vb





select * from planes where t='2021-11-15 15:29:11'::timestamp --order by t desc, z


select count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp from planes 
where t='2021-11-15 15:29:11'::timestamp --order by t desc, z




SELECT 
  table_name, 
  pg_size_pretty( pg_total_relation_size(quote_ident(table_name))), 
  pg_total_relation_size(quote_ident(table_name))
FROM 
  information_schema.tables
WHERE 
  table_schema = 'public'
ORDER BY 
  pg_total_relation_size(quote_ident(table_name)) desc
  
  
  
CREATE INDEX v500_convexhull_idx ON v500 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v400_convexhull_idx ON v400 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v300_convexhull_idx ON v300 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v200_convexhull_idx ON v200 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v100_convexhull_idx ON v100 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v350_convexhull_idx ON v350 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v250_convexhull_idx ON v250 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v150_convexhull_idx ON v150 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v275_convexhull_idx ON v275 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v225_convexhull_idx ON v225 USING GIST(ST_ConvexHull(rast));
CREATE INDEX v175_convexhull_idx ON v175 USING GIST(ST_ConvexHull(rast));


CREATE INDEX u500_convexhull_idx ON u500 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u400_convexhull_idx ON u400 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u300_convexhull_idx ON u300 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u200_convexhull_idx ON u200 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u100_convexhull_idx ON u100 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u350_convexhull_idx ON u350 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u250_convexhull_idx ON u250 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u150_convexhull_idx ON u150 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u275_convexhull_idx ON u275 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u225_convexhull_idx ON u225 USING GIST(ST_ConvexHull(rast));
CREATE INDEX u175_convexhull_idx ON u175 USING GIST(ST_ConvexHull(rast));




explain (analyze, buffers, verbose)

select ua.val, va.val, ub.val, vb.val from (
	select ST_Value(rast, ST_MakePoint(49.4051, 27.6397)) as val from u250)ua, 
	(select ST_Value(rast, ST_MakePoint(49.4051, 27.6397)) as val from v250)va, 
	(select ST_Value(rast, ST_MakePoint(49.4051, 27.6397)) as val from u275)ub, 
	(select ST_Value(rast, ST_MakePoint(49.4051, 27.6397)) as val from v275)vb 
where ua.val is not null and ub.val is not null and va.val is not null and vb.val is not null





alter table u300 add column minx float null;
alter table u300 add column maxx float null;
alter table u300 add column miny float null;
alter table u300 add column maxy float null;

drop index u300_geo_indx;

create index u300_geo_indx on u300 using btree (minx, miny, maxx, maxy, rid);


alter table u300 drop column minx;
alter table u300 drop column maxx;
alter table u300 drop column miny;
alter table u300 drop column maxy;

CREATE OR REPLACE PROCEDURE public.fillTables(t text)
 LANGUAGE plpgsql
AS $function$
	begin
		execute format('alter table u%s add column minx float null',t);
		execute format('alter table u%s add column maxx float null',t);
		execute format('alter table u%s add column miny float null',t);
		execute format('alter table u%s add column maxy float null',t);
		execute format('create index u%s_geo_indx on u%s using btree (minx, miny, maxx, maxy, rid)',t,t);
		execute format('alter table v%s add column minx float null',t);
		execute format('alter table v%s add column maxx float null',t);
		execute format('alter table v%s add column miny float null',t);
		execute format('alter table v%s add column maxy float null',t);
		execute format('create index v%s_geo_indx on v%s using btree (minx, miny, maxx, maxy, rid)',t,t);
	end;
	$function$
;



call filltables('300');
call filltables('500');
call filltables('400');
call filltables('200');
call filltables('100');
call filltables('350');
call filltables('250');
call filltables('150');
call filltables('275');
call filltables('225');
call filltables('175');



CREATE OR REPLACE PROCEDURE public.recalc(t text)
 LANGUAGE plpgsql
AS $function$
	begin
		execute format('update %s set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast))',t);
	end;
	$function$
;




CREATE OR REPLACE PROCEDURE public.recalc()
 LANGUAGE plpgsql
AS $function$
	begin
update u500 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u400 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u300 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u200 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u100 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u350 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u250 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u150 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u275 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u175 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update u225 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));

update v500 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v400 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v300 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v200 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v100 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v350 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v250 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v150 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v275 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v175 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
update v225 set 
minx = st_xmin(ST_Envelope(rast)),
maxx = st_xmax(ST_Envelope(rast)),
miny = st_ymin(ST_Envelope(rast)),
maxy = st_ymax(ST_Envelope(rast));
	end;
	$function$
;





select * from planes order by t desc, z desc


select count(*) from planes where t='2021-11-22 13:40:18'

explain (analyze, buffers, verbose)

with d as (
select ua.rid as ua, ub.rid as ub, va.rid as va, vb.rid as vb
from u300 ua join u350 ub using (minx, miny, maxx, maxy)
join v300 va using (minx, miny, maxx, maxy)
join v350 vb using (minx, miny, maxx, maxy)
where -5.7839>=minx and -5.7839<=maxx and 50.0475>=miny and 50.0475<=maxy
)
select ST_Value(ua.rast, ST_MakePoint(-5.7839, 50.0475)),
ST_Value(va.rast, ST_MakePoint(-5.7839, 50.0475)),
ST_Value(ub.rast, ST_MakePoint(-5.7839, 50.0475)),
ST_Value(vb.rast, ST_MakePoint(-5.7839, 50.0475))
from d
join u300 ua on ua.rid=ua
join v300 va on va.rid=va
join u350 ub on ub.rid=ub
join v350 vb on vb.rid=vb



select t, count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp 
from planes 
--where t = (select max(t) from planes)
group by t
order by t desc

select typ, count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp 
from planes 
where t = (select max(t) from planes)
group by typ
order by n desc



select typ, avg(disp) from (

select t, typ, count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp 
from planes join (select typ from planes where t = (select max(t) from planes) group by typ having count(*)>50)t using (typ)
group by t, typ
order by n desc--t desc, typ desc

)t  group by typ


select typ, count(*) from planes where t = (select max(t) from planes) group by typ order by count(*) desc


select * from planes where typ='PRM1'

alter table planes add column typ varchar(10) null;

truncate planes




select * from planes order by t desc


create table planes2 (
	t timestamp  not null,
	z float not null,
	planeVelocity float not null,
	planeDirection float not null,
	expectedSpeed float not null,
	windX float not null,
	windY float not null,
	error float not null,
	typ varchar(10) not null
)


SELECT AddGeometryColumn ('public','planes2','geom',0,'POINT',2);



select * from planes2 order by t desc


select typ, expectedspeed from planes2 p 
group by typ, expectedspeed
order by typ


select z, sqrt(px*px+py*py) as p, planedirection as pd
from (
select *, 
planeVelocity * cos(radians(90-planedirection)) - windx as px,
planeVelocity * sin(radians(90-planedirection)) - windy as py
from planes2 
where typ='A343'
)t


select min(planedirection), max(planedirection), avg(planedirection), stddev(planedirection) from planes2

create table typemap(
	typ varchar(10) not null,
	p float8 not null,
	primary key(typ)
);


insert into typemap(typ, p)


select typ, avg(p) as p, stddev_samp(p), count(*), avg(po), stddev_samp(po) 
from (
select typ, sqrt(px*px+py*py) as p, po from (
select typ, planeVelocity as po,
planeVelocity * cos(radians(90-planedirection)) - windx as px,
planeVelocity * sin(radians(90-planedirection)) - windy as py
from planes2
where t<current_date
)t)t
join (select typ from planes2 where t = (select max(t) from planes2) group by typ having count(*)>50)t2 using (typ)
group by typ
order by typ;



A319	227.71392621124434	10.030806433590598	12751	224.25937024547093	23.532004336594394
A320	229.1034992393414	9.864223397026972	30404	226.4735416392582	23.0770100171361
A321	231.56921235083936	7.388853779117612	16541	229.75944078350807	23.914760359553117
B738	228.13593468275602	9.349509138520908	49107	225.15696580935366	24.0292869757793
B77W	246.02588229091458	8.257522637028215	9065	248.92625923883094	27.202704483709336

A319	223.52610320913607	17.09956216217238	325	219.72240000000014	22.938674424335844
A320	225.91987822721086	18.700419643163258	1145	226.11751965065534	22.20717642062484
A321	231.3136481132953	18.481784659054966	409	234.2613202933984	26.632271817742488
B738	224.77555410388075	20.051384212869095	1619	220.7223903644228	22.649856515087947
B77W	249.33998409995615	20.284644823331607	472	248.49885593220338	25.002958083262527


select *, sqrt(px*px+py*py)-m.p as e
from (
select *, 
planeVelocity * cos(radians(90-planedirection)) - windx as px,
planeVelocity * sin(radians(90-planedirection)) - windy as py
from planes2 
)t join typemap m using (typ)




select t, count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp 
from (
select t, typ, sqrt(px*px+py*py)-m.p as v
from (
select t, typ, 
planeVelocity * cos(radians(90-planedirection)) - windx as px,
planeVelocity * sin(radians(90-planedirection)) - windy as py
from planes2 
) t2 join typemap m using (typ)
) t2
join (select typ from planes2 where t = (select max(t) from planes2) group by typ having count(*)>50)t using (typ)
group by t
order by t desc



update planes2 t2
set error = sqrt((planeVelocity * cos(radians(90-planedirection)) - windx)*(planeVelocity * cos(radians(90-planedirection)) - windx)
+(planeVelocity * sin(radians(90-planedirection)) - windy)*(planeVelocity * sin(radians(90-planedirection)) - windy)) - m.p
from typemap m where m.typ = t2.typ 



select * from planes2 order by t desc, error desc


select * from ST_Value(POINT ()

select ST_Value(rast, ST_MakePoint(138.178, 34.0032)) from u250


select * from planes2 


explain (analyse, buffers, verbose)
with d as (
select ua.rid as ua, ub.rid as ub, va.rid as va, vb.rid as vb
from u200 ua join u225 ub using (minx, miny, maxx, maxy)
join v200 va using (minx, miny, maxx, maxy)
join v225 vb using (minx, miny, maxx, maxy)
where 12.781>=minx and 12.781<=maxx and 47.4956>=miny and 47.4956<=maxy
)
select ST_Value(ua.rast, ST_MakePoint(12.781, 47.4956)),
ST_Value(va.rast, ST_MakePoint(12.781, 47.4956)),
ST_Value(ub.rast, ST_MakePoint(12.781, 47.4956)),
ST_Value(vb.rast, ST_MakePoint(12.781, 47.4956))
from d
join u200 ua on ua.rid=ua
join v200 va on va.rid=va
join u225 ub on ub.rid=ub
join v225 vb on vb.rid=vb




select t, typ, count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp 
from (
select t, typ, sqrt(px*px+py*py)-m.p as v
from (
select t, typ, err
planeVelocity * cos(radians(90-planedirection)) - windx as px,
planeVelocity * sin(radians(90-planedirection)) - windy as py
from planes2 
) t2 join typemap m using (typ)
) t2
join (select typ from planes2 where t = (select max(t) from planes2) group by typ having count(*)>50)t using (typ)
group by t, typ
order by t desc, typ desc



select t, typ, count(*) as n, min(v) as min, max(v) as max, avg(v) as sv, stddev_samp(v) as disp 
from (
select t, typ, error as v
from planes2 
) t2
join (select typ from planes2 where t = (select max(t) from planes2) group by typ having count(*)>50)t using (typ)
group by t, typ
order by t desc, typ desc




select t, count(*) as n, min(error) as min, max(error) as max, avg(error) as sv, stddev_samp(error) as disp 
from planes2 
group by t
order by t desc


delete from planes2 where t>=current_date

select * from planes2 
join typemap t using (typ)
--where t='2021-12-06 12:30:01'
order by t desc, error desc


select *, planeVelocity * cos(radians(90-planedirection)) - windx, planeVelocity * sin(radians(90-planedirection)) - windy, m.p,
sqrt((planeVelocity * cos(radians(90-planedirection)) - windx)*(planeVelocity * cos(radians(90-planedirection)) - windx)
+(planeVelocity * sin(radians(90-planedirection)) - windy)*(planeVelocity * sin(radians(90-planedirection)) - windy)),
sqrt((planeVelocity * cos(radians(90-planedirection)) - windx)*(planeVelocity * cos(radians(90-planedirection)) - windx)
+(planeVelocity * sin(radians(90-planedirection)) - windy)*(planeVelocity * sin(radians(90-planedirection)) - windy)) - m.p
from planes2 p 
join typemap m using (typ)
where t='2021-12-06 12:30:01' and windx=26.837856817900246

