
// Test 1: Copy and move semantics for primitive types and structs with copy ability.
// Setup a simple module for testing copying and moving functionality.
 
//# publish
module 0xBADA::CopyMoveTest {
    use std::vector;

    // Struct with copy ability
    struct CopyStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    public fun create_struct(a: u8, b: u16): CopyStruct {
        CopyStruct { a, b }
    }

    public fun test_copy_and_move_u8() {
        let original: u8 = 42;
        let copy_value = original; // copy
        let moved_value = copy_value; // move from copy
        // Use both original and moved_value to ensure no conflict
        assert!(original == 42, 999);
        assert!(moved_value == 42, 999);
        // last expression
        ()
    }

    public fun test_copy_and_move_struct() {
        let struct1 = create_struct(10, 300);
        let copy_struct = struct1; // copy
        // move from copy
        let struct2 = copy_struct;
        // use original struct1
        assert!(struct1.a == 10, 999);
        assert!(struct2.b == 300, 999);
        ()
    }

    public fun test_vector_copy_and_usage() {
        let vec_original: vector<u8> = vector::empty();
        vector::push_back(&mut vec_original, 1);
        vector::push_back(&mut vec_original, 2);
        let vec_copy = vec_original; // copy
        let vec_ref = &vec_copy; // borrow reference
        // Use the reference after move
        assert!(*vector::borrow(vec_ref, 0) == 1, 999);
        assert!(*vector::borrow(vec_ref, 1) == 2, 999);
        // use original vector: in Move, the move consumes ownership, so must ensure no reuse after move
        // last expression
        ()
    }
}

// Functions to run tests
public fun run_copy_struct_tests() {
    // Run test for primitive type copy/move
    0xBADA::CopyMoveTest::test_copy_and_move_u8();
    // Run test for struct copy/move
    0xBADA::CopyMoveTest::test_copy_and_move_struct();
    // Run test for vector copy/use
    0xBADA::CopyMoveTest::test_vector_copy_and_usage();
}


//# run 0xBADA::CopyMoveTest::run_copy_struct_tests --signers 0xC0DE

// Test 2: Setup file logging from environment variable to exercise that feature.
 
//# publish
module 0xFACE::FileLogger {
    use std::string;
    use std::file;
    use std::env;

    public fun setup_logging() {
        let env_name = b"LOG_FILE_NAME";
        let maybe_filename = env::var(env_name);
        if (maybe_filename.is_some()) {
            let filename_bytes = maybe_filename::unwrap(maybe_filename);
            let filename_str = string::utf8(&filename_bytes);
            // Create file handle
            let file_handle = file::create(filename_str);
            // Assume setting some global logger to write to this file
            // For test purity, just verify filename is acquired
        } else {
            // No environment variable set, do nothing
        }
        // last expression
        ()
    }
}

// Run setup logging with environment variable
public fun run_setup_logging() {
    0xFACE::FileLogger::setup_logging();
}


//# run 0xFACE::FileLogger::run_setup_logging --signers 0xC0DE


// Featurres:
// 9af19ba210d3086ac523ddbde2e6d610: Test that a value can be copied and then moved from the copy, while still allowing the original value to be used, for both primitive types and structs with the copy ability.
// e42dce7ea06b22692bc18a435a5737ce: Test that a vector can be copied and then its reference used after moving the original vector, ensuring correct live variable analysis for references and moves.
// 56a82df6b40d543d56a4081aa298c444: Set up file logging by specifying a file name from the environment variable.
