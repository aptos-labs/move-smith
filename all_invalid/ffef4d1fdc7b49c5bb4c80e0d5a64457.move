// Test transactional script and modules

//------------------------------
//# publish
module 0xCAFE::ExprArgs {
    use std::signer;
    use std::vector;

    // Test function which takes a u8, a bool, and a vector<u64>
    public fun takes_exprs(a: u8, b: bool, v: vector<u64>) {
        assert!(a == 44, 1);
        assert!(b == true, 2);
        assert!(vector::length(&v) == 3, 3);
        assert!(vector::borrow(&v, 1) == &11, 4);
    }

    // Helper runner so we can call it from a test
    public fun run_test() {
        let x = 41u8 + 1u8 + 2u8;
        let y = !false;
        let z = vector::empty<u64>();
        vector::push_back(&mut z, 9);
        vector::push_back(&mut z, 11);
        vector::push_back(&mut z, 21 - 9 + 0);
        Self::takes_exprs(x, y, z);
    }
}
//# run 0xCAFE::ExprArgs::run_test --signers 0xCAFE

//-------------------------------
//# publish
module 0xCAFE::IterateLValues {
    use std::vector;

    // A function that doubles a value and pushes into a vector
    public fun process_each(v: &mut vector<u64>, x: &u64) {
        vector::push_back(v, 2 * *x);
    }

    // Runner: iterates over a vector and processes each element
    public fun run_iterate() {
        let input = vector::empty<u64>();
        vector::push_back(&mut input, 10);
        vector::push_back(&mut input, 15);
        vector::push_back(&mut input, 3);

        let output = vector::empty<u64>();
        let i = 0;
        let len = vector::length(&input);
        while (i < len) {
            let val_ref = vector::borrow(&input, i);
            Self::process_each(&mut output, val_ref);
            i = i + 1;
        };
        // output vector now contains [20, 30, 6]
        assert!(vector::length(&output) == 3, 77);
        assert!(*vector::borrow(&output, 0) == 20, 78);
        assert!(*vector::borrow(&output, 1) == 30, 79);
        assert!(*vector::borrow(&output, 2) == 6, 80);
    }
}
//# run 0xCAFE::IterateLValues::run_iterate --signers 0xCAFE

//-------------------------------
//# publish
module 0xCAFE::AbortExpr {
    // Just aborts with a custom code
    public fun abort_with_dynamic_code(x: u8, y: u8) {
        if (x > y) {
            abort (x * 10 + y);
        }
    }

    public fun run_abort() {
        // will trigger abort(56)
        Self::abort_with_dynamic_code(5, 1);
    }
}
//# run 0xCAFE::AbortExpr::run_abort --signers 0xCAFE

//--------------------------------
//# run
script {
    use std::signer;
    use 0xCAFE::ExprArgs;
    use 0xCAFE::IterateLValues;
    use 0xCAFE::AbortExpr;

    fun main(s: &signer) {
        ExprArgs::run_test();
        IterateLValues::run_iterate();
        // Let's catch the abort of AbortExpr and continue for demo
        AbortExpr::abort_with_dynamic_code(2, 2); // doesn't abort
        AbortExpr::abort_with_dynamic_code(9, 4); // aborts with code 94
    }
}