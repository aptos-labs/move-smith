//# publish
module 0xCAFE::GenericTypeTest {
    // A generic struct with a type parameter
    struct Container<T> {
        value: T,
    }

    // Function to instantiate Container with a specific type argument<string>
    public fun create_string_container(s: vector<u8>): Container<vector<u8>> {
        Container { value: s }
    }

    // Verify attribute on function
    #[verify]
    public fun verify_container(container: &Container<vector<u8>>) {
        // A placeholder for verification logic if needed
        // For test, no actual verification code
    }

    // A function to test nested generics with multiple type arguments
    struct Pair<A, B> {
        first: A,
        second: B,
    }

    // Function returning a nested generic type
    public fun create_pair<T1, T2>(a: T1, b: T2): Pair<T1, T2> {
        Pair { first: a, second: b }
    }

    // Function to verify the nested type
    #[verify]
    public fun verify_pair(pair: &Pair<u8, vector<u8>>) {
        // No-op verification
    }

    // Test function to create and verify generic instances organized as runner
    public fun run_generic_tests(): () {
        let s = b"Hello, Move!";
        let container = create_string_container(s);
        verify_container(&container);

        let byte_val: u8 = 42;
        let string_val = b"Test".to_vec();
        let p = create_pair(byte_val, string_val);
        verify_pair(&p);
    }
}

//# run 0xCAFE::GenericTypeTest::run_generic_tests --signers 0xCAFE

//# publish
module 0xCAFE::VerificationAndPackageTest {
    // A resource with verification attribute
    resource struct Config {
        max_value: u64,
        min_value: u64,
        verified: bool,
    }

    // Function to initialize a Config resource
    public fun initialize_config(account: &signer, max: u64, min: u64) {
        move_to(account, Config { max_value: max, min_value: min, verified: false });
    }

    // Verification function that checks constraints
    #[verify]
    public fun verify_config(config: &Config): bool {
        config.max_value >= config.min_value
    }

    // Function to set verified flag if verification passes
    public fun set_verified(account: &signer) {
        let config_ref = borrow_global_mut<Config>(Signer::address_of(account));
        if (verify_config(&config_ref)) {
            config_ref.verified = true;
        }
    }

    // Organize in package: a function that uses resources with verification attribute
    public fun run_verification_process(account: &signer) {
        initialize_config(account, 1000, 10);
        set_verified(account);
    }
}

//# run 0xCAFE::VerificationAndPackageTest::run_verification_process --signers 0xCAFE

//# publish
module 0xCAFE::OrganizeModules {
    // A simple library resource
    resource struct Data {
        id: u64,
        name: vector<u8>,
    }

    // Function to publish the resource
    public fun publish_data(account: &signer, id: u64, name_bytes: vector<u8>) {
        move_to(account, Data { id, name: name_bytes });
    }

    // Function to access the resource
    public fun get_data(address: address): &Data {
        borrow_global<Data>(address)
    }

    // Function to organize modules with data
    public fun run_organize() {
        // It assumes 0xDEAD as a signer for the purpose of this test
        // (In actual test environment, replace with actual signer address)
        // Note: The caller's address can also be used
        let signers_addr = // placeholder for signer address
            // For test, use 0xCAFE
            @0xCAFE;

        // publish data
        publish_data(&signers_addr, 42, b"ModuleData".to_vec());
        // borrow data to verify access
        let data_ref = get_data(@0xCAFE);
        // No assertion, just access
    }
}

//# run 0xCAFE::OrganizeModules::run_organize --signers 0xCAFE

// Featurres:
// eb0c30d054b7bc67ebc619af804b2b17: Provide optional type arguments in generic type or function invocations using angle brackets (<...>)
// 7de5c415f36b52af2275191ee808773b: Use verification attributes in your code to annotate functions or resources with specific verification requirements.
// c17a12b242a42c345e3c4c5630cdd985: Organize Move code into packages with named address mappings.
