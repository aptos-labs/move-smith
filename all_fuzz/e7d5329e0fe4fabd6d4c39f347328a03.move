
//# publish
module 0xCAFE::AddAndLambda {
    /// Simple addition function for two u8 numbers
    // inline]
    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    /// Function that returns the sum of two numbers plus one
    // inline]
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        sum + 1
    }

    /// Function with lambda: takes two u8 and returns sum and product as a tuple
    public fun compute_with_lambda(a: u8, b: u8): (u8, u8) {
        // lambda expression that captures a and b locally
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            let p = x * y;
            (s, p)
        };
        lambda(a, b)
    }

    /// Runner function to call compute_with_lambda with fixed values
    public fun run_lambda(): (u8, u8) {
        compute_with_lambda(3u8, 4u8)
    }
}



//# run 0xCAFE::AddAndLambda::add_u8 --args 5u8 10u8



//# run 0xCAFE::AddAndLambda::add_and_increment --args 5u8 10u8



//# run 0xCAFE::AddAndLambda::compute_with_lambda --args 3u8 4u8



//# run 0xCAFE::AddAndLambda::run_lambda




//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndLambda;

    /// Inline helper function multiplies and adds using AddAndLambda module calls
    // inline]
    public fun multiply_and_add(x: u8, y: u8): u8 {
        let sum = AddAndLambda::add_u8(x, y);
        // multiply using lambda inside AddAndLambda by extracting product from tuple
        let (_, product) = AddAndLambda::compute_with_lambda(x, y);
        sum + product
    }

    /// Runner function calls multiply_and_add with fixed args
    public fun runner(): u8 {
        multiply_and_add(2u8, 3u8)
    }
}



//# run 0xCAFE::NestedCall::multiply_and_add --args 2u8 3u8



//# run 0xCAFE::NestedCall::runner



//# run
script {
    use 0xCAFE::AddAndLambda;
    use 0xCAFE::NestedCall;

    public fun main() {
        let add_res = AddAndLambda::add_u8(10u8, 20u8);
        let add_inc_res = AddAndLambda::add_and_increment(10u8, 20u8);
        let (lam_sum, lam_prod) = AddAndLambda::compute_with_lambda(5u8, 6u8);
        let nested_res = NestedCall::multiply_and_add(4u8, 5u8);

        // Use results to prevent unused variable warnings
        let _ = add_res;
        let _ = add_inc_res;
        let _ = lam_sum;
        let _ = lam_prod;
        let _ = nested_res;
    }
}
