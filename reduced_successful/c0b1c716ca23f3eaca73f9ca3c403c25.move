
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return the sum + 1 to check proper computation
        sum + 1
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, y)
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_sum --args 3u8 4u8



//# run 0xCAFE::AdditionModule::use_lambda --args 5u8 7u8



//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun call_add_with_inline(x: u8, y: u8): u8 {
        // Calls the AdditionModule function that adds and returns sum+1
        AdditionModule::add_and_return_sum(x, y)
    }

    // Runner function without arguments to call the above function
    public fun runner(): u8 {
        call_add_with_inline(10u8, 20u8)
    }
}



//# run 0xCAFE::NestedInlineCaller::runner



//# publish
module 0xCAFE::VectorHexTest {
    use std::vector;

    public fun compare_vectors(): bool {
        let explicit_vec = vector[0xDEu8, 0xADu8, 0xBEu8, 0xEFu8];
        let hex_vec = x"DEADBEEF";

        // Check lengths
        assert!(vector::length(&explicit_vec) == vector::length(&hex_vec), 1);

        // Check elements equal
        let i = 0;
        while (i < vector::length(&explicit_vec)) {
            assert!(*vector::borrow(&explicit_vec, i) == *vector::borrow(&hex_vec, i), 2);
            i = i + 1;
        };

        true
    }
}



//# run 0xCAFE::VectorHexTest::compare_vectors



//# publish
module 0xCAFE::WildcardAccessTest {
    public fun wildcard_access(): u8 {
        // Valid use of wildcard for public function in AdditionModule
        let f = 0xCAFE::AdditionModule::add_and_return_sum;
        // Call using the wildcard access
        f(2u8, 3u8)
    }
}



//# run 0xCAFE::WildcardAccessTest::wildcard_access
