
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    /// Function to add two u8 values and then add an offset to the sum
    public fun add_with_offset(a: u8, b: u8, offset: u8): u8 {
        let sum = a + b;
        sum + offset
    }

    /// Function with lambda expression that multiplies and adds inputs
    public fun lambda_expr(a: u8, b: u8): u8 {
        let f: (u8, u8) -> u8 has copy + drop = |x: u8, y: u8| {
            x * y + x
        };
        f(a, b)
    }

    /// Runner function to test above two functions
    public fun run_tests(): u8 {
        let v1 = add_with_offset(2u8, 3u8, 4u8);
        let v2 = lambda_expr(3u8, 5u8);
        v1 + v2
    }

    spec {
        fun add_with_offset(a: u8, b: u8, offset: u8) {
            ensures result >= a;
        }

        fun lambda_expr(a: u8, b: u8) {
            ensures result > 0;
        }
    }
}




//# run 0xCAFE::LambdaTest::run_tests





//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaTest;

    /// Inline function returning a tuple of increments applied to input
    public inline fun inline_increment(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }

    /// Function that calls inline_increment inside and adjusts sum
    public fun nested_call(x: u8): u8 {
        let (a, b) = inline_increment(x);
        // Call a function from another module to add with offset
        let c = LambdaTest::add_with_offset(a, b, 1u8);
        c
    }

    spec nested_call {
        ensures result > x;
    }
}




//# run 0xCAFE::NestedInlineCall::nested_call --args 5u8





//# publish
module 0xCAFE::SpecAnnotations {
    struct Simple has copy, drop, store {
        val: u8,
    }

    public fun create(val: u8): Simple {
        Simple { val }
    }

    public fun increment(s: &mut Simple) {
        s.val = s.val + 1;
    }

    spec Simple {
        invariant val >= 0;
    }

    spec increment {
        modifies s;
        ensures s.val == old(s.val) + 1;
    }

    spec create {
        ensures result.val == val;
    }
}




//# run 0xCAFE::SpecAnnotations::create --args 10u8
