
//# publish
module 0xCAFE::AbortInBinOp {
    use std::error;

    public fun test_abort_in_binop() {
        let a = if (true) { 1 } else { 2 };
        let b = if (false) { 3 } else { 4 };
        // The following line intentionally contains an abort expression inside a block used as an operand.
        // This should cause a verification or runtime abort.
        let _ = a + (if (a > 0) { abort 999; } else { 0 });
        // The above line should trigger an abort during execution.
        // Since this is a test, the abort should be caught by the test framework.
    }
}


//# run 0xCAFE::AbortInBinOp::test_abort_in_binop


// The following modules simulate a dependency graph between modules based on their dependencies.
// The graph is constructed as a set of modules, each importing others, forming a directed acyclic graph.


//# publish
module 0xCAFE::ModuleA {
    use 0xCAFE::ModuleC;
    // ModuleA depends on ModuleC
    public fun run() {}
}


//# publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA;
    // ModuleB depends on ModuleA
    public fun run() {}
}


//# publish
module 0xCAFE::ModuleC {
    // ModuleC has no dependencies
    public fun run() {}
}

// These modules together form the dependency graph:
// ModuleB -> ModuleA -> ModuleC
// and ModuleC has no dependencies.

// To verify the correctness, we can create a function that references all modules

//# publish
module 0xCAFE::DependencyGraphVerifier {
    use 0xCAFE::ModuleA;
    use 0xCAFE::ModuleB;
    use 0xCAFE::ModuleC;

    public fun verify_dependencies() {
        ModuleA::run();
        ModuleB::run();
        ModuleC::run();
    }
}


//# run 0xCAFE::DependencyGraphVerifier::verify_dependencies


// The following script triggers detailed bytecode verification failure.
// We deliberately generate an invalid bytecode snippet (simulate via invalid instruction).
// Since Move scripts are compiled within the framework, we simulate by including a malformed module.
//

//# run
script {
    // The Move VM should detect invalid bytecode during compilation.
    // This is a manual simulation: in an actual test, this would be an invalid script.
    // But for demonstration, we show an intentionally malformed script.
    //
    // Note: Move language does not provide syntax for invalid bytecode directly.
    // Instead, we can simulate verification failure by including invalid code.
    // Here, just include a syntax error to trigger compilation errors.
    invalid_move_code: () {
        // missing semicolon or invalid syntax
        let x = 123
        // no semicolon, should cause verification failure
    }
}

// The above script should fail the compilation, producing detailed error messages
// about verification failure, such as missing semicolons or invalid instructions.

// Featurres:
// 0182c1793cb068bc0c1b7f0324c594d2: Test that abort expressions inside code blocks used as operands in binary operations are correctly detected and handled during execution.
// 94edb5e14905208dab6e3d3dc730616e: Construct a directed dependency graph of modules based on their dependencies.
// 070e2e2b6fc53d7fb90fcd8d68dad542: Trigger detailed error messages when bytecode verification fails during compilation
