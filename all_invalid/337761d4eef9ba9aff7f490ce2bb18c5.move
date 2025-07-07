
//# publish
module 0xCAFE::LintOptimizationTest1 {
    // Module with various coding style features for lint testing

    struct Data has copy, drop, store {
        a: u8,
        b: u64,
    }

    public fun new_data(): Data {
        let a = 10u8;
        let b = 20u64;
        Data { a, b }
    }

    // Function violating style by not using parentheses in if (should be linted)
    public fun style_violation_if(x: bool): u8 {
        if x {
            1u8
        } else {
            2u8
        }
    }

    // Correct style with parentheses
    public fun style_correct_if(x: bool): u8 {
        if (x) {
            1u8
        } else {
            2u8
        };
        3u8
    }

    public fun lint_runner() {
        let d = new_data();
        let _ = d.a + (d.b as u8);

        // Trigger style_violation_if to be lint-checked
        let _ = style_violation_if(true);
        let _ = style_correct_if(false);
    }
}


//# run 0xCAFE::LintOptimizationTest1::lint_runner


//# publish
module 0xCAFE::LintOptimizationTest2 {
    // Module with complex logic and generic usage for optimization and linting

    use std::vector;

    struct Container<T> has copy, drop, store {
        items: vector<T>
    }

    public fun new_container<T>(): Container<T> {
        Container { items: vector::empty<T>() }
    }

    public fun add_item<T>(c: &mut Container<T>, item: T) {
        vector::push_back(&mut c.items, item);
    }

    public fun count_items<T>(c: &Container<T>): u64 {
        vector::length(&c.items)
    }

    public fun lint_optimization_runner() {
        let c = new_container<u8>();
        add_item(&mut c, 5u8);
        add_item(&mut c, 10u8);
        let count = count_items(&c);

        assert!(count == 2, 0);
    }
}


//# run 0xCAFE::LintOptimizationTest2::lint_optimization_runner


//# publish
module 0xCAFE::OptimizationConfigTest {
    // Module testing configurable optimization passes and lint consistency

    struct Counter has copy, drop, store {
        val: u64
    }

    public fun new_counter(): Counter {
        Counter { val: 0 }
    }

    public fun increase(c: &mut Counter, amt: u64) {
        c.val = c.val + amt;
    }

    public fun get_val(c: &Counter): u64 {
        c.val
    }

    public fun optimization_runner() {
        let c = new_counter();
        increase(&mut c, 1);
        increase(&mut c, 2);
        let v = get_val(&c);
        assert!(v == 3, 1);
    }
}


//# run 0xCAFE::OptimizationConfigTest::optimization_runner


//# publish
module 0xCAFE::MultiModuleLintOptimize {
    // Multiple functions with various style and complexity to test lint & optimization idempotency

    struct Pair has copy, drop, store {
        first: u8,
        second: u8,
    }

    public fun create_pair(a: u8, b: u8): Pair {
        Pair { first: a, second: b }
    }

    public fun sum_pair(p: &Pair): u8 {
        p.first + p.second
    }

    public fun lint_opt_runner() {
        let p = create_pair(3u8, 5u8);
        let s = sum_pair(&p);

        assert!(s == 8u8, 7);
    }
}


//# run 0xCAFE::MultiModuleLintOptimize::lint_opt_runner


//# publish
module 0xCAFE::ComboModules {
    struct Temp has copy, drop, store {
        data: u8
    }

    public fun run_combo() {
        let t = Temp { data: 42u8 };
        let x = t.data;
        assert!(x == 42u8, 9);
    }
}


//# run 0xCAFE::ComboModules::run_combo


// Additional combined test orchestrating lint and optimization sequences manually

// Run lint tests on defined modules (~simulated by running their runner functions)
  
//# run 0xCAFE::LintOptimizationTest1::lint_runner

  
//# run 0xCAFE::LintOptimizationTest2::lint_optimization_runner

  
//# run 0xCAFE::MultiModuleLintOptimize::lint_opt_runner


// Run optimization passes and validate no lint regressions (simulated by re-running runners)
  
//# run 0xCAFE::LintOptimizationTest1::lint_runner

  
//# run 0xCAFE::LintOptimizationTest2::lint_optimization_runner

  
//# run 0xCAFE::OptimizationConfigTest::optimization_runner

  
//# run 0xCAFE::MultiModuleLintOptimize::lint_opt_runner

  
//# run 0xCAFE::ComboModules::run_combo


// Run tests with optimization passes toggled for behavior and lint check consistency
  
//# run 0xCAFE::OptimizationConfigTest::optimization_runner

  
//# run 0xCAFE::ComboModules::run_combo


// Featurres:
// 5a1f9548099b9358755a9e992d422c7d: Run lint checks to enforce recommended coding and style practices in Move programs.
// b5a32a6117cd6d94dbd90966e801970e: Define modules using the 'module' function with a module identifier and its definition.
// 28277c32ad3fb6b073e3e1ad62644152: Perform stackless bytecode optimization passes in a configurable pipeline.
