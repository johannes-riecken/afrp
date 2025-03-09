##############################################################################
#
# linux platform-specific configuration template
#
##############################################################################

# include user-configurable options
CONF_LOCAL = $(PROJROOT)/config-linux-local.mk
include $(CONF_LOCAL)

#-----------------------------------------------------------------------------
# platform-specific definitions
#-----------------------------------------------------------------------------
architecture = i386

