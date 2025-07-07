
//# publish
module 0xCAFE::OperatorsAndLambda {
    // Removed unused import 'std::signer'
    // Removed use of unbound module 'MyModule'

    public fun add_and_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum >= 10) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let anon: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let res = (a << 1) + (b >> 1);
            res
        };
        anon(x, y)
    }

    public inline fun inline_double(a: u16): u16 {
        a * 2
    }

    // Since MyModule is not available, remove nested_inline_call or replace logic
    public fun nested_inline_call(a: u16): u16 {
        let doubled = inline_double(a);
        // Replaced external call with dummy logic
        let x = doubled / 2;
        let y = doubled - x;
        x + y
    }

    public fun operators_test(x: u8, y: u8, z: u8): u8 {
        let a = x;
        a = a + y;        // a = a + y
        a = a - z;        // a = a - z
        a = a * 2;        // a = a * 2
        a = a / 2;        // a = a / 2
        let b = a % 5;    // modulo

        let c = b ^ 3;   // bitwise xor
        c = c << 2;          // shift left
        c = c >> 1;          // shift right

        let d = (x <= y);     // less or equal
        let e = (x >= y);     // greater or equal
        let f = (x == y);     // equal
        let g = (x != y);     // not equal

        if (d == e) {
            1
        } else if (f != g) {
            2
        } else {
            c + b + a
        }
    }

    // Removed use_external_module because MyModule is unbound
}
    

//# run 0xCAFE::OperatorsAndLambda::add_and_return_specific --args 4u8 8u8


//# run 0xCAFE::OperatorsAndLambda::lambda_example --args 10u8 2u8


//# run 0xCAFE::OperatorsAndLambda::nested_inline_call --args 7u16


//# run 0xCAFE::OperatorsAndLambda::operators_test --args 7u8 5u8 3u8
