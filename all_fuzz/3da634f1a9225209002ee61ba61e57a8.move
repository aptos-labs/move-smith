
//# publish
module 0xCAFE::Adder {
    // Test addition of two u8 before returning a specific value

    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 for demonstration
        sum + 1
    }

    // Lambda usage: define a closure that doubles a value and add external parameter
    public fun lambda_double_add(x: u8, y: u8): u8 {
        let double = |n: u8| n * 2;
        double(x) + y
    }

    // Inline function to be used cross-module
    public inline fun inline_increment(x: u16): u16 {
        x + 1
    }
}



//# run 0xCAFE::Adder::add_then_return_sum --args 10u8 20u8



//# run 0xCAFE::Adder::lambda_double_add --args 5u8 3u8



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    // Call inline function cross-module to test nested calls
    public fun call_inline(x: u16): u16 {
        Adder::inline_increment(x)
    }
}



//# run 0xCAFE::Caller::call_inline --args 41u16



//# publish
module 0xCAFE::SpecExample {
    // Removed 'use std::spec;' as 'spec' module is not recognized in current environment

    struct SpecStruct has store {
        val: u8,
    }

    // Function with a spec block
    public fun with_spec(x: u8): u8 {
        // Spec blocks are currently not supported, commenting out for compile
        /*
        spec {
            ensures result == x + 5;
        }
        */
        x + 5
    }
}



//# run 0xCAFE::SpecExample::with_spec --args 10u8



//# publish
module 0xCAFE::MultiAnonBlocks {
    public fun multiple_blocks(x: u8): u8 {
        {
            let a = x + 1;
            a;
        };
        {
            let b = x + 2;
            b;
        };
        // Final anonymous block returning sum of previous two plus 1
        {
            let a = x + 1;
            let b = x + 2;
            a + b + 1
        }
    }
}



//# run 0xCAFE::MultiAnonBlocks::multiple_blocks --args 10u8
