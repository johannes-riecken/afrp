##############################################################################
#
# defs.mk -- Specification of global rules and definitions for building
# many kinds of targets from their source files.
#
# NOTE:  This file provides definitions and rules that constitute a 
# generic 'template' for compiling and releasing programs that are
# not specific to any particular project.  You should not make any
# project-specific changes to this file.  Any changes to this file
# should be made to the original, which lives under the 'Makedefs'
# project in the haskell.org CVS repository.
#
# This file is for use in GNU Make ver. 3.76 or later.
#
#
# Original definitions by Henrik Nilsson.  Portability tweaks by
# Antony Courtney.
#
# $Id: defs.mk,v 1.1 2003/09/13 00:24:11 henrik Exp $
#
##############################################################################

# ToDo:
# - Need to get conotrol over the names.
#   Naming conventions: close to existing Makefile conventions when those
#   exist (e.g. caps. for commands and options), otherwise lowercase with
#   underscore as separator.
# - Rethink the target strategy. E.g. currently we cannot build a C executable.
#   Having a "taraget type" variable would be OK as far as I'm concerned.
# - Document the names, and what need to be defined when.
# - Move back include import to beginning of each directory-specific make
#   file. Think about how to specify topdir. Given an absolute topdir,
#   we would not need the "topdir" variable. (Or?) (Hm. I guess the oppoiste
#   is almost easier.)
#   E.g. options may have to be set differently depending on what compiler
#   is used! We can abstract out certain "common" options by binding them
#   to a variable (usch as HC_OPT_FLAG), but there ARE limits ...
#   As an alternative, one could consider having e.g. HC = $(GHC)
#   where GHC would be $(GHC_COMPILER) $(GHC_FLAGS) ... or something.
# - Package definitions/extra includes is another example where one might
#   well have to do compiler-specifc things in a directory-specific Makefile.
# - We need a way to refer to things like HsFFI.h independently of
#   Haskell system! Currently I'm defining GHC_ROOT and using that
#   directly in directory-specific makefiles.
# - Configuration! Many things in project-defs.mk should go into config.
# - Look over Haskell options. E.g. -L. etc. should not be there
#   unconditionally! (-L. removed in this file.)
# - In general, try to figure out how to set option in a good way, at least
#   for Haskell, what abstractions to make, what the user should set on
#   command line/in directory-specific make file, etc.
# - Is the rule for building test applications still used? If not,
#   it should go. (The rule which starts: "% : %Main.o ...".)

#-----------------------------------------------------------------------------
# ensure that PROJROOT is defined
#-----------------------------------------------------------------------------
ifeq ($(strip $(PROJROOT)),)
$(error ERROR: Makefile must set PROJROOT to top-level project directory)
endif

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


#-----------------------------------------------------------------------------
# include project-defs.mk:
#-----------------------------------------------------------------------------
PROJDEFS=$(PROJROOT)/project-defs.mk
include $(PROJDEFS)

#-----------------------------------------------------------------------------
# include VERSION.mk:
#-----------------------------------------------------------------------------

# file containing master version numbers for project:
RELFILE = $(PROJROOT)/VERSION.mk
include $(RELFILE)

#-----------------------------------------------------------------------------
# Paths 
#-----------------------------------------------------------------------------

# Directory for third-party libraries.
lib_dir = $(prefix)/lib

# Directories where third-party GHC libraries live.
ghclibs_dir = $(lib_dir)/ghc
ghcimports_dir = $(ghclibs_dir)/imports

# Directory for installation of third-party binaries.
bin_install_dir = $(install_prefix)/bin

# Directory for installation of third-party libraries.
lib_install_dir = $(install_prefix)/lib

# Directory for installation of third-party documentation.
doc_install_dir = $(install_prefix)/doc

# Directories for (inst. of) third-party GHC libraries. Created if necessary.
ghclibs_install_dir = $(lib_install_dir)/ghc
ghcimports_install_dir = $(ghclibs_install_dir)/imports

# Hugs library installation directory:
hugslibs_install_dir = $(lib_install_dir)/hugs

# Java library installation directory:
javalibs_install_dir = $(lib_install_dir)/java


##############################################################################
#
# definitions for source and binary distribution targets (dist, src-dist
# and bin-dist).
#
##############################################################################

