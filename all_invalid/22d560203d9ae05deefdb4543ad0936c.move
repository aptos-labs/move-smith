
//# publish
module 0xCAFE::ExperimentControl {
    use std::signer;
    use std::vector;

    // A keyset of allowed experiments
    const EXPERIMENTS: vector<vector<u8>> = vector[
        b"exp1",
        b"exp2",
        b"exp_with_fn",
        b"exp_with_inline_fn",
        b"exp_with_closure",
        b"exp_access_parsing"
    ];

    // AccessSpecifier with negation and params
    struct AccessSpecifier has copy, drop, store {
        name: vector<u8>,
        negated: bool,
        params: vector<u8>,
    }

    struct Experiment has copy, drop, store {
        name: vector<u8>,
        access: AccessSpecifier,
    }

    /// Validate experiment name against EXPERIMENTS keyset
    public fun validate_experiment_name(name: &vector<u8>) {
        let found = false;
        let len = vector::length(&EXPERIMENTS);
        let i = 0u64;
        while (i < len) {
            if (vector::borrow(&EXPERIMENTS, i) == name) {
                found = true;
            };
            i = i + 1;
        };
        assert!(found, 1001);
    }

    /// Declare an experiment only if in EXPERIMENTS keyset
    public fun declare_experiment(name: vector<u8>, access: AccessSpecifier): Experiment {
        validate_experiment_name(&name);
        Experiment {name, access}
    }

    /// Inline function example with tuple return
    public inline fun inline_return_sum_diff(a: u8, b: u8): (u8, u8) {
        // Fix: add parentheses around the condition in if expression
        (a + b, a - (if (a > b) { b } else { a }))
    }

    /// Closure usage: accepts u8 and u8 returns u8
    public fun use_closure(x: u8, y: u8, f: |(u8, u8)| u8): u8 {
        f((x, y))
    }

    /// Experiment declaring function using inline, tuple, and closure 
    public fun experiment_with_functions() {
        // Declare an experiment only if named exp_with_fn
        let exp1 = declare_experiment(b"exp_with_fn", AccessSpecifier {
            name: b"read",
            negated: false,
            params: b"none"
        });

        let (sum, diff) = inline_return_sum_diff(10u8, 3u8);

        let result = use_closure(sum, diff, |(a, b): (u8, u8)| -> u8 {
            a * b
        });

        // Dummy usage of result and exp1
        let _x = result + vector::length(&exp1.name) as u8;
    }

    /// Experiment declaring function using closures with multiple params and copying closures
    public fun experiment_with_closure_and_lambda() {
        let exp2 = declare_experiment(b"exp_with_closure", AccessSpecifier {
            name: b"write",
            negated: false,
            params: b"param1"
        });

        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let copied_lambda = copy lambda;

        let res1 = lambda(5u8, 7u8);
        let res2 = copied_lambda(8u8, 9u8);

        let _total = res1 + res2 + vector::length(&exp2.name) as u8;
    }

    /// Parse individual AccessSpecifier from inputs
    public fun parse_access_spec(name: vector<u8>, negated: bool, params: vector<u8>): AccessSpecifier {
        AccessSpecifier {name, negated, params}
    }

    /// Test access spec parsing with and without negation and with params
    public fun experiment_access_parsing() {
        let acc1 = parse_access_spec(b"read", false, b"");
        let acc2 = parse_access_spec(b"write", true, b"paramX");
        let acc3 = parse_access_spec(b"admin", false, b"paramY,paramZ");

        let exp = declare_experiment(b"exp_access_parsing", acc3);

        // Dummy usages to avoid warnings
        let _ = acc1.negated;
        let _ = acc2.params;
        let _ = vector::length(&exp.name);
    }
}



//# run 0xCAFE::ExperimentControl::declare_experiment --args b"exp1" b"read" false b"paramA"



//# run 0xCAFE::ExperimentControl::experiment_with_functions



//# run 0xCAFE::ExperimentControl::experiment_with_closure_and_lambda



//# run 0xCAFE::ExperimentControl::experiment_access_parsing
