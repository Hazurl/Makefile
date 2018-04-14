#include <iostream>

// Can be use if the makefile is set up with `include/` as include path
#include <X.hpp>
// otherwise
// #include "../include/X.hpp"

int main() {
    X x;
    std::cout << "Hello from main.cpp\n";
    std::cout << "The value of X::static_int is " << x.weird_function() << '\n'; 
}