# Where binaries, libraries, etc. gets installed. Usually same as prefix,
# but overridden when making a distribution.
install_prefix = $(prefix)

#-----------------------------------------------------------------------------
# Tools, arguments, and auxiliary files
#-----------------------------------------------------------------------------

SHELL = /bin/sh

#MF = Makefile.$(PLATFORM)
MF = Makefile
HS_DEPS  = .hs_dependences
C_DEPS   = .c_dependences
CXX_DEPS = .cc_dependences
ALL_DEPS = $(HS_DEPS) $(C_DEPS) $(CXX_DEPS)

# Haskell compiler / interpreter
HI = hugs
HC = ghc

#
# It might be possible to avoid making the following conditional,
# but many of these options are really rather ghc-specific.
#
ifeq ($(HC),ghc)
# HS_OPTS passed to HC in all cases. Add to HS_OPTS using '+='.
# HS_USER_OPTS intended to be set temporarily in environment/on command line.
HS_OPTS     += -O $(HS_PACKAGES) $(HS_EXTRA_IMPORTS) $(HS_USER_OPTS)
HS_CPP_OPTS =
HS_LD_OPTS  += -L$(ghclibs_dir) $(PLATFORM_LD_OPTS)
COMPILE.hs  = $(HC) -c $(HS_CPP_OPTS) $(HS_OPTS) -o $@
LINK.hs     = $(HC) $(HS_OPTS) $(HS_LD_OPTS)
# tool to build Haskell dependencies:
MKDEPS.hs   = $(HC) -M -optdep-f -optdep$(HS_DEPS) \
                    $(HS_EXCLUDED_IMPORTS) \
                    $(HS_CPP_OPTS) $(HS_OPTS) 
# Use this instead if you have a broken GHC (5.02.1) and happen to have a
# suitably tweaked copy of mkdependHS (from an old GHC, e.g. 4.08.2) around.
# (But note that excl. dirs. probably does not work.):
# MKDEPS.hs   = mkdependHS -f $(HS_DEPS) $(HS_EXCLUDED_IMPORTS) \
#                          -- $(HS_CPP_OPTS) $(HS_OPTS) --
ifneq ($(strip $(HS_IMPORT_DIRS)),)
HS_EXTRA_IMPORTS=-i$(HS_IMPORT_DIRS)
HS_EXCLUDED_IMPORTS=-optdep--exclude-directory=$(HS_IMPORT_DIRS)
# HS_EXCLUDED_IMPORTS=--exclude-directory=$(HS_IMPORT_DIRS)
endif
else
# for non-ghc systems:
HS_LD_OPTS  += $(PLATFORM_LD_OPTS)
endif

ARROWP = arrowp

# greencard stuff:
# greencard executable:
GCPROG = $(GC_DIR)/src/green-card
GC_LIB_DIR = $(GC_DIR)/lib/$(HS)

GCTARGET = --target $(HS)

ifneq ($(strip $(GC_DIR)),)
HS_EXTRA_IMPORTS += -i$(GC_LIB_DIR)
endif

# Hmmmm.  This used to be set this way, but HS_EXTRA_IMPORTS isn't
# available yet...
# GCOPTS += $(GCTARGET) $(HS_EXTRA_IMPORTS)
GCOPTS += $(GCTARGET) -i$(GC_LIB_DIR)
GREENCARD = $(GCPROG) $(GCOPTS)

# If we're compiling greencard stuff for hugs, then we need to add
# GC_LIB_DIR to C includes:
ifneq ($(strip $(gc_sources)),)
ifeq ($(strip $(HS)),hugs)
CPPFLAGS += -I$(GC_LIB_DIR)
endif
endif

# happy stuff
#
# ghc-specific (for now)
HAPPY = happy -agc

# C compiler stuff:


CC = gcc
CFLAGS += $(CPPFLAGS)
MKDEPS.c = $(CC) -MM $(CPPFLAGS) > ${C_DEPS}

CXX 	  = g++
# Think about how to handle OPTIM, both for C, C++, and Haskell.
CXXFLAGS  = $(OPTIM)
MKDEPS.cc = $(CXX) -MM $(CPPFLAGS) > $(CXX_DEPS)

# Java stuff:
JAVAC = javac

RM = rm -f

RANLIB = ranlib 

INSTALL.exe = install -m755
INSTALL.hi  = install -m644
INSTALL.a   = install -m644

