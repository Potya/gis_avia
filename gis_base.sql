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

