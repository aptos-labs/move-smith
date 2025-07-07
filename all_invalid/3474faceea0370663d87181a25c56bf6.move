//# publish
module 0x1::BinopAndExpList {

    /// Performs some binary operations and evaluates an expression list
    public fun binop_and_exp_list(): u64 {
        let a = 10;
        let b = 20;

        // Binary operations
        let sum = a + b;          // 30
        let diff = b - a;         // 10
        let prod = a * b;         // 200
        let div = b / a;          // 2

        // Expression list evaluation with custom callback
        let exprs = [1u64, 2, 3, 4, 5];

        fun parse_item(x: u64): u64 {
            x * 2
        }

        let mut res = 0;
        let len = Vector::length(&exprs);
        let mut i = 0;
        while (i < len) {
            let val = *Vector::borrow(&exprs, i);
            res = res + parse_item(val);
            i = i + 1;
        };
        sum + diff + prod + div + res
    }

    /// Runner function callable without arguments
    public fun run(): u64 {
        binop_and_exp_list()
    }
}
//# run 0x1::BinopAndExpList::run

//# publish
module 0x1::TestAttributeConflict {

    // Attempt to define a function with both #[test] and #[test_only] attributes
    // to produce compile-time errors.

    #[test]
    #[test_only]
    public fun conflict_function(): u64 {
        42
    }

    // Runner to call conflict_function, just to have a runner
    public fun run(): u64 {
        conflict_function()
    }
}
//# run 0x1::TestAttributeConflict::run