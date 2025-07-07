
//# publish
module 0xCAFE::LambdaModule {
    // Removed unused alias 'signer'

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
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun run_lambda_lambda(): u8 {
        let f1: |u8| u8 has copy + drop = |x: u8| { x + 1 };
        // Fix the function type of f2 to match the closure call:
        // The arg type tuple should be (|u8| u8, u8) => u8
        let f2: |(|u8| u8, u8)| u8 has copy + drop = |pair: (|u8| u8, u8)| {
            let (f, y) = pair;
            f(y)
        };
        f2((f1, 3))
    }
}



//# run 0xCAFE::LambdaModule::add_and_flag --args 20u8 22u8



//# run 0xCAFE::LambdaModule::add_and_flag --args 10u8 32u8



//# run 0xCAFE::LambdaModule::lambda_adder --args 13u8 14u8



//# run 0xCAFE::LambdaModule::run_lambda_lambda




//# publish
module 0xCAFE::InlineCaller {
    // The following module depends on LambdaModule. Since it's in same file, okay.
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
    use std::signer;

    struct Data has copy, drop, store {
        val: u8
    }

    spec module {
        // global invariant: max val stored at this addr never > 100
        invariant forall addr: address {
            exists data: Data
                // We check invariant only if data exists at addr
                && borrow_global<Data>(addr).val <= 100
        }
    }

    public fun store_data(addr: &signer, val: u8) {
        let data = Data { val };
        move_to<Data>(addr, data);
    }

    public fun update_data(addr: &signer, val: u8) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(addr));
        data_ref.val = val;
    }

    spec store_data {
        ensures exists data: Data {
            borrow_global<Data>(signer::address_of(addr)).val == val
        }
    }

    spec update_data {
        requires exists data: Data;
        ensures borrow_global<Data>(signer::address_of(addr)).val == val;
    }

    // Function that uses reference parameters in spec
    public fun add_to_data(addr: &signer, add_val: u8) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(addr));
        data_ref.val = data_ref.val + add_val;
    }

    spec add_to_data {
        requires exists data: Data;
        ensures borrow_global<Data>(signer::address_of(addr)).val ==
            old(borrow_global<Data>(signer::address_of(addr)).val) + add_val;
    }
}



//# run 0xCAFE::SpecModule::store_data --signers 0xD00D --args 10u8



//# run 0xCAFE::SpecModule::update_data --signers 0xD00D --args 20u8



//# run 0xCAFE::SpecModule::add_to_data --signers 0xD00D --args 15u8