MKDIRSREC = install -d

# DLL suffix / prefix names:
# Win32:
ifeq ($(strip $(PLATFORM)),win32)
dll_suffix=dll
else
# dll_prefix=lib
dll_suffix=so
endif

#-----------------------------------------------------------------------------
# Implicit rules for Haskell
#-----------------------------------------------------------------------------

# Unclear what the best option is here. GHC does not update
# an interface file unnecessarily, i.e. unelss it changes textually(?).
# This means that an .hi file can be older than an .hs and .o file even
# AFTER that .hs file has been compiled!
# However, sine an interface file can import a lot of other interface files,
# it can actually "change" without changing textually. Say if the
# definition of an imported type synonym changes. Such an indirect change
# should cause anything depending on this interface file to be recompiled.
# That is the purpose of the arrangement below. Unfortunately the solution
# below means that if only an interface file is missing (i.e., the
# corresponding .o file exists), then that file will not be remade.)
# Anyway, it is not completely clear how effective the arrangement is.

# This works better than a pattern rule with both a .hi and a .o target
# since GHC does not generate any dependences for .hi files.
%.hi: %.o ;


%.o: %.hs
	$(COMPILE.hs) $<

%.o: %.lhs
	$(COMPILE.hs) $<

# Preprocessing  arrowized Haskell. (The suffix .as is somewhat unfortunate
# since it conflicts with the Applixware Spreadsheet suffix, and since there
# is no 'h'. Maybe .ahs would be better?
%.hs: %.as
	$(ARROWP) $< > $@

# Preprocessing of greencard files
%.hs: %.gc
	$(GREENCARD) $<

# Under hugs, processing a greencard file produces a .c file, too:
%.c: %.gc
	$(GREENCARD) $<

# Happy:
%.hs:	%.ly
	$(HAPPY) $<

# Java compilation:
%.class : %.java
	$(JAVAC) $<

#------------------------------------------------------------------------------
# implicit rule for macro-processed html and text:
#------------------------------------------------------------------------------

M4 = m4

%.html: %.m4 $(RELFILE)
	$(M4) -P -Dm4_version=$(version) $< > $@

# These directories should normally exist, but are created just in case.
assumed_dirs = $(bin_install_dir) $(lib_install_dir) $(doc_install_dir)

install_dirs = $(assumed_dirs) 


#-----------------------------------------------------------------------------
# Derived source and object files
#-----------------------------------------------------------------------------

# TODO: can we clean up the naming here, and make it more systematic?

# E.g. for GreenCard-generated files and files generated by the Arrows preproc.
hs_gen_sources = $(addsuffix .hs,$(basename $(gc_sources))) \
                 $(addsuffix .hs,$(basename $(as_sources))) \
                 $(addsuffix .hs,$(basename $(happy_sources)))		

gen_sources = $(hs_gen_sources)

gc_objects = $(addsuffix .o,$(basename $(gc_sources)))

all_hs_sources = $(hs_sources) $(hs_gen_sources)

all_hs_interfaces = $(addsuffix .hi,$(basename $(all_hs_sources)))

all_hs_objects = $(addsuffix .o,$(basename $(all_hs_sources)))

all_c_sources = $(c_sources)

all_c_objects = $(addsuffix .o,$(basename $(all_c_sources)))

all_cc_sources = $(cc_sources)

all_cc_objects = $(addsuffix .o,$(basename $(all_cc_sources)))

all_objects = $(all_hs_objects) $(all_c_objects) $(all_cc_objects)

dll_objects = $(gc_objects) $(all_c_objects)

html_gen_sources = $(addsuffix .html,$(basename $(html_m4_sources)))

gen_sources += $(html_gen_sources)

# derive the library name from the package name, if the user hasn't
# defined it already.
ifneq ($(strip $(all_objects)),)
ifeq ($(strip $(lib_name)),)
lib_name = $(project_name)
endif
endif

java_lib_classes = $(addsuffix .class,$(basename $(java_lib_sources)))

java_jar_files = $(java_lib_classes) $(java_lib_resources)

gen_targets = $(gen_sources)

# define Haskell library targets differently depending on whether
# we are building for a Haskell compiler or interpeter.  If building
# for a compiler, we build lib.a from all_objects.  If building
# from an interpeter, we build dynamic library or .so from GreenCard
# and C library sources.
#

