// Set the backtrace environment variable requires either running mv command before or relies on host environment
// We cannot do environment setting inside Move code, but
// we can test errors with backtrace enabled by ensuring a failure occurs and compiler backtrace is attached.
// However, transactional test format does not support setting env vars inside itself, so this is only a comment.

//# publish
module 0xCAFE::CopyChainTest {
    use std::debug;
    use std::signer;

    /// A struct with copy ability to test copy chain and destruction
    struct Wrapper has copy, drop, store, key {
        value: u64,
    }

    /// A struct to test nested copy chains and destruction
    struct Container has copy, drop, store {
        w1: Wrapper,
        w2: Wrapper,
    }

    /// Runner function to test copy chain destruction correctness
    public fun runner() {
        // Create Wrapper instances
        let w1 = Wrapper { value: 100 };
        let w2 = Wrapper { value: 200 };
        let w3 = Wrapper { value: 300 };

        // Create Container
        let c = Container { w1: copy w1, w2: copy w2 };

        // Copy chain: assign c.w1 to w1a, then w1a to w1b
        let w1a = copy c.w1;
        let w1b = copy w1a;

        // Now destroy w1a by re-assign to a new Wrapper (trigger destruction in copy chain)
        let w1a = Wrapper { value: 400 };

        // Equality checks (without assertions as per instructions)
        let eq1 = (w1b.value == 100);
        let eq2 = (w1a.value == 400);
        let eq3 = (c.w2.value == 200);

        // Use debug::print to force usage
        debug::print(&b"eq1: ");
        debug::print(&u64_to_bytes(eq1 as u64));
        debug::print(&b"\neq2: ");
        debug::print(&u64_to_bytes(eq2 as u64));
        debug::print(&b"\neq3: ");
        debug::print(&u64_to_bytes(eq3 as u64));
        debug::print(&b"\n");
    }

    // Helper function to convert u64 to vector<u8> for debug print
    public inline fun u64_to_bytes(x: u64): vector<u8> {
        let mut bytes = Vector::empty<u8>();
        let mut n = x;
        // 8 bytes little endian
        let i = 0;
        while (i < 8) {
            Vector::push_back(&mut bytes, (n & 0xFF) as u8);
            n = n >> 8;
            i = i + 1;
        }
        bytes
    }


    /// A function to demonstrate call expression usage
    public fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    /// A function to demonstrate call expression with type argument and function kind CallFunction (free function)
    public fun get_wrapper_value(w: Wrapper): u64 {
        w.value
    }

    /// Runner for call expressions
    public fun call_expr_runner() {
        // Call add_two_u8 via call expression
        let result = call add_two_u8(3u8, 4u8);
        debug::print(&b"add_two_u8(3,4) = ");
        debug::print(&u64_to_bytes(result as u64));
        debug::print(&b"\n");

        // Call get_wrapper_value via call expression with one argument
        let w = Wrapper { value: 999 };
        let val = call get_wrapper_value(w);
        debug::print(&b"get_wrapper_value(Wrapper{999}) = ");
        debug::print(&u64_to_bytes(val));
        debug::print(&b"\n");

        // Call a module function with explicit type parameters and arguments (simulated)
        // Since there are no generics, just demonstrate with no type args
        let v = call Container { w1: Wrapper { value: 1 }, w2: Wrapper { value: 2 } };
        // Just print something to use v so it is not unused
        let _ = v.w1.value + v.w2.value;
    }
}
//# run 0xCAFE::CopyChainTest::runner
//# run 0xCAFE::CopyChainTest::call_expr_runner

//# publish
module 0xCAFE::CallExample {
    use std::debug;

    /// Public inline function to demonstrate call expression
    public inline fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    /// Runner function calling multiply via call expression
    public fun runner() {
        let x = 7u64;
        let y = 8u64;

        // call expression with free function multiply
        let res = call multiply(x, y);
        debug::print(&b"multiply(7,8) = ");
        debug::print(&u64_to_bytes(res));
        debug::print(&b"\n");
    }

    // Helper function to convert u64 to vector<u8> for debug print
    public inline fun u64_to_bytes(x: u64): vector<u8> {
        let mut bytes = Vector::empty<u8>();
        let mut n = x;
        let mut i = 0;
        while (i < 8) {
            Vector::push_back(&mut bytes, (n & 0xFF) as u8);
            n = n >> 8;
            i = i + 1;
        }
        bytes
    }
}
//# run 0xCAFE::CallExample::runner


//# run
script {
    use 0xCAFE::CopyChainTest;
    use 0xCAFE::CallExample;

    fun main() {
        // Run the runner functions to test copy chain destruction and call expression
        CopyChainTest::runner();
        CopyChainTest::call_expr_runner();
        CallExample::runner();
    }
}

// Featurres:
// 445fcdebe264ed16869a4233b4dfc04e: Configure the compiler to include backtrace information during errors by setting the 'MVC_BACKTRACE_ENV_VAR' environment variable.
// 5f2ba91b946acfaef5bc1b41c3366d82: Test that destroying a variable in a copy chain with a re-assignment correctly removes all related copy information, ensuring equality comparisons use the correct values.
// 957f4ac0040e1148684d1fb2cc2c2abb: Call functions and methods using the `call` expression, specifying the function name, call kind, optional type arguments, and argument list.
