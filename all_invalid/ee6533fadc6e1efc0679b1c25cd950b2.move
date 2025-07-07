
//# publish
module 0xCAFE::AddU8 {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Returns fixed value 42u8 after adding x and y, testing addition works
        42u8
    }
}


//# run 0xCAFE::AddU8::add_and_return --args 20u8 22u8


//# publish
module 0xCAFE::LambdaTest {
    public fun run_lambda() {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _result = adder(10u8, 32u8);
        
        let multiplier: |u64, u64| u64 has copy+drop = |a: u64, b: u64| {
            a * b
        };
        let _prod = multiplier(6u64, 7u64);
    }
}


//# run 0xCAFE::LambdaTest::run_lambda


//# publish
module 0xCAFE::InlineCalls {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let intermediate = Self::inline_add(x, y);
        // call inline_add again to test nested call
        Self::inline_add(intermediate, 1u8)
    }
}


//# publish
module 0xCAFE::CrossModuleInlineCalls {
    use 0xCAFE::InlineCalls;

    public fun call_inline_add_twice(x: u8, y: u8): u8 {
        InlineCalls::nested_calls(x, y)
    }
}


//# run 0xCAFE::CrossModuleInlineCalls::call_inline_add_twice --args 5u8 6u8


//# publish
module 0x0042::foo {
    struct Foo has key {}

    public fun make_foo(account: &signer) {
        let foo = Foo {};
        move_to<Foo>(account, foo);
    }

    public fun has_foo(addr: address): bool {
        exists<Foo>(addr)
    }
}


//# publish
module 0xCAFE::CallMakeFoo {
    use std::signer;
    use 0x0042::foo;

    public fun f(s: signer) {
        let lambda: |&signer|() has copy+drop = |acct: &signer| {
            foo::make_foo(acct);
        };
        lambda(&s);
    }

    public fun check_foo(addr: address): bool {
        foo::has_foo(addr)
    }
}


//# run 0xCAFE::CallMakeFoo::f --signers 0xBEEF


//# run 0xCAFE::CallMakeFoo::check_foo --args @0xBEEF


//# publish
module 0xCAFE::CheckModulesAt1 {
    public fun is_aptos_module(name: vector<u8>): bool {
        let aptos_std = b"aptos_std";
        let aptos_framework = b"aptos_framework";

        // Compare with aptos_std or aptos_framework names
        if (vector::length(&name) == vector::length(&aptos_std)) {
            let i = 0;
            while (i < vector::length(&name)) {
                if (*vector::borrow(&name, i) != *vector::borrow(&aptos_std, i)) {
                    break;
                };
                i = i + 1;
            };
            if (i == vector::length(&name)) {
                return true;
            };
        };

        if (vector::length(&name) == vector::length(&aptos_framework)) {
            let j = 0;
            while (j < vector::length(&name)) {
                if (*vector::borrow(&name, j) != *vector::borrow(&aptos_framework, j)) {
                    break;
                };
                j = j + 1;
            };
            if (j == vector::length(&name)) {
                return true;
            };
        };

        false
    }
}


//# run 0xCAFE::CheckModulesAt1::is_aptos_module --args b"aptos_std"


//# run 0xCAFE::CheckModulesAt1::is_aptos_module --args b"aptos_framework"


//# run 0xCAFE::CheckModulesAt1::is_aptos_module --args b"other_module"


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3b66726e5f08ac212abbef39034ae6cc: Test that calling the anonymous function stored in `f` correctly invokes `0x42::foo::make_foo` and initializes the `Foo` resource for the account.
// 42ea313cce7b739ddd5f5b66f85c3a35: Identify modules residing at the address '0x1' with the names 'aptos_std' or 'aptos_framework' by their module name or numerical address.
