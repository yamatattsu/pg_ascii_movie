EXTENSION = pg_ascii_movie
DATA = pg_ascii_movie--1.0.sql
PGFILEDESC = "pg_ascii_movie - ascii movie player for PostgreSQL"

ifdef NO_PGXS
subdir = contrib/pg_ascii_movie
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
else
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
endif

