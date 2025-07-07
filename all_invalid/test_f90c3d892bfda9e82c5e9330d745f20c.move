//# publish
module 0xabcde::constant_module {
    const MY_CONST: u64 = 42;

    public inline fun get_constant(): u64 {
        MY_CONST
    }

    public fun call_external_constant(): u64 {
        // This function simulates calling an external module's exposed function.
        0xabcde::constant_module::get_constant()
    }
}

 //# publish
module 0xfedcb::external_module {
    public fun fetch_constant(): u64 {
        // Expose a function that calls another module's function
        0xabcde::constant_module::get_constant()
    }
}

 //# run 0xabcde::constant_module::get_constant --signers 0xabcde
 //# run 0xfedcb::external_module::fetch_constant --signers 0xdeadbeef

 //# run 0xabcde::constant_module::call_external_constant --signers 0xabcde

 //# run
script {
    // Assign value based on a condition
    let result;
    if (0xabcde::constant_module::get_constant() == 42) {
        result = 100;
    } else {
        result = 200;
    };
    result
}
