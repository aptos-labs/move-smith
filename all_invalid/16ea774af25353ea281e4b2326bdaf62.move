//# publish
@deprecated
module 0xCAFE::DeprecatedModule {
    public inline fun demo_deprecated_usage(): bool {
        // Test deprecated module can still be compiled
        true
    }
}
//# run 0xCAFE::DeprecatedModule::demo_deprecated_usage


//# publish
module 0xCAFE::Operators {
    use std::signer;
    use std::vector;

    // Test a function that exercises many operators
    public fun ops_test(s: &signer) {
        let mut a: u64 = 10;
        let mut b: u64 = 3;
        let mut c: bool = true;
        let mut d: bool = false;

        // Arithmetic operators
        a += b;    // a = 13
        a -= 2;    // a = 11
        a *= 2;    // a = 22
        a /= 11;   // a = 2
        a %= 2;    // a = 0

        // Bitwise operators
        let mut e: u8 = 0b1010;
        e ^= 0b0101;  // e = 0b1111 = 15
        e <<= 1;      // e = 0b11110 = 30
        e >>= 2;      // e = 0b111 = 7

        // Boolean Logic
        c = c && !d;   // true && !false = true
        d = c || d;    // true || false = true
        let eq = (a == 0);
        let neq = (e != 0);

        // Comparison operators and colon operators
        let s_addr = signer::address_of(s);
        // "::" operator used to access module functions or values, used in call below
        Self::dummy();

        // Range operator .. used to create vector slice or range
        let vec = vector::empty<u8>();
        let _slice = vector::empty<u8>(); // just dummy for now, no slicing here
        // (No built-in syntax for range to produce vector slice in Move - but .. often used in spec)

        // We just use eq and neq here to prevent unused warnings
        let _ = (eq, neq, e, c, d, a, b);
    }

    public fun dummy() {
        // empty function to test usage of ::
    }
}
//# run 0xCAFE::Operators::ops_test --signers 0xCAFE


//# publish
module 0xCAFE::TypeParameterAbilities {
    use std::vector;

    // A struct representing a type param + its abilities as a bitset u8
    struct TParamAbility has copy, drop, store {
        type_name: vector<u8>,
        ability_set: u8, // bit 0: copy, bit 1: drop, bit 2: store, bit 3: key (not used here)
    }

    // Convert a tuple vector of (type_name, vector<ability>) into a vector<TParamAbility>
    public fun convert_types(types: vector<(vector<u8>, vector<u8>)>): vector<TParamAbility> {
        let mut results = vector::empty<TParamAbility>();
        let len = vector::length(&types);
        let mut i = 0;
        while (i < len) {
            let (name, abilities) = *vector::borrow(&types, i);
            let mut bitset: u8 = 0;
            let abilities_len = vector::length(&abilities);
            let mut j = 0;
            while (j < abilities_len) {
                let ab = *vector::borrow(&abilities, j);
                if (ab == b"copy") {
                    bitset = bitset | 1u8;
                } else if (ab == b"drop") {
                    bitset = bitset | 2u8;
                } else if (ab == b"store") {
                    bitset = bitset | 4u8;
                } else if (ab == b"key") {
                    bitset = bitset | 8u8;
                };
                j = j + 1;
            };
            vector::push_back(&mut results, TParamAbility { type_name: name, ability_set: bitset });
            i = i + 1;
        };
        results
    }

    // Runner with no arguments - just hardcoded test data
    public fun runner() {
        let mut test_types = vector::empty<(vector<u8>, vector<u8>)>();
        vector::push_back(&mut test_types, (b"u8", vector::empty<u8>())); // no abilities
        let mut abl1 = vector::empty<u8>();
        vector::push_back(&mut abl1, b"copy");
        vector::push_back(&mut abl1, b"drop");
        vector::push_back(&mut abl1, b"store");
        vector::push_back(&mut abl1, b"key");
        vector::push_back(&mut test_types, (b"SomeStruct", abl1));

        let result = Self::convert_types(test_types);
        let _ = result;
    }
}
//# run 0xCAFE::TypeParameterAbilities::runner

// Featurres:
// 390b5dabfa1eded9d6a07449255a295e: Mark entire modules as deprecated with an annotation.
// a4c9e87bb8d4dd45b945089d5c43429a: Write operators such as &&, ||, ==, !=, +=, -=, *=, /=, %=, ^=, <<=, >>=, ::, .. and others.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
