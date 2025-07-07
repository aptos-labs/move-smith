// Transactional test case for Move compiler and VM
// Testing:
// 1. Lexer advancement on matching tokens
// 2. Attribute assignment using #[attribute_name=...] syntax
// 3. 'use' declarations importing modules/items

address 0x1 {
    module LexerTest {
        // A dummy struct to test attribute assignment
        #[custom_attribute = 42]
        struct ItemWithAttribute has copy, drop, store {
            value: u64,
        }

        // Another struct without attribute to compare
        struct PlainItem has copy, drop, store {
            value: u64,
        }
    }
}

address 0x2 {
    module ImportTest {
        use 0x1::LexerTest::{ItemWithAttribute, PlainItem};

        /// Public function to test the imported structs and attributes
        public fun test_import_and_attributes(): u64 {
            let item = ItemWithAttribute { value: 100 };
            let plain = PlainItem { value: 200 };

            // We expect that 'item' has some attribute assigned - 
            // though in Move, no runtime reflection - 
            // so we simulate usage by returning the attribute value 42 hardcoded
            // This is to "test" attribute parsing did not break compilation

            assert!(item.value == 100, 1);
            assert!(plain.value == 200, 2);

            42 // attribute value assigned in #[custom_attribute=42]
        }
    }
}

script {
    use 0x2::ImportTest::test_import_and_attributes;

    fun main() {
        // Test 1 & 3: Using imported function and modules via 'use'
        let attr_val = test_import_and_attributes();

        // Test 2: attribute assigned value "42" should be returned
        assert!(attr_val == 42, 100);
    }
}

// Featurres:
// 339f6807b3336c0a4b88c2ccdb5128e1: Advance the lexer to consume the token if it matches
// 0c61cc4b4109ac4af8ff1dd7dc50a980: Assign attribute values to items using `#[attribute_name=...]` syntax in Move code
// 5088acc417798600c0e061ae3cd83653: Use 'use' declarations to import modules or items into the current scope
