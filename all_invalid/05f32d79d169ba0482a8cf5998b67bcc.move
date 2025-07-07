//# publish
module 0xCAFE::MutableBonds {
    // Test multiple mutable borrows and updates on local variable
    public fun multi_borrow_update(x: u8): u8 {
        let mut mut_val = x;

        // First borrow & update
        let mut_ref: &mut u8 = &mut mut_val;
        *mut_ref = *mut_ref + 10;

        // Second borrow & update
        let mut_ref2: &mut u8 = &mut mut_val;
        *mut_ref2 = *mut_ref2 + 20;

        mut_val
    }

    // Runner function calling multi_borrow_update
    public fun runner(): u8 {
        multi_borrow_update(5u8)
    }
}

//# run 0xCAFE::MutableBonds::runner


// Address block with multiple module definitions
address 0xCAFE {

    //# publish
    module ModuleA {
        public fun hello(): u8 {
            42u8
        }
    }

    //# publish
    module ModuleB {
        public fun call_hello(): u8 {
            ModuleA::hello()
        }
    }
}

//# run 0xCAFE::ModuleA::hello

//# run 0xCAFE::ModuleB::call_hello



//# publish
module 0xCAFE::PackagePathsSymbol {
    use std::string;

    struct PackagePaths has store {
        // Change field from string::String to vector<u8> as symbol module is not available
        name: vector<u8>,
        path: string::String,
    }

    public fun create(name: vector<u8>, path: vector<u8>): PackagePaths {
        let path_str = string::utf8(path);
        PackagePaths { name, path: path_str }
    }

    public fun get_name(pp: &PackagePaths): &vector<u8> {
        &pp.name
    }

    public fun get_path(pp: &PackagePaths): &string::String {
        &pp.path
    }

    public fun runner(): (&vector<u8>, &string::String) {
        let p = create(b"mypkg", b"/some/path");
        (get_name(&p), get_path(&p))
    }
}

//# run 0xCAFE::PackagePathsSymbol::runner