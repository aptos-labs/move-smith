
//# publish
module 0xCAFE::MathModule {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus 10 to vary output
        sum + 10
    }

    // Note: Move does not currently support lambda expressions or closure types.
    // We'll change use_lambda to be a normal function that mimics the intended behavior.
    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let c = x + y;
        let d = x * y;
        (c, d)
    }

    public inline fun inline_increment(a: u16): u16 {
        a + 1
    }

    public fun call_inline_and_add(a: u16, b: u16): u16 {
        let inc_a = inline_increment(a);
        let inc_b = inline_increment(b);
        inc_a + inc_b
    }

    public fun sequence_of_instructions(x: u8): u8 {
        let a = x + 1;
        let b = a * 2;
        let c = b - 3;
        let d = c / 2;
        d
    }

    struct TupleStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    public fun tuple_match_and_struct_destructure(): u8 {
        // Move currently does not support tuples as first-class citizens.
        // Replace tuple with explicit variables.
        let p: u8 = 5;
        let q: u16 = 10;
        let s = TupleStruct {a: p, b: q};
        let TupleStruct {a, b} = s;
        a + (b as u8)
    }
}



//# run 0xCAFE::MathModule::add_and_return --args 2u8 3u8



//# run 0xCAFE::MathModule::use_lambda --args 4u8 5u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun nested_call(a: u16, b: u16): u16 {
        MathModule::call_inline_and_add(a, b)
    }
}



//# run 0xCAFE::CallerModule::nested_call --args 7u16 8u16



//# run 0xCAFE::MathModule::sequence_of_instructions --args 4u8



//# run 0xCAFE::MathModule::tuple_match_and_struct_destructure
