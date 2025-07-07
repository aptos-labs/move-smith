// Use a test address 0xCAFE as required

//# publish
module 0xCAFE::TypeParamConstraints {
    use std::signer;

    // 1. Define struct with type parameters with constraints
    // Constraint: T must be copyable and storeable (implied by store)
    // Constraint: U must be copyable and storeable
    struct Container<T: copy + store, U: copy + store> has store {
        val_t: T,
        val_u: U,
    }

    /// A runner function that creates an instance of Container<u8, u64> to test param constraints
    public fun runner(): u64 {
        let container = Container { val_t: 42u8, val_u: 1000u64 };
        container.val_u
    }
}
//# run 0xCAFE::TypeParamConstraints::runner


//# publish
module 0xCAFE::PackagePathConversion {
    use std::string;
    use std::symbol;

    struct PackagePathString has store {
        address: string::String,
        module: string::String,
        named_address_map_keys: vector<string::String>,
        named_address_map_values: vector<string::String>,
    }

    struct PackagePathSymbol has store {
        address: symbol::Symbol,
        module: symbol::Symbol,
        named_address_map_keys: vector<symbol::Symbol>,
        named_address_map_values: vector<symbol::Symbol>,
    }

    // Converts a vector<string::String> to vector<symbol::Symbol>
    fun convert_vec_string_to_symbol(keys: vector<string::String>): vector<symbol::Symbol> {
        let mut symbols = vector::empty<symbol::Symbol>();
        let len = vector::length(&keys);
        let mut i = 0;
        while (i < len) {
            let s = vector::borrow(&keys, i);
            let sym = symbol::new(s);
            vector::push_back(&mut symbols, sym);
            i = i + 1;
        }
        symbols
    }

    // Convert the PackagePathString to PackagePathSymbol by converting each string to symbol
    public fun convert_path(pkg_path: PackagePathString): PackagePathSymbol {
        let address_sym = symbol::new(&pkg_path.address);
        let module_sym = symbol::new(&pkg_path.module);
        let keys_sym = convert_vec_string_to_symbol(pkg_path.named_address_map_keys);
        let vals_sym = convert_vec_string_to_symbol(pkg_path.named_address_map_values);

        PackagePathSymbol {
            address: address_sym,
            module: module_sym,
            named_address_map_keys: keys_sym,
            named_address_map_values: vals_sym,
        }
    }

    // A runner function to test conversion
    public fun runner(): bool {
        let address_str = string::utf8_42(); // "42"
        let module_str = string::utf8_84(); // "84"

        let mut keys = vector::empty<string::String>();
        let mut vals = vector::empty<string::String>();

        vector::push_back(&mut keys, string::utf8_97()); // "a"
        vector::push_back(&mut keys, string::utf8_98()); // "b"

        vector::push_back(&mut vals, string::utf8_99()); // "c"
        vector::push_back(&mut vals, string::utf8_100()); // "d"

        let pkg_path = PackagePathString {
            address: address_str,
            module: module_str,
            named_address_map_keys: keys,
            named_address_map_values: vals,
        };

        let _converted = convert_path(pkg_path);
        true
    }

}
//# run 0xCAFE::PackagePathConversion::runner


//# publish
module 0xCAFE::TypeErrorHandling {
    use std::vector;

    // An enum for type representation to mimic unexpected type cases
    enum TypeRep {
        U8,
        U64,
        Bool,
        Address,
        Unexpected, // represents unexpected type
    }

    // Returns the size in bytes of a type or an error code for unexpected
    public fun size_of_type(t: TypeRep): u64 {
        if (t == TypeRep::U8) {
            1
        } else if (t == TypeRep::U64) {
            8
        } else if (t == TypeRep::Bool) {
            1
        } else if (t == TypeRep::Address) {
            16
        } else {
            // Error handling for unexpected type
            0xffffffffffffffff // use u64 max as error sentinel
        }
    }

    // Runner tries several types including unexpected and returns sum of valid sizes
    public fun runner(): u64 {
        let types = vector::empty<TypeRep>();
        vector::push_back(&mut types, TypeRep::U8);
        vector::push_back(&mut types, TypeRep::U64);
        vector::push_back(&mut types, TypeRep::Unexpected);
        vector::push_back(&mut types, TypeRep::Bool);

        let mut sum = 0u64;
        let len = vector::length(&types);
        let mut i = 0;
        while (i < len) {
            let s = size_of_type(*vector::borrow(&types, i));
            if (s != 0xffffffffffffffff) {
                sum = sum + s;
            }
            i = i + 1;
        }
        sum
    }
}
//# run 0xCAFE::TypeErrorHandling::runner


//# run
script {
    use std::debug;
    use 0xCAFE::TypeParamConstraints;
    use 0xCAFE::PackagePathConversion;
    use 0xCAFE::TypeErrorHandling;

    fun main() {
        let size_sum = TypeErrorHandling::runner();
        debug::print(&string::utf8("Size sum excluding unexpected types:"));
        debug::print(&string::utf8_u64(size_sum));

        let converted_ok = PackagePathConversion::runner();
        if (converted_ok) {
            debug::print(&string::utf8("PackagePath conversion succeeded"));
        }

        let val = TypeParamConstraints::runner();
        debug::print(&string::utf8_u64(val));
    }
}

// Featurres:
// a751ab551b101d83e9e29ae0609c0d79: Define struct type parameters with a fixed set of constraints.
// de38fcde4206c2188dc15e31490f9b7b: Convert PackagePaths with String fields to PackagePaths with Symbol fields for names, paths, and named address maps.
// dded9be223fac34813eccd921aec2897: Handle unexpected type cases with appropriate error handling in your code.
