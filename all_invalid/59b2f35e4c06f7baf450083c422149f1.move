//# publish
module 0xCAFE::ModuleErrorReporting {
    use std::signer;
    use std::vector;

    // Function that aborts with a specific error code
    public fun do_abort() {
        abort 0xDEAD_BEEF;
    }

    // Function that calls another function improperly to trigger error (for verification)
    // We'll make a function that expects signer but we call it without signer in script to get error
    public fun expect_signer(_s: &signer) {
    }

    // A runner function that attempts an improper call to expect_signer,
    // this will cause a compile or runtime error about improper function call signatures.
    public fun runner_improper_call() {
        // Should fail: calling expect_signer without signer argument
        expect_signer(move x); // Intentional incorrect syntax to test detailed error reporting (should error on compile)
    }
}

//# run 0xCAFE::ModuleErrorReporting::do_abort -- signers 0xCAFE
// The above run will cause abort, but it's ok to exercise error reporting on abort

//# publish
module 0xCAFE::ModuleMoveSyntax {
    // This module tests the move syntax 'move x' instead of 'move(x)'
    // We'll do a very simple function that moves a resource
    resource struct R { val: u64 }

    public fun create_r(): R {
        R { val: 42 }
    }

    public fun move_resource(r: R): u64 {
        let moved_r = move r;
        moved_r.val
    }

    // Runner function that creates and then moves the resource
    public fun runner() {
        let r = create_r();
        let val = move_resource(move r);
        // val is now 42, discard val since no assert needed
    }
}

//# run 0xCAFE::ModuleMoveSyntax::runner

//# publish
module 0xCAFE::ModuleOutOfGas {
    use std::signer;
    use std::vector;

    // A function that loops indefinitely or very long to exhaust gas
    public fun loop_forever() {
        let mut i: u64 = 0;
        // Intentionally an infinite loop (large loop instead of truly infinite
        // to not hang forever in execution environment if gas was generous)
        loop {
            i = i + 1;
            if (i == 1000000000) { // large enough to cause out-of-gas
                break;
            }
        }
    }

    // Runner to call the expensive loop
    public fun runner() {
        loop_forever();
    }
}

//# run 0xCAFE::ModuleOutOfGas::runner


//# run
script {
    use std::signer;
    use 0xCAFE::ModuleErrorReporting;
    use 0xCAFE::ModuleMoveSyntax;
    use 0xCAFE::ModuleOutOfGas;

    fun main(_signer: signer) {
        // 1. Call do_abort to test detailed error reporting about abort
        // This will abort the transaction, but that's expected for error reporting.
        // Ignore the rest after abort.
        ModuleErrorReporting::do_abort();

        // 2. Test move syntax
        let r = ModuleMoveSyntax::create_r();
        let val = ModuleMoveSyntax::move_resource(move r);

        // 3. Test out-of-gas by calling expensive loop
        ModuleOutOfGas::loop_forever();
    }
}

// Featurres:
// 86e60b7b8afe9487f0d478e63af0d9d5: Receive detailed error reporting about improper function calls, including call sites and the reason for the restriction
// 80fa296d3cb0b60df8732396c95c08e7: Write 'move x' instead of 'move(x)' to specify a move operation.
// aaf7a91ccdb352a55228e2bf4a99e181: Test that the script correctly handles an out-of-gas situation during a loop execution.
