
//# publish
module 0xCAFE::UnaryAndLambda {
    use std::vector;

    public fun test_unary_operators(x: u8): u8 {
        // Apply unary arithmetic and logical operators
        let y = !true;
        let z = !(false);
        let a = x + 1;
        let b = a * 2;

        // Use unary minus does not exist, we test unary NOT and boolean NOT
        let direct_not = !((a > 5) || (b > 10));
        let indirect_not = !(a <= 5) && !(b <= 10);

        // last expression is return value
        b
    }

    public fun nested_lambda_use(): u8 {
        let outer = 5u8;

        let f1: |u8| u8 has copy + drop = |a: u8| {
            let inner = 2u8;
            let f2: |u8| u8 has copy + drop = |b: u8| {
                // capture outer and inner variables
                outer + inner + a + b
            };
            f2(3u8)
        };
        f1(4u8)
    }

    public fun parse_list_with_callback(
        list: vector<u8>,
        parser: |u8| u8
    ): vector<u8> {
        let len = vector::length(&list);
        let parsed = vector::empty<u8>();
        let i = 0;
        while (i < len) {
            let item = *vector::borrow(&list, i);
            let parsed_item = parser(item);
            vector::push_back(&mut parsed, parsed_item);
            i = i + 1;
        };
        parsed
    }

    public fun runner_parse_list(): vector<u8> {
        // Parsing each element by doubling its value
        let list = vector[1u8, 2u8, 3u8, 4u8];
        let callback: |u8| u8 has copy+drop = |x: u8| { x * 2 };
        parse_list_with_callback(list, callback)
    }
}


//# run 0xCAFE::UnaryAndLambda::test_unary_operators --args 4u8


//# run 0xCAFE::UnaryAndLambda::nested_lambda_use


//# run 0xCAFE::UnaryAndLambda::runner_parse_list


// Featurres:
// a12be701b4cca6f3c13773c6fbb4b0df: Apply unary operators to expressions with the `unary_exp` expression.
// efe36f711ea2fe32d6f52459ba1c3a45: Test that nested lambda functions can capture and use variables from their enclosing scope.
// 47d0084ab2da340155c0aede54e71e54: Provide custom parsing logic for each list item via a callback function.
