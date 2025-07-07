//# publish
address 0xA and 0xB {
module EscapeSequences {
    /// Function to create a byte string literal with escape sequences
    public fun test_escape_sequences(): vector<u8> {
        // Use escape sequences in byte string
        let bytes = b"Hello\nWorld\t\x41\x42\x43"; // "\n" (newline), "\t" (tab), "\x41"('A'), "\x42"('B'), "\x43"('C')
        bytes
    }

    /// Function to create a dependency declaration module
    public fun create_dependency_module() {
        // No-op function to simulate dependency; in real scenario, dependencies are specified in module declaration
        // For the purpose of test, dependencies are declared via module dependencies in source
    }
}
}

//# publish
address 0xC {
module DependencyModule {
    // Dummy module to test dependency declaration
    public fun dummy() {}
}
}

//# publish
address 0xD {
module Invocations {
    use 0xD::Invoker;
    use 0xD::Helpers;

    // Function that assigns function pointer to a local variable and calls it
    public fun test_invocation_styles() {
        let func_ref = Invoker::get_internal_function();

        // Direct call
        Invoker::call_direct();

        // Call via variable
        let f = func_ref;
        f();

        // Call via lambda (closure)
        let lambda = || {
            Invoker::call_direct();
        };
        lambda();
    }
}
}

//# publish
address 0xE {
module MapTest {
    use 0xE::SimpleMap;

    // Struct containing a map
    struct Container {
        map: SimpleMap<u64, u64>,
    }

    // Function to test keys function with multiple identical keys
    public fun test_keys(): vector<u64> {
        let map = SimpleMap::new();
        // Insert multiple entries with same key
        SimpleMap::insert(&mut map, 42, 1);
        SimpleMap::insert(&mut map, 42, 2);
        SimpleMap::insert(&mut map, 100, 3);

        // keys function should return keys including duplicates or as per implementation
        let keys_vec = SimpleMap::keys(&map);
        keys_vec
    }

    // Function to access module info inside an unpacked struct
    public fun access_module_info() {
        let container = Container { map: SimpleMap::new() };
        // Access module information (e.g., module address and name)
        let module_addr = @0xE;
        let module_name = "MapTest";
        // Access inside the struct (for illustration)
        let _info = (module_addr, module_name);
        // No-op, just to simulate access
    }
}
}

// Script that ties all tests together
//# run
script {
    // Test 1: Escape sequences in byte strings
    let escape_result = 0xA::EscapeSequences::test_escape_sequences();
    // expect escape_result to be b"Hello\nWorld\tABC"

    // Test 2: Dependency declaration - just call dummy
    0xC::DependencyModule::dummy();

    // Test 3: Function invocation styles
    0xD::Invocations::test_invocation_styles();

    // Test 4: keys function with duplicate keys
    let keys = 0xE::MapTest::test_keys();

    // Test 5: Access module info within struct
    0xE::MapTest::access_module_info();
} --signers 0xA --args