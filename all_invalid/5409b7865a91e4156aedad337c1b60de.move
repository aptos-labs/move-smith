
//# publish
module 0xCAFE::VariableCategorization {
    struct MyStruct<T> {
        field1: T,
        field2: u64,
    }
}

module 0xCAFE::InlineExpressions {
    public fun evaluate_side_effects(): u64 {
        let a = 10;
        let b = 20;
        // Inline-like code block with side effects
        let result = {
            a = a + 1; // side effect
            b = b + 2; // side effect
            a + b // final value to be returned
        };
        result // return the final value
    }
}


//# run 0xCAFE::VariableCategorization::VariableCategorization

//# run 0xCAFE::InlineExpressions::evaluate_side_effects --signers 0xCAFE


//# publish
module 0xCAFE::StructTypeParams {
    struct Container<T> {
        value: T,
    }

    public fun create_container<T>(val: T): Container<T> {
        Container { value: val }
    }

    public fun get_value<T>(container: &Container<T>): T {
        copy container.value
    }
}


//# run 0xCAFE::StructTypeParams::create_container --args 42u64 --signers 0xCAFE

//# run 0xCAFE::StructTypeParams::get_value --args 0xCAFE::StructTypeParams::create_container::create_container 42u64 --signers 0xCAFE

// Featurres:
// e737c436af184ab5cb814c1263acd1ea: Categorize local variables as 'no', 'maybe', or 'yes' initialized based on their initialization status.
// 9b6096659f32566b68b5dfcb8fef2c71: Test that the Move language correctly evaluates multiple inline-like code blocks with side effects in an expression and returns the expected final value.
// 7bed143cecaa4a44ba2a9ddc13d7c0a5: Define structs with type parameters in your modules.
