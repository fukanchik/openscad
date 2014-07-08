#
#
#
OPENSCAD=~/src/openscad/openscad

STLS=brush-holder.stl mounting-hub.stl

all: $(patsubst %,stl/%, $(STLS))

stl/brush-holder.stl: brush-holder.scad
	$(OPENSCAD) -o $@ $<

stl/mounting-hub.stl: mounting-hub.scad
	$(OPENSCAD) -o $@ $<

