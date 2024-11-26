# check_class prints error for single input [plain]

    Code
      check_class(x = "x", .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      x You provided:
      * `x` with class <character>
    Code
      check_class(x = list(), .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      x You provided:
      * `x` with class <list>
    Code
      check_class(x = data.frame(), .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      x You provided:
      * `x` with class <data.frame>
    Code
      check_class(x = matrix(), .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      x You provided:
      * `` with class <matrix>
      * `` with class <array>
    Code
      check_class(x = 1, .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      x You provided:
      * `x` with class <numeric>
    Code
      check_class(x = list(), .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      x You provided:
      * `x` with class <list>
    Code
      check_class(x = data.frame(), .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      x You provided:
      * `x` with class <data.frame>
    Code
      check_class(x = matrix(), .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      x You provided:
      * `` with class <matrix>
      * `` with class <array>

# check_class prints error for single input [ansi]

    Code
      check_class(x = "x", .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<character>[39m
    Code
      check_class(x = list(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<list>[39m
    Code
      check_class(x = data.frame(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<data.frame>[39m
    Code
      check_class(x = matrix(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `` with class [34m<matrix>[39m
      [36m*[39m `` with class [34m<array>[39m
    Code
      check_class(x = 1, .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<numeric>[39m
    Code
      check_class(x = list(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<list>[39m
    Code
      check_class(x = data.frame(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<data.frame>[39m
    Code
      check_class(x = matrix(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `` with class [34m<matrix>[39m
      [36m*[39m `` with class [34m<array>[39m

# check_class prints error for single input [unicode]

    Code
      check_class(x = "x", .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      ✖ You provided:
      • `x` with class <character>
    Code
      check_class(x = list(), .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      ✖ You provided:
      • `x` with class <list>
    Code
      check_class(x = data.frame(), .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      ✖ You provided:
      • `x` with class <data.frame>
    Code
      check_class(x = matrix(), .expected_class = "numeric")
    Condition
      Error:
      ! `x` must be of class <numeric>
      ✖ You provided:
      • `` with class <matrix>
      • `` with class <array>
    Code
      check_class(x = 1, .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      ✖ You provided:
      • `x` with class <numeric>
    Code
      check_class(x = list(), .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      ✖ You provided:
      • `x` with class <list>
    Code
      check_class(x = data.frame(), .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      ✖ You provided:
      • `x` with class <data.frame>
    Code
      check_class(x = matrix(), .expected_class = "character")
    Condition
      Error:
      ! `x` must be of class <character>
      ✖ You provided:
      • `` with class <matrix>
      • `` with class <array>

# check_class prints error for single input [fancy]

    Code
      check_class(x = "x", .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<character>[39m
    Code
      check_class(x = list(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<list>[39m
    Code
      check_class(x = data.frame(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<data.frame>[39m
    Code
      check_class(x = matrix(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `` with class [34m<matrix>[39m
      [36m•[39m `` with class [34m<array>[39m
    Code
      check_class(x = 1, .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<numeric>[39m
    Code
      check_class(x = list(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<list>[39m
    Code
      check_class(x = data.frame(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<data.frame>[39m
    Code
      check_class(x = matrix(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `` with class [34m<matrix>[39m
      [36m•[39m `` with class [34m<array>[39m

# check_class prints error for multiple input [plain]

    Code
      check_class(x = 1, y = "x", .expected_class = "numeric")
    Condition
      Error:
      ! `y` must be of class <numeric>
      x You provided:
      * `y` with class <character>
    Code
      check_class(x = "x", y = "y", .expected_class = "numeric")
    Condition
      Error:
      ! `x` and `y` must be of class <numeric>
      x You provided:
      * `x` with class <character>
      * `y` with class <character>
    Code
      check_class(x = 1, y = "x", z = list(), a = data.frame(), .expected_class = "numeric")
    Condition
      Error:
      ! `y`, `z`, and `a` must be of class <numeric>
      x You provided:
      * `y` with class <character>
      * `z` with class <list>
      * `a` with class <data.frame>
    Code
      check_class(x = "x", y = 1, .expected_class = "character")
    Condition
      Error:
      ! `y` must be of class <character>
      x You provided:
      * `y` with class <numeric>
    Code
      check_class(x = 1, y = 2, .expected_class = "character")
    Condition
      Error:
      ! `x` and `y` must be of class <character>
      x You provided:
      * `x` with class <numeric>
      * `y` with class <numeric>
    Code
      check_class(x = "x", y = 1, z = list(), a = data.frame(), .expected_class = "character")
    Condition
      Error:
      ! `y`, `z`, and `a` must be of class <character>
      x You provided:
      * `y` with class <numeric>
      * `z` with class <list>
      * `a` with class <data.frame>

# check_class prints error for multiple input [ansi]

    Code
      check_class(x = 1, y = "x", .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `y` with class [34m<character>[39m
    Code
      check_class(x = "x", y = "y", .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` and `y` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<character>[39m
      [36m*[39m `y` with class [34m<character>[39m
    Code
      check_class(x = 1, y = "x", z = list(), a = data.frame(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y`, `z`, and `a` must be of class [34m<numeric>[39m
      [31mx[39m You provided:
      [36m*[39m `y` with class [34m<character>[39m
      [36m*[39m `z` with class [34m<list>[39m
      [36m*[39m `a` with class [34m<data.frame>[39m
    Code
      check_class(x = "x", y = 1, .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `y` with class [34m<numeric>[39m
    Code
      check_class(x = 1, y = 2, .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` and `y` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `x` with class [34m<numeric>[39m
      [36m*[39m `y` with class [34m<numeric>[39m
    Code
      check_class(x = "x", y = 1, z = list(), a = data.frame(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y`, `z`, and `a` must be of class [34m<character>[39m
      [31mx[39m You provided:
      [36m*[39m `y` with class [34m<numeric>[39m
      [36m*[39m `z` with class [34m<list>[39m
      [36m*[39m `a` with class [34m<data.frame>[39m

# check_class prints error for multiple input [unicode]

    Code
      check_class(x = 1, y = "x", .expected_class = "numeric")
    Condition
      Error:
      ! `y` must be of class <numeric>
      ✖ You provided:
      • `y` with class <character>
    Code
      check_class(x = "x", y = "y", .expected_class = "numeric")
    Condition
      Error:
      ! `x` and `y` must be of class <numeric>
      ✖ You provided:
      • `x` with class <character>
      • `y` with class <character>
    Code
      check_class(x = 1, y = "x", z = list(), a = data.frame(), .expected_class = "numeric")
    Condition
      Error:
      ! `y`, `z`, and `a` must be of class <numeric>
      ✖ You provided:
      • `y` with class <character>
      • `z` with class <list>
      • `a` with class <data.frame>
    Code
      check_class(x = "x", y = 1, .expected_class = "character")
    Condition
      Error:
      ! `y` must be of class <character>
      ✖ You provided:
      • `y` with class <numeric>
    Code
      check_class(x = 1, y = 2, .expected_class = "character")
    Condition
      Error:
      ! `x` and `y` must be of class <character>
      ✖ You provided:
      • `x` with class <numeric>
      • `y` with class <numeric>
    Code
      check_class(x = "x", y = 1, z = list(), a = data.frame(), .expected_class = "character")
    Condition
      Error:
      ! `y`, `z`, and `a` must be of class <character>
      ✖ You provided:
      • `y` with class <numeric>
      • `z` with class <list>
      • `a` with class <data.frame>

# check_class prints error for multiple input [fancy]

    Code
      check_class(x = 1, y = "x", .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `y` with class [34m<character>[39m
    Code
      check_class(x = "x", y = "y", .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` and `y` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<character>[39m
      [36m•[39m `y` with class [34m<character>[39m
    Code
      check_class(x = 1, y = "x", z = list(), a = data.frame(), .expected_class = "numeric")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y`, `z`, and `a` must be of class [34m<numeric>[39m
      [31m✖[39m You provided:
      [36m•[39m `y` with class [34m<character>[39m
      [36m•[39m `z` with class [34m<list>[39m
      [36m•[39m `a` with class [34m<data.frame>[39m
    Code
      check_class(x = "x", y = 1, .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `y` with class [34m<numeric>[39m
    Code
      check_class(x = 1, y = 2, .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `x` and `y` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `x` with class [34m<numeric>[39m
      [36m•[39m `y` with class [34m<numeric>[39m
    Code
      check_class(x = "x", y = 1, z = list(), a = data.frame(), .expected_class = "character")
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `y`, `z`, and `a` must be of class [34m<character>[39m
      [31m✖[39m You provided:
      [36m•[39m `y` with class [34m<numeric>[39m
      [36m•[39m `z` with class [34m<list>[39m
      [36m•[39m `a` with class [34m<data.frame>[39m

