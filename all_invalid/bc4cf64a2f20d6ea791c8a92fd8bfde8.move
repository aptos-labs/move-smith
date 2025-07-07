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

    /// A dummy inline function that accepts another function (fn(): u64) and returns the sum of calling it twice.
    public inline fun call_twice_and_sum(f: &impl Fn(): u64): u64 {
        let a = f();
        let b = f();
        a + b
    }

    /// A function that returns a fixed number for demonstration
    public fun get_five(): u64 {
        5
    }

    /// Runner testing inline function that accepts function parameters.
    public fun runner_inline(): u64 {
        // Inline call with &get_five function pointer
        // In Move you cannot pass &get_five directly since Move does not have function pointers or Fn traits;
        // Instead, let's simulate by calling twice and summing manually:
        // But the requirement is to test function abstractions invoked in module code.
        // We can do it by defining an inline function that takes a fun param and calls it twice, summing the result.
        // Move currently does not support function types as parameters, but Aptos Move supports `fun` types as arguments since it uses Move 1.6+.
        // Let's declare a generic function caller with fun parameter.

        // Actually, per latest Move syntax, you can write:
        // public inline fun call_twice_and_sum(f: fun(): u64): u64 { ... }
        // So let's adjust above accordingly.

        call_twice_and_sum_internal(get_five)
    }
}

public inline fun call_twice_and_sum_internal(f: fun(): u64): u64 {
    let a = f();
    let b = f();
    a + b
}

//# run 0xCAFE::TestModules::runner_identify
//# run 0xCAFE::TestModules::runner_inline

// Featurres:
// 42ea313cce7b739ddd5f5b66f85c3a35: Identify modules residing at the address '0x1' with the names 'aptos_std' or 'aptos_framework' by their module name or numerical address.
// 58aa7d33294cfa880282fc4a645ac435: Optionally create post-state spec variables using 'let post' in spec blocks.
// b2e4d2efe99bb6aed3bfad8dd2c221b6: Test that inline functions accepting function parameters are correctly invoked and summed, verifying proper handling of function abstractions within module code.
