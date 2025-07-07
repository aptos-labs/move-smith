
//# publish
module 0xCAFE::ClosureMutateCapture {
    use std::copy;

    struct Counter has copy, drop {
        count: u8,
    }

    public fun test_capture_mutate(): u8 {
        let local_counter = Counter { count: 0 };

        let mut_closure: &mut (|| u8) = &mut || {
            local_counter = Counter { count: local_counter.count + 1 };
            local_counter.count
        };

        let a = mut_closure();
        let b = mut_closure();
        let c = mut_closure();

        a + b + c
    }
}




//# run 0xCAFE::ClosureMutateCapture::test_capture_mutate




//# publish
module 0xCAFE::PackagePathConversion {
    use std::string;
    use std::vector;
    use std::symbol;

    struct PackagePathString has store {
        addresses: vector<address>,
        named_addresses: vector<(string::String, address)>,
        modules: vector<string::String>,
    }

    struct PackagePathSymbol has store {
        addresses: vector<address>,
        named_addresses: vector<(symbol::Symbol, address)>,
        modules: vector<symbol::Symbol>,
    }

    public fun convert_string_to_symbol(s: string::String): symbol::Symbol {
        symbol::new_(s)
    }

    public fun convert(ps: PackagePathString): PackagePathSymbol {
        let addrs = vector::empty<address>();
        let named_addrs = vector::empty<(symbol::Symbol, address)>();
        let mods = vector::empty<symbol::Symbol>();

        let len_addresses = vector::length(&ps.addresses);
        let len_named = vector::length(&ps.named_addresses);
        let len_mods = vector::length(&ps.modules);

        let i = 0;
        while (i < len_addresses) {
            vector::push_back(&mut addrs, *vector::borrow(&ps.addresses, i));
            i = i + 1;
        };

        let j = 0;
        while (j < len_named) {
            let (name_str, addr) = *vector::borrow(&ps.named_addresses, j);
            let name_sym = convert_string_to_symbol(name_str);
            vector::push_back(&mut named_addrs, (name_sym, addr));
            j = j + 1;
        };

        let k = 0;
        while (k < len_mods) {
            let mod_str = *vector::borrow(&ps.modules, k);
            vector::push_back(&mut mods, convert_string_to_symbol(mod_str));
            k = k + 1;
        };

        PackagePathSymbol {
            addresses: addrs,
            named_addresses: named_addrs,
            modules: mods,
        }
    }
}




//# run 0xCAFE::PackagePathConversion::convert --args \
  vector[]:vector<address> \
  vector[(b"alice", @0x1), (b"bob", @0x2)]:vector<(string::String, address)> \
  vector[b"Token", b"Coin"]:vector<string::String>




//# publish
module 0xCAFE::VisibilityWithTypeArgs {
    struct Container<T> has key {
        value: T,
    }

    // Public with optional type arguments
    public<T> fun public_generic(x: T): Container<T> {
        Container<T> { value: x }
    }

    // Friend visibility restricted to friend address and type argument
    friend<T> fun friend_generic(addr: address, x: T): Container<T> {
        Container<T> { value: x }
    }

    // Script visibility restricted to type argument
    

//# run
    script<T> fun script_generic(x: T): Container<T> {
        Container<T> { value: x }
    }

    public fun runner() {
        let _ = public_generic<u8>(10u8);
        let _ = friend_generic<u8>(@0xCAFE, 20u8);
        let _ = script_generic<u16>(30u16);
    }
}




//# run 0xCAFE::VisibilityWithTypeArgs::runner
