
//# publish
address 0xCAFE {
    module CustomAddressMapping {
        // A resource to hold address mappings for testing
        struct AddressMap has store, key {
            mapping: vector<(vector<u8>, vector<u8>)>,
        }

        public fun create_address_map(): AddressMap {
            AddressMap {
                mapping: vector::empty(),
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
                    return option::some<vector<u8>>(a);
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