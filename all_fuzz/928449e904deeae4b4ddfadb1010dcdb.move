
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
        }
    }
}


//# run
script {
    fun main() {
        let x = 10u8;
        let y = 25u8;

        let sum = 0xCAFE::LambdaTest::add_u8_and_return_sum(x, y);

        let (sum_lambda, product_lambda) = 0xCAFE::LambdaTest::lambda_sum_and_product(x, y);

        let inc_sum = 0xCAFE::InlineCaller::call_add_and_increment(x, y);

        let result = 0xCAFE::LambdaTest::apply_lambda(x, |a: u8| a * 2);

        // No asserts required per instructions
    }
}


//# run 0xCAFE::LambdaTest::add_u8_and_return_sum --args 15u8 40u8


//# run 0xCAFE::LambdaTest::lambda_sum_and_product --args 5u8 7u8


//# run 0xCAFE::InlineCaller::call_add_and_increment --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3237041cd3e3a0a9176d527051ce4718: Declare specification variables using either the 'global' or 'local' keyword in a spec block.
// 297a70cd64bb09838fa23406faa49331: Filter source and library definitions separately to include only relevant module members.
