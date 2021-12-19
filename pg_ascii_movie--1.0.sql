\echo Use "CREATE EXTENSION pg_ascii_movie" to load this file. \quit

CREATE OR REPLACE FUNCTION get_wait_time(in pos integer)
RETURNS double precision AS $$
	DECLARE
		var_pos integer;
		var_f_rate double precision;
		var_sql text;
		var_out double precision;
	BEGIN
		var_pos := pos;
		var_f_rate := 15.0;
		var_sql := 'select (select data from sw1 limit 1 offset ' || var_pos || ')::double precision /' || var_f_rate;

		EXECUTE var_sql INTO var_out;
		RETURN var_out;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_frame(in pos integer)
RETURNS text AS $$
	DECLARE
		var_pos integer;
		var_sql text;
		var_out text;
	BEGIN
		var_pos := pos;
		var_sql := 'select array_to_string(array(select data from sw1 limit 13 offset '|| var_pos ||'), chr(10))';
		EXECUTE var_sql INTO var_out;
		RETURN var_out;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE play_sw1() 
AS $$
	DECLARE
		var_start integer;
		var_end integer;
		var_out text;
		var_wait_time double precision;
		var_wait_pos integer;
		var_frame_pos integer;
		var_offset integer;
	BEGIN
		var_start := 0;
		var_end := 3410;
		var_wait_pos := 0;
		var_frame_pos := 1;
		var_offset := 14;

		PERFORM '\pset format unaligned';

		FOR var_i IN var_start..var_end LOOP
			-- fetch data
			SELECT get_wait_time(var_wait_pos) INTO var_wait_time;
			SELECT get_frame(var_frame_pos) INTO var_out;

			-- clear display and write frame
			RAISE INFO '%', E'\x\033[H\033[2J' || chr(10) || var_i || '/' || var_end || chr(10) || var_out || chr(10) || chr(10);

			-- wait
			PERFORM pg_sleep(var_wait_time);

			-- increment file position
			var_wait_pos := var_wait_pos + var_offset;
			var_frame_pos := var_frame_pos + var_offset;
		END LOOP;

		PERFORM '\pset format aligned';
	END;
$$ LANGUAGE plpgsql;
