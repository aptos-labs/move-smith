
//# publish
module 0xCAFE::AccessWarningModule {
    // This module demonstrates that inline functions accessing other functions in the same module may generate access warnings

    public fun public_func(x: u8): u8 {
        x + 1
    }

    public inline fun inline_caller(x: u8): u8 {
        // Calling public_func inline within the same module
        Self::public_func(x)
    }


    // The following declarations are errors because specification modules cannot have Move functions, structs, or constants
    //
    // Uncommenting any of the below lines should produce compilation errors

    /*
    public fun illegal_fun(): u8 {
        0u8
    }

    struct IllegalStruct has copy, drop {
        x: u8
    }

    const ILLEGAL_CONST: u8 = 1u8;
    */
}


//# run 0xCAFE::AccessWarningModule::inline_caller --args 10u8


//# script
//# run
script {
    use 0xCAFE::AccessWarningModule;

    fun main() {
        // Invoke inline_caller function to trigger inline call warnings
        let _res = AccessWarningModule::inline_caller(20u8);
    }
}
