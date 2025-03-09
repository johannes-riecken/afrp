##############################################################################
#
# top-level Makefile for Invaders
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
PROJROOT = .

##############################################################################
#
# directory-specific definitions:

# set TOPDIR to indicate that this is the top-level directory for this
# project.
# This enables dist and related targets that should only be run from
# the top level directory of a project.
TOPDIR = true

#-----------------------------------------------------------------------------
# Subdirectories
#-----------------------------------------------------------------------------

SUBDIRS = src

# sub-directories with relevant dist targets:

# DISTSUBDIRS = 

#src_dist_files = README
# src_dist_dirs = $(SUBDIRS) examples experimental
src_dist_dirs = src afp-demos afp-soccer

# extra files to be included in the distribution:

# dist_extra_files = RELNOTES-$(PLATFORM).txt

# rsync stuff:

# RSYNC_HOST = haskell.org
# RSYNC_PATH = /home/haskell/arrows


#
# end of directory-specific definitions.
#
##############################################################################

DEFS = $(PROJROOT)/defs.mk
include $(DEFS)
