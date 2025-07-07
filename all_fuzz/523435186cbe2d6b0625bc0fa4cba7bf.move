
//# publish
module 0xCAFE::MathModule {
    // Simple function to add two u8 values and return the sum + 10
    public fun add_two_values_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function with a lambda (anonymous function) that multiplies two u8 values
    public fun multiply_with_lambda(x: u8, y: u8): u8 {
        let multiply: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        multiply(x, y)
    }

    // Lambda that returns a tuple of (sum, product)
    public fun sum_and_product_lambda(a: u8, b: u8): (u8, u8) {
        let compute: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        compute(a, b)
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathModule;

    // Calls inline function from MathModule inside an inline function here returning adjusted sum
    public fun compute_and_adjust(a: u8, b: u8): u8 {
        let sum = MathModule::add_two_values_and_offset(a, b);
        sum + 5
    }

    // Calls sum_and_product_lambda of MathModule and sums the results
    public fun sum_of_sum_and_product(a: u8, b: u8): u8 {
        let (sum, product) = MathModule::sum_and_product_lambda(a, b);
        sum + product
    }

    // Runner that exercises nested calls with fixed arguments
    public fun run_runner() {
        let _ = compute_and_adjust(3u8, 4u8);
        let _ = sum_of_sum_and_product(5u8, 6u8);
    }
}



//# run 0xCAFE::MathModule::add_two_values_and_offset --args 7u8 8u8



//# run 0xCAFE::MathModule::multiply_with_lambda --args 3u8 5u8



//# run 0xCAFE::MathModule::sum_and_product_lambda --args 4u8 6u8



//# run 0xCAFE::NestedCalls::compute_and_adjust --args 2u8 3u8



//# run 0xCAFE::NestedCalls::sum_of_sum_and_product --args 3u8 4u8



//# run 0xCAFE::NestedCalls::run_runner
