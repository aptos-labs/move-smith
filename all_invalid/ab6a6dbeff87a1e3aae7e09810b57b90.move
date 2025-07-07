
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

    // Expose MAGIC constant via public function (to fix privacy issue)
    public fun get_magic(): u8 {
        MAGIC
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Addition;

    // Calls inline_add from Addition module and adds MAGIC constant again (using public getter)
    public fun call_addition_inline(x: u8, y: u8): u8 {
        let res = Addition::inline_add(x, y);
        res + Addition::get_magic()
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

    // Result type defined inside the same module to fix unbound error
    struct Result<T, E> has copy, drop, store {
        is_ok: bool,
        value: vector<u8>, // use vector<u8> as opaque container
    }

    public inline fun ok<T, E>(_val: T): Result<T, E> {
        let _vec = vector[];
        Result<T, E> { is_ok: true, value: _vec }
    }

    public inline fun err<T, E>(_val: E): Result<T, E> {
        let _vec = vector[];
        Result<T, E> { is_ok: false, value: _vec }
    }

    // Function returning Unit type to indicate success
    public fun do_nothing(): Unit {
        Unit {}
    }

    // Function that returns an error or success Unit depending on input
    public fun maybe_error(flag: bool): Result<Unit, UnresolvedError> {
        if (flag) {
            ok<Unit, UnresolvedError>(do_nothing())
        } else {
            err<Unit, UnresolvedError>(UnresolvedError {})
        }
    }
}



//# run 0xCAFE::Addition::add_and_magic --args 10u8 20u8



//# run 0xCAFE::Addition::lambda_double_example --args 21u8



//# run 0xCAFE::Caller::call_addition_inline --args 15u8 25u8



//# run 0xCAFE::SourceHashExample::publish_source



//# run 0xCAFE::ErrorHandling::do_nothing



//# run 0xCAFE::ErrorHandling::maybe_error --args true



//# run 0xCAFE::ErrorHandling::maybe_error --args false
