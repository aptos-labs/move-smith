//# publish
module 0xCAFE::FunctionTypeTest {
    use std::signer;

    const CONST_VALUE: u64 = 42u64;

    public native fun native_no_args(): u64;

    public fun defined_no_args(): u64 {
        let x = CONST_VALUE;
        x
    }

    public fun takes_function(f: || u64): u64 {
        let val = f();
        val + CONST_VALUE
    }

    public fun returns_function(): || u64 {
        || 100u64
    }

    public fun runner() {
        let f: || u64 = returns_function();
        let res = takes_function(f);
        let res2 = defined_no_args();
        let _ = res + res2 + native_no_args();
    }
}

//# run 0xCAFE::FunctionTypeTest::runner


// Featurres:
// 1aec77f4e8edb94bdfe31ad964824728: Specify empty parameter function types with '||' as in '|| u64'.
// 36f33fe235cdad4c61527b4091b05f11: Ensure constant values are within the u64 range.
// b18451b7f2927b8092fe415072e1e412: Create function bodies that are either native (semicolon-terminated) or defined with a sequence of instructions enclosed in braces.
