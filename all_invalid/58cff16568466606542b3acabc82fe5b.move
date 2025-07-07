
//# publish
module 0xCAFE::AdditionModule {
    /// Add two u8 values and then add 42 to the result
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 42u8;
        result
    }

    /// Function demonstrating lambda usage and calling the lambda
    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            p + q
        };
        let sum = adder(x, y);

        // Nested lambda calling
        let doubler: |u8| u8 has copy+drop = |z: u8| {
            adder(z, z)
        };
        doubler(sum)
    }

    /// Generic function using a type parameter with multiple abilities combined with '+'
    public fun combine_and_store<T: copy + drop + store>(val1: T, val2: T): T {
        let _ = val1;
        val2
    }
}


//# run 0xCAFE::AdditionModule::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AdditionModule::lambda_example --args 3u8 4u8


//# publish
module 0xCAFE::AbilityTest {
    use std::signer;

    struct Data<T: copy + drop + store> has key {
        val: T,
    }

    public fun create_data<T: copy + drop + store>(s: signer, v: T) {
        let data = Data<T> { val: v };
        move_to<Data<T>>(&s, data);
    }

    public fun read_data<T: copy + drop + store>(addr: address): T {
        let ref: &Data<T> = borrow_global<Data<T>>(addr);
        ref.val
    }
}


//# run 0xCAFE::AbilityTest::create_data --signers 0xDEAD --args 123u8


//# run 0xCAFE::AbilityTest::read_data --args 0xDEAD


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
