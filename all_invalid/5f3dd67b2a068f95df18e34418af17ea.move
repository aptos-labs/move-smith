//# publish
module 0xCAFE::LintConfigModule {
    // This module doesn't enforce any lint: skipping hypothetical lints
    // Using attributes with `#[skip(lint_name)]` is a feature for testing parser acceptance; here is example usage

    #[skip("unused_variable")]
    #[skip("unused_result")]
    public fun no_lint_example() {
        let _unused = 42;
        // Not using the value intentionally, no lint should be triggered
    }
}

//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::InlineCallee;

    // Calling inlined function from another module; test correct inlining and execution
    public fun call_inlined_once(x: u64): u64 {
        InlineCallee::inlined_add_one(x)
    }

    public fun call_inlined_twice(x: u64): u64 {
        let y = InlineCallee::inlined_add_one(x);
        InlineCallee::inlined_add_one(y)
    }

    public fun call_nested_inline(x: u64): u64 {
        InlineCallee::inlined_double_add_one(x)
    }
}

//# publish
module 0xCAFE::InlineCallee {
    // Public inline function adds one to input
    public inline fun inlined_add_one(x: u64): u64 {
        x + 1
    }

    // Public inline function that calls another inline function twice; tests multi-layer inlining
    public inline fun inlined_double_add_one(x: u64): u64 {
        let a = inlined_add_one(x);
        inlined_add_one(a)
    }
}

//# publish
module 0xCAFE::ExpressionTree {
    // Build an expression tree respecting operator precedence
    // For test: expression = 1 + 2 * 3
    // Correct precedence means multiply before add: 1 + (2 * 3) = 7

    // Enum to represent simple expression tree nodes
    enum Op has copy, drop {
        Add,
        Multiply
    }

    struct Expr has copy, drop {
        left: u64,
        op: Op,
        right: u64
    }

    // Evaluate expression tree
    public fun evaluate(e: Expr): u64 {
        match (e.op) {
            Op::Add => e.left + e.right,
            Op::Multiply => e.left * e.right,
        }
    }

    // Construct expression tree manually for 1 + (2 * 3)
    public fun build_expr(): Expr {
        let left = 1;
        let right = 2 * 3; // test precedence: multiplication happens before addition
        Expr {left, op: Op::Add, right}
    }

    // Build nested expression tree for (1 + 2) * 3: tests explicit precedence override
    public fun build_expr_override(): Expr {
        let left = 1 + 2;
        let right = 3;
        Expr {left, op: Op::Multiply, right}
    }

    // Compose complex expression: ((1 + 2) * (3 + 4))
    public fun build_complex_expr(): u64 {
        let left_expr = Expr {left: 1, op: Op::Add, right: 2};
        let right_expr = Expr {left: 3, op: Op::Add, right: 4};
        let left_val = evaluate(left_expr);
        let right_val = evaluate(right_expr);
        left_val * right_val
    }
}

//# run 0xCAFE::LintConfigModule::no_lint_example

//# run 0xCAFE::InlineCaller::call_inlined_once --args 41u64

//# run 0xCAFE::InlineCaller::call_inlined_twice --args 40u64

//# run 0xCAFE::InlineCaller::call_nested_inline --args 39u64

//# run 0xCAFE::ExpressionTree::evaluate --args 0xCAFE::ExpressionTree::Expr{left:1u64, op: 0xCAFE::ExpressionTree::Op::Add, right:6u64}

//# run 0xCAFE::ExpressionTree::build_expr

//# run 0xCAFE::ExpressionTree::build_expr_override

//# run 0xCAFE::ExpressionTree::build_complex_expr

// Featurres:
// a99471d2ea89cf76f0ccd0486eb6abcd: Configure your code with `#[skip(lint_name)]` attributes to customize lint enforcement according to your preferences.
// 3f5c63826c1b1169c8804295ff1fe53f: Test that inlined public functions can be called through multiple module boundaries and properly compose their inlining and execution results.
// 0ed81ed021c1455f3b7b6b2c52012423: Utilize the precedence values for parsing complex expressions correctly, especially when constructing or analyzing expression trees.
