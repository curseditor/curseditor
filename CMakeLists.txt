cmake_minimum_required(VERSION 3.20)

project(curseditor LANGUAGES C CXX)

# ----------------------------------------------------------------------
# Toolchain / language settings
# ----------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)     # nice for clangd / IDEs

# ----------------------------------------------------------------------
# Project layout helpers
# ----------------------------------------------------------------------
set(DEPS_DIR    ${CMAKE_CURRENT_SOURCE_DIR}/deps)
set(SRC_DIR     ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)

# ----------------------------------------------------------------------
# Sources
# ----------------------------------------------------------------------
set(PROJECT_SOURCES
    ${SRC_DIR}/main.cpp

    # --- ImGui ---------------------------------------------------------
    ${DEPS_DIR}/imtui/third-party/imgui/imgui/imgui.cpp
    ${DEPS_DIR}/imtui/third-party/imgui/imgui/imgui_draw.cpp
    ${DEPS_DIR}/imtui/third-party/imgui/imgui/imgui_widgets.cpp
    ${DEPS_DIR}/imtui/third-party/imgui/imgui/imgui_tables.cpp
    ${DEPS_DIR}/imtui/third-party/imgui/imgui/misc/cpp/imgui_stdlib.cpp
    ${DEPS_DIR}/imtui/third-party/imgui/imgui/imgui_demo.cpp

    # --- ImTui ---------------------------------------------------------
    ${DEPS_DIR}/imtui/src/imtui-impl-ncurses.cpp
    ${DEPS_DIR}/imtui/src/imtui-impl-text.cpp
)

# ----------------------------------------------------------------------
# Third-party libraries
# ----------------------------------------------------------------------
find_package(Curses REQUIRED)        # ncurses for ImTui
find_package(CURL   REQUIRED)        # libcurl ≥ 7.40, needs UDS support
find_package(Threads REQUIRED)       # libcurl may link against it

# ----------------------------------------------------------------------
# Target
# ----------------------------------------------------------------------
add_executable(curseditor ${PROJECT_SOURCES})

target_include_directories(curseditor PRIVATE
    ${INCLUDE_DIR}                    # your own headers
    ${CURSES_INCLUDE_DIR}
    ${DEPS_DIR}                       # umbrella include for other deps
    ${DEPS_DIR}/imgui
    ${DEPS_DIR}/imtui/include
    ${DEPS_DIR}/imtui/third-party/imgui
    ${DEPS_DIR}/imtui/third-party/imgui/imgui
)

target_link_libraries(curseditor
    PRIVATE
    ${CURSES_LIBRARIES}
    Threads::Threads
    CURL::libcurl                    # imported target from find_package(CURL)
)