//# publish
module 0xCAFE::DeprecationTest {
    // Deprecated function
    #[deprecated = "use new_function instead"]
    public fun old_function(): u64 {
        42
    }

    public fun new_function(): u64 {
        43
    }

    // Runner function that calls the deprecated function
    public fun runner(): u64 {
        old_function()
    }

    // Inline function to be removed after inlining (simulated)
    #[inline]
    public fun inline_func(x: u64): u64 {
        x + 1
    }

    public fun use_inline(): u64 {
        inline_func(10)
    }
}

//# run 0xCAFE::DeprecationTest::runner
//# run 0xCAFE::DeprecationTest::use_inline

//# publish
module 0xCAFE::ModuleWithInline {
    #[inline]
    public fun add_one(x: u64): u64 {
        x + 1
    }

    public fun call_add_one(): u64 {
        add_one(100)
    }

    // Runner function with no args
    public fun runner(): u64 {
        call_add_one()
    }
}

//# run 0xCAFE::ModuleWithInline::runner


//# run
script {
    use 0xCAFE::DeprecationTest;
    use 0xCAFE::ModuleWithInline;

    fun main() {
        let v1 = DeprecationTest::old_function();
        let v2 = DeprecationTest::new_function();
        let v3 = DeprecationTest::runner();
        let v4 = DeprecationTest::use_inline();
        let v5 = ModuleWithInline::runner();

        // Just a dummy usage to force codegen and runtime path coverage
        let _sum = v1 + v2 + v3 + v4 + v5;
    }
}

// Featurres:
// 9def49343c650663209a2268dd6c0e84: Define Move modules to encapsulate related code and resources.
// 5e550e056a0844180685ceff61211e66: Use deprecated members from modules with warning messages.
// 4957c6b77b94890bc1f8b09f0feac0e4: Remove inline functions from the program after inlining to reduce code size and prevent codegen issues.
