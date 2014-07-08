#
# Builds STL files.
# Requires environment variable OPENSCAD pointing to openscad binary.
#
STLS=brush-holder.stl mounting-hub.stl

all: $(patsubst %,stl/%, $(STLS))

stl/brush-holder.stl: brush-holder.scad
	$(OPENSCAD) -o $@ $<

stl/mounting-hub.stl: mounting-hub.scad
	$(OPENSCAD) -o $@ $<

