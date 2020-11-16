cmake_minimum_required(VERSION 3.16)
project(multithreading_t3)

set(CMAKE_CXX_STANDARD 14)

add_executable(multithreading_t3 main.cpp)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(multithreading_t3 Threads::Threads)