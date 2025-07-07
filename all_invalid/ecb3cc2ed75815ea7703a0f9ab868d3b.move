//# publish
module 0xCAFE::AstSimplifyFullTest {
    use std::signer;

    // A full module spec block targeting the entire module
    spec module {
        // Just a dummy invariant for demonstration purposes
        invariant true;
    }

    // A public function that we want to run from outside
    public fun runner(_account: &signer) {
        // no-op: just a runner to call inside tests
    }

    // A function that should be eliminated if AST_SIMPLIFY_FULL is active,
    // e.g., a dead function that's never called
    public fun eliminated_function() {
        assert!(false, 42);
    }
}

//# run 0xCAFE::AstSimplifyFullTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::VisibilityCheck {
    // Spec block on the module
    spec module {
        // Just a dummy condition to be checked at module level
        invariant true;
    }

    // Internal function (default visibility) - allowed in scripts
    fun internal_func() {}

    // Public function - allowed in modules, but not in scripts
    public fun public_func() {}

    // Friend function - also not allowed in scripts
    friend fun friend_func() {}

    // Package function - not allowed in scripts either
    native fun package_func();

    // Runner function to call
    public fun runner() {
        internal_func();
        public_func();
        friend_func();
        package_func();
    }
}

//# run 0xCAFE::VisibilityCheck::runner


//# run
script {
    // internal function in script - allowed, no visibility modifiers
    fun internal_script_func() {}

    fun main() {
        internal_script_func();
    }
}

// Featurres:
// 407795779da1e58cabdb55f16af6ad6b: Enable full AST simplification with code elimination when the 'AST_SIMPLIFY_FULL' experiment is active.
// d7d672a1cc1c150fea48c574e56d50dd: Create specification blocks that target the entire module rather than individual members
// d6b18feb62bf10640ad30fdeb701a653: Ensure that script functions do not use public, package, or friend visibility, as scripts must only contain internally visible functions.
