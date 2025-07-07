//# publish
module 0xCAFE::FuncRefsTest {
    use std::signer;

    /// A function type alias that takes two u64 and returns u64
    // Move currently doesn't support type alias for function types, so we define inline

    /// This inline function takes two function refs and two u64 parameters,
    /// calls the functions with those parameters and returns the sum of results.
    public inline fun foo(
        f1: &fun(u64, u64): u64,
        f2: &fun(u64, u64): u64,
        x: u64,
        y: u64
    ): u64 {
        let r1: u64 = (*f1)(x, y);
        let r2 = (*f2)(x, y);
        r1 + r2
    }

    /// Simple function to return sum of two u64.
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    /// Another function that returns product of two u64.
    public fun mul(x: u64, y: u64): u64 {
        x * y
    }

    /// A no-argument runner function that demonstrates inline function and function refs.
    public fun runner(): u64 {
        // Declare a typed binding with optional type annotation after variable name.
        let f1: &fun(u64, u64): u64 = &Self::add;
        let f2 = &Self::mul; // no type annotation here

        let x: u64 = 3;
        let y = 4; // infer u64 from context

        foo(f1, f2, x, y)
    }
}
//# run 0xCAFE::FuncRefsTest::runner


//# run
script {
    use 0xCAFE::FuncRefsTest;

    fun main() {
        let r = FuncRefsTest::runner();
        // No assertions needed, just run to check both compiler and VM
        let _x = r;
    }
}

// Featurres:
// 51538506128d3532953eac476017dfce: Generate on-chain file format bytecode units from stackless bytecode functions
// 668b34d96d6abfda6188a8ce9279c6c2: Declare a typed binding with an optional type annotation after the variable name.
// fa8b9e28cd9746d83bfa2acc574ce3d0: Test that the inline function `foo` correctly calls the passed function references with the provided arguments and returns their sum.
