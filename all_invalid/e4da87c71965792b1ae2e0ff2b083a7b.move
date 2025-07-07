
//# publish
module 0xCAFE::Addition {
    // This module tests addition and lambda expressions

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 20) {
            20
        } else {
            sum
        };
    }

    public fun apply_lambda(a: u8, b: u8): u8 {
        // A lambda that adds two u8 numbers
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun use_nested_inline(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }
}


//# run 0xCAFE::Addition::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::Addition::apply_lambda --args 7u8 8u8


//# run 0xCAFE::Addition::use_nested_inline --args 12u16


//# publish
module 0xCAFE::WildcardResourceTest {
    use std::signer;
    use std::vector;

    struct AnyResource has store { val: u8 }

    public fun store_any_resource(s: signer, val: u8) {
        let obj = AnyResource { val };
        move_to<AnyResource>(&s, obj);
    }

    public fun read_any_resource(addr: address): u8 acquires * {
        let val_ref = borrow_global<AnyResource>(addr);
        val_ref.val
    }

    public fun remove_any_resource(s: signer) acquires * {
        let r = move_from<AnyResource>(signer::address_of(&s));
        let AnyResource { val: _val } = r;
    }

    public fun do_store_read_remove(s: signer, val: u8): u8 {
        store_any_resource(s, val);
        let v = read_any_resource(signer::address_of(&s));
        remove_any_resource(s);
        v
    }
}


//# run 0xCAFE::WildcardResourceTest::do_store_read_remove --signers 0xDEAD --args 42u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a09d929e2204df43285784ad08728860: Use the '*' wildcard to represent any resource at a specific address in access specifications.