# if there are Haskell library sources to worry about...
ifneq ($(strip $(hs_lib_target)),)
# and if we are compiling the Haskell code for ghc:
ifeq ($(strip $(HS)),ghc)
lib.a = libHS$(hs_lib_target).a
lib_targets = $(all_hs_interfaces) $(lib.a)
else
# we're interpreting our Haskell code
# check if there are *compiled* library sources:
ifneq ($(strip $(dll_objects)),)
dll = $(dll_prefix)$(hs_lib_target).$(dll_suffix)
lib_targets = $(dll)
endif
endif
endif

lib_targets += $(java_target)


# A similar check for tests:
# if there are Haskell test sources to worry about...
ifneq ($(strip $(hs_test_targets)),)
# and if we are compiling the Haskell code for ghc
ifeq ($(strip $(HS)),ghc)
test_targets = $(hs_test_targets)
# we' don't bother with an else branch, since we can just leave
# test_targets undefined if we're building for a Haskell interpreter.
endif
endif

#-----------------------------------------------------------------------------
# Main targets
#-----------------------------------------------------------------------------

.PHONY: all install uninstall dist bin-dist src-dist clean really-clean

all: $(lib_targets) $(app_target) $(test_targets) $(gen_targets) subdirs

# ghc-specific library install target:
ifeq ($(strip $(HS)),ghc)
ifneq ($(strip $(lib.a)),)

# Directory for GHC library interface files. In keeping with the current
# GHC conventions, this is private to the library in question and hence
# created on installation and deleted on uninstallation.
ghc_package_import_install_dir = $(ghcimports_install_dir)/$(project_name)

install_dirs += $(ghclibs_install_dir) $(ghc_package_import_install_dir)
uninstall_dirs += $(ghc_package_import_install_dir)

ghc_lib_install_path = $(ghclibs_install_dir)/$(lib.a)
uninstall_files += $(ghc_lib_install_path)

install_targets += ghc_lib_install

ghc_lib_install: $(lib.a)
	$(INSTALL.a) $(lib.a) $(ghc_lib_install_path)
	$(INSTALL.hi) $(all_hs_interfaces) $(ghc_package_import_install_dir)
endif
endif

# hugs-specific library install target:
ifeq ($(strip $(HS)),hugs)
ifneq ($(strip $(all_hs_sources)),)

hugs_lib_dir = $(hugslibs_install_dir)/$(project_name)

install_dirs += $(hugs_lib_dir)
uninstall_dirs += $(hugs_lib_dir)

install_targets += hugs_lib_install

# if this library includes a DLL, we need to install that:
ifneq ($(strip $(dll)),)
hugs_dll_install_path = $(hugs_lib_dir)/$(dll)

hugs_lib_install: $(dll) $(all_hs_sources)
	$(INSTALL.a) $(dll) $(hugs_dll_install_path)
	$(INSTALL.hi) $(all_hs_sources) $(hugs_lib_dir)
else
hugs_lib_install: $(dll) $(all_hs_sources)
	$(INSTALL.hi) $(all_hs_sources) $(hugs_lib_dir)
endif


endif
endif

# Haskell application install target:
ifneq ($(strip $(app_target)),)

install_targets += app_install

app_install:	$(app_target)
	$(INSTALL.exe) $(app_target) $(bin_install_dir)

endif

# java-specific library install target:
ifneq ($(strip $(java_lib_target)),)

install_dirs += $(javalibs_install_dir)
uninstall_files += $(javalibs_install_dir)/$(java_lib_target)

install_targets += java_lib_install


java_lib_install: $(java_lib_target)
	$(INSTALL.a) $(java_lib_target) $(javalibs_install_dir)
endif


%.jar:	$(java_jar_files)
	jar cf $@ $(java_jar_files)


ifeq ($(strip $(major)),)
$(error ERROR: must include RELEASE in top-level Makefile which defines 'major' and 'minor')
endif

ifeq ($(strip $(minor)),)
$(error ERROR: must include RELEASE in top-level Makefile which defines 'major' and 'minor')
endif

version = $(major).$(minor)

# only define dist targets if TOPDIR is defined
ifneq ($(strip $(TOPDIR)),)

