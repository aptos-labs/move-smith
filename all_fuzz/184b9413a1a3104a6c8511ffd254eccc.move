
//# publish
module 0xCAFE::Adder {
    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 20) {
            100u8
        } else {
            sum
        }
    }

    public fun use_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |val: u8| {
            val * 2
        };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Adder::add_two --args 5u8 4u8


//# run 0xCAFE::Adder::add_two --args 15u8 10u8


//# run 0xCAFE::Adder::use_lambda --args 7u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Adder::inline_add(a, b)
    }
}


//# run 0xCAFE::Caller::call_inline_add --args 3u8 6u8


//# publish
module 0xCAFE::InterfaceCleanup {
    // This module represents testing removal of bytecode files after interface generation
    // as dummy logic, since in Move code we cannot remove files, this is symbolic.
    public fun dummy() {}
}


//# run 0xCAFE::InterfaceCleanup::dummy


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9b47cf51351f3a28b90ef53be117eb6e: Remove bytecode files from the list of dependencies after generating interface files.
