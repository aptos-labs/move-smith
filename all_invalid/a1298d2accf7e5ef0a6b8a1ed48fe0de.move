
//# publish
module 0xCAFE::ConditionalAndLocalVars {
    // Spec block with a named function
    spec {
        // Declare a spec function that calls an internal function
        fun check_condition() {
            assert(true, 42);
        }
    }

    public fun conditional_branch(flag: bool): u64 {
        let result: u64; // Declare a local variable
        if (flag) {
            result = 100;
        } else {
            let temp: u64 = 50; // Declare a local variable inside else block
            result = temp;
        }
        result
    }

    public fun inner_function(x: u64): u64 {
        let y: u64; // Declare variable without initialization
        y = x + 10;
        y
    }

    public fun run_spec() {
        check_condition();
    }
}



//# run 0xCAFE::ConditionalAndLocalVars::run_spec



//# run 0xCAFE::ConditionalAndLocalVars::conditional_branch --args  true --signers 0xCAFE



//# run 0xCAFE::ConditionalAndLocalVars::conditional_branch --args  false --signers 0xCAFE



//# run 0xCAFE::ConditionalAndLocalVars::inner_function --args 42 --signers 0xCAFE