// Transactional Test for Move Compiler and VM
// This test focuses on: patterns in rule expressions, error handling for types, and index expressions.

//# publish
module 0xA1::PatternIndexModule {
    use std::vector;

    // Enum demonstrating pattern matching (with tuple-struct style variants for matching parts)
    enum Expr {
        Num(u64),
        IndexExpr(Box<Expr>, Box<Expr>), // two sub-expressions for index
        Err,
    }

    // Example function: pattern match to extract parts of IndexExpr.
    public fun pattern_match(e: &Expr): u64 {
        match e {
            Expr::Num(n) => n,
            Expr::IndexExpr(box Expr::Num(left), box Expr::Num(right)) => left + right,
            // Unexpected type: error handling case
            _ => 0,
        }
    }

    // Demonstrate index expression with two sub-expressions and covering error cases.
    public fun indexer(exprs: vector<Expr>): u64 {
        // Try to get: exprs[0] as main expr, exprs[1] as index
        let main_expr = vector::borrow(&exprs, 0);
        let index_expr = vector::borrow(&exprs, 1);

        let ix_expr = Expr::IndexExpr(
            box::new(main_expr.clone()),
            box::new(index_expr.clone()),
        );
        pattern_match(&ix_expr)
    }

    // Runner function to call from the test
    public fun runner(account: &signer) {
        let exprs = vector::empty<Expr>();
        vector::push_back(&mut exprs, Expr::Num(5));
        vector::push_back(&mut exprs, Expr::Num(42));
        let res = indexer(exprs); // Should sum: 5 + 42 = 47
        // (No side effect, just exercises VM)
        let _ = res;
    }
}

//# run 0xA1::PatternIndexModule::runner --signers 0xA1

// Now, let’s test a transaction script variant.
//# run
script {
    use 0xA1::PatternIndexModule;
    fun main(account: &signer) {
        PatternIndexModule::runner(account);
    }
}