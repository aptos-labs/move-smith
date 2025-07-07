
//# publish
module 0xCAFE::PrimaryExpressions {
    use std::vector;

    // A struct that uses primary expressions as default values
    struct DefaultValues has copy, drop, store {
        b: bool,
        n: u64,
        bytes: vector<u8>,
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


// Featurres:
// 8e6fca7ad7a41c88c6b4a550ff9e7b3e: Create primary expressions such as name references and value literals (like numbers, booleans, byte strings).
// 1d9fa496d61af9b5404ccf32b1548863: Use module keys that include an optional address and a module name.
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