#
# N.B.:  For now, we just assume that we are always building
# Haskell-related stuff, so we will always care about the Haskell
# system used to build the binary release.  Revisit this if we
# want to use this defs.mk file for non-Haskell projects.
#
# append Haskell system to binary distribution bundle name:
bin_dist_qual = $(HS)

ifneq ($(strip $(bin_dist_qual)),)
bin_name_extra = -$(bin_dist_qual)
endif

bin_dist_name = dist/$(project_name)-$(version)-$(PLATFORM)-$(architecture)$(bin_name_extra).tgz

# Note: We distinguish win32 sources because of its CR/LF convention.
ifneq ($(PLATFORM),win32)
    src_dist_name = dist/$(project_name)-$(version)-src.tgz
else
    src_dist_name = dist/$(project_name)-$(version)-win32-src.tgz
endif

# form dist_name from project_name and version:
dist_name = $(project_name)-$(version)

.PHONY:	dist src-dist bin-dist dist-subdirs dist-base

# Since src-dist invokes really-clean, invoke make recursively here works
# better than making src-dist and bin_dist dependences since we definitely
# have control over the order in which the distributions are built and
# since the dependence files does not get removed behind the back of
# a running make which would need them (again) on a recursive invocation.
dist:	dist-base
	$(MAKE) -f $(MF) src-dist
	$(MAKE) -f $(MF) bin-dist


# basic dist targets, built whenever any kind of distribution is made:
dist-base:  dist-dir dist-subdirs dist-extra

#
# disgusting name needed because we want 'DISTSUBDIRS' to be the list
# of sub-directories on which we perform 'make dist' recursively.
DISTSUBDIRTARGETS = $(DISTSUBDIRS:%=%-dist)

dist-subdirs: $(DISTSUBDIRTARGETS)

$(DISTSUBDIRTARGETS):
	$(MAKE) -C $(@:-dist=) dist

bin-dist: all dist-base
	( mkdir $(dist_name) && \
	  mkdir $(dist_name)/parts && \
	  make -f $(MF) install_prefix=`pwd`/$(dist_name)/parts install && \
	  DISTMF=$(dist_name)/Makefile && \
	  echo ".PHONY: install uninstall" > $$DISTMF && \
	  echo "install:" >> $$DISTMF && \
	  echo "	install -d $(prefix)" >> $$DISTMF && \
	  echo "	cp -fdR parts/* $(prefix)" >> $$DISTMF && \
	  echo "uninstall:" >> $$DISTMF && \
	  make -n -f $(MF) uninstall | grep '^$(RM) ' | sed -e 's/^/	/' \
               >> $$DISTMF && \
	  tar -zcvf $(bin_dist_name) $(dist_name) && \
	  rm -rf $(dist_name) ) \
        || (rm -rf $(dist_name) ; exit 1)

# Use src_dist_files and src_dist_dirs to determine what to include in
# source distribution:

src_dist_paths = $(src_dist_files) $(src_dist_dirs)

