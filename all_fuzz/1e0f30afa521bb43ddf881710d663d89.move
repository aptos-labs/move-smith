
//# publish
module 0xCAFE::PrimaryExpressions {
    // Removed unused 'use std::vector;'

    // A struct that uses primary expressions as default values
    // Added `public` so the struct and its fields are accessible outside the module
    struct DefaultValues has copy, drop, store {
        pub b: bool,
        pub n: u64,
        pub bytes: vector<u8>,
    }

    public fun create_default(): DefaultValues {
        // primary expressions: booleans, numbers, byte strings
        let b = true;
        let n = 42u64;
        let bytes = b"aptos\0";
        DefaultValues { b, n, bytes }
    }

    public fun local_references(): u8 {
        // Use name references and value literals
        let x = 10u8;
        let y = 20u8;
        let z = x + y;
        z
    }

    public fun mix_types(): (bool, u8, vector<u8>) {
        let flag = false;
        let val = 255u8;
        let vec = x"DEADBEEF";
        (flag, val, vec)
    }
}



//# run 0xCAFE::PrimaryExpressions::create_default



//# run 0xCAFE::PrimaryExpressions::local_references



//# run 0xCAFE::PrimaryExpressions::mix_types




//# publish
module 0xCAFE::ModuleKeyUsage {
    // This module interacts with 0xCAFE::PrimaryExpressions using a full module key

    public fun call_create_default(): bool {
        let dv = 0xCAFE::PrimaryExpressions::create_default();
        // Access to `b` is allowed because `b` is now public
        dv.b
    }

    public fun call_local_references(): u8 {
        0xCAFE::PrimaryExpressions::local_references()
    }

    public fun call_mix_types(): (bool, u8) {
        let (flag, val, _) = 0xCAFE::PrimaryExpressions::mix_types();
        (flag, val)
    }
}



//# run 0xCAFE::ModuleKeyUsage::call_create_default



//# run 0xCAFE::ModuleKeyUsage::call_local_references



//# run 0xCAFE::ModuleKeyUsage::call_mix_types
