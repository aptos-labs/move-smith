
//# publish
module 0xCAFE::AddModule {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    // Write functions containing lambda (anonymous function) expressions.
    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        let my_lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        my_lambda(x, y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
    // This function calls AddModule::add_values and AddModule::apply_lambda and produces a combined result
    public fun nested_call(a: u8, b: u8): u8 {
        let sum = AddModule::add_values(a, b);

        let (add_res, mul_res) = AddModule::apply_lambda(a, b);
        // Return sum + mul_res capped at 255 (u8 max)
        if (sum + mul_res > 255) {
            255u8
        } else {
            sum + mul_res
        }
    }
}


//# publish
module 0xCAFE::FileReadModule {
    use std::vector;
    use std::string;

    // Annotate a resource type with abilities copy, drop, store and key
    struct File has copy, drop, store, key {
        name: vector<u8>,
        contents: vector<u8>,
    }

    // This function simulates "opening and reading" a Move source file by filename.
    // Since Move VM cannot access actual file system, we simulate the file content for a specific filename.
    public fun open_and_read(filename: vector<u8>): vector<u8> {
        let known_filename = b"test.move";
        if (vector::length(&filename) == vector::length(&known_filename)) {
            let equal = true;
            let len = vector::length(&filename);
            let i = 0u64;
            while (i < len) {
                if (*vector::borrow(&filename, i as u64) != *vector::borrow(&known_filename, i as u64)) {
                    equal = false;
                };
                i = i + 1;
            };
            if (equal) {
                // Simulated file contents as vector<u8>
                b"// This is a test Move source file\nmodule 0xCAFE::Dummy {}\n"
            } else {
                vector::empty<u8>()
            }
        } else {
            vector::empty<u8>()
        }
    }
}


//# run 0xCAFE::AddModule::add_values --args 50u8 30u8


//# run 0xCAFE::AddModule::apply_lambda --args 5u8 6u8


//# run 0xCAFE::CallerModule::nested_call --args 10u8 20u8


//# run 0xCAFE::FileReadModule::open_and_read --args b"test.move"


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 164ba562c4731671143e8b98bdd3d61c: Open and read a Move source file by filename.
// 50d5db87db2e2d6d33db299be9acb706: Annotate types with abilities such as 'copy', 'drop', 'store', or 'key'.
