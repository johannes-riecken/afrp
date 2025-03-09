#############################################################################
#
# user-editable definitions reflecting how things are installed
# on a particular machine.
#
##############################################################################

# directory where libraries and binaries installed when doing
# a 'make install':

prefix = c:/haskell

# We now use the standard module Control.Arrows instead.
#
# path of arrows interface files (shouldn't need to be changed, unless
# you installed arrows with a different prefix than above):
#
# ARROWS_IMP_DIR = $(ghcimports_dir)/arrow

# Haskell system for which we are building (just one):
#
HS = ghc
#HS = hugs

