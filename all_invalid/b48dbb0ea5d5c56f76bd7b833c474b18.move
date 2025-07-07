//# publish
module 0x1::TestInlineFunctions {
    use std::signer;

    /// Inline function f returns the input plus 1.
    #[inline]
    fun f(x: u64): u64 {
        x + 1
    }

    /// Inline function g returns the input multiplied by 2.
    #[inline]
    fun g(x: u64): u64 {
        x * 2
    }

    /// `foo` takes a function pointer `func` and an argument `arg`, applies `func` to `arg` and 
    /// sums with the result of applying g on arg.
    fun foo(func: &fn(u64): u64, arg: u64): u64 {
        (func)(arg) + g(arg)
    }

    /// runner function to exercise the inline functions and foo.
    public fun run() {
        let x = 10u64;
        let res_f = f(x);
        let res_g = g(x);
        let res_foo_f = foo(&f, x);
        let res_foo_g = foo(&g, x); // foo with g passed as argument to show flexibility

        // Do nothing with results - just exercise calls
        let _ = (res_f, res_g, res_foo_f, res_foo_g);
    }
}

//# run 0x1::TestInlineFunctions::run


//# publish
module 0x1::ResourceModuleA {
    use std::signer;

    /// Define a resource R owned by Account.
    resource struct R has key {
        val: u64
    }

    /// Acquire resource R under the caller's account.
    public fun acquire_r(account: &signer, val: u64): R {
        R { val }
    }

    /// A function that attempts to acquire R resource from another module - but will fail if R is not in this module
    /// We simulate this by requiring R from this module only.
    public fun acquire_other_module_resource(account: &signer) acquires R {
        // Just borrow, no operation needed for test.
        let _r_ref = borrow_global<R>(signer::address_of(account));
    }

    /// Runner function that acquires resource R and reads val.
    public fun run(account: &signer) {
        let r = acquire_r(account, 42);
        let val = r.val;
        let _ = val;
    }
}

//# run 0x1::ResourceModuleA::run --signers 0x1


//# publish
module 0x1::ResourceModuleB {
    use std::signer;

    /// Define a resource S distinct from R
    resource struct S has key {
        val: u64
    }

    /// Acquire resource S in this module
    public fun acquire_s(account: &signer, val: u64): S {
        S { val }
    }

    /// Attempt to acquire R from ResourceModuleA - this must fail (for the VM this is a test to verify correct resource acquisition restriction)
    /// We do not include code that compiles but would violate resource restrictions. Instead, no function that acquires R is provided.
    /// Just a runner to acquire S.
    public fun run(account: &signer) {
        let s = acquire_s(account, 123);
        let _ = s.val;
    }
}

//# run 0x1::ResourceModuleB::run --signers 0x1


//# publish
module 0x1::RemoveTailJumpTest {
    // This module exists to test that the Move compiler VM correctly removes tail jump instructions.
    // We implement a simple recursive function that involves multiple calls and returns,
    // to produce bytecode sequences which would otherwise have tail jumps.

    /// Recursive factorial function to produce code with return and calls.
    public fun factorial(n: u64): u64 {
        if (n == 0) {
            1
        } else {
            n * factorial(n - 1)
        }
    }

    /// Runner calls factorial with argument 5 to exercise code paths.
    public fun run() {
        let res = factorial(5);
        let _ = res;
    }
}

//# run 0x1::RemoveTailJumpTest::run