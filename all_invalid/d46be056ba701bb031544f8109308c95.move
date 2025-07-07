//# publish
module 0xCAFE::Constants {
    const CONST_U8: u8 = 42;
    const CONST_U64: u64 = 1000;
    const CONST_BOOL: bool = true;

    public fun runner() {
        // Just read constants to make sure they are usable
        let _a = CONST_U8;
        let _b = CONST_U64;
        let _c = CONST_BOOL;
    }
}

//# run 0xCAFE::Constants::runner

//# publish
module 0xCAFE::SymbolConversion {
    use std::string;
    use std::vector;
    use std::symbol;

    public fun convert_strings_to_symbols(strings: vector<string::String>): vector<symbol::Symbol> acquires symbol::Symbol {
        let mut symbols = vector::empty<symbol::Symbol>();
        let len = vector::length(&strings);
        let mut i = 0;
        while (i < len) {
            let s = vector::borrow(&strings, i);
            let sym = symbol::from_string(s);
            vector::push_back(&mut symbols, sym);
            i = i + 1;
        }
        symbols
    }

    public fun runner() {
        let s1 = string::utf8(b"hello");
        let s2 = string::utf8(b"world");
        let svec = vector::empty<string::String>();
        let mut svec = svec;
        vector::push_back(&mut svec, s1);
        vector::push_back(&mut svec, s2);

        let _syms = convert_strings_to_symbols(svec);
    }
}

//# run 0xCAFE::SymbolConversion::runner

//# publish
module 0xCAFE::BreakTest {
    public fun runner() {
        let mut x = 0;
        loop {
            x = x + 1;
            break;
            // If break didn't work, below code would run
            // but per instructions no assertion needed
            x = x + 1000;
        }
        // After loop, function will return normally
    }
}

//# run 0xCAFE::BreakTest::runner

// Featurres:
// 3268075e95e87cb32c5385a426ea6270: Assign values to constants at declaration time in Move.
// 4357e526173231bd709dd2c863e56c2b: Convert a vector of String references to a vector of Symbol instances using the Symbol::from method.
// 40386585b505f1be911d5d00db89f09e: Test that the script terminates immediately when encountering a 'break' statement inside a loop without executing any assertions.
