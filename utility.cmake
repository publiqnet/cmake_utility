if( APPLE )
    find_program( BREW_PROGRAM brew )
    if( BREW_PROGRAM )
        find_program( SED_PROGRAM sed )
        find_program( BASH_PROGRAM bash )
        if( BASH_PROGRAM AND SED_PROGRAM )
            execute_process( COMMAND "${BASH_PROGRAM}" "-c" "${BREW_PROGRAM} config | ${SED_PROGRAM} -n -E 's/^HOMEBREW_PREFIX: (.+)$$/\\1/p'" OUTPUT_VARIABLE HOMEBREW_PREFIX )
            string( STRIP "${HOMEBREW_PREFIX}" HOMEBREW_PREFIX )
        else()
            set( HOMEBREW_PREFIX "/usr/local" )
        endif()

        list( APPEND CMAKE_PREFIX_PATH
              "${HOMEBREW_PREFIX}/opt/openssl"
              "${HOMEBREW_PREFIX}/opt/boost@1.60"
              "${HOMEBREW_PREFIX}/opt/pbc"
              "${HOMEBREW_PREFIX}/opt/gmp"
              "${HOMEBREW_PREFIX}/opt/cryptopp"
              "${HOMEBREW_PREFIX}/opt/rocksdb"
              "${HOMEBREW_PREFIX}/opt/qt5"
            )
    endif()
endif()

if (NOT BUILD_SHARED_LIBS)
set (Boost_USE_STATIC_LIBS ON)
set (CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()
set (Boost_MULTITHREADED ON)
set (Boost_USE_STATIC_RUNTIME OFF)

find_package(Boost 1.53 REQUIRED
    COMPONENTS system
               filesystem
               program_options
               locale)

MESSAGE(STATUS "boost info")
MESSAGE(STATUS "${Boost_INCLUDE_DIR}")
MESSAGE(STATUS "${Boost_LIBRARIES}")

list( APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake_utility/CMakeModules" )

find_package(CryptoPP REQUIRED)
if (NOT TARGET rocksdb)
    find_package(RocksDB)
endif()
#if(ROCKSDB_FOUND)
#    set(GLOB_ROCKSDB_FOUND 1 CACHE STRING "${ROCKSDB_INCLUDE_DIR}")
#endif()


