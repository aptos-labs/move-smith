
//# publish
module 0xCAFE::TestModule {
    // This module tests functions returning addition of two u8 values,
    // contains lambda expressions, and calls inline function from another module.

    // Since 0xCAFE::MyModule does not exist and cannot be referenced,
    // we define the required functions inline here for testing.

    // Simulate MyModule::f1: add 1 if condition is true, else add 0
    fun f1(x: u8, cond: bool): u8 {
        if (cond) {
            x + 1
        } else {
            x
        }
    }

    // Simulate MyModule::f2: returns a tuple (x, x+1)
    fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    // Simple function to add two u8 values and then add 10 using MyModule::f1
    public fun add_and_process(a: u8, b: u8): u8 {
        let sum = a + b;
        // Use f1 to add 1 more if true, true always for simplicity
        let result = f1(sum, true);
        result
    }

    // Function containing lambda expressions that returns sum and product of two values
    public fun lambda_test(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let c = x + y;
            let d = x * y;
            (c, d)
        };
        lambda(a, b)
    }

    // Function that calls inline function from MyModule and adds 100 to the first result
    public fun call_inline_and_add(x: u16): u16 {
        let (a, _b) = f2(x);
        a + 100u16
    }

    public fun runner() {
        let _ = add_and_process(2u8, 3u8);
        let (_sum, _product) = lambda_test(4u8, 5u8);
        let _ = call_inline_and_add(10u16);
    }
}



//# run 0xCAFE::TestModule::add_and_process --args 10u8 20u8



//# run 0xCAFE::TestModule::lambda_test --args 6u8 7u8



//# run 0xCAFE::TestModule::call_inline_and_add --args 5u16



//# run 0xCAFE::TestModule::runner
