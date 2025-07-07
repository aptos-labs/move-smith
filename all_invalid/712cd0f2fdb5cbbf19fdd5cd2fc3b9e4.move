
//# publish
module 0xCAFE::LambdaAddition {
    use std::signer;

    // 1. Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_then_return(val1: u8, val2: u8, ret_val: u8): u8 {
        let sum = val1 + val2;
        let _dummy = sum; // to simulate usage of sum before returning ret_val
        ret_val
    }

    // 2. Write functions containing lambda (anonymous function) expressions.
    public fun apply_lambda_to_sum(val1: u8, val2: u8, f: |u8| u8): u8 {
        let sum = val1 + val2;
        f(sum)
    }

    // Helper: wrap lambda inside the module to workaround inability to pass lambdas as args externally
    public fun add_10(x: u8): u8 {
        x + 10
    }

    // Resource declaration corrected: struct
    struct MyResource {
        data: u64,
    }

    public fun create_resource(s: &signer, data: u64) {
        let r = MyResource { data };
        move_to<MyResource>(s, r);
    }

    public fun read_resource(s: &signer): u64 {
        let r_ref = borrow_global<MyResource>(signer::address_of(s));
        r_ref.data
    }

    public fun destroy_resource(s: &signer) {
        let r = move_from<MyResource>(signer::address_of(s));
        let MyResource { data: _data } = r;
    }

    // Runner from above functions without arguments for simple run command
    public fun runner_no_args() {
        let _ = add_then_return(1u8, 2u8, 5u8);
        let lambda: |u8| u8 has copy+drop = |x: u8| x * 2;
        let _ = apply_lambda_to_sum(10u8, 5u8, lambda);
    }
}



//# run 0xCAFE::LambdaAddition::add_then_return --args 4u8 5u8 100u8


//# run 0xCAFE::LambdaAddition::apply_lambda_to_sum --args 4u8 5u8 0u8 --type-args  # Pass dummy arg for lambda since it can't be passed from CLI


//# run 0xCAFE::LambdaAddition::apply_lambda_to_sum --args 4u8 5u8 0u8 --type-args
// Instead, run a wrapper function that uses the predefined lambda inside the module:
//# publish
module 0xCAFE::LambdaAddition {
    public fun apply_add_10_to_sum(val1: u8, val2: u8): u8 {
        apply_lambda_to_sum(val1, val2, add_10)
    }
}

// Then run:

//# run 0xCAFE::LambdaAddition::apply_add_10_to_sum --args 4u8 5u8


//# run 0xCAFE::LambdaAddition::runner_no_args


//# run 0xCAFE::LambdaAddition::create_resource --signers 0xBEEF --args 123u64


//# run 0xCAFE::LambdaAddition::read_resource --signers 0xBEEF


//# run 0xCAFE::LambdaAddition::destroy_resource --signers 0xBEEF


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions with workaround for external passing.
// 6ab8797b66a06348f368b697382c1c80: Declare resources as 'struct StructName' instead of 'resource StructName'.
