
//# publish
module 0xCAFE::AdditionModule {
    // Simple addition function returning sum plus one
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // Function using a lambda to multiply then add
    public fun with_lambda(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy = |a: u8, b: u8| a * b + 1;
        f(x, y)
    }

    // Inline function that returns sum and difference as tuple
    public inline fun tuple_inline(a: u8, b: u8): (u8, u8) {
        (a + b, a - b)
    }

    // Spec function with parameter list in parentheses and imperative ignored by compiler
    spec fun spec_func(x: u8, y: u8): u8 {
        let z = x + y;
        z = z + 1;
        z
    }

    // Spec function with parentheses around parameter list and imperative ignores
    spec fun spec_func_parens((x: u8, y: u8)): u8 {
        let z = x + y;
        z = z + 2;
        z
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Calls inline function from AdditionModule, returns sum plus difference
    public fun call_inline_tuple(x: u8, y: u8): u8 {
        let (sum, diff) = AdditionModule::tuple_inline(x, y);
        sum + diff
    }

    // Run a lambda from AdditionModule indirectly
    public fun call_lambda(x: u8, y: u8): u8 {
        AdditionModule::with_lambda(x, y)
    }
}


//# publish
module 0xCAFE::ByteBufferModule {
    struct ByteBuffer has store {
        buf: vector<u8>
    }

    public fun new_buffer(): ByteBuffer {
        let buf = vector::empty<u8>();
        ByteBuffer { buf }
    }

    // Append a byte (given as char) to the byte buffer
    public fun push_char(bb: &mut ByteBuffer, c: char) {
        // Convert char to ascii byte, e.g. 'A' -> 65u8
        let c_byte = u8::from_bytes([c as u8, 0, 0, 0]);
        vector::push_back(&mut bb.buf, c_byte);
    }
}


//# run 0xCAFE::AdditionModule::add_and_increment --args 12u8 34u8


//# run 0xCAFE::AdditionModule::with_lambda --args 3u8 5u8


//# run 0xCAFE::CallerModule::call_inline_tuple --args 10u8 4u8


//# run 0xCAFE::CallerModule::call_lambda --args 6u8 7u8


//# run 0xCAFE::ByteBufferModule::new_buffer


//# run 0xCAFE::ByteBufferModule::push_char --args 0x0u8 65u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a6e10024aa543c46926e5bc7a36747d7: Rely on the compiler to mark spec functions containing imperative expressions as uninterpreted, so they are excluded from certain verification analyses.
// c97d16ca4d327179d64cbaa15d06c6b2: Declare functions in specifications with parameter lists enclosed in parentheses.
// 1cf57ddf4a49dd6d8ef62268c1145c63: Add a character to a byte buffer by converting it to its ASCII byte representation.
