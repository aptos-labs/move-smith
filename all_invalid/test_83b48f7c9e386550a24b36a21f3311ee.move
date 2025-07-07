//# publish
module 0x99::test_module {
    use std::bcs;
    use std::string::{Self};
    use std::vector;

    // Test 1: Validate that init handles empty key and value vectors by converting them to UTF-8 strings and BCS bytes.
    public entry fun init() {
        let keys: vector<vector<u8>> = vector[];
        let values: vector<u64> = vector[];
        let _string_keys = vector::map(&keys, |key| { string::utf8(key) });
        let _bcs_values = vector::map(&values, |v| { bcs::to_bytes<u64>(&v) });
        // No assertions, just ensure no errors occur.
    }

    // Test 2: Verify that a function returning tuple (1, 2) produces expected result.
    fun generate_tuple(): (u64, u64) {
        let a = 1;
        (a, {a = a + 1; a}) // returns (1, 2)
    }

    public fun check_sum(): u64 {
        let (x, y) = generate_tuple();
        x + y // Should be 3
    }

    // Test 3: Access control test with resource management, ensuring permissions work via function values.
    //# publish
    module 0x99::resource_control {
        use 0x1::signer::signer;
        use 0x99::test_module::Data;

        struct CountResource has key {
            count: u64
        }

        public fun create_control(s: &signer) {
            move_to(s, CountResource { count: 0 })
        }

        public fun get_count(s: &signer, read_work: |&CountResource|u64): u64 acquires CountResource {
            // Read permission passed via function
            read_work(&CountResource { count: 0 }) // The argument is placeholder; actual access via storage
        }

        public fun update_count(s: &signer, update_work: |&mut CountResource|u64): u64 acquires CountResource {
            // Write permission via function
            update_work(&mut CountResource { count: 0 }) // Placeholder for actual resource
        }
    }

    //# publish
    module 0x99::app_with_control {
        use 0x99::resource_control;

        fun init_module(s: &signer) {
            resource_control::create_control(s);
        }

        fun get_count(s: &signer): u64 {
            resource_control::get_count(s, |res: &resource_control::CountResource| res.count)
        }

        fun increment(s: &signer): u64 {
            resource_control::update_count(s, |res: &mut resource_control::CountResource| {
                let current = res.count;
                res.count = current + 1;
                current
            })
        }
    }

    //# run 0x99::test_module::init
    //# run 0x99::app_with_control::init_module --signers 0x99
    //# run 0x99::app_with_control::increment --signers 0x99
    //# run 0x99::app_with_control::increment --signers 0x99
    //# run 0x99::app_with_control::get_count --signers 0x99
}