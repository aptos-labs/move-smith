
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_sum_and_product(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }

    public fun apply_lambda(x: u8, f: |u8| u8): u8 {
        f(x)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_add_and_increment(a: u8, b: u8): u8 {
        let sum = LambdaTest::add_u8_and_return_sum(a, b);
        sum + 1
    }
}



//# publish
module 0xCAFE::SpecVarExample {
    spec module {
        global foo: u8;

        // local spec variable with an example value
        local bar: u64;

        invariant [foo_always_positive] {
            foo > 0
        };
    }
}



//# run
script {
    fun double(a: u8): u8 {
        a * 2
    };

    fun main() {
        let x = 10u8;
        let y = 25u8;

        let sum = 0xCAFE::LambdaTest::add_u8_and_return_sum(x, y);

        let (sum_lambda, product_lambda) = 0xCAFE::LambdaTest::lambda_sum_and_product(x, y);

        let inc_sum = 0xCAFE::InlineCaller::call_add_and_increment(x, y);

        // Cannot pass inline lambda in script, use named function instead
        let result = 0xCAFE::LambdaTest::apply_lambda(x, double);

        // No asserts required per instructions
    }
};
