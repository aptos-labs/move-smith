
//# publish
module 0xCAFE::ComputeModule {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_internally(a: u8, b: u8): u8 {
        let intermediate = inline_addition(a, b);
        intermediate + 1
    }

    spec add_and_return_special {
        ensures result == 42 || result == x + y;
    }

    spec lambda_example {
        ensures result == a + b;
    }

    // Removed the spec for inline_addition because inline function specs are not supported yet
    /*
    spec inline_addition {
        ensures result == a + b;
    }
    */

    spec call_inline_internally {
        ensures result == a + b + 1;
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::ComputeModule;

    public fun call_nested_functions(a: u8, b: u8): u8 {
        let first = ComputeModule::add_and_return_special(a, b);
        let second = ComputeModule::call_inline_internally(a, b);
        first + second
    }

    spec call_nested_functions {
        ensures result == (ComputeModule::add_and_return_special(a, b) + ComputeModule::call_inline_internally(a, b));
    }
}



//# run
script {
    use 0xCAFE::ComputeModule;
    use 0xCAFE::CallerModule;

    fun main() {
        // Test addition with conditional return special value 42
        let result1 = ComputeModule::add_and_return_special(4u8, 6u8); // sum=10 => 42 expected
        let _ = result1;

        // Test lambda function
        let result2 = ComputeModule::lambda_example(7u8, 8u8); // 15 expected
        let _ = result2;

        // Test internal inline function call
        let result3 = ComputeModule::call_inline_internally(1u8, 2u8); // 4 expected (3 + 1)
        let _ = result3;

        // Test nested function calls across modules
        let result4 = CallerModule::call_nested_functions(3u8, 3u8); // (6 or 42) + (7) expected; since sum=6 not 10, add_and_return_special returns 6; so 6 + 7 = 13
        let _ = result4;
    }
}
