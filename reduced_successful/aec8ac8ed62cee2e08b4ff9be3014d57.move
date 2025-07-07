
//# publish
module 0xCAFE::TestModule {
    // Removed unused import 'signer'

    // Added 'key' ability so Pair can be used with move_to/move_from
    struct Pair has copy, drop, store, key {
        a: u8,
        b: u8,
    }

    public fun add_then_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let _fixed_value = 42u8;
        // Return the fixed value regardless of sum to test computation correctness separate from return
        _fixed_value
    }

    public fun apply_lambda_to_2_and_3(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(2u8, 3u8)
    }

    public fun use_custom_type(x: u8, y: u8): Pair {
        Pair { a: x, b: y }
    }

    public fun remove_self() {
        // This function will remove its struct at caller's address
        let addr = @0xCAFE;
        if (exists<Pair>(addr)) {
            move_from<Pair>(addr);
        };
    }
}



//# run 0xCAFE::TestModule::add_then_return_fixed --args 5u8 10u8



//# run 0xCAFE::TestModule::apply_lambda_to_2_and_3



//# run 0xCAFE::TestModule::use_custom_type --args 7u8 8u8



//# run 0xCAFE::TestModule::remove_self
