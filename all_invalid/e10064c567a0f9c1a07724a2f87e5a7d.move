//# publish
module 0xCAFE::AccessControlTest {
    struct Counter has store {
        count: u64,
        flag: bool,
    }

    public fun create_counter(): Counter {
        Counter { count: 0, flag: true }
    }

    // Public function to increment count
    public fun increment(c: &mut Counter) {
        c.count = c.count + 1;
    }

    // Public(script) function - can only be called by scripts
    public(script) fun reset(c: &mut Counter) {
        c.count = 0;
    }

    // Public(entry) function - can be called in entry transactions only
    public(entry) fun flip_flag(c: &mut Counter) {
        c.flag = !c.flag;
    }

    fun private_fun_example() {
        // This function is private: no access specifier means private
        // Just a dummy function to confirm private is accepted
        let x = 1u8;
        let _y = x + 1;
    }

    public fun run_access_control_test() {
        let mut c = create_counter();

        increment(&mut c);
        increment(&mut c);
        reset(&mut c);
        flip_flag(&mut c);

        private_fun_example();
    }
}

//# run 0xCAFE::AccessControlTest::run_access_control_test


//# publish
module 0xCAFE::StructFieldIteration {
    use std::debug;

    struct FullData has store {
        a: u8,
        b: u16,
        c: bool,
        d: u64,
    }

    // Iterates over fields and logs their values individually
    public fun log_fields(data: &FullData) {
        debug::print(&b"Field a = ");
        debug::print(&u8_to_vec(data.a));
        debug::print(&b"\n");
        debug::print(&b"Field b = ");
        debug::print(&u16_to_vec(data.b));
        debug::print(&b"\n");
        debug::print(&b"Field c = ");
        debug::print(&bool_to_vec(data.c));
        debug::print(&b"\n");
        debug::print(&b"Field d = ");
        debug::print(&u64_to_vec(data.d));
        debug::print(&b"\n");
    }

    fun u8_to_vec(x: u8): vector<u8> {
        vector::empty<u8>()
            // Just a dummy empty vector representing `x` for logging
    }

    fun u16_to_vec(_x: u16): vector<u8> {
        vector::empty<u8>()
    }

    fun u64_to_vec(_x: u64): vector<u8> {
        vector::empty<u8>()
    }

    fun bool_to_vec(_b: bool): vector<u8> {
        vector::empty<u8>()
    }

    public fun run_struct_field_iteration() {
        let data = FullData { a: 42u8, b: 300u16, c: true, d: 5000u64 };
        log_fields(&data);
    }
}

//# run 0xCAFE::StructFieldIteration::run_struct_field_iteration


//# publish
module 0xCAFE::SpecModuleHandling {
    use std::vector;
    use std::address;

    struct ModuleInfo has copy, drop, store {
        name: vector<u8>,
        is_spec: bool,
    }

    struct ModuleCollection has store {
        spec_modules: vector<ModuleInfo>,
        regular_modules: vector<ModuleInfo>,
    }

    public fun create(): ModuleCollection {
        ModuleCollection {
            spec_modules: vector::empty<ModuleInfo>(),
            regular_modules: vector::empty<ModuleInfo>(),
        }
    }

    public fun add_module(
        collection: &mut ModuleCollection,
        name: vector<u8>,
        is_spec: bool,
    ) {
        let module_info = ModuleInfo { name, is_spec };
        if (is_spec) {
            vector::push_back(&mut collection.spec_modules, module_info);
        } else {
            vector::push_back(&mut collection.regular_modules, module_info);
        };
    }

    public fun count_spec_modules(collection: &ModuleCollection): u64 {
        vector::length(&collection.spec_modules) as u64
    }

    public fun count_regular_modules(collection: &ModuleCollection): u64 {
        vector::length(&collection.regular_modules) as u64
    }

    public fun run_spec_module_handling() {
        let mut coll = create();

        let mod1 = b"RegularModule1";
        let mod2 = b"SpecModule1";
        let mod3 = b"RegularModule2";
        let mod4 = b"SpecModule2";

        add_module(&mut coll, mod1, false);
        add_module(&mut coll, mod2, true);
        add_module(&mut coll, mod3, false);
        add_module(&mut coll, mod4, true);

        let _spec_count = count_spec_modules(&coll);
        let _reg_count = count_regular_modules(&coll);
    }
}

//# run 0xCAFE::SpecModuleHandling::run_spec_module_handling


// Featurres:
// c7b1a0c5317056916323518874692592: Specify access control for functions using access specifiers.
// bd28eeae1ce71d93da1b64be274d9e2f: Iterate over fields of a struct to handle each field individually.
// d9ce1800d97241d902dd92a8d3cae71c: Handle spec modules distinctly from regular modules by storing them in a specialized collection.
