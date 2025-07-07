//# publish
address 0xCAFE {
    module ConstantManager {
        use std::vector;
        use std::string;

        // A struct to hold constant names and values
        struct ConstantRegistry has key {
            names: vector<vector<u8>>,
            values: vector<u64>,
        }

        public fun new_registry(): ConstantRegistry {
            ConstantRegistry {
                names: vector::empty(),
                values: vector::empty(),
            }
        }

        // Inline helper function to compare byte vectors (constant names)
        #[inline]
        fun is_same_name(a: &vector<u8>, b: &vector<u8>): bool {
            if (vector::length(a) != vector::length(b)) {
                return false;
            }
            let len = vector::length(a);
            let mut i = 0;
            while (i < len) {
                if (*vector::borrow(a, i) != *vector::borrow(b, i)) {
                    return false;
                }
                i = i + 1;
            }
            true
        }

        // Adds a constant to the registry if name is not duplicated
        public fun add_constant(reg: &mut ConstantRegistry, name: vector<u8>, value: u64) acquires ConstantRegistry {
            let len = vector::length(&reg.names);
            let mut i = 0;
            while (i < len) {
                if (is_same_name(&reg.names[i], &name)) {
                    // duplicate found, do nothing
                    return;
                }
                i = i + 1;
            }
            vector::push_back(&mut reg.names, name);
            vector::push_back(&mut reg.values, value);
        }

        // Retrieve constant by name
        public fun get_constant(reg: &ConstantRegistry, name: &vector<u8>): Option<u64> {
            let len = vector::length(&reg.names);
            let mut i = 0;
            while (i < len) {
                if (is_same_name(&reg.names[i], name)) {
                    return Option::some(reg.values[i]);
                }
                i = i + 1;
            }
            Option::none()
        }

        // Inline function for doubling a number (used to benefit from inlining)
        #[inline]
        fun double(x: u64): u64 {
            x + x
        }

        // Create index expression simulation: returns combined u64 using two indexes
        // (e.g., indexes packed into one value)
        public fun combined_index(a: u8, b: u8): u64 {
            // Shift `a` by 8 bits and add `b`
            ((a as u64) << 8) + (b as u64)
        }

        // Runner function to exercise the above functionalities
        public fun runner() {
            let mut reg = new_registry();
            let name1 = b"CONST_ONE";
            let name2 = b"CONST_TWO";

            add_constant(&mut reg, vector::from_bytes(name1), 100);
            add_constant(&mut reg, vector::from_bytes(name2), 200);
            // Test duplicate add: should not add again
            add_constant(&mut reg, vector::from_bytes(name1), 999);

            let val1 = get_constant(&reg, &vector::from_bytes(name1));
            let val2 = get_constant(&reg, &vector::from_bytes(name2));
            let val3 = get_constant(&reg, &vector::from_bytes(b"NOT_FOUND"));

            let double_val = double(21);

            let index_val = combined_index(0x0A, 0x0B);

            // Dummy usage of the results to avoid unused warnings
            assert!(val1 == Option::some(100), 1);
            assert!(val2 == Option::some(200), 2);
            assert!(val3 == Option::none(), 3);
            assert!(double_val == 42, 4);
            assert!(index_val == ((0x0A as u64) << 8) + 0x0B, 5);
        }
    }
    
    //# run 0xCAFE::ConstantManager::runner
}

//# run
script {
    use 0xCAFE::ConstantManager;

    fun main() {
        // Call the runner function to run all tests
        ConstantManager::runner();
    }
}

// Featurres:
// 317fa7b3c5a552d9524c0b3f9e17ab77: Add constants to the module's constant registry while checking for duplicates.
// a4b61cdd68ad99f48a43beb6e10c4d59: Create index expressions with two sub-expressions.
// 7b96b033e8f7cf7d716d13afcbe4a504: Write Move code that benefits from inlining of functions during compilation for better performance or abstraction.
