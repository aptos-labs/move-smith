
//# publish
module 0xCAFE::OptimizationTest {
    use std::vector;
    use std::option::Option;

    struct Container<T> has copy, drop {
        value: T,
    }

    // Function using basic arithmetic operations to get bytecode optimized
    public fun compute(mut x: u8): u8 {
        x = x + 1;
        x = x * 2;
        if (x > 10) {
            x = x - 5;
        } else {
            x = x + 5;
        };
        x
    }

    // Function that returns optional tuple for unpacking test
    public fun optional_unpack(flag: bool): Option<(u8, u8)> {
        if (flag) {
            Option::some((3u8, 4u8))
        } else {
            Option::none<(u8, u8)>()
        }
    }

    // Helper function to sum the tuple if Option is Some, else 0
    public fun sum_optional_tuple(opt: Option<(u8, u8)>): u8 {
        match opt {
            Option::Some((a, b)) => a + b,
            Option::None => 0,
        }
    }

    // Function that modifies the mutable ref and returns a bound for the for loop
    public fun update_and_loop_limit(bound_ref: &mut u8): u8 {
        *bound_ref = *bound_ref + 3;
        *bound_ref
    }

    // Function that tests the for loop with bound from update_and_loop_limit
    public fun for_loop_test() {
        let bound = 2u8;
        let n = update_and_loop_limit(&mut bound);

        let sum = 0u8;
        for (i in 0..n) {
            sum = sum + i;
        };
    }
}



//# run 0xCAFE::OptimizationTest::compute --args 5u8


//# run 0xCAFE::OptimizationTest::optional_unpack --args true


//# run 0xCAFE::OptimizationTest::optional_unpack --args false


//# run 0xCAFE::OptimizationTest::sum_optional_tuple --args "7" "8"


//# run 0xCAFE::OptimizationTest::for_loop_test
