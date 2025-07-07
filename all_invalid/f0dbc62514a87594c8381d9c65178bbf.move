
//# publish
module 0xCAFE::UninitCheckerTestA {
    use std::signer;

    // Struct with type param having ability constraints copy+store
    struct StructCopyStore<T: copy + store> has store {
        val: T,
        flag: bool,
    }

    // Struct with type param having ability constraints drop+store
    struct StructDropStore<T: drop + store> has store {
        val: T,
        count: u8,
    }

    // Simple struct with no type params, has store
    struct Simple has store {
        x: u8,
        y: u8,
    }

    // Struct param T has no ability constraints
    struct NoConstraint<T> has store {
        data: T,
    }

    // Function testing various local vars initialization/uninit usage
    public fun test_uninit_vars(x: u8) {
        // uninitialized local variables declarations
        let v1: u8;
        let v2: bool;
        let v3: StructCopyStore<u8>;
        let v4: StructDropStore<u8>;
        let s: Simple;

        // Using variable before initialization should be caught by checker
        // Here just using them to trigger checks
        // Assign initialized values to some vars to prevent false positive
        v1 = 42u8;
        v2 = true;
        s = Simple { x: 1u8, y: 2u8 };

        // v3 and v4 deliberately left uninitialized to test detection

        // Use uninitialized v3.val - should error if checker works
        // Using a field of uninitialized struct variable
        let _tmp1 = v3.val;

        // Use uninitialized v4.count
        let _tmp2 = v4.count;

        // Initialize v3 now to fix future usage
        v3 = StructCopyStore<u8>{ val: 7u8, flag: false };

        // Assign values to v4 to avoid uninit later
        v4 = StructDropStore<u8>{ val: 9u8, count: 1 };

        // Access initialized fields
        let a = v3.val;
        let b = v4.count;

        // Variable with no ability constraints
        let u_nc: NoConstraint<u8>;
        u_nc = NoConstraint<u8>{ data: 5u8 };
        let _d = u_nc.data;

        // Real use of v1 and v2 after assignment, fix: condition wrapped in parentheses
        let _sum = v1 + (if (v2) { 1u8 } else { 0u8 });
    }

    // Runner function to execute above test with simple input
    public fun runner() {
        test_uninit_vars(5u8);
    }
}



//# run 0xCAFE::UninitCheckerTestA::runner




//# publish
module 0xCAFE::UninitCheckerTestB {
    // Removed unused use std::signer;
    use 0xCAFE::UninitCheckerTestA;

    // Struct with generic parameter constrained with copy+drop+store
    struct StructCopyDropStore<T: copy + drop + store> has store {
        member: T,
        data: u64,
    }

    // Param struct reusing type from imported module
    struct Wrapper<T: store> has store {
        inner: UninitCheckerTestA::NoConstraint<T>,
    }

    // Function that calls function from other module in same package
    public fun call_external_runner() {
        UninitCheckerTestA::runner();
    }

    // Function with locals mixing primitive and generic types illustrating address mapping
    public fun test_mixed_vars() {
        let a: u8 = 10u8;

        // StructCopyDropStore instantiated with u8 (copy + drop + store)
        let obj1: StructCopyDropStore<u8>;
        obj1 = StructCopyDropStore<u8>{ member: 100u8, data: 0u64 };

        // Wrapper instantiated with u8 type param
        let wrap: Wrapper<u8>;
        wrap = Wrapper<u8>{ inner: UninitCheckerTestA::NoConstraint<u8>{ data: 55u8 } };

        // Access fields to verify no uninitialized use error
        let _x = obj1.member;
        let _y = wrap.inner.data;

        // Call external runner function
        call_external_runner();
    }

    public fun runner() {
        test_mixed_vars();
    }
}



//# run 0xCAFE::UninitCheckerTestB::runner




//# publish
module 0xCAFE::PackageTestMain {
    // Removed unused use std::signer;
    use 0xCAFE::UninitCheckerTestA;
    use 0xCAFE::UninitCheckerTestB;

    // Struct with ability constraints mix
    struct ComplexStruct<T: copy + store, U: drop + store> has store {
        a: T,
        b: U,
        flag: bool,
    }

    // Function testing initialization and usage of parametrized structs with ability constraints
    public fun test_ability_constrained_structs() {
        // Instantiate ComplexStruct with u8 and UninitCheckerTestA::Simple
        let s = UninitCheckerTestA::Simple { x: 1u8, y: 2u8 };
        let cs = ComplexStruct<u8, UninitCheckerTestA::Simple>{ a: 10u8, b: s, flag: true };

        // Declare uninitialized variable with type param having store and drop 
        let uninit_var: ComplexStruct<u8, UninitCheckerTestA::Simple>;

        // Use field of uninitialized variable - trigger UninitializedUseChecker on fields with drop ability
        let _ = uninit_var.flag;
        let _ = uninit_var.b.y;

        // Now assign value to fix uninit usage
        uninit_var = cs;

        // Access fields after initialization
        let _val_a = uninit_var.a;
        let _val_b_x = uninit_var.b.x;

        // Cross module calls that combine all interactions
        UninitCheckerTestA::runner();
        UninitCheckerTestB::runner();
    }

    public fun runner() {
        test_ability_constrained_structs();
    }
}



//# run 0xCAFE::PackageTestMain::runner




//# publish
module 0xF00D::PkgTestAddr1 {
    // Added ability drop for Addr1Struct to allow dropping safely
    struct Addr1Struct has store, drop {
        id: u64,
        data: u8,
    }

    public fun get_id(a: Addr1Struct): u64 {
        a.id
    }
}



//# publish
module 0xBEEF::PkgTestAddr2 {
    use 0xF00D::PkgTestAddr1;

    struct Addr2Struct has store {
        value: u8,
        inner: PkgTestAddr1::Addr1Struct,
    }

    public fun get_nested_id(s: Addr2Struct): u64 {
        // s.inner is not copy, so unpack or consume with match tuple unpack
        // Move does not allow copying non-copy types, so let's unpack s to consume inner properly
        let Addr2Struct { value: _, inner } = s;
        // 'inner' consumed, now can pass to get_id
        PkgTestAddr1::get_id(inner)
    }
}



//# publish
module 0xCAFE::PkgTestAddrMain {
    use 0xBEEF::PkgTestAddr2;

    struct MainStruct has store {
        nested: PkgTestAddr2::Addr2Struct,
    }

    public fun create_nested(): MainStruct {
        // Fix: create inner with correct module address
        let inner = PkgTestAddr1::Addr1Struct { id: 123u64, data: 7u8 };
        let addr2struct = PkgTestAddr2::Addr2Struct { value: 255u8, inner };
        MainStruct { nested: addr2struct }
    }

    public fun get_id_from_main(s: MainStruct): u64 {
        PkgTestAddr2::get_nested_id(s.nested)
    }

    public fun run_example_usage() {
        let ms = create_nested();
        let _id = get_id_from_main(ms);
    }
}



//# run 0xCAFE::PkgTestAddrMain::run_example_usage
