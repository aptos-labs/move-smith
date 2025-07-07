
//# publish
module 0xCAFE::MyModule {
    // Provide function f2 so that 0xCAFE::Addition can call it.
    public fun f2(a: u16): (u8, u8) {
        // Return a tuple of two u8 elements derived from a (arbitrary example)
        let first = (a % 256) as u8;
        let second = ((a / 256) % 256) as u8;
        (first, second)
    }
}

//# publish
module 0xCAFE::Addition {
    use std::vector;

    // Simple add function returning sum + 5.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        // Lambda to multiply and then add 2
        let mul_then_add = |x: u8, y: u8| {
            let mult = x * y;
            mult + 2
        };
        mul_then_add(a, b)
    }

    public fun call_inline_from_other_module(a: u16): u32 {
        // Call inline f2 from MyModule and then get the first element and cast to u32
        let (first, _) = 0xCAFE::MyModule::f2(a);
        let result: u32 = first as u32;
        result
    }

    public fun mutate_vector_by_index(): u8 {
        let v = x"0102030405"; // vector<u8> equivalent with 5 elements
        // mutate element at index 2 (3rd element) to 42
        *vector::borrow_mut(&mut v, 2) = 42u8;
        // mutate element at index 0 (1st element) to 10
        *vector::borrow_mut(&mut v, 0) = 10u8;

        // sum changed elements and return
        (*vector::borrow(&v, 0)) + (*vector::borrow(&v, 2))
    }

    public fun aggressive_simplification(x: u8): u8 {
        // if true, just return x+1, else returns x+100 (but that branch eliminated)
        if (true) {
            x + 1
        } else {
            x + 100
        };
        // confirmed simplified to x+1 here, but returning a constant for demonstration
        42u8
    }

    public fun macro_style_expansion(x: u8): u8 {
        // Simulate macro expansion: Square function expanded inline here
        let square = x * x;
        square
    }
}



//# run 0xCAFE::Addition::add_and_offset --args 10u8 15u8


//# run 0xCAFE::Addition::with_lambda --args 6u8 7u8


//# run 0xCAFE::Addition::call_inline_from_other_module --args 2u16


//# run 0xCAFE::Addition::mutate_vector_by_index


//# run 0xCAFE::Addition::aggressive_simplification --args 10u8


//# run 0xCAFE::Addition::macro_style_expansion --args 8u8
