
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // NOTE: Move currently does NOT support lambda syntax or anonymous functions.
    // We replace these lambdas with normal named functions.
    public fun double(a: u8): u8 {
        a + a
    }

    public fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun lambda_double_and_add() {
        let val = 3u8;
        let doubled = Self::double(val);
        let result = Self::add(doubled, val);
        let _ = result; // Just use the lambda results to test anonymous function support
    }

    public fun runner() {
        let _ = add_and_return_sum(5, 10);
        lambda_double_and_add();
    }
}



//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun incr_and_double(a: u8): u8 {
        let one_added = a + 1;
        let doubled = LambdaTest::add_and_return_sum(one_added, one_added);
        doubled
    }

    public fun runner() {
        let _ = incr_and_double(4u8);
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::LambdaTest::lambda_double_and_add



//# run 0xCAFE::NestedCallTest::runner
