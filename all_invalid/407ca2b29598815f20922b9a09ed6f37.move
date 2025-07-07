
//# publish
module 0xBABE::VariableUnbindingTest {
    // Variable unpacking and name unbinding test
    public fun unpack_variables(x: u8, y: u16, z: u32): (u8, u16, u32) {
        let (_x, _y, _z) = (x, y, z);
        (_x, _y, _z)
    }

    // Function to test deprecation attribute at address level
    // Mark entire address as deprecated for test completeness
    // deprecated(address)]
    public fun deprecated_func(): u64 {
        42
    }

    // Generic function to test treating functions as first-class citizens
    public fun generic_identity<T>(val: T): T {
        val
    }

    // Function that takes a function pointer as argument
    public fun apply_function<T>(f: fn(T) -> T, arg: T): T {
        f(arg)
    }

    // Function that returns a function pointer
    public fun get_increment_function(): fn(u64) -> u64 {
        fn increment(x: u64): u64 {
            x + 1
        }
        increment
    }

    // Function combining unpacking, deprecation, and first-class function features
    public fun combined_test(): (u8, u16, u32, u64) {
        // Unpack variables with specific names
        let (a, b, c) = unpack_variables(1, 2, 3);
        // Call deprecated function
        let _ = deprecated_func();
        // Treat a generic function as a first-class value
        let id_fn: fn(u64) -> u64 = generic_identity;
        let result = id_fn(100);
        // Get a function and invoke it
        let inc_fn = get_increment_function();
        let incremented = inc_fn(41);
        (a, b, c, incremented + result)
    }
}



//# run 0xBABE::VariableUnbindingTest::unpack_variables --args 5u8 10u16 15u32


//# run 0xBABE::VariableUnbindingTest::deprecated_func


//# run 0xBABE::VariableUnbindingTest::apply_function --args 0xBABE::VariableUnbindingTest::generic_identity --args 123u64


//# run 0xBABE::VariableUnbindingTest::get_increment_function


//# run 0xBABE::VariableUnbindingTest::combined_test


// Featurres:
// e72a272d426fefa1d35ea88d03eb3386: Use variable names to unbind variables during unpacking operations.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
