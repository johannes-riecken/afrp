##############################################################################
#
# linux platform-specific configuration template
#
##############################################################################

# include user-configurable options
CONF_LOCAL = $(PROJROOT)/config-solaris-local.mk
include $(CONF_LOCAL)

#-----------------------------------------------------------------------------
# platform-specific definitions
#-----------------------------------------------------------------------------
architecture = sparc

