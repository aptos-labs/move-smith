
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 20) {
            100u8
        } else {
            sum
        }
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let anon_add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        anon_add(x, y)
    }

    public inline fun inline_sum(a: u16, b: u16): u16 {
        a + b
    }

    public fun caller_inline(x: u16, y: u16): u16 {
        let result = inline_sum(x, y);
        result
    }
}



//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 15u8



//# run 0xCAFE::AddAndReturn::add_and_return --args 5u8 5u8



//# run 0xCAFE::AddAndReturn::lambda_test --args 7u8 8u8



//# run 0xCAFE::AddAndReturn::caller_inline --args 300u16 400u16



//# publish
module 0xCAFE::TupleAndQualifiedNames {
    struct Pair has copy, drop {
        x: u8,
        y: u8,
    }

    public fun tuple_return(): Pair {
        Pair { x: 42u8, y: 84u8 }
    }

    public fun get_field_positional(): u8 {
        let t = tuple_return();
        // Access struct fields by name
        t.x
    }

    public fun get_field_positional_1(): u8 {
        let t = tuple_return();
        t.y
    }

    public fun test_qualified_name(): u8 {
        // Use number literal followed by :: for address access
        let x = 0xCAFE::AddAndReturn::add_and_return(2u8, 3u8);
        x
    }
}



//# run 0xCAFE::TupleAndQualifiedNames::get_field_positional



//# run 0xCAFE::TupleAndQualifiedNames::get_field_positional_1



//# run 0xCAFE::TupleAndQualifiedNames::test_qualified_name
