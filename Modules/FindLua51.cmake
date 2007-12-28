# Locate Lua library
# This module defines
# LUA_LIBRARIES
# LUA_FOUND, if false, do not try to link to Lua 
# LUA_INCLUDE_DIR, where to find lua.h 
#
# Note that the expected include convention is
# #include "lua.h"
# and not
# #include <lua/lua.h>
# This is because, the lua location is not standardized and may exist
# in locations other than lua/


FIND_PATH(LUA_INCLUDE_DIR lua.h
  PATHS
  $ENV{LUA_DIR}
  NO_DEFAULT_PATH
  PATH_SUFFIXES include/lua51 include/lua5.1 include/lua include
)
FIND_PATH(LUA_INCLUDE_DIR lua.h
  PATHS ${CMAKE_PREFIX_PATH} # Unofficial: We are proposing this.
  NO_DEFAULT_PATH
  PATH_SUFFIXES include/lua51 include/lua5.1 include/lua include
)
FIND_PATH(LUA_INCLUDE_DIR lua.h
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
  PATH_SUFFIXES include/lua51 include/lua5.1 include/lua include
)

FIND_LIBRARY(LUA_LIBRARY 
  NAMES lua51 lua5.1 lua
  PATHS
  $ENV{LUA_DIR}
  NO_DEFAULT_PATH
    PATH_SUFFIXES lib64 lib
)
FIND_LIBRARY(LUA_LIBRARY 
  NAMES lua51 lua5.1 lua
  PATHS ${CMAKE_PREFIX_PATH} # Unofficial: We are proposing this.
    NO_DEFAULT_PATH
    PATH_SUFFIXES lib64 lib
)
FIND_LIBRARY(LUA_LIBRARY
  NAMES lua51 lua5.1 lua
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw
  /opt/local
  /opt/csw
  /opt
    PATH_SUFFIXES lib64 lib
)

IF(LUA_LIBRARY)
  # include the math library for Unix
  IF(UNIX AND NOT APPLE)
    FIND_LIBRARY(MATH_LIBRARY_FOR_LUA m)
    SET( LUA_LIBRARIES "${LUA_LIBRARY};${MATH_LIBRARY_FOR_LUA}" CACHE STRING "Lua Libraries")
  # For Windows and Mac, don't need to explicitly include the math library
  ELSE(UNIX AND NOT APPLE)
    SET( LUA_LIBRARIES "${LUA_LIBRARY}" CACHE STRING "Lua Libraries")
  ENDIF(UNIX AND NOT APPLE)
ENDIF(LUA_LIBRARY)

SET(LUA_FOUND "NO")
IF(LUA_LIBRARIES AND LUA_INCLUDE_DIR)
  SET(LUA_FOUND "YES")
ENDIF(LUA_LIBRARIES AND LUA_INCLUDE_DIR)
