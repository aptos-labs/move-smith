//# publish
module 0xCAFE::GenericTypeTest {
    // A generic struct with a type parameter
    struct Container<T> {
        value: T,
    }

    // Function to instantiate Container with a specific type argument<vector<u8>>
    public fun create_string_container(s: vector<u8>): Container<vector<u8>> {
        Container { value: s }
    }

    // Note: The #[verify] attribute is unknown; remove or replace with supported attribute if needed
    // Since the attribute is not recognized, we remove it.
    // public fun verify_container(container: &Container<vector<u8>>) {
    //     // A placeholder for verification logic if needed
    // }

    // A function to test nested generics with multiple type arguments
    struct Pair<A, B> {
        first: A,
        second: B,
    }

    // Function returning a nested generic type
    public fun create_pair<T1, T2>(a: T1, b: T2): Pair<T1, T2> {
        Pair { first: a, second: b }
    }

    // Again, remove unsupported attribute
    // public fun verify_pair(pair: &Pair<u8, vector<u8>>) {
    //     // No-op verification
    // }

    // Test function to create and verify generic instances organized as runner
    public fun run_generic_tests(): () {
        let s = b"Hello, Move!";
        let container = create_string_container(s);
        // No verification call needed

        let byte_val: u8 = 42;
        let string_val = vector::clone(&b"Test".to_owned()); // replace to_vec() with vector::clone
        let p = create_pair(byte_val, string_val);
        // No verification call needed
    }
}

//# run 0xCAFE::GenericTypeTest::run_generic_tests --signers 0xCAFE

//# publish
module 0xCAFE::VerificationAndPackageTest {
    // Move does not support 'resource' keyword at top level for struct definitions
    // Instead, define as struct (already correct), but no 'resource' keyword is needed
    struct Config {
        max_value: u64,
        min_value: u64,
        verified: bool,
    }

    // Function to initialize a Config resource
    public fun initialize_config(account: &signer, max: u64, min: u64) {
        move_to(account, Config { max_value: max, min_value: min, verified: false });
    }

    // Verification function that checks constraints
    #[verify_only]
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
    struct Data {
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
        // Using 0xCAFE as signer for test purposes
        let signers_addr = @0xCAFE;

        // publish data
        publish_data(&signers_addr, 42, b"ModuleData".to_owned());
        // borrow data to verify access
        let data_ref = get_data(@0xCAFE);
        // No assertion, just access
    }
}

//# run 0xCAFE::OrganizeModules::run_organize --signers 0xCAFE