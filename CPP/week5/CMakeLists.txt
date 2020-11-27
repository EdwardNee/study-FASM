cmake_minimum_required(VERSION 3.16)
project(multitr_omp_4)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fopenmp")

add_executable(multitr_omp_4 main.cpp)
find_package(Threads REQUIRED)
target_link_libraries(multitr_omp_4 Threads::Threads)