//# publish
module 0xCAFE::SpecFuncTest {
    use std::signer;

    spec module {
        // Declaring spec functions of various forms
        spec fun spec_fun1(x: u64): u64;

        // Spec variables
        spec let spec_var1: bool;

        // Including specs from another module (simulate by self-include)
        include 0xCAFE::SpecFuncTest;

        // Applying an invariant (dummy example: always true)
        apply true;

        // Module level pragmas
        pragma "test_pragma";

        // Spec function with body referencing built-in types
        spec fun spec_fun2(v: vector<u8>): bool {
            true
        }

        // Spec function with type parameters
        spec fun <T> spec_fun_generic(x: T): bool;

        // Spec let with expression using built-in types
        spec let spec_let1: u8 = 123u8;
    }

    public fun runner(account: &signer) {
        // empty runner to allow --run command
    }
}
//# run 0xCAFE::SpecFuncTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::ReachabilityTest {

    spec module {
        // A function with 'no' keyword meaning unreachable code
        spec fun unreachable_fun(): u64 {
            no;
            // code following no is considered unreachable
            42
        }

        // Variable with 'no' declaration
        spec let unreachable_var: bool = no;
    }

    public fun runner(account: &signer) {
        // empty runner only
    }
}
//# run 0xCAFE::ReachabilityTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::BuiltinTypesTest {
    use std::signer;

    // A struct with all built-in primitive types to reference them
    struct AllBuiltin {
        b: bool,
        u8_: u8,
        u64_: u64,
        u128_: u128,
    }

    spec module {
        // Spec function listing all built-in types in signatures and bodies
        spec fun all_builtins(
            b: bool,
            u8_: u8,
            u64_: u64,
            u128_: u128,
            addr: address,
            signer_: signer
        ): bool {
            let _ = b;
            let _ = u8_;
            let _ = u64_;
            let _ = u128_;
            let _ = addr;
            let _ = signer_;
            true
        }
    }

    public fun runner(account: &signer) {
        let x = AllBuiltin {
            b: true,
            u8_: 10u8,
            u64_: 20u64,
            u128_: 30u128,
        };
        // just dummy usage to make sure code is valid
    }
}
//# run 0xCAFE::BuiltinTypesTest::runner --signers 0xCAFE

//# run
script {
    use std::signer;

    fun main(account: &signer) {
        // Simple script test to force VM run and compiler checks on all built-ins

        // Construct values of all built-in types
        let b: bool = true;
        let u8_val: u8 = 255u8;
        let u64_val: u64 = 123456789u64;
        let u128_val: u128 = 987654321u128;
        let addr_val: address = signer::address_of(account);

        // No-op usage
        let _ = b;
        let _ = u8_val;
        let _ = u64_val;
        let _ = u128_val;
        let _ = addr_val;
    }
}

// Featurres:
// 35a59e1bbe25ea62bc219715c2689c6a: Declare specification functions, variables, lets, includes, applies, and pragmas without processing unbound names in their contents.
// 0f969730f1ad33e58b8fdc7180c14a97: Use 'no' as an indication that a code segment is definitely not reachable.
// 9eae8a3032e0227f4ac7acdfcbcd6a5d: Refer to all built-in type names available in Move.
