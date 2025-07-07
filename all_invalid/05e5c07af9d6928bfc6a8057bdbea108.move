
//# publish
module 0xCAFE::LambdaLiftAttr {
    use std::vector;

    // attr_alpha]
    // attr_beta = 42]
    spec module {
        // alpha_spec]
        fun alpha(): () {}

        // beta_spec = 100]
        fun beta(): () {}
    }

    struct Container has store {
        values: vector<u8>,
    }

    public fun create_container(): Container {
        let cont = Container { values: vector::empty<u8>() };
        cont
    }

    public fun append_values(cont: &mut Container) {
        // Define a lambda lifted to function scope as a normal function    
        // Move does not support closures, so let’s use a helper function instead
        fun add_two(x: u8): u8 {
            x + 2u8
        }

        let values_ref = &mut cont.values;

        // Use the lifted lambda (helper function) on each value that's appended
        vector::push_back(values_ref, add_two(3u8));
        vector::push_back(values_ref, add_two(5u8));
        vector::push_back(values_ref, add_two(7u8));
    }

    public fun inline_lambda_use(): u8 {
        // Move does not support lambdas, so we define a local function instead
        fun inline_add(a: u8, b: u8): u8 {
            a + b
        }
        inline_add(10u8, 20u8)
    }

    public fun chain_field_access(): u8 {
        let cont = create_container();
        append_values(&mut cont);

        // Chain: access field vector, then index it
        let x = *vector::borrow(&cont.values, 1);
        x
    }
}



//# run 0xCAFE::LambdaLiftAttr::create_container



//# run 0xCAFE::LambdaLiftAttr::append_values 



//# run 0xCAFE::LambdaLiftAttr::inline_lambda_use



//# run 0xCAFE::LambdaLiftAttr::chain_field_access
