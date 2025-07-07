
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
}


//# run 0xCAFE::AccessWarningModule::inline_caller --args 10u8


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


//# run script {
script {
    use 0xCAFE::AccessWarningModule;

    fun main() {
        // Invoke inline_caller function to trigger inline call warnings
        let _res = AccessWarningModule::inline_caller(20u8);
    }
}


// Featurres:
// affb833837439dde63faf7f0eb8dcc8a: Define script blocks using the 'script' keyword.
// 759d6a677489cb30b1d7f33b9438433d: Display access warnings when inline, non-private functions call functions within the same module, indicating potential access concerns.
// 00d5da4c654d1d499b3f0e3337e544be: Receive error messages if you declare Move functions, structs, or constants directly inside a specification module
