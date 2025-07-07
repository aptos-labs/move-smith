
//# publish
module 0xCAFE::TestModule {
    use std::option;
    // Removed unused import
    // use std::signer;

    struct Inner has copy, drop, store {
        val: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        num: u8,
    }

    // Added 'store' ability to enum Wrapper
    enum Wrapper has copy, drop, store {
        V1,
        V2(Inner),
        V3 { field: Outer },
    }

    struct Singleton has store {
        inner: Inner,
        w: Wrapper,
    }

    // Function with unique name #1, returns Outer struct explicitly
    public fun create_outer(num: u8): Outer {
        let inner = Inner { val: 100u64 };
        Outer { inner, num }
    }

    // Function with unique name #2, returns Wrapper explicitly
    public fun create_wrapper(v: u8): Wrapper {
        if (v == 0) {
            Wrapper::V1
        } else if (v == 1) {
            Wrapper::V2(Inner { val: 42u64 })
        } else {
            Wrapper::V3 { field: Outer { inner: Inner { val: 7u64 }, num: 3u8 } }
        }
    }

    // Test copy and move semantics on primitives and structs with copy, drop
    public fun copy_move_test(x: u8): (u8, u8) {
        let prim_copy = x;
        let prim_move = x;
        // both prim_copy and prim_move should be usable (u8 has copy)
        let struct_copy = Inner { val: 10u64 };
        let struct_move = struct_copy;
        let val1 = prim_copy + 1;
        let val2 = struct_move.val + 1u64;
        (val1, val2 as u8)
    }

    // Function using binding mechanism for Optional conversion from u8 to Option<u8>
    public fun convert_to_option(x: u8): option::Option<u8> {
        let opt = option::some(x);
        // Bind opt to variable
        let opt_var = opt;
        opt_var
    }

    // Declare function with explicit signature returning Outer struct
    public fun get_outer_struct(num: u8): Outer {
        create_outer(num)
    }

    // Function returning Wrapper given an Inner
    public fun wrap_inner(i: Inner): Wrapper {
        Wrapper::V2(i)
    }

    // Create Singleton resource to test nested field referencing other types
    public fun create_singleton(): Singleton {
        let inner = Inner { val: 999u64 };
        let w = Wrapper::V3 { field: Outer { inner: Inner { val: 555u64 }, num: 7u8 } };
        Singleton { inner, w }
    }
}



//# run 0xCAFE::TestModule::create_outer --args 5u8



//# run 0xCAFE::TestModule::create_wrapper --args 2u8



//# run 0xCAFE::TestModule::copy_move_test --args 10u8



//# run 0xCAFE::TestModule::convert_to_option --args 100u8



//# run 0xCAFE::TestModule::get_outer_struct --args 42u8



//# run 0xCAFE::TestModule::wrap_inner --args 0x0



//# run 0xCAFE::TestModule::create_singleton
