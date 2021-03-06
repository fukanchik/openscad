#
# Builds STL files.
# Requires environment variable OPENSCAD pointing to openscad binary.
#
STLS=brush-holder.stl mounting-hub.stl filament_bar.stl slm_holder.stl

all: $(patsubst %,stl/%, $(STLS))

stl/brush-holder.stl: brush-holder.scad
	$(OPENSCAD) -o $@ $<

stl/mounting-hub.stl: mounting-hub.scad
	$(OPENSCAD) -o $@ $<

stl/filament_bar.stl: filament_bar.scad
	$(OPENSCAD) -o $@ $<

stl/slm_holder.stl: slm_holder.scad
	$(OPENSCAD) -o $@ $<

