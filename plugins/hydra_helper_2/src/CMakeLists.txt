# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(hydra_helper_library VERSION 0.0.1 LANGUAGES C)

add_library(hydra_helper SHARED
  "hydra_helper.c"
)

set_target_properties(hydra_helper PROPERTIES
  PUBLIC_HEADER hydra_helper.h
  OUTPUT_NAME "hydra_helper"
)

target_compile_definitions(hydra_helper PUBLIC DART_SHARED_LIB)
