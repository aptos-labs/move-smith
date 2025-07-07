
//# publish
module 0xCAFE::AddAndCompute {
    const MAGIC_NUMBER: u8 = 42;

    public fun add_then_magic(x: u8, y: u8): u8 {
        let sum = x + y;
        // local variable reassignment with new value
        let sum = sum + 1;
        if (sum == MAGIC_NUMBER) {
            sum
        } else {
            MAGIC_NUMBER
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun add_one(a: u8): u8 {
        a + 1
    }
}


//# publish
module 0xCAFE::CallInlineFromOther {
    use 0xCAFE::AddAndCompute;

    public fun call_add_one_and_add(x: u8, y: u8): u8 {
        let val = AddAndCompute::add_one(x);
        val + y
    }
}


//# publish
module 0xCAFE::WithSpecifiers {
    use std::signer;

    struct Data has store, key {
        value: u8,
    }

    public fun pure_add(x: u8, y: u8): u8 acquires Data {
        x + y
    }

    public fun create_data(s: signer, val: u8) acquires Data {
        let data = Data {value: val};
        move_to<Data>(&s, data);
    }

    public fun read_data(s: signer): u8 reads Data {
        let data_ref = borrow_global<Data>(signer::address_of(&s));
        data_ref.value
    }

    public fun write_data(s: signer, val: u8) writes Data {
        let data_mut_ref = borrow_global_mut<Data>(signer::address_of(&s));
        data_mut_ref.value = val;
    }
}


//# run 0xCAFE::AddAndCompute::add_then_magic --args 20u8 21u8


//# run 0xCAFE::AddAndCompute::use_lambda --args 5u8 7u8


//# run 0xCAFE::CallInlineFromOther::call_add_one_and_add --args 10u8 15u8


//# run 0xCAFE::WithSpecifiers::create_data --signers 0xBEEF --args 50u8


//# run 0xCAFE::WithSpecifiers::read_data --signers 0xBEEF


//# run 0xCAFE::WithSpecifiers::write_data --signers 0xBEEF --args 77u8


//# run 0xCAFE::WithSpecifiers::read_data --signers 0xBEEF


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a57b6f60494bce5f2302d16d6f24626f: Annotate functions with access specifiers such as 'acquires', 'reads', and 'writes', including handling for 'pure' functions.
// e0647ae03f52e75fb33319a40b3832e9: Verify that local variables can be reassigned within the same function.
// 92e0070943738d16812fa4208f5a1e8b: Define module constants within a module.
