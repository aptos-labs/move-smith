
//# publish
module 0xCAFE::MathUtils {
    // Module that has inline add function to add two u8 numbers
    public inline fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    // Test lambda function, capturing and returning sum of two u8s
    public fun lambda_add() : u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(10u8, 20u8)
    }

    // Runner function for transactional test
    public fun runner(): u8 {
        let sum = add_two_u8(1u8, 2u8);
        let lambda_sum = lambda_add();
        sum + lambda_sum
    }
}



//# run 0xCAFE::MathUtils::runner



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathUtils;

    // Call the inline add_two_u8 function from MathUtils and also lambda_add 
    public fun call_nested(): u8 {
        let base = MathUtils::add_two_u8(5u8, 7u8);
        let lambda_val = MathUtils::lambda_add();
        base + lambda_val
    }
}



//# run 0xCAFE::CallerModule::call_nested




//# publish
module 0xCAFE::ParseErrorDemo {
    // Function to simulate user-friendly parse error on EOF token
    public fun parse_error_message(sys_token_found: bool) {
        // Just simulate detection of EOF token encountered unexpectedly
        if (!sys_token_found) {
            // In real system this might happen during parsing
            // Just a demonstration of user-friendly message output (no abort here)
            let _user_msg = b"Error: Unexpected end-of-file token encountered during parsing.";
        } else {
            let _user_msg = b"Parsing passed.";
        };
    }
}



//# run 0xCAFE::ParseErrorDemo::parse_error_message --args false



//# run 0xCAFE::ParseErrorDemo::parse_error_message --args true




//# publish
module 0xCAFE::ChainedAccess {
    struct TestStruct has store {
        val_vec: vector<u8>
    }

    public fun create_struct_with_vec(): TestStruct {
        let v = vector[1u8, 2u8, 3u8];
        TestStruct {val_vec: v}
    }

    public fun get_second_element_plus_one(): u8 {
        let obj = create_struct_with_vec();
        // consume obj by unpacking it to avoid drop error
        let TestStruct { val_vec } = obj;
        1 + *std::vector::borrow(&val_vec, 1)
    }
}



//# run 0xCAFE::ChainedAccess::get_second_element_plus_one
