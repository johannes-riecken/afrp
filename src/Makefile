##############################################################################
#
# Makefile for building AFRP 2
#
# Based on Makefile.leaf template from 'Makedefs' project
#
##############################################################################


# Initial "all" target:
# This goes first to make it the default target.

.PHONY: all

all:

# Project root -- root directory where configuration files are found:
# This MUST be defined.
PROJROOT = ..

#-----------------------------------------------------------------------------
# include config.mk:
#-----------------------------------------------------------------------------
CONFIG=$(PROJROOT)/config.mk
include $(CONFIG)

$(CONFIG):
	@echo "ERROR: $(CONFIG) file not found."
	@echo
	@echo "Please configure the system by either creating a link to a"
	@echo "config-<PLATFORM>.mk for your platform or by running the appropriate"
	@echo "configuration script."
	@echo; exit 1

##############################################################################
#
# Directory-specific definitions:

#-----------------------------------------------------------------------------
# Source files (directory specific)
#-----------------------------------------------------------------------------

# Haskell sources.
hs_sources = \
    AFRP.hs \
    AFRPAffineSpace.hs \
    AFRPDiagnostics.hs \
    AFRPEvent.hs \
    AFRPForceable.hs \
    AFRPGeometry.hs \
    AFRPInternals.hs \
    AFRPMiscellany.hs \
    AFRPMergeableRecord.hs \
    AFRPPoint2.hs \
    AFRPPoint3.hs \
    AFRPTask.hs \
    AFRPUtilities.hs \
    AFRPVector2.hs \
    AFRPVector3.hs \
    AFRPVectorSpace.hs

# c_lib_sources =

# c_test_sources =

# cc_lib_sources =

# cc_test_sources =


#-----------------------------------------------------------------------------
# Package and library dependences (directory specific)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Package and library dependences (directory specific)
#-----------------------------------------------------------------------------

HS_PACKAGES = -package lang -package concurrent

# Needs work to provide a neater interface in some cases. E.g. just enumerate
# the packages and have make insert -package automatically.
# These definitions could depend on platform, Haskell system etc, since
# the configuration file has been importted prior to this point.
# We must define things like HS_IMPORT_DIRS here since later _conditional_
# definitions depend on whether it is empty or not (at the point of that
# definition, NOT later).

# colon separated list of directories where _stable_ interfaces are
# located.
# We now use Control.Arrow instead.
# HS_IMPORT_DIRS = $(ARROWS_IMP_DIR)
HS_IMPORT_DIRS =


#-----------------------------------------------------------------------------
# Target specification and flags for compilation and linking (dir. specific)
#-----------------------------------------------------------------------------

# Compilation options:

HS_OPTS += -fglasgow-exts

# Library targets:

hs_lib_target = afrp

#
# End of directory-specific definitions.
#
##############################################################################

DEFS = ../defs.mk
include $(DEFS)

##############################################################################
#
# Add complementary targets or overrides defs.mk below:
#
