//# publish
module 0xCAFE::TestModules {
    use std::signer;

    /// This struct is to test storing and copy abilities
    struct Dummy has store, copy, drop, key {
        value: u64,
    }

    /// A function to test identification of standard modules by address and name.
    /// Returns 0 if address is not 0x1, returns 1 if module name starts with "aptos_" at address 0x1.
    public fun identify_standard_module(addr: address, module_name: vector<u8>): u8 {
        // Check address
        if (addr != @0x1) {
            return 0;
        };

        // "aptos_std" and "aptos_framework" in bytes
        let aptos_std = b"aptos_std";
        let aptos_framework = b"aptos_framework";

        // Compare given module_name with aptos_std or aptos_framework
        if (module_name == aptos_std) {
            return 1;
        };
        if (module_name == aptos_framework) {
            return 1;
        };
        0
    }

    /// Runner to check identify_standard_module with various inputs
    public fun runner_identify(): u8 {
        let ret1 = Self::identify_standard_module(@0x1, b"aptos_std");
        let ret2 = Self::identify_standard_module(@0x1, b"aptos_framework");
        let ret3 = Self::identify_standard_module(@0x1, b"random_module");
        let ret4 = Self::identify_standard_module(@0x2, b"aptos_std");
        // Sum results will be 1+1+0+0=2
        ret1 + ret2 + ret3 + ret4
    }

    /// A function that returns a fixed number for demonstration
    public fun get_five(): u64 {
        5
    }

    /// Runner testing inline function that accepts function parameters.
    public fun runner_inline(): u64 {
        call_twice_and_sum_internal(Self::get_five)
    }
}

public inline fun call_twice_and_sum_internal(f: fun(): u64): u64 {
    let a = f();
    let b = f();
    a + b
}

//# run 0xCAFE::TestModules::runner_identify
//# run 0xCAFE::TestModules::runner_inline