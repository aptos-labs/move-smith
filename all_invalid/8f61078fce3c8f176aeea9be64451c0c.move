
//# publish
module 0xCAFE::LambdaLiftAttr {
    use std::vector;

    // attr_alpha]
    // attr_beta = 42]
    spec module {
        // alpha_spec] 
        fun alpha() {}

        // beta_spec = 100]
        fun beta() {}
    }

    struct Container has store {
        values: vector<u8>,
    }

    public fun create_container(): Container {
        let cont = Container { values: vector[] };
        cont
    }

    public fun append_values(mut cont: Container) {
        // Define a lambda lifted to function scope
        let add_two: |u8|u8 = |x: u8| { x + 2u8 };

        let values_ref = &mut cont.values;

        // Use the lifted lambda on each value that's appended
        vector::push_back(values_ref, add_two(3u8));
        vector::push_back(values_ref, add_two(5u8));
        vector::push_back(values_ref, add_two(7u8));
    }

    public fun inline_lambda_use(): u8 {
        // Inline function usage with lambda
        let inline_add = (|a: u8, b: u8| { a + b });
        inline_add(10u8, 20u8)
    }

    public fun chain_field_access(): u8 {
        let cont = create_container();
        append_values(cont);

        // Chain: access field vector, then index it
        let x = *vector::borrow(&cont.values, 1);
        x
    }
}



//# run 0xCAFE::LambdaLiftAttr::create_container



//# run 0xCAFE::LambdaLiftAttr::append_values 



//# run 0xCAFE::LambdaLiftAttr::inline_lambda_use



//# run 0xCAFE::LambdaLiftAttr::chain_field_access


// Features:
// b96aa00a04c014ffafa027357a5737bb: Lift lambda functions into higher scopes with optional inline function inclusion.
// 12e23ce9d95ad2bc7d29c694cc830809: Chain field accesses or index expressions (e.g., x.f, x[1]) after an expression.
// a4e33a282cae3cdb894d91b180870d57: Add attributes to modules via spec modules and have those attributes appear on the merged module.
