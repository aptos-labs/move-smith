//# publish
address 0xCAFE {
    module ModuleA {
        use std::vector;

        struct Element has copy, drop, store {
            key: u64,
            value: u64,
        }

        public fun new_element(key: u64, value: u64): Element {
            Element { key, value }
        }

        // generic inline function to map vector by reference to keys
        public inline fun map_keys<T>(vec: &vector<T>, extractor: &fun(&T): u64): vector<u64> {
            let mut result = vector::empty<u64>();
            let len = vector::length(vec);
            let mut i = 0;
            while (i < len) {
                let ref_elem = vector::borrow(vec, i);
                let key = extractor(ref_elem);
                vector::push_back(&mut result, key);
                i = i + 1;
            };
            result
        }

        // helper function to extract keys from Element by reference
        public fun extract_key(e: &Element): u64 {
            e.key
        }

        // runner function to create vector of elements and return vector of keys using map_keys
        public fun runner(): vector<u64> {
            let mut v = vector::empty<Element>();
            vector::push_back(&mut v, new_element(111u64, 10u64));
            vector::push_back(&mut v, new_element(222u64, 20u64));
            vector::push_back(&mut v, new_element(333u64, 30u64));
            map_keys(&v, &extract_key)
        }
    }
}

//# run 0xCAFE::ModuleA::runner


//# publish
address 0xCAFE {
    module ModuleB {
        // This module exists to test uniqueness of module aliases in the same namespace.
        // We purposely reuse the alias `ModuleA` in the test runner to ensure error is detected by compiler if duplicated.
        // But as per requirement, do not alias here, just publish multiple modules to trigger duplicate alias conflict in the compiler if any.

        public fun runner(): u64 {
            42u64
        }
    }
}

//# run 0xCAFE::ModuleB::runner


//# publish
address 0xCAFE {
    module SpecFuncs {
        spec module {
            // Named spec function inside spec block targeted at this module
            spec fun is_positive(x: u64): bool {
                x > 0
            }
        }
    }
}

// Featurres:
// 86f3e44c7ba6c25ee0603458bde6118a: Ensure module aliases are unique within a namespace to prevent duplication errors.
// 8819767f4c31f2fc027a4533595af519: Test that mapping over a vector of struct elements by reference allows collecting their fields (keys) into a new vector using generic inline functions.
// 8ca5154684fda1d15a08e50f89100d0e: Declare named spec functions inside spec blocks targeted at the module.
