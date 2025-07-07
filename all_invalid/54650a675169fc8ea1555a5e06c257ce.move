
//# publish
module 0xCAFE::ClosureAndSpecTest {
    use std::vector;
    use std::string;

    // Spec block attached to entire module
    spec module {
        // A dummy spec indicating all functions in this module are side-effect free.
        // This is just for demonstration; no real checking.
        fun module_is_pure(): bool {
            true
        }
    }

    // Function to demonstrate closures usage
    public fun test_closures(): u64 {
        // Define a closure that captures nothing
        let add_one: |u64| u64 = |x: u64| { x + 1 };

        // Define a closure that captures a variable
        let base: u64 = 10;
        let add_base: |u64| u64 = |x: u64| { x + base };

        // Call closures and sum the results
        let res1: u64 = add_one(5);
        let res2: u64 = add_base(5);
        res1 + res2
    }

    // Function returning a vector of all builtin type names
    public fun all_type_names(): vector<vector<u8>> {
        // These are some Move builtin types as strings
        vector[
            b"bool",
            b"u8",
            b"u16",
            b"u32",
            b"u64",
            b"u128",
            b"address",
            b"vector",
            b"struct",
            b"signer",
            b"bool",
            b"byte"
        ]
    }

    // Runner function calling above functions
    public fun runner(): u64 {
        let closure_result = test_closures();

        let names = all_type_names();

        // For usage demonstration, sum byte lengths of type names plus closure_result
        let acc: u64 = 0;
        let len = vector::length(&names);
        let i = 0;
        while (i < len) {
            acc = acc + (vector::length(&vector::borrow(&names, i)) as u64);
            i = i + 1;
        };

        closure_result + acc
    }
}


//# run 0xCAFE::ClosureAndSpecTest::test_closures


//# run 0xCAFE::ClosureAndSpecTest::all_type_names


//# run 0xCAFE::ClosureAndSpecTest::runner


// Featurres:
// 85c48ba5a7da7c03dbf39553d01c6ee2: Create and use closures, with closure-specific correctness checks in Move 2.2 and above
// 83167d7245798f4b191535799142c0f7: Use the 'all_type_names' function to access a set containing all the built-in type names defined in the Move compiler.
// 6fc375cc07405a18b00028440c7ab966: Attach specification blocks to entire modules to specify module-level properties.
