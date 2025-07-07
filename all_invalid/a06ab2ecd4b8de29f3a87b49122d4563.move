
//# publish
module 0xCAFE::VectorRefTest {
    use std::vector;

    // Fix: return a vector<u8> directly instead of a reference to a local vector
    public fun get_ref_vector(): vector<u8> {
        let v = vector[10u8, 20u8, 30u8];
        v
    }

    public fun unpack_first_two_elements() {
        let v = vector[100u8, 101u8, 102u8];
        let r = &v;

        // unpack first two elements by borrow without moving the vector
        let first = *vector::borrow(r, 0);
        let second = *vector::borrow(r, 1);

        let _sum = first + second;

        // Use vector after unpacking references from it (should still be valid)
        let third = *vector::borrow(r, 2);

        let _ = _sum + third;
    }
}



//# run 0xCAFE::VectorRefTest::unpack_first_two_elements




//# publish
module 0xCAFE::LoopBreakTest {
    public fun loop_with_break_on_bool(cond: bool): u8 {
        let counter = 0u8;
        loop {
            if (cond) {
                if (counter >= 5) {
                    break;
                };
                counter = counter + 1;
            } else {
                break;
            };
        };
        counter
    }
}



//# run 0xCAFE::LoopBreakTest::loop_with_break_on_bool --args true



//# run 0xCAFE::LoopBreakTest::loop_with_break_on_bool --args false




//# publish
module 0xCAFE::FuncFieldStruct {
    public struct StructWithFunc has copy, drop {
        func: |u8| u8
    }

    public fun create_struct_with_closure(): StructWithFunc {
        let closure: |u8| u8 has copy+drop = |x: u8| {
            x * 2
        };
        StructWithFunc {func: closure}
    }

    public fun call_func_field(s: &StructWithFunc, x: u8): u8 {
        (s.func)(x)
    }

    public fun runner() {
        let instance = create_struct_with_closure();
        let _result = call_func_field(&instance, 21u8);
    }
}



//# run 0xCAFE::FuncFieldStruct::runner
