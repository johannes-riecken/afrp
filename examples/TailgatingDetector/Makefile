##############################################################################
#
# Makefile for building the Tailgating Detector
#
##############################################################################

# NOTE! This should possibly be replaced with something simpler that a user
# could just take and build his own stuff around. In particular, should
# probably assume that libraries are installed in the "right" place.

# Initial "all" target:
# This goes first to make it the default target.

.PHONY: all

all:

# project root -- root directory where configuration files are found:
# This MUST be defined.
PROJROOT = ../..

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
# directory-specific definitions:

#-----------------------------------------------------------------------------
# Source files (directory specific)
#-----------------------------------------------------------------------------

# Haskell sources.

as_sources = TestTGMain.as TailgatingDetector.as

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
HS_IMPORT_DIRS = $(ARROWS_IMP_DIR):../../src

HS_LD_OPTS += -L../../src

#-----------------------------------------------------------------------------
# Target specification and flags for compilation and linking (dir. specific)
#-----------------------------------------------------------------------------

#
# compilation options:
#

HS_OPTS += -fglasgow-exts

# Executable targets:

app_target = testtg

# libraries to be linked with Haskell executables:
#
HS_APP_LIBS = -lHSafrp -lHSarrow

#
# end of directory-specific definitions.
#
##############################################################################

DEFS = ../../defs.mk
include $(DEFS)

##############################################################################
#
# Add complementary targets or overrides defs.mk below:
#
