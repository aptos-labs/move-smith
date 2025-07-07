
//# publish
module 0xCAFE::AdditionModule {
    // Module to test addition and lambda expressions, inline function calls, flush write annotations, field mutation, and block expressions

    const FLUSH_CODE_OFFSET: u64 = 42;

    // Added `key` ability so Container can be stored globally
    struct Container has store, key {
        value: u8,
    }

    // Simple function that adds two u8 values then returns 42u8 as a sentinel
    public fun add_then_return_42(a: u8, b: u8): u8 {
        let _x = a + b; // renamed x to _x to avoid unused variable warning
        // flush write annotation at code offset 42 after computing sum
        // flush_write(FLUSH_CODE_OFFSET)]
        42u8
    }

    // Function containing lambda expressions demonstrating capturing and calling
    public fun lambda_demo(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy = |a: u8, b: u8| { a + b };
        let mul_lambda: |u8, u8|u8 has copy = |a: u8, b: u8| { a * b };
        let sum = add_lambda(x, y);
        let prod = mul_lambda(x, y);
        sum + prod
    }

    // Inline function that returns a tuple of sums
    public inline fun inline_sum(a: u8, b: u8): (u8, u8) {
        (a + b, b + a)
    }

    // Call inline_sum from within this module returning just the first element
    public fun call_inline_sum(a: u8, b: u8): u8 {
        let (s1, s2) = inline_sum(a, b);
        s1
    }

    // Mutate a field using dotted expression and a right-hand value
    public fun mutate_field(c: &mut Container, new_val: u8) {
        c.value = new_val;
    }

    // Use a block expression to group multiple expressions; block evaluates to last expression
    public fun block_expression_demo(x: u8, y: u8): u8 {
        let result = {
            let a = x + y;
            let b = a * 2;
            b - x
        };
        result
    }

    // To allow other modules to create Container instances, provide a function that returns Container
    public fun create_container(val: u8): Container {
        Container { value: val }
    }

    // To allow other modules to mutate the Container, provide a public function
    public fun mutate_container_field(c: &mut Container, new_val: u8) {
        c.value = new_val;
    }
}




//# run 0xCAFE::AdditionModule::add_then_return_42 --args 12u8 30u8




//# run 0xCAFE::AdditionModule::lambda_demo --args 4u8 5u8




//# run 0xCAFE::AdditionModule::call_inline_sum --args 7u8 8u8




//# publish
module 0xCAFE::FieldMutationModule {
    use std::signer;
    use 0xCAFE::AdditionModule;

    // Added `key` ability to Wrapper so it can be stored globally
    struct Wrapper has store, key {
        inner: AdditionModule::Container,
    }

    public fun create_wrapper(s: signer, val: u8) {
        // Use AdditionModule's public function to create Container instead of direct struct construction
        let container = AdditionModule::create_container(val);
        let wrapper = Wrapper { inner: container };
        move_to(&s, wrapper);
    }

    public fun mutate_wrapper_field(s: signer, new_val: u8) {
        let wrapper_ref = borrow_global_mut<Wrapper>(signer::address_of(&s));
        // mutate inner.value field via public function in AdditionModule
        AdditionModule::mutate_container_field(&mut wrapper_ref.inner, new_val);
    }

    public fun call_block_expression(x: u8, y: u8): u8 {
        AdditionModule::block_expression_demo(x, y)
    }
}




//# run 0xCAFE::FieldMutationModule::create_wrapper --signers 0xBEEF --args 10u8




//# run 0xCAFE::FieldMutationModule::mutate_wrapper_field --signers 0xBEEF --args 50u8




//# run 0xCAFE::FieldMutationModule::call_block_expression --args 2u8 3u8