ifeq ($(strip $(src_dist_paths)),)
src-dist: 
	$(error ERROR: can't build source distribution: src_dist_files and src_dist_dirs empty.)

else

src-dist: really-clean dist-base
	( mkdir .$(dist_name) && \
	  cp Makefile.srcdist .$(dist_name)/Makefile && \
	  cp defs.mk project-defs.mk VERSION.mk config-*.mk .$(dist_name) && \
	  cp -dR $(src_dist_files) $(src_dist_dirs) .$(dist_name) && \
	  mv .$(dist_name) $(dist_name) && \
	  tar -zcvf $(src_dist_name) \
	      --exclude CVS \
	      --exclude .cvsignore \
              --exclude=\*~ \
              --exclude=\*.class \
              --exclude=private \
              $(dist_name) && \
	  rm -rf $(dist_name) ) \
	|| (rm -rf $(dist_name) ; exit 1)
endif

# carefully tag the CVS repository with the version number

CVSTAG = RELEASE_$(major)_$(minor)

.PHONY:	cvs-tag

# We use -c option to ensure that there are no un-commited changes before
# tagging...
cvs-tag:
	cvs -c tag $(CVSTAG)

# *sigh*.  I tried to do a uniqueness check on the tag, but this just
# doesn't work right, and I don't know why.  Giving up for now...
# ensure that this tag is unique!
# cvs-check-unique:
# 	@echo "checking cvs server to ensure release tag is unique..."
# 	@( ( cvs -q -q log -h |grep "symbolic names:" |grep -q $(CVSTAG) ) && \
# 	  (echo "*** ERROR: release tag $(CVSTAG) already found."; exit 1) ) || \
# 	echo "cvs server tag check complete."


# target to synchronize dist sub-directory with some directory on
# remote host using rsync:
.PHONY:	rsync rsync-fail

RSYNC = rsync -e ssh

ifneq ($(strip $(RSYNC_HOST)),)
ifneq ($(strip $(RSYNC_PATH)),)
ifneq ($(strip $(USER)),)
rsync:
	$(RSYNC) dist/* $(USER)@$(RSYNC_HOST):$(RSYNC_PATH)

else
rsync:	rsync-fail
endif
else
rsync:	rsync-fail
endif
else
rsync:	rsync-fail
endif

rsync-fail:
	$(error ERROR: must define USER, RSYNC_HOST and RSYNC_PATH before making rsync target.)

else
#
# error: not at top-level
.PHONY:	dist-fail

dist:	dist-extra
src-dist:	dist-fail
bin-dist:	dist-fail

dist-fail:
	@echo "*** ERROR: TOPDIR undefined.  Please only run 'make dist' in the top-level"
	@echo "*** directory of your project."
	@exit 1
endif


.PHONY: dist-dir

dist-dir:	
	$(MKDIRSREC) $(PROJROOT)/dist

ifneq ($(strip $(dist_extra_files)),)
dist-extra:	$(dist_extra_files)
	cp $(dist_extra_files) $(PROJROOT)/dist
else
dist-extra:
endif


# AC, 2/2/2002:  We no longer get rid of source or binary distributions
# in clean or really-clean, since we may want to refer to these for
# archival purposes.  (For example, perhaps it was built with an old
# compiler that is no longer available.)
#

# local clean:
.PHONY: lclean

lclean:
	-$(RM) $(lib_targets) $(app_target) $(test_targets) $(all_objects) \
	       $(all_hs_interfaces) $(extra_clean_targets) \
	       $(java_lib_classes) $(ALL_DEPS) \
	       *~ .*~ *.bak .*.bak *.dll *.exe *.ilk *.lib *.exp *.pdb

clean:	clean-subdirs lclean

really-clean: rclean-subdirs lclean
	-$(RM) $(gen_targets)


#-----------------------------------------------------------------------------
# Auxiliary targets
#-----------------------------------------------------------------------------

.PHONY: install_dirs
.PRECIOUS: $(lib.a) $(test)

# AC, 2/1/2002:  commented out because users have reported flakiness
# with handling of .INTERMEDIATE in some versions of GNU make, and
# it's not critical to correct functioning of Makefile.
#
# HN, 2002-02-07: In any case, we only want .INTERMEDIATE when building
# archives (and shared objects given that there also is an archive?).
#
#.INTERMEDIATE: $(all_objects)

$(lib.a): $(lib.a)($(all_objects))
	-$(RANLIB) $@


# This does not seem to be used anymore?
% : %Main.o $(all_test_objects) $(lib.a)
	$(LINK.hs) -o $@ $< $(all_test_objects) $(HS_APP_LIBS)

# an application target:
ifneq ($(strip $(app_target)),)
$(app_target):	$(all_objects)
	$(LINK.hs) -o $@ $(all_objects) $(HS_APP_LIBS)
endif

install_dirs: $(install_dirs)

$(install_dirs):
	$(MKDIRSREC) $@

# Rules for building DLLs on various platforms:

ifneq ($(strip $(dll)),)
ifeq ($(strip $(PLATFORM)),win32)

MSCC = cl
CFLAGS = -nologo -MD -Zi -DWIN32 $(CPPFLAGS)

extra_clean_targets += $(lib_name).def $(lib_name).exp $(lib_name).ilk \
	$(lib_name).lib $(lib_name).pdb vc60.pdb

%.o : %.c
	$(MSCC) $(CFLAGS) /Fo$@ /c $<

# old crap from my attempt at building dll's using Cygwin's gcc:
# (This doesn't actually work; maybe someone will revive it someday).

# DLL_EXP_LIB = lib$(lib_name).a
# DLL_EXP_DEF = $(lib_name).def

# DLLWRAP_FLAGS = --export-all --output-def $(DLL_EXP_DEF) \
# 	--implib $(DLL_EXP_LIB) \
# 	--driver-name $(CC)

# DLLWRAP = dllwrap

# %.dll :	$(dll_objects)
# 	$(DLLWRAP) $(DLLWRAP_FLAGS) -o $(dll) \
# 	    $(dll_objects) $(HS_LD_OPTS) $(DLL_LDLIBS)

%.dll :	$(dll_objects)
	link -nologo -debug -dll -out:$@ $(dll_objects) $(dll_link_libs)

endif
ifeq ($(strip $(PLATFORM)),linux)

CFLAGS = -fPIC -g -D_REENTRANT $(CPPFLAGS)

LDFLAGS = $(PLATFORM_LD_OPTS)

%.so : $(dll_objects)
	$(CC) -shared -Wl,-soname,$@ $(LDFLAGS) -DSTRICT -o $@ $(dll_objects) $(APP_LIBS)


endif
endif

#-----------------------------------------------------------------------------
# Automatic handling of dependences
#-----------------------------------------------------------------------------

# Note: Since the dependence files are included, they automatically become
# targets.

# Haskell
ifneq ($(strip $(all_hs_sources)),)

# only build Haskell dependences if we have a dependency-generator
# tool available.  Otherwise, just truncate the HS_DEPS file.
ifneq ($(strip $(MKDEPS.hs)),)
$(HS_DEPS): $(MF) $(CONFIG) $(DEFS) $(all_hs_sources)
	$(MKDEPS.hs) $(all_hs_sources) || ($(RM) $(HS_DEPS) ; exit 1)
else
$(HS_DEPS):
	 ($(RM) $(HS_DEPS) ; touch $(HS_DEPS))
endif

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),really-clean)
ifneq ($(MAKECMDGOALS),src-dist)
-include $(HS_DEPS)
endif
endif
endif

endif

# C
ifneq ($(strip $(all_c_sources)),)

$(C_DEPS): $(MF) $(CONFIG) $(DEFS) $(all_c_sources)
	$(MKDEPS.c) $(all_c_sources) || ($(RM) $(C_DEPS) ; exit 1)

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),really-clean)
ifneq ($(MAKECMDGOALS),src-dist)
-include $(C_DEPS)
endif
endif
endif

endif

# C++
ifneq ($(strip $(all_cc_sources)),)

$(CXX_DEPS): $(MF) $(CONFIG) $(DEFS) $(all_cc_sources)
	$(MKDEPS.cc) $(all_cc_sources) || ($(RM) $(CXX_DEPS) ; exit 1)

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),really-clean)
ifneq ($(MAKECMDGOALS),src-dist)
-include $(CXX_DEPS)
endif
endif
endif

endif

#
# building / cleaning sub-directories:
#

CLEANSUBDIRS = $(SUBDIRS:%=%-clean)
RCLEANSUBDIRS = $(SUBDIRS:%=%-rclean)
INSTALLSUBDIRS  = $(SUBDIRS:%=%-install)
UNINSTALLSUBDIRS  = $(SUBDIRS:%=%-uninstall)

.PHONY: subdirs $(SUBDIRS) $(CLEANSUBDIRS) $(RCLEANSUBDIRS) \
	$(INSTALLSUBDIRS) $(UNINSTALLSUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean-subdirs: $(CLEANSUBDIRS)

$(CLEANSUBDIRS):
	$(MAKE) -C $(@:-clean=) clean

rclean-subdirs: $(RCLEANSUBDIRS)

$(RCLEANSUBDIRS):
	$(MAKE) -C $(@:-rclean=) really-clean

install-subdirs: $(INSTALLSUBDIRS)

$(INSTALLSUBDIRS):
	$(MAKE) -C $(@:-install=) install

uninstall-subdirs: $(UNINSTALLSUBDIRS)

$(UNINSTALLSUBDIRS):
	$(MAKE) -C $(@:-uninstall=) uninstall


#
# install and uninstall targets.
# fragile:  need to ensure that appropriate install vars are defined
# first.
#

install: install-subdirs all install_dirs $(install_targets)

uninstall: uninstall-subdirs
ifneq ($(strip $(uninstall_files)),)
	-$(RM) $(uninstall_files)
endif
ifneq ($(strip $(uninstall_dirs)),)
	-$(RM) -r $(uninstall_dirs)
endif
