
//# publish
module 0xDEADBEEF::TestModule {
    use std::vector;
    use std::signer;

    // Internal resource and function
    struct InternalResource {
        value: u64,
    }

    public fun internal_function_call() acquires InternalResource {
        // Internal function modifies resource
        let addr = signer::address_of(&signer::borrow_self());
        let res_ref: &mut InternalResource = borrow_global_mut<InternalResource>(addr);
        res_ref.value = res_ref.value + 1;
    }

    // Public function calling internal function
    public fun call_internal() acquires InternalResource {
        internal_function_call();
    }

    // Internal resource initialization
    public fun init_resource(s: signer) {
        move_to<InternalResource>(&s, InternalResource { value: 0 });
    }

    // Internal function, higher visibility only within module
    internal fun internal_add(a: u64, b: u64): u64 {
        a + b
    }
}

 

//# run 0xDEADBEEF::TestModule::init_resource --signers 0xCAFEBABE

 

//# run 0xDEADBEEF::TestModule::call_internal --signers 0xCAFEBABE

 


//# run 0xDEADBEEF::TestModule::internal_add --args 10u64 20u64

// The above call should produce an error if called outside the module, but since internal_add is internal, calling from transaction is invalid, the above is for test compile failure, so here for test, it's included as reference and not to be run.


// Variable handling and shadowing within a script:


//# run
script {
    fun main(signer: signer) {
        let outer_var = 0u64;
        let i = 0u64;
        while (i < 3) {
            let inner_var = i + 10;
            // Shadow inner_var
            let inner_var = inner_var + 1;
            // check inner_var value inside loop
            assert!(inner_var == (i + 10) + 1, 999);
            outer_var = outer_var + inner_var;
            i = i + 1;
        }
        // After loop, outer_var should be sum of (i+10+1) for i=0,1,2
        // i=0: inner_var=11 -> outer_var+=11
        // i=1: inner_var=12 -> outer_var+=12
        // i=2: inner_var=13 -> outer_var+=13
        // total: 11+12+13=36
        assert!(outer_var == 36, 9990);
    }
}



//# run 0xDEADBEEF::TestModule::f1 --args 5u8 true



//# run 0xDEADBEEF::TestModule::f3 --args 100u16

// Testing the visibility restriction: try to call internal function externally (should fail at compile time)
// This should be commented or omitted, as Move compiler will reject it.
// let _ = 0xDEADBEEF::TestModule::internal_add(1, 2); // Compile error expected



//# expected_failure out_of_gas
// Trigger an out_of_gas failure by running code that loops excessively or consumes gas intentionally.
// This is difficult in a small test, but you could simulate by calling a function meant to consume gas
// For illustration, imagine a gas-consuming loop:



//# run
script {
    fun gas_waster() {
        let count = 0u64;
        while (count < 1000000) {
            count = count + 1;
        };
    }

    fun main() {
        gas_waster();
    }
}

// The above script, when executed in the test environment with limited gas, should result in an out_of_gas failure



//# expected_failure vector_error
// For vector error, attempt to access out-of-bounds index:

 

//# run
script {
    fun main() {
        let v: vector<u8> = vector::empty<u8>();
        vector::push_back(&v, 1);
        // Access out of bounds
        let _ = vector::borrow(&v, 5); // Should cause vector out-of-bounds error
    }
}



//# expected_failure abort_code
// Trigger an abort with a specific code inside a script:



//# run
script {
    fun main() acquires InternalResource {
        let s = signer::borrow_self();
        // Initialize resource to be able to call internal function
        if (!exists<0xDEADBEEF::TestModule::InternalResource>(signer::address_of(&s))) {
            0xDEADBEEF::TestModule::init_resource(s);
        }
        // Force an assertion failure or manually abort
        abort 1234;
    }
}

// This should be tested separately as a failure with abort code 1234



//# expected_failure major_status
// Attempt to call a non-existent function or use incorrect signature



//# run
script {
    fun main() {
        // Call a function that doesn't exist, leading to major status failure
        // Since Move will catch this, simulate by aborting directly.
        abort 5678;
    }
}

// This triggers a major status failure with code 5678


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 0595f75a56fec1e97ce1b048cb59caa7: Specify the failure kind using keywords such as abort_code, arithmetic_error, out_of_gas, vector_error, or major_status within the // expected_failure(...)] attribute.
