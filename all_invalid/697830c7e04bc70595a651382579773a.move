
//# publish
address 0xCAFE {
    module CustomAddressMapping {
        // A resource to hold address mappings for testing
        struct AddressMap has store, key {
            mapping: vector<(vector<u8>, vector<u8>)>,
        }

        public fun create_address_map(): AddressMap {
            AddressMap {
                mapping: vector![],
            }
        }

        public fun add_address(mapping: &mut AddressMap, name: vector<u8>, addr: vector<u8>) {
            let pair = (name, addr);
            vector::push_back(&mut mapping.mapping, pair);
        }

        public fun get_address(mapping: &AddressMap, name: vector<u8>): option<vector<u8>> {
            let i = 0;
            while (i < vector::length(&mapping.mapping)) {
                let (n, a) = &vector::borrow(&mapping.mapping, i);
                if (*n == name) {
                    return option::some(a.clone());
                }
                i = i + 1;
            }
            option::none()
        }
    }
}


//# publish
address 0xBEEF {
    module Program {
        use 0xCAFE::CustomAddressMapping;

        // A program that creates and assigns multiple addresses using tuple assignment
        public fun setup() {
            let address_map = CustomAddressMapping::create_address_map();

            // Assign multiple names and addresses at once
            let (names, addresses) = (
                vector!["alice".as_bytes(), "bob".as_bytes()],
                vector![b"0xdeadbeef", b"0xcafebabe"]
            );

            let address_map_mut = address_map;

            let len = vector::length(&names);
            let i = 0;

            while (i < len) {
                let name = vector::borrow(&names, i).clone();
                let addr = vector::borrow(&addresses, i).clone();
                CustomAddressMapping::add_address(&mut address_map_mut, name, addr);
                i = i + 1;
            }
        }
    }
}


//# run 0xCAFE::CustomAddressMapping::create_address_map --signers 0xBEEF

//# run 0xBEEF::Program::setup --signers 0xBEEF

// Featurres:
// 71a2dc4a89a5e061d52106eb579ef278: Use custom named address mappings in your Move packages.
// 6e5c7471bf95f6365228a1e5c9d72dc5: Define a program using the Move compiler API with a program structure.
// 5de7f7519fe76bf271215be8b7df10c1: Assign multiple names at once in a single statement using tuple or list assignment syntax.
