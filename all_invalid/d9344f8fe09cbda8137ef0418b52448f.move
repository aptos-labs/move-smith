
//# publish
module 0xCAFE::TestAdd {
    /// Adds two u8 numbers and then returns x + y + 1
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    /// Returns the sum of two numbers using a lambda function
    public fun sum_with_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
}


//# run 0xCAFE::TestAdd::add_and_increment --args 5u8 10u8


//# run 0xCAFE::TestAdd::sum_with_lambda --args 7u8 8u8


//# publish
module 0xCAFE::TestInline {
    use 0xCAFE::TestAdd;

    /// Calls the inline function in TestAdd indirectly
    public inline fun inline_add(x: u8, y: u8): u8 {
        // Use sum_with_lambda which contains lambda expressions
        let sum_lambda_result = TestAdd::sum_with_lambda(x, y);

        // Use add_and_increment which sums and increments by 1
        let add_inc_result = TestAdd::add_and_increment(x, y);

        // Return sum_lambda_result + add_inc_result for testing nested calls
        sum_lambda_result + add_inc_result
    }
}


//# run 0xCAFE::TestInline::inline_add --args 3u8 4u8


//# publish
module 0xCAFE::TestReference {
    /// Holds a vector<u8> for reference testing
    struct Container has copy, drop, store {
        data: vector<u8>
    }

    public fun create_container(): Container {
        let data = vector[1u8, 2u8, 3u8];
        Container { data }
    }

    /// Returns the length of the data vector via a reference
    public fun length_via_ref(c: &Container): u64 {
        // use std::vector::length
        let len = std::vector::length(&c.data);
        len
    }

    /// Append a byte to data vector via a mutable reference
    public fun append_byte(c: &mut Container, b: u8) {
        std::vector::push_back(&mut c.data, b);
    }
}


//# run 0xCAFE::TestReference::create_container

// We'll call length_via_ref and append_byte via script wrapper below


//# run
script {
    use 0xCAFE::TestReference;

    fun main() {
        let c = TestReference::create_container();
        let len_before = TestReference::length_via_ref(&c);
        TestReference::append_byte(&mut c, 4u8);
        let len_after = TestReference::length_via_ref(&c);
        // lengths returned but no assertions per instructions
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 108d66fe40e9f1f13a1f0294a8997173: Use reference types to process borrowed data in functions.
