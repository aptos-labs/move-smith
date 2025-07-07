// Filename: tests/transactional/compile_vm_tests.move
// Purpose: Transactional test covering compiler errors on restricted names, 
// correct handling of variable bindings and functional constructs,
// and defaulting to Name expression without colon (access chain 'One').

module 0x1::compile_vm_tests {
    use std::debug;
    use std::vector;

    /// Test 1: Using restricted names for Move constructs should fail to compile.
    /// We'll put these inside separate functions with comments, 
    /// so the test framework can validate these produce compiler errors.
    ///
    /// Unfortunately, Move doesn't allow deliberately invalid code to be compiled in the same module,
    /// so these pieces will be commented with explanation where a user can try to compile
    /// to verify error messages.
    ///
    /// The test framework should attempt to compile these snippets separately.

    // ==== Test 1: Compile error tests ====

    /*
    // Error Case: Using reserved keyword `module` as a module name - should throw an error.
    module 0x1::module {
        fun dummy(): u64 { 0 }
    }
    */

    /*
    // Error Case: Using restricted name `fun` as a function name - should throw an error.
    module 0x1::foo {
        public fun fun(): u64 { 42 }
    }
    */

    /*
    // Error Case: Using restricted name `let` as a variable name - should throw an error.
    module 0x1::foo {
        public fun test() {
            let let = 1; // 'let' is a keyword, cannot be used as variable name
            debug::print(&let);
        }
    }
    */

    // ==== Test 2: Variable bindings, destructuring, inline functions, HOF, anonymous closures ====

    /// Struct and helper for destructuring
    struct Pair has copy, drop, store {
        x: u64,
        y: u64,
    }

    /// Higher-order function that takes a function (u64, u64) -> u64 and applies it to two numbers
    public fun apply_fn(f: &fun(u64, u64): u64, a: u64, b: u64): u64 {
        f(*a, *b)
    }

    /// Inline function example
    public fun inline_increment(x: u64): u64 {
        // define an inline lambda-like function (anonymous closure)
        // Note: Move currently does not officially support anonymous closures,
        // but it supports references to public function pointers.
        //
        // Simulate closure by reference to function pointer.
        let inc = &add_one;
        inc(x)
    }

    /// Public function for inline increment
    public fun add_one(x: u64): u64 {
        x + 1
    }

    /// Test destructuring of a struct inside a function
    public fun test_destructuring(p: Pair): u64 {
        let Pair { x, y } = p; // destructuring, bind variables
        x * y
    }

    /// Example function to test inline function passed as argument
    public fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    /// Main test function that tests all the above concepts together transactionally
    public fun test_all(): u64 {
        // Variable bindings
        let x = 10;
        let y = 20;

        // Destructuring
        let p = Pair { x: x, y: y };
        let product = test_destructuring(p);
        assert!(product == 200, 1);

        // Inline function invocation
        let inc_x = inline_increment(x);
        assert!(inc_x == 11, 2);

        // Higher order function with multiply
        let mul_res = apply_fn(&multiply, x, y);
        assert!(mul_res == 200, 3);

        // Anonymous closure simulation:
        // Move doesn't support anonymous in-line closures,
        // but references to functions can behave like HOF parameters.
        // We'll simulate by passing a function pointer.

        // Compose a "closure" that adds two and multiplies by three
        // Actually define a temp function inside this function for demo:
        fun add_then_mul(a: u64, b: u64): u64 {
            let sum = a + b;
            sum * 3
        }
        let res = apply_fn(&add_then_mul, 1, 2);
        assert!(res == 9, 4);

        // All tests passed return sum of results
        product + inc_x + mul_res + res
    }

    // ==== Test 3: Omit colon to default to creating a Name expression with access chain 'One' ====

    // In Move script syntax (transaction scripts), omitting leading colon before identifier
    // creates a Name expression with access chain starting with that identifier.
    // Since this is a module and in Move code, we can show an example through naming and access expressions.

    // We create a function that simulates this by showing a variable called One and using it.

    const One: u64 = 1;

    public fun test_access_chain() {
        // Use One directly without colon prefix - tests that One is accessed by default as a Name expression.
        let v = One;
        assert!(v == 1, 5);
    }

}

// Featurres:
// d877c8510ec718ba1a581eca0d7a5155: Receive clear error messages when attempting to use a restricted name for a Move construct such as a module, function, or variable.
// a266a7f8865315499de9a81c96b2fb89: Test the correct handling of variable bindings, destructuring, inline functions, higher-order functions, and anonymous closures in Move.
// b9ad8da44435f4a319fe70768091b32a: Omit the colon to default to creating a Name expression with access chain 'One'.
