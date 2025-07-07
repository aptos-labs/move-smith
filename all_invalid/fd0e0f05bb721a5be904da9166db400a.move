
//# publish
module 0xCAFE::TypeConstraintsAndParsing {
    use std::string;
    use std::vector;
    use std::signer;

    struct Container<T> has store, key {
        value: T
    }

    public fun create_container<T: copy + drop + store>(val: T): Container<T> {
        Container { value: val }
    }

    public fun get_container_value<T: copy + drop + store>(container: &Container<T>): T {
        container.value
    }

    public fun parse_address(addr_str: vector<u8>): option<address> {
        // Assume addr_str has exactly 16 bytes representing an address
        // For simplicity, generate an address if length == 16, else none
        // Note: In real tests, you might need more complex parsing, but here is a stub
        if (vector::length<&u8>(&addr_str) == 16) {
            // In Move, directly casting bytes to address isn't allowed in script, but for test simulation:
            // Use a placeholder to produce address from bytes
            // Actual parsing would be more involved; here, we simulate with dummy address
            // For the test, just return an address with bytes specific to the input
            address::from_bytes(&addr_str)
        } else {
            option::none<address>()
        }
    }

    public fun demonstrate_type_constraint_and_parsing(s: signer) {
        // Create containers with constrained types
        let c_u8 = create_container<u8>(42u8);
        let c_bool = create_container<bool>(true);
        let v_u8 = get_container_value<&u8>(&c_u8);
        let v_bool = get_container_value<&bool>(&c_bool);
        assert!(v_u8 == 42u8, 0);
        assert!(v_bool, 1);

        // Parse address from byte vector
        let addr_bytes: vector<u8> = b"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10";
        let parsed_addr_opt = parse_address(addr_bytes);
        match (parsed_addr_opt) {
            option::some(addr) => {
                // do something with addr, e.g., check that it's not zero
                assert!(addr != address::ZERO, 2);
            },
            option::none() => {
                // Fail the test if parsing failed
                abort 999;
            }
        }
    }
}


//# run 0xCAFE::TypeConstraintsAndParsing::demonstrate_type_constraint_and_parsing --signers 0xBEEF

// Featurres:
// 1fc4d487ad3b1e83b69c5b34cabee61e: Specify type constraints using a colon ':' in Move code for a type.
// d0b098ad8683852699d7cda3649455e4: Specify the type of a variable using a colon followed by the type after the variable name.
// 05775f887f44514bef70890eb76294b1: Parse address bytes from a string representation in Move code.
