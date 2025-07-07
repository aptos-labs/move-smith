
//# publish
module 0xCAFE::InlineFunctionTest {
    // Test defining and using an inline function at module level only
    public inline fun add_ten(x: u8): u8 {
        x + 10
    }

    // A stored function that adds 23 when called
    // We'll store a function pointer here
    struct StoredFun has key {
        func: |()| u8
    }

    public fun create_stored_fun(): StoredFun {
        let lambda: |()| u8 has copy+drop = || { 23u8 };
        StoredFun { func: lambda }
    }

    public fun call_stored_fun(sfun: &StoredFun): u8 {
        (sfun.func)()
    }

    // Runner to create and call stored function returning 23
    public fun runner(): u8 {
        let sfun = create_stored_fun();
        call_stored_fun(&sfun)
    }
}


//# run 0xCAFE::InlineFunctionTest::runner


//# run 0xCAFE::InlineFunctionTest::create_stored_fun


//# run 0xCAFE::InlineFunctionTest::call_stored_fun --args 0xCAFE:InlineFunctionTest::StoredFun


//# run
script {
    // This script tries to define inline function, which should fail compilation if uncommented
    /* 
    inline fun try_inline_script_fun(x: u8): u8 {
        x + 1
    }
    */

    fun main() {
        // Can't define inline functions in scripts
        // Let's just call the module inline function
        let result = 0xCAFE::InlineFunctionTest::add_ten(13u8);
        let _ = result;
    }
}


// Featurres:
// be884025ad9ffa26551f16a00c235ca0: Ensure inline functions are not defined within scripts.
// 930f83177884e6968dc972db2624fc13: Test that a stored function can be initialized and later invoked to return the expected value 23.
// a67c4716a34e1345526cde917f209144: Write hexadecimal or numerical account addresses as literals in Move code
