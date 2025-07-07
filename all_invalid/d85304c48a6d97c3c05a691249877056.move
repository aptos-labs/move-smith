module 0xCAFE::TypeConstraintsAndParsing {
    use std::vector;
    use std::signer;
    use std::option;
    use std::address;

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
        if (vector::length<&u8>(&addr_str) == 16) {
            // Use address::from_bytes
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