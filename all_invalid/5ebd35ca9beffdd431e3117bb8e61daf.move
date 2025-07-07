//# publish
module 0xCAFE::TestSpecFunction {
    spec fun double(x: u64): u64 {
        let f = |a: u64| a * 2;
        f(x)
    }

    spec fun add_optional_type(v: vector<u8>, ty_opt: option<address>): vector<u8> {
        // This spec function takes an optional type vector for demonstration.
        if (option::is_some(&ty_opt)) {
            vector::append(&mut vector::empty<u8>(), &v)
        } else {
            v
        }
    }

    native fun native_func() : u64;

    public fun runner(): u64 {
        // Call native function
        let val: u64 = Self::native_func();
        val + double(10) // Use inlined lambda spec function double
    }
}
//# run 0xCAFE::TestSpecFunction::runner

//# publish
module 0xCAFE::NativeFuncImpl {
    native fun native_func(): u64;

    public fun native_func(): u64 {
        42
    }
}
//# run 0xCAFE::NativeFuncImpl::native_func

//# run 0xCAFE::TestSpecFunction::native_func

//# run
script {
    use 0xCAFE::TestSpecFunction;

    fun main(): u64 {
        let result = TestSpecFunction::runner();
        result
    }
}

// Featurres:
// 0d69a082e67405f49fd062fefa73e547: Write Move spec functions using lambda expressions and have them automatically expanded and generated during compilation and inlining.
// 0e12a1b2edb5efe353962ad8146a7927: Pass an optional vector of types to functions to handle cases where type information might be absent, enabling flexible type assignments in your code.
// eccac62b7732d501973093a96d582dae: End function declarations with a semicolon for native functions or a block for implemented functions.
