#include <X.hpp>

int X::static_int = 42;

int X::weird_function() {
    return static_int;
}