
//# publish
module 0xCAFE::AdditionModule {
    // Module to test u8 addition and inline function calls

    const EXPECTED_RESULT: u8 = 42;

    public inline fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = add_two(a, b);
        if (sum == EXPECTED_RESULT) {
            EXPECTED_RESULT
        } else {
            sum
        }
    }

    public fun caller_add_and_check(a: u8, b: u8): u8 {
        // Call inline function defined above via nested call
        add_and_check(a, b)
    }
}



//# run 0xCAFE::AdditionModule::add_and_check --args 20u8 22u8



//# run 0xCAFE::AdditionModule::add_and_check --args 10u8 5u8



//# run 0xCAFE::AdditionModule::caller_add_and_check --args 40u8 2u8




//# publish
module 0xCAFE::AnnotationModule {
    // This module includes bytecode annotations (conceptual for compiler optimization testing)
    // Actual bytecode annotations are compiler internal but here represented as dummy doc comments

    public fun coalesce_example(x: u8, y: u8): u8 {
        // @annotation: coalesce_var start 'a'
        let a = x + y;
        // @annotation: coalesce_var reuse 'a'
        let b = a * 2;
        // @annotation: coalesce_var end 'a'
        b
    }
}



//# run 0xCAFE::AnnotationModule::coalesce_example --args 3u8 4u8
