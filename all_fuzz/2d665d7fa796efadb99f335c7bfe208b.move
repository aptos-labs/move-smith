
//# publish
module 0xCAFE::AddLambda {
    // Removed unused import: use std::signer;

    // A function that adds two u8's and returns the sum plus a fixed offset
    public fun add_with_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        // Add fixed offset 5
        sum + 5
    }

    // A function that declares and uses a lambda to add two numbers and multiply the result by two
    public fun lambda_add_and_double(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };

        let mul_two = |a: u8| {
            a * 2
        };

        let sum = add(x, y);
        let doubled = mul_two(sum);
        doubled
    }

    // Function to test variable moves, copies, and drops in lambda context
    struct Dummy has drop {}

    public fun infer_assign_and_drop() {
        let x = 10u8;
        let y = x; // copy inferred

        // Move ownership of Dummy
        let d1 = Dummy {};
        let d2 = d1;

        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let copy_lambda = copy lambda;
        let _ = copy_lambda(1u8, 2u8);

        // Scope to drop
        {
            let _temp = Dummy {};
        };
    }
}

// Separate module for MyModule

//# publish
module 0xCAFE::MyModule {
    /// f2 returns a tuple (a, a+1)
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

// Another module or inside AddLambda to call MyModule's function

//# publish
module 0xCAFE::AddLambdaHelpers {
    public fun call_inline_and_sum(a: u16): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }
}



//# run 0xCAFE::AddLambda::add_with_offset --args 3u8 4u8


//# run 0xCAFE::AddLambda::lambda_add_and_double --args 2u8 3u8


//# run 0xCAFE::AddLambdaHelpers::call_inline_and_sum --args 10u16


//# run 0xCAFE::AddLambda::infer_assign_and_drop
