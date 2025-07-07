
//# publish
module 0xCAFE::Addition {
    // Constant declaration
    const MAGIC: u8 = 42;

    // Adds two u8 values and returns their sum plus the MAGIC constant
    public fun add_and_magic(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + MAGIC
    }

    // Function with a lambda that doubles a number
    public fun lambda_double_example(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |n: u8| {
            n * 2
        };
        doubler(x)
    }

    // Inline function returning the sum of two u8 values
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Addition;

    // Calls inline_add from Addition module and adds MAGIC constant again
    public fun call_addition_inline(x: u8, y: u8): u8 {
        let res = Addition::inline_add(x, y);
        res + Addition::MAGIC
    }
}


//# publish
module 0xCAFE::SourceHashExample {
    // Simulate source file hash association

    struct SourceFile has copy, drop, store {
        name: vector<u8>,
        content: vector<u8>,
        hash: vector<u8>,
    }
    
    // Publishes a source file record
    public fun publish_source() {
        let name = b"source.move";
        let content = b"module 0xCAFE::Example { }";
        let hash = x"abcdef1234567890";
        let _src = SourceFile { name, content, hash };
    }
}


//# publish
module 0xCAFE::ErrorHandling {
    // Demonstrates using Unit type and simple error management

    struct Unit has copy, drop {} 

    struct UnresolvedError has drop {}

    // Function returning Unit type to indicate success
    public fun do_nothing(): Unit {
        Unit {}
    }

    // Function that returns an error or success Unit depending on input
    public fun maybe_error(flag: bool): Result<Unit, UnresolvedError> {
        if (flag) {
            Result::ok<Unit, UnresolvedError>(do_nothing())
        } else {
            Result::err<Unit, UnresolvedError>(UnresolvedError {})
        };
    }

    // Result type, simple version as it's std in Aptos std module
    /// Using std::result but as no std allowed except in std module, define minimal Result type:
    struct Result<T, E> has copy, drop, store {
        is_ok: bool,
        value: vector<u8>, // use vector<u8> as opaque container
    }

    public inline fun ok<T, E>(val: T): Result<T, E> {
        let _val = vector[];
        Result<T, E> { is_ok: true, value: _val }
    }

    public inline fun err<T, E>(val: E): Result<T, E> {
        let _val = vector[];
        Result<T, E> { is_ok: false, value: _val }
    }
}


//# run 0xCAFE::Addition::add_and_magic --args 10u8 20u8


//# run 0xCAFE::Addition::lambda_double_example --args 21u8


//# run 0xCAFE::Caller::call_addition_inline --args 15u8 25u8


//# run 0xCAFE::SourceHashExample::publish_source


//# run 0xCAFE::ErrorHandling::do_nothing


//# run 0xCAFE::ErrorHandling::maybe_error --args true


//# run 0xCAFE::ErrorHandling::maybe_error --args false


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7111f53b42d3f84e91f3e1d4229edb5d: Declare module-level constants using the 'const' keyword followed by a name, type, value, and semicolon.
// 0772e38ae5cf4b0bc3d91be9a39786fd: Associate source file hashes with their corresponding file names and source contents for use in the package system.
// fe4621ae0d61f411fef5c1f6ecd21071: Recognize and handle special types like Unit or UnresolvedError for error management.
