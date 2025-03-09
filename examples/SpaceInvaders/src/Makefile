##############################################################################
#
# Makefile for building Invaders
#
# Based on Makefile.leaf template from 'Makedefs' project
#
# $Id: Makefile,v 1.1 2003/09/13 00:24:11 henrik Exp $
#
##############################################################################


# Initial "all" target:
# This goes first to make it the default target.

.PHONY: all

all:

# project root -- root directory where configuration files are found:
# This MUST be defined.
PROJROOT = ..

##############################################################################
#
# Directory-specific definitions.

#-----------------------------------------------------------------------------
# Source files (directory specific)
#-----------------------------------------------------------------------------

# Haskell sources:
hs_sources = \
    Animate.hs \
    ColorBindings.hs \
    Colors.hs \
    Command.hs \
    Diagnostics.hs \
    IdentityList.hs \
    Object.hs \
    Parser.hs \
    PhysicalDimensions.hs \
    RenderLandscape.hs \
    RenderObject.hs \
    WorldGeometry.hs

as_sources = \
    Main.as \
    ObjectBehavior.as \
    SimpleGun.as


#-----------------------------------------------------------------------------
# Package and library dependences (directory specific)
#-----------------------------------------------------------------------------

# Define ghc-specific package imports here, if needed.
HS_PACKAGES = -package lang -package concurrent -package HGL

# Colon separated list of directories where _stable_ interfaces are
# located.
HS_IMPORT_DIRS = $(ghcimports_dir)/afrp


#-----------------------------------------------------------------------------
# Target specification and flags for compilation and linking (dir. specific)
#-----------------------------------------------------------------------------

# Compilation options.

HS_OPTS += -fglasgow-exts

HS_LD_OPTS += \
    -L$(ghclibs_dir)
#    -L$(X_ROOT)/lib

# library targets:

app_target = invaders

# libraries to be linked with Haskell executables:
#
# HS_APP_LIBS = -lHSafrp -lHSarrow -lHShgl -lX11
HS_APP_LIBS = -lHSafrp

#
# End of directory-specific definitions.
#
##############################################################################

#
# include top-level make definitions:
#
DEFS = $(PROJROOT)/defs.mk
include $(DEFS)

##############################################################################
#
# Add complementary targets or overrides defs.mk below.
#
