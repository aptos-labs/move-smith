// Address alias test -- to assign a name to an account address
// This is a config section, which is not executable code but demonstrates the syntax:
// address CAFFE = 0xCAFE

// #publish
module 0xCAFE::CyclicInline {
    // Two inline functions that call each other to test detection of cyclic calls

    #[inline]
    fun f1(): u64 {
        // This should trigger a cyclic inline call detection if the compiler inlines endlessly
        f2()
    }

    #[inline]
    fun f2(): u64 {
        f1()
    }

    // Non-inline function to avoid immediate cycle on main
    public fun runner(): u64 {
        // Call f1 - inlining should detect cycle and refuse or error
        // Here we just call it so inlining happens in compile to detect cycle
        f1()
    }
}
// #run 0xCAFE::CyclicInline::runner --signers 0xCAFE

// #publish
module 0xCAFE::PatternBinding {
    // Test pattern-bindings to locals, both with and without type

    // A struct for pattern matching
    struct Pair has copy, drop {
        x: u8,
        y: u8,
    }

    public fun runner(): u8 {
        // Binding without explicit type
        let p = Pair { x: 10, y: 20 };
        let Pair { x, y } = p;
        // x and y are u8
        let sum = x + y;

        // Binding with explicit type annotation for new local
        let Pair { x: a, y: b }: Pair = p;
        let sum2: u8 = (a + b);

        // Using let block expression with pattern binding
        let res = {
            let Pair { x, y } = p;
            x * y
        };
        sum + sum2 + res
    }
}
// #run 0xCAFE::PatternBinding::runner --signers 0xCAFE

// #run 0xCAFE::PatternBinding::runner --signers 0xCAFE

// #run 0xCAFE::CyclicInline::runner --signers 0xCAFE

// #run 0xCAFE::PatternBinding::runner --signers 0xCAFE


// #run 0xCAFE::CyclicInline::runner --signers 0xCAFE


// #run 0xCAFE::PatternBinding::runner --signers 0xCAFE


//# run
script {
    fun main(account: signer) {
        // Dummy: call PatternBinding.runner
        let res = 0xCAFE::PatternBinding::runner();
        // call CyclicInline.runner (will likely fail with cyclic error but triggers compile)
        let _ = 0xCAFE::CyclicInline::runner();
    }
}

// Featurres:
// 849cdc3430d3537a79447731cdcfa751: Detect and prevent cyclic calls between inline functions to avoid infinite inlining.
// 0398755694b591d2da1013f326ff1117: Pattern-bind values to local variables in Move blocks, with or without an explicit type.
// 4a1fee204c98bcfa6dd60411e4376794: Assign a name to an account address using the syntax <address_name>=<address> in Move configuration.
