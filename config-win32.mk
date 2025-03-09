##############################################################################
#
# win32 platform-specific configuration template
#
##############################################################################

# include user-configurable options
CONF_LOCAL = $(PROJROOT)/config-win32-local.mk
include $(CONF_LOCAL)

#-----------------------------------------------------------------------------
# platform-specific definitions
#-----------------------------------------------------------------------------
architecture = i386
