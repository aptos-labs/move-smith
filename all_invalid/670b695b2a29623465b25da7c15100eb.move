// # publish
address 0xCAFE {

// A module to test specs, pattern binding, named addresses

module NamedAddressesSpecPattern {
    use std::vector;

    /// Custom named addresses to illustrate usage in code
    /// these are just constants here to simulate named addresses to use in tests
    const APTOS_STD : address = 0x1;
    const APTOS_FRAMEWORK : address = 0x3;
    const APTOS_TOKEN : address = 0x4;
    const APTOS_TOKEN_OBJECTS : address = 0x5;

    /// A struct used to return multiple values to enable pattern binding for testing
    struct Pair has copy, drop, store {
        x: u64,
        y: bool,
    }

    /// Return a vector of Pairs for pattern matching tests
    public fun get_pairs(): vector<Pair> {
        let mut v = vector::empty<Pair>();
        vector::push_back(&mut v, Pair { x: 1, y: true });
        vector::push_back(&mut v, Pair { x: 2, y: false });
        vector::push_back(&mut v, Pair { x: 3, y: true });
        v
    }

    /// Runner function to test pattern matching and specs
    public fun runner(): u64 {
        let pairs = Self::get_pairs();
        let mut sum: u64 = 0;

        // Pattern binding test:
        // Iterate pairs and destructure pattern (Pair {x, y})
        let n = vector::length(&pairs);
        let mut i = 0;
        while (i < n) {
            let pair = *vector::borrow(&pairs, i);
            let Pair { x, y } = pair;
            if (y) {
                sum = sum + x;
            }
            i = i + 1;
        }
        sum
    }

    spec module {
        /// A spec constant with named address
        const SOME_ADDR: address = APTOS_STANDARD;
    }

    spec fun sum_positive(xs: vector<u64>) : u64 {
        let mut acc: u64 = 0;
        let len = vector::length(&xs);
        let mut i = 0;
        while (i < len) {
            let x = *vector::borrow(&xs, i);
            if (x > 0) {
                acc = acc + x;
            }
            i = i + 1;
        }
        acc
    }

}

}

// # run 0xCAFE::NamedAddressesSpecPattern::runner

// Featurres:
// 86a2612079237d8f897b9d6f420c2c51: Assign custom named addresses such as 'aptos_std', 'aptos_framework', 'aptos_token', and 'aptos_token_objects' to specific numerical addresses like 0x1, 0x3, and 0x4 in your Move project.
// 6690ecacc05deb76718ba05ec0be0845: Write specifications using 'spec' and related keywords to include formal specifications in your Move code.
// b32ffbcace11142c705f53965c856e8e: Employ pattern binding in Move code to deconstruct and process a list of bind patterns.
