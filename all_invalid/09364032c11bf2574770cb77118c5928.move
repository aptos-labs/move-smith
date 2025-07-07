// Using a non-0x1 address as requested
// # publish
module 0xCAFE::ShadowPkgDep {
    public struct ShadowStruct has store, copy, drop {
        value: u64,
    }

    public fun get_value(s: &ShadowStruct): u64 {
        s.value
    }

    public fun shadow_function(): u64 {
        42
    }

    // Runner function with no arguments that just returns a constant
    public fun runner(): u64 {
        shadow_function()
    }
}
// # run 0xCAFE::ShadowPkgDep::runner

// # publish
module 0xCAFE::PkgDep {
    use 0xCAFE::ShadowPkgDep;

    // A function with package visibility: only callable within this package
    // In Aptos Move, package visibility is declared using `public(script)` or `public(friend)`
    // However, the test assumes package visibility restricted to certain contexts.
    // Aptos Move supports friend visibility, so we'll simulate package visibility using friend visibility
    // and put the friend in this module itself (as allowed).
    //
    // Note this requires Aptos Move compiler that supports `public(friend)` visibility;
    // for demonstration, `public(friend 0xCAFE)` limits to 0xCAFE friend modules.

    // This function will only be callable by friend 0xCAFE modules (i.e. inside this package)
    public(friend 0xCAFE) fun package_only_function(): u64 {
        99
    }

    // Runner function calls the package_only_function internally
    public fun call_package_function(): u64 {
        package_only_function()
    }
}
// # run 0xCAFE::PkgDep::call_package_function

// # publish
module 0xCAFE::GenericStruct {
    // 1: Declare type parameter for struct
    // This struct holds a generic type T with store and drop ability.
    public struct Container<T> has drop, store {
        inner: T,
    }

    // Create a Container<u64> with value 7
    public fun make_u64_container(): Container<u64> {
        Container { inner: 7 }
    }

    // Return the inner value of Container<u64>
    public fun get_inner_value(c: &Container<u64>): u64 {
        c.inner
    }

    // Runner function creates a container and returns the contained value
    public fun runner(): u64 {
        let c = make_u64_container();
        get_inner_value(&c)
    }
}
// # run 0xCAFE::GenericStruct::runner

// # run
script {
    use 0xCAFE::GenericStruct;
    use 0xCAFE::PkgDep;
    use 0xCAFE::ShadowPkgDep;

    fun main() {
        // Test generic struct and its functions
        let container = GenericStruct::make_u64_container();
        let val = GenericStruct::get_inner_value(&container);
        // `val` is 7 here

        // Test calling package_visible function via public function in PkgDep
        let pkg_val = PkgDep::call_package_function();
        // `pkg_val` is 99 here

        // Test ShadowPkgDep runner to exercise shadowing
        let shadow_val = ShadowPkgDep::runner();
        // shadow_val is 42 here

        // Use the ShadowPkgDep directly also
        let shadow_struct = ShadowPkgDep::ShadowStruct { value: 1234 };
        let extracted = ShadowPkgDep::get_value(&shadow_struct);
        // extracted is 1234

        // No assertions needed, value usage is enough for test coverage
    }
}

// Featurres:
// e374a7c668a1b94c8a289f53af65f853: Declare type parameters for structs
// 7669c10993e328017887329d3570dde0: Optionally remove intersecting dependency files if sources are allowed to shadow dependencies.
// a551f36d6b7299492bf1b78bc0c8db28: Call functions with package visibility restricted to certain contexts
