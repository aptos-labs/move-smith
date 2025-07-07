//# publish
module 0x1::Dependency {
    /// Native struct with no fields.
    native struct NativeResource;

    struct R has store {
        value: u64,
    }

    public fun create_r(v: u64): R {
        R { value: v }
    }

    /// Modify or interact with R based on v.
    public fun do(r: &mut R, v: u64) {
        if (v > 10) {
            r.value = r.value + v;
        } else {
            r.value = r.value * v;
        }
    }

    /// Runner function calling do() to test modification.
    public fun runner() {
        let mut r = create_r(5);
        do(&mut r, 4);  // multiply path: 5 * 4 = 20
        do(&mut r, 20); // add path: 20 + 20 = 40

        // Note: no assertions needed as per instructions.
    }
}

//# run 0x1::Dependency::runner

//# publish
#[skip(["unused-variable", "variable-shadowing", "missing-abort-code"])]
module 0x1::PackagePaths {
    use std::string;
    use std::vector;

    struct PackagePaths has store {
        // Original String name transformed to Symbol.
        name: address::Symbol,
        targets: vector<String>,
        deps: vector<String>,
    }

    public fun new(name: string::String, targets: vector<string::String>, deps: vector<string::String>): PackagePaths {
        PackagePaths {
            name: string::string_to_symbol(&name),
            targets,
            deps,
        }
    }

    /// Return the symbol name for testing.
    public fun get_name_symbol(pkg: &PackagePaths): address::Symbol {
        pkg.name
    }

    /// Runner function to create PackagePaths and return the symbol name.
    public fun runner() {
        let name = string::utf8(b"TestPkg");
        let targets = vector::empty<string::String>();
        let deps = vector::empty<string::String>();

        let pkg = new(name, targets, deps);
        let _sym = get_name_symbol(&pkg);
    }
}

//# run 0x1::PackagePaths::runner


//# publish
module 0x1::ListExpressions {
    /// Function creating a list from multiple expressions.
    public fun create_list(): vector<u64> {
        let v = vector::from_elem(0u64, 0); // empty vector
        let list = vector::empty<u64>();
        let list = vector::push_back(list, 1);
        let list = vector::push_back(list, 2);
        let list = vector::push_back(list, 3);
        list
    }

    /// Runner function to exercise list creation.
    public fun runner() {
        let _list = create_list();
    }
}

//# run 0x1::ListExpressions::runner


//# run
script {
    use 0x1::Dependency;
    use 0x1::PackagePaths;
    use 0x1::ListExpressions;
    use std::debug;

    fun main() {
        // Test Dependency::do with signer interaction

        // create a mutable resource r
        let mut r = Dependency::create_r(7);
        Dependency::do(&mut r, 3); // 7 * 3 = 21
        Dependency::do(&mut r, 12); // 21 + 12 = 33

        // Create PackagePaths and verify symbol
        let name = std::string::utf8(b"MyPackage");
        let targets = std::vector::empty<std::string::String>();
        let deps = std::vector::empty<std::string::String>();
        let pkg = PackagePaths::new(name, targets, deps);
        let _symbol = PackagePaths::get_name_symbol(&pkg);

        // Create the list expression
        let list = ListExpressions::create_list();

        // Output some debug info (not an assertion)
        debug::print(&std::string::utf8(b"Test script executed."));
    }
}