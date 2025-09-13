cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "luxand_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

# Define the plugin library target
add_library(${PROJECT_NAME} SHARED
  "luxand_flutter_plugin.cpp"
  "luxand_flutter_plugin.h"
)

apply_standard_settings(${PROJECT_NAME})
set_target_properties(${PROJECT_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PROJECT_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# System-level dependencies
find_package(PkgConfig REQUIRED)

target_include_directories(${PROJECT_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PROJECT_NAME} PRIVATE flutter flutter_wrapper_plugin)

# List of absolute paths to libraries that should be bundled with the plugin
set(luxand_flutter_bundled_libraries
  ""
  PARENT_SCOPE
)