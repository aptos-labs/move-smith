//# publish
module 0xCAFE::FunctionRefsAndStructs {
    // Use inline functions with function references and structs with named fields and associated types

    struct Container<T> has copy, drop, store {
        value: T,
        id: u64
    }

    public inline fun foo(
        f1: &fun(u8, u8): u8,
        f2: &fun(u16): u16,
        a: u8,
        b: u8,
        c: u16
    ): u16 {
        let r1 = *f1(a, b);
        let r2 = *f2(c);
        // cast r1 u8 to u16 for addition
        (r1 as u16) + r2
    }

    public fun runner(): u16 {
        let add = fun(x: u8, y: u8): u8 { x + y };
        let square = fun(x: u16): u16 { x * x };
        foo(&add, &square, 5u8, 10u8, 3u16)
    }

    public fun create_container(): Container<u8> {
        Container { value: 42u8, id: 1001u64 }
    }

    public fun cast_and_check(x: u16): u8 {
        // Cast u16 to u8 (assuming x < 256)
        let y = x as u8;
        // Check with assertion
        assert(y == (x as u8), 777);
        y
    }
}

//# run 0xCAFE::FunctionRefsAndStructs::runner

//# run 0xCAFE::FunctionRefsAndStructs::create_container

//# run 0xCAFE::FunctionRefsAndStructs::cast_and_check --args 200u16