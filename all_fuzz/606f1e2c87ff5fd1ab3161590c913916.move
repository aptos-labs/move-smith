
//# publish
module 0xCAFE::MathOps {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 1;
        result
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::MathOps::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::MathOps::with_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOps;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        // Call MathOps::inline_add twice nestedly
        let partial = MathOps::inline_add(a, b);
        MathOps::inline_add(partial, 1)
    }
}


//# run 0xCAFE::NestedCalls::nested_inline_call --args 20u8 5u8


//# publish
module 0xCAFE::StringDecoder {
    use std::vector;

    public fun decode_string_literal(s: vector<u8>): vector<u8> {
        // In a real scenario, error handling must be done
        // Here just return the byte vector for demonstration
        s
    }

    public fun run_decode_test(): vector<u8> {
        // Decode a byte string literal
        let bytes = b"AptosMoveTest";
        decode_string_literal(bytes)
    }
}


//# run 0xCAFE::StringDecoder::run_decode_test


//# publish
module 0xCAFE::StructUses {
    use std::string;
    use std::vector;

    struct BasicStruct has copy, drop, store {
        val: u64,
    }

    public fun create_basic_struct(v: u64): BasicStruct {
        BasicStruct { val: v }
    }

    public fun create_vector_of_structs(): vector<BasicStruct> {
        let s1 = BasicStruct { val: 1 };
        let s2 = BasicStruct { val: 2 };
        let v = vector::empty<BasicStruct>();
        vector::push_back(&mut v, s1);
        vector::push_back(&mut v, s2);
        v
    }

    // Using `Struct` handle by type parameter for demonstration
    public fun create_struct_by_handle(): BasicStruct {
        // This is just instantiation, interpretation of "Struct handle" is compiler internal,
        // here it shows type usage by identifier.
        BasicStruct { val: 123 }
    }
}


//# run 0xCAFE::StructUses::create_basic_struct --args 999u64


//# run 0xCAFE::StructUses::create_vector_of_structs


//# run 0xCAFE::StructUses::create_struct_by_handle


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 14550188013c2562a88c89a29e9771fe: Decode a string literal into a byte vector with diagnostic error handling
// 33393c308eb8a6712ef2abfbbd0718db: Specify struct types by their handle index using the 'Struct' feature.
