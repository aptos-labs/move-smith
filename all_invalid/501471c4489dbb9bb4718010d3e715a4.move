// Using 0xCAFE as the test address

// #publish
module 0xCAFE::SpecFeatureTest {
    // Spec function declaration without using any bound names inside
    spec fun spec_function_no_bound(x: u64): bool {
        x > 0
    }

    // Spec variable declared
    spec var global_counter: u64;

    // Let declared inside specs
    spec let some_value = 42u64;

    // Includes another spec function inside a spec function
    spec fun included_spec_fun(): bool {
        spec_function_no_bound(1)
    }

    // Applies clause example (no bound names)
    spec applies spec_function_no_bound(10);

    // Pragma declaration example in spec
    spec pragma true;

    // Spec block with update of spec variable
    spec update global_counter {
        global_counter = global_counter + 1;
    }

    // Runner function for executing the update block
    public fun runner() {
        // This function doesn't do anything at runtime,
        // but running the update in spec is tested in the transactional test framework
    }
}
// #run 0xCAFE::SpecFeatureTest::runner --signers 0xCAFE

// #publish
module 0xCAFE::SpecScript {
    // A public entry function that does nothing
    public entry fun main() {
    }
}

// #run 0xCAFE::SpecScript::main --signers 0xCAFE

// #run
script {
    use 0xCAFE::SpecFeatureTest;
    use 0xCAFE::SpecScript;

    fun main(account: signer) {
        // Call the module runner function, does nothing but tests spec update and declarations
        SpecFeatureTest::runner();

        // Call the SpecScript main entry function
        SpecScript::main(account);
    }
}

// Featurres:
// 35a59e1bbe25ea62bc219715c2689c6a: Declare specification functions, variables, lets, includes, applies, and pragmas without processing unbound names in their contents.
// fb5ef64b88094984e06ff5d08f6ec515: Update specification variables inside spec blocks using the 'update' keyword.
// 1542839f0ae1b2ab2529e0d1b5e8ad87: Declare a script using 'script' syntax.
