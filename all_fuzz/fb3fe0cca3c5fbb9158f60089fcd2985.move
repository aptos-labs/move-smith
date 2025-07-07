
//# publish
module 0xCAFE::AddAndLambda {
    // Removed unused import
    // use std::signer;

    // Adds two u8 numbers and returns the sum plus 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 5;
        result
    }

    // Uses a lambda to multiply a number by 2
    public fun double_with_lambda(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        f(x)
    }

    // Inline function returning tuple (increment, decrement)
    public inline fun inc_dec(x: u8): (u8, u8) {
        (x + 1, x - 1)
    }

    // Fixed: No module MyModule::f2 exists, so implement f2 inline here for test
    public inline fun f2(x: u16): (u16, u16) {
        (x + 1, x - 1)
    }

    // Use the inline function defined above instead of 0xCAFE::MyModule::f2
    public fun nested_call(x: u16): (u16, u16) {
        let (a, b) = f2(x);
        (a, b)
    }

    struct MutStruct has store {
        val: u8,
    }

    // Mutate field of Dotted expression directly
    public fun mutate_field_directly(s: &mut MutStruct) {
        s.val = s.val + 10;
    }
}


//# run 0xCAFE::AddAndLambda::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::double_with_lambda --args 13u8


//# run 0xCAFE::AddAndLambda::nested_call --args 5u16



//# publish
module 0xCAFE::SpecialValueExpressions {
    // Removed unused import
    // use std::signer;

    // Function demonstrates constructions resembling special values
    public fun special_values_demo() {
        // Removed the let _unit_value = (); because () is not a valid type/value to assign in Move.
        // Instead, just write an empty expression statement if needed, or omit it.

        // Emulate error handling by aborting explicitly when false
        let condition = false;
        if (!condition) {
            abort 100;
        };

        // Demonstrate break/continue by looping
        let counter = 0u8;
        loop {
            if (counter == 2) {
                break;
            };
            counter = counter + 1;
            continue;
        };

        // Value sequence using block with final value
        let _value_block = {
            let x = 1u8;
            x + 1
        };

        // Spec blocks are not explicit in Move, but let a spec comment here:
        // spec special_values_spec { true }
    }
}


//# run 0xCAFE::SpecialValueExpressions::special_values_demo




//# publish
module 0xCAFE::TestMutateDottedField {
    struct MyStruct has store {
        inner: Inner,
    }

    struct Inner has store {
        v: u8,
    }

    public fun new_struct(v: u8): MyStruct {
        let inner = Inner {v};
        MyStruct {inner}
    }

    public fun mutate_field(s: &mut MyStruct, new_v: u8) {
        s.inner.v = new_v;
    }
}


//# run 0xCAFE::TestMutateDottedField::mutate_field --args 99u8
