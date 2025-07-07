//# publish
module 0xCAFE::LiftedLambdas {
    // A lambda-like function: regular function that we "lift" globally.
    public fun add_one(x: u64): u64 {
        x + 1
    }

    // Higher-order function: takes a function as param and applies it.
    public fun apply_fn(x: u64, f: &fn(u64): u64): u64 {
        *f(x)
    }

    // Runner function: call add_one via apply_fn with inlined function.
    public fun run_lifted_lambda() {
        let res = apply_fn(41, &add_one);
        let _ = res; // no assertions, just exercising
    }
}

//# run 0xCAFE::LiftedLambdas::run_lifted_lambda


//# publish
module 0xCAFE::InliningControl {
    // Inline attribute simulated: comment to indicate this is intended to be inlined
    // (Move compiler currently does not have explicit inline pragmas, but we simulate by small function size)
    public fun inlined_fn(x: u64): u64 {
        x * 2
    }

    // Non-inline function (larger body to inhibit inlining)
    public fun noinline_fn(x: u64): u64 {
        let mut acc = 0;
        let mut i = 0;
        while (i < x) {
            acc = acc + 1;
            i = i + 1;
        }
        acc
    }

    // Runner: Calls both inlined and non-inlined functions
    public fun run_inline_control() {
        let res1 = inlined_fn(10);
        let res2 = noinline_fn(5);
        let _ = (res1, res2);
    }
}

//# run 0xCAFE::InliningControl::run_inline_control


//# publish
module 0xCAFE::PublicVisibility {
    // A public function that does nothing but is public visibility
    public fun public_function() {
    }

    // A private function to contrast with public
    fun private_function() {
    }

    // Runner to call public function
    public fun run_public_visibility() {
        public_function();
    }
}

//# run 0xCAFE::PublicVisibility::run_public_visibility


//# run
script {
    // Entry point script that calls module functions

    0xCAFE::LiftedLambdas::run_lifted_lambda();
    0xCAFE::InliningControl::run_inline_control();
    0xCAFE::PublicVisibility::run_public_visibility();
}

// Featurres:
// 1866c40bc2f20f6142313ef44b66c3f3: Add lifted lambda expressions into the global environment as functions.
// 296137f73b01ca107f2e516f6e55c58b: Use function inlining and control whether to keep or lift inline functions
// ff1512edbab62479df53703ac4442701: Declare public functions or modules using the 'public' visibility modifier.
