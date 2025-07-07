//# publish
module 0xCAFE::Symbol {
    /// A simple Symbol struct that wraps a vector of u8
    struct Symbol {
        bytes: vector<u8>,
    }

    /// Creates a new Symbol from a vector of bytes
    public fun from(bytes: vector<u8>): Symbol {
        Symbol { bytes }
    }
}

//# publish
module 0xCAFE::TestModule {
    use 0xCAFE::Symbol;

    /// A generic function that accepts a vector of strings (as vector of vector<u8>)
    /// Converts each String into a Symbol using Symbol::from
    public fun convert_strings_to_symbols<N: u64>(
        strings: vector<vector<u8>>
    ): vector<Symbol::Symbol> {
        let symbols = vector::empty<Symbol::Symbol>();
        let length = vector::length(&strings);
        let mut i = 0;
        while (i < length) {
            let s_ref = vector::borrow(&strings, i);
            let symbol = Symbol::from(s_ref);
            vector::push_back(&mut symbols, symbol);
            i = i + 1;
        }
        symbols
    }

    /// A function to test ability constraints on a generic type
    /// Constrain T to have copy, drop, store, and key abilities
    public fun constrained_generic<T: copy + drop + store + key>(value: T): T {
        // Just return the value
        value
    }

    /// A runner function to execute the above functionalities
    public fun run() {
        // Sample vector of string references (byte vectors)
        let strings = vector[
            b"Hello".to_vec(),
            b"Move".to_vec(),
            b"Symbols".to_vec()
        ];

        // Convert strings to symbols
        let symbols = convert_strings_to_symbols::<0>(strings);

        // Test constrained generic function with primitive type (u64)
        let num: u64 = 42;
        let _ = constrained_generic::<u64>(num);
    }
}

//# run 0xCAFE::TestModule::run --signers 0xCAFE