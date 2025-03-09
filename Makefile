##############################################################################
#
# Top-level Makefile for AFRP 2
#
##############################################################################

# Initial "all" target:
# This goes first to make it the default target.

.PHONY: all

all:

# project root -- root directory where configuration files are found:
# This MUST be defined.
PROJROOT = .

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
# Subdirectories
#-----------------------------------------------------------------------------

SUBDIRS = src

#
# End of directory-specific definitions.
#
##############################################################################

DEFS = $(PROJROOT)/defs.mk
include $(DEFS)
