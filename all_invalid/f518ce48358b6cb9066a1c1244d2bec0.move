
//# publish
module 0xCAFE::BindLambdaLiveIntervals {
    use std::signer;

    // Simple struct to force some storage usage
    struct Data has store {
        val: u64
    }

    public fun create_data(s: signer, v: u64) {
        let data = Data { val: v };
        move_to<Data>(&s, data);
    }

    public fun bind_and_lambda(x: u8): u8 {
        // Bind with explicit type annotation
        let a: u8 = x + 1;

        // Bind without explicit type annotation
        let b = a * 2;

        // Lambda capturing no variables
        let lambda_empty: |u8|u8 has copy+drop = |y: u8| y + 5u8;

        // Lambda capturing a variable
        let lambda_capture: |u8|u8 has copy+drop = |z: u8| {
            // capture binding b inside lambda
            b + z
        };

        // Call lambdas
        let r1 = lambda_empty(b);
        let r2 = lambda_capture(b);

        // Use Bind with complex expression and type annotation
        let c: u8 = r1 + r2;

        c
    }

    // This function is designed to test inspecting live intervals of variables manually
    public fun live_interval_demo(x: u8): u8 {
        let v1: u8 = x + 1;     // v1 lives here
        let v2: u8 = v1 + 3;    // v2 start, v1 may end after this
        let v3: u8 = v2 * 2;    // v3 start, v2 may end after this

        // Manual comments giving offsets (for hypothetical analysis):
        // offset 0: parameters (x)
        // offset 1: bind v1
        // offset 2: bind v2
        // offset 3: bind v3
        // offset 4: return v3

        v3
    }

    // A runner wrapper to test bind_and_lambda with a simple argument
    public fun runner() {
        let _ = bind_and_lambda(10u8);
    }
}


//# run 0xCAFE::BindLambdaLiveIntervals::bind_and_lambda --args 7u8


//# run 0xCAFE::BindLambdaLiveIntervals::live_interval_demo --args 5u8


//# run 0xCAFE::BindLambdaLiveIntervals::runner


// Featurres:
// afce6dde9812b907927aaec064498535: Bind variables to expressions with optional type annotations using `Bind`.
// f67ace54097c00c4d91e1a438cc44ced: Inspect the live intervals of variables at specific code offsets in a function for debugging or analysis purposes.
// c163b3213962928e29d1b57d9b6a4b2a: Use the syntax '|' to start lambda capture lists, possibly with captures or empty.
