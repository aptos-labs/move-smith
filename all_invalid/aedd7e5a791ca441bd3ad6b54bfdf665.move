// #publish
module 0xCAFE::ClosureTest {
    use std::vector;

    // A function that returns a closure capturing a variable.
    // In Move, closures aren't first-class citizens, but we simulate capturing via functions that take arguments.
    // This tests nested closures with captures by nesting functions with inline local captures.
    public fun nested_capture(x: u64): u64 acquires ClosureTest {
        // The outer "closure"
        let outer_capture = move |y: u64| {
            // The inner "closure"
            let inner_capture = move |z: u64| {
                // Use all captured variables x, y, z.
                x + y + z
            };
            inner_capture(30)
        };
        outer_capture(20)
    }

    // Runner function for nested_capture
    public fun run_nested_capture(): u64 {
        nested_capture(10)
    }


    // Function declared NOT to return function-typed values, to test environment limitations.
    // Here we just write a function that returns a u8; no function-typed return.
    public fun no_function_return(x: u8): u8 {
        x + 1
    }

    public fun run_no_function_return(): u8 {
        no_function_return(7)
    }


    // Impure function to simulate impure construct in specification.
    // For example, a storage write is impure.
    public fun impure_storage_write(account: &signer) {
        // Simulate impure action
        move_to(account, Self { dummy_field: 1 });
    }

    struct Self has store {
        dummy_field: u8,
    }

    // Spec function with impure call, to view call chain in spec checking
    #[spec]
    fun spec_impure_call(addr: address) {
        // This impure call in spec should cause violation with call chain printed
        Self::impure_direct_call(addr)
    }

    #[spec]
    fun impure_direct_call(addr: address) {
        // Impure call in spec context
        move_to_spec(addr, Self { dummy_field: 7 }) // storage write in spec - impure
    }

    #[spec] 
    native(friend);
    fun move_to_spec(addr: address, value: Self);

    // Runner function for impure_storage_write
    public fun run_impure_write(account: &signer) {
        impure_storage_write(account)
    }
}

// #run 0xCAFE::ClosureTest::run_nested_capture
// #run 0xCAFE::ClosureTest::run_no_function_return
// #run 0xCAFE::ClosureTest::run_impure_write --signers 0xCAFE

// #publish
module 0xCAFE::Runner {
    use 0xCAFE::ClosureTest;

    // Script to run runner functions and print results.
    script {
        use std::debug;
        use std::signer;

        fun main(account: signer) {
            let nested_result = ClosureTest::run_nested_capture();
            debug::print(&vector::singleton(b"Nested capture result: "));
            debug::print(&vector::singleton(u8(nested_result as u8)));

            let no_func_ret = ClosureTest::run_no_function_return();
            debug::print(&vector::singleton(b" No func return result: "));
            debug::print(&vector::singleton(no_func_ret));

            ClosureTest::run_impure_write(&account);
            debug::print(&vector::singleton(b" Impure write executed"));
        }
    }
}
// #run 0xCAFE::Runner::main --signers 0xCAFE

// Featurres:
// 081aeb33a6d9532a045a6ffc0a06d723: Test that nested closures correctly capture and use variables from their enclosing scope, including nested and re-entrant captures.
// c59529a48b9010cbea2c450960d883a7: Declare functions that do not return function-typed values unless allowed by the environment options.
// 8ee9cdbbaf8cbaff696ba611c081457b: View the call chain that led to an impure construct being used in a specification, pinpointing the source of the violation.
