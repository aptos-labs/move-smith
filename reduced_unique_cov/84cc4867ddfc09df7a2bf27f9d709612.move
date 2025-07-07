
//# publish
module 0xCAFE::LambdaModule {
    use std::signer;

    public fun add_and_flag(a: u8, b: u8): u8 {
        let sum = a + b;

        // return 42 if sum is 42, else 0
        if (sum == 42) {
            42
        } else {
            0
        }
    }

    public fun lambda_adder(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun run_lambda_lambda(): u8 {
        let f1: |u8| u8 has copy+drop = |x: u8| { x + 1 };
        let f2: | (|u8| u8), u8 | u8 has copy+drop = |f: |u8| u8, y: u8| { f(y) };
        f2(f1, 3)
    }
}


//# run 0xCAFE::LambdaModule::add_and_flag --args 20u8 22u8


//# run 0xCAFE::LambdaModule::add_and_flag --args 10u8 32u8


//# run 0xCAFE::LambdaModule::lambda_adder --args 13u8 14u8


//# run 0xCAFE::LambdaModule::run_lambda_lambda



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaModule;

    public inline fun double_sum(x: u8, y: u8): u8 {
        let s = LambdaModule::lambda_adder(x, y);
        s + s
    }

    public fun call_double_sum(x: u8, y: u8): u8 {
        double_sum(x, y)
    }
}


//# run 0xCAFE::InlineCaller::call_double_sum --args 12u8 13u8



//# publish
module 0xCAFE::SpecModule {
    use std::vector;

    struct Data has copy, drop, store {
        val: u8
    }

    spec module {
        // global invariant: max val stored at this addr never > 100
        invariant forall (addr: address) {
            // We only check invariant for addresses with Data resource
            exists (data: Data): (borrow_global<Data>(addr).val <= 100)
        }
    }

    public fun store_data(addr: &signer, val: u8) {
        let data = Data { val };
        move_to<Data>(addr, data);
    }

    public fun update_data(addr: &signer, val: u8) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(addr));
        data_ref.val = val
    }

    spec store_data {
        ensures exists (data: Data) {
            borrow_global<Data>(@signer::address_of(addr)).val == val
        }
    }

    spec update_data {
        requires exists (data: Data);
        ensures borrow_global<Data>(@signer::address_of(addr)).val == val;
    }

    // Function that uses reference parameters in spec
    public fun add_to_data(addr: &signer, add_val: u8) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(addr));
        data_ref.val = data_ref.val + add_val;
    }

    spec add_to_data {
        requires exists (data: Data);
        ensures borrow_global<Data>(@signer::address_of(addr)).val == old(borrow_global<Data>(@signer::address_of(addr)).val) + add_val;
    }
}


//# run 0xCAFE::SpecModule::store_data --signers 0xD00D --args 10u8


//# run 0xCAFE::SpecModule::update_data --signers 0xD00D --args 20u8


//# run 0xCAFE::SpecModule::add_to_data --signers 0xD00D --args 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 42600b5bbe8ce664466b1a6ee2ac08db: Write quantifier expressions (`forall`, `exists`, etc.) in specification contexts.
// d61efbb86f25c57579e561d0f88d1852: Create references to types using '&T' (immutable) and '&mut T' (mutable).
// 538789966662936199a3ee87a28b6121: Define specifications for functions and structs that include preconditions, postconditions, and invariants.
