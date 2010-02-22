
#=============================================================================
# Copyright 2004-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)

set(CMAKE_SHARED_LIBRARY_C_FLAGS "")				# -pic
set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared")	# -shared
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")			# +s, flag for exe link to use shared lib
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "")			# -rpath
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP "")		# : or empty
set(CMAKE_INCLUDE_FLAG_C "-I")			# -I
set(CMAKE_INCLUDE_FLAG_C_SEP "")		# , or empty
set(CMAKE_LIBRARY_PATH_FLAG "-L")
set(CMAKE_LIBRARY_PATH_TERMINATOR "")	# for the Digital Mars D compiler the link paths have to be terminated with a "/"
set(CMAKE_LINK_LIBRARY_FLAG "-l")

set(CMAKE_LINK_LIBRARY_SUFFIX "")
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_SHARED_LIBRARY_PREFIX "lib")	# lib
set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")	# .so
set(CMAKE_EXECUTABLE_SUFFIX "")			# .exe
set(CMAKE_DL_LIBS "dl")

set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a")

# basically all general purpose OSs support shared libs
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)

set(CMAKE_SKIP_RPATH OFF CACHE BOOL
	"If set, runtime paths are not added when using shared libraries.")

set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL
	"If this value is on, makefiles will be generated without the .SILENT directive, and all commands will be echoed to the console during the make.  This is useful for debugging only. With Visual Studio IDE projects all commands are done without /nologo.")

if(CMAKE_GENERATOR MATCHES "Makefiles")
	set(CMAKE_COLOR_MAKEFILE ON CACHE BOOL
		"Enable/Disable color output during build.")
	mark_as_advanced(CMAKE_COLOR_MAKEFILE)
	if(DEFINED CMAKE_RULE_MESSAGES)
		set_property(GLOBAL PROPERTY RULE_MESSAGES ${CMAKE_RULE_MESSAGES})
	endif()
endif()

# Set a variable to indicate whether the value of CMAKE_INSTALL_PREFIX
# was initialized by the block below.  This is useful for user
# projects to change the default prefix while still allowing the
# command line to override it.
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
	set(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT 1)
endif()

# Choose a default install prefix for this platform.
if(CMAKE_HOST_UNIX)
	set(CMAKE_INSTALL_PREFIX
		"/usr/local"
		CACHE
		PATH
		"Install path prefix, prepended onto install directories.")
else()
	if(CMAKE_SIZEOF_VOID_P MATCHES "8")
		# 64-bit build on Win64
		if(NOT "$ENV{ProgramW6432}" MATCHES "^$")
			set(CMAKE_GENERIC_PROGRAM_FILES "$ENV{ProgramW6432}")
		endif()

	else()
		# 32-bit build
		if(NOT "$ENV{ProgramFiles(x86)}" MATCHES "^$")
			# building on Win64
			set(CMAKE_GENERIC_PROGRAM_FILES "$ENV{ProgramFiles(x86)}")
		elseif(NOT "$ENV{ProgramFiles}" MATCHES "^$")
			# building on Win32
			set(CMAKE_GENERIC_PROGRAM_FILES "$ENV{ProgramFiles}")
		endif()
	endif()

	if(NOT "${CMAKE_GENERIC_PROGRAM_FILES}")
		# Fallback case
		if("$ENV{SystemDrive}" MATCHES "^$")
			set(CMAKE_GENERIC_PROGRAM_FILES "C:/Program Files")
		else()
			set(CMAKE_GENERIC_PROGRAM_FILES "$ENV{SystemDrive}/Program Files")
		endif()
	endif()

	set(CMAKE_INSTALL_PREFIX
		"${CMAKE_GENERIC_PROGRAM_FILES}/${PROJECT_NAME}"
		CACHE
		PATH
		"Install path prefix, prepended onto install directories.")
	set(CMAKE_GENERIC_PROGRAM_FILES)

	file(TO_CMAKE_PATH "${CMAKE_INSTALL_PREFIX}" CMAKE_INSTALL_PREFIX)
endif()

mark_as_advanced(CMAKE_SKIP_RPATH CMAKE_VERBOSE_MAKEFILE)
