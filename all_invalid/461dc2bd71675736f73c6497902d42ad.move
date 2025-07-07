//# publish
address 0xCAFE {
    module ForbiddenNamesChecker {
        // A set of forbidden names to check against
        const FORBIDDEN_NAMES: vector<vector<u8>> = vector[
            b"address",
            b"module",
            b"script",
            b"fun",
            b"move",
            b"native",
            b"specifier",
            b"spec",
            b"return",
            b"break",
            b"continue"
        ];

        // Returns true if `name` is forbidden
        public fun is_forbidden_name(name: &vector<u8>): bool {
            let i = 0;
            while (i < vector::length(&FORBIDDEN_NAMES)) {
                if (vector::equal(name, &vector::borrow(&FORBIDDEN_NAMES, i))) {
                    return true;
                }
                i = i + 1;
            }
            false
        }

        // Function to check list of names, returns count of forbidden names found
        public fun count_forbidden_names(names: &vector<vector<u8>>): u64 {
            let count = 0;
            let i = 0;
            while (i < vector::length(names)) {
                let n = vector::borrow(names, i);
                if (Self::is_forbidden_name(n)) {
                    count = count + 1;
                }
                i = i + 1;
            }
            count
        }

        // Runner function to call count_forbidden_names on a sample list
        public fun runner(): u64 acquires Self {
            let sample_names = vector[
                b"hello",
                b"fun",
                b"world",
                b"move",
                b"cool"
            ];
            Self::count_forbidden_names(&sample_names)
        }
    }

//# run 0xCAFE::ForbiddenNamesChecker::runner
}

//# publish
address 0xCAFE {
    module PropertySets {
        use std::vector;
        use std::option;

        // A struct representing a property with a name and value (u64)
        struct Property has copy, drop, store {
            name: vector<u8>,
            value: u64,
        }

        // A property set holding multiple properties
        struct PropertySet has copy, drop, store {
            properties: vector<Property>,
        }

        // Create a new empty property set
        public fun new_property_set(): PropertySet {
            PropertySet { properties: vector::empty() }
        }

        // Add a property to the property set
        public fun add_property(ps: &mut PropertySet, name: vector<u8>, value: u64) {
            vector::push_back(&mut ps.properties, Property { name, value });
        }

        // Compute the sum of all properties' values (as a sample expression over the property set)
        public fun sum_values(ps: &PropertySet): u64 {
            let sum = 0;
            let i = 0;
            while (i < vector::length(&ps.properties)) {
                let p = vector::borrow(&ps.properties, i);
                sum = sum + p.value;
                i = i + 1;
            }
            sum
        }

        // Runner function: build property set, add properties, return sum
        public fun runner(): u64 {
            let mut ps = Self::new_property_set();
            Self::add_property(&mut ps, b"height", 180);
            Self::add_property(&mut ps, b"weight", 75);
            Self::add_property(&mut ps, b"age", 30);
            Self::sum_values(&ps)
        }
    }

//# run 0xCAFE::PropertySets::runner
}

//# publish
address 0xCAFE {
    module ScriptWithSpec {
        use std::signer;

        // A simple function to add two numbers
        public fun add(a: u64, b: u64): u64 {
            a + b
        }

        // A specification block with attached attributes for the script's spec
        #[spec(addition_spec)]
        spec module {
            #[attribute("purpose", "Test adding function in script")]
            #[attribute("author", "Aptos Test")]
            fun test_addition(a: u64, b: u64): u64 {
                add(a, b)
            }
        }
    }

//# run 0xCAFE::ScriptWithSpec::add --args 20u64 22u64
}

//# run
script {
    use 0xCAFE::ScriptWithSpec;

    fun main() {
        let x = 10u64;
        let y = 32u64;
        let sum = ScriptWithSpec::add(x, y);
        // No asserts needed, running VM with this call exercises compiler and VM.
    }
}

// Featurres:
// c838b462f314f5cdf6238506a518c872: Ensure that the code does not use restricted names by checking against a set of forbidden names.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
// 764e23137183797d1b0f7d6586814f54: Attach attributes to your script's specification blocks.
