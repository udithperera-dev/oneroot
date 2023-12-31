#[[
* *
*  * Created by Udith Perera on 12/21/23, 1:57 PM
*  * Copyright (c) 2023 . All rights reserved.
*  * Last modified 12/21/23, 1:57 PM
*  * Web : www.akurupela.com
*  * Email : info@akurupela.com
*
]]


cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector-all")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-protector-all")

add_library(toolChecker SHARED
        oneroot_binary.cpp)

target_link_libraries(toolChecker
        android
        log)