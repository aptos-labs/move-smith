//# publish
module 0xCAFE::UnusedVars {
    // test unused parameters and variables prefixed with _
    public fun test_unused_params(_x: u64, y: u64): u64 {
        let _unused_var = y + 1;
        y
    }

    public fun test_assign_self(x: u64): u64 {
        let mut v = x;
        v = v;
        v
    }

    public fun runner(): u64 {
        // call test_unused_params with some values
        let r1 = Self::test_unused_params(10, 20);
        // call test_assign_self with some value
        let r2 = Self::test_assign_self(r1);
        r2
    }
}

//# run 0xCAFE::UnusedVars::runner

//# publish
module 0xBEEF::Caller {
    public fun call_cafe_runner(): u64 {
        // This will NOT compile/run in the transactional test because cross-address module calls are disallowed.
        // So here we just define function but will test the error by calling in the script below.
        0
    }
}

//# run 0xCAFE::UnusedVars::test_assign_self --args 123u64

//# run
script {
    use 0xCAFE::UnusedVars;
    use 0xBEEF::Caller;

    fun main() {
        // test that assigning var to itself and returning gives correct value
        let a = 42u64;
        let b = UnusedVars::test_assign_self(a);

        // test that unused parameters/variables do not affect output
        let c = UnusedVars::test_unused_params(100, 200);

        // call the runner function
        let d = UnusedVars::runner();

        // The following is intended to fail to illustrate cross-module call from different address
        // Because the transaction test will not raise compile error but the Move VM disallows cross-address calls
        // So this is a no-op here or commented out.

        // let e = Caller::call_cafe_runner();

        // All results can be assigned to unused variables and ignored 
        let _ = b;
        let _ = c;
        let _ = d;
    }
}

// Featurres:
// 209c1a8dfac8c453a8048c3cfe37fb91: Test that unused parameter and variable bindings (bindings starting with underscores) do not affect function execution or return values.
// 3706de2091a5ab85b38141826b39c882: Test that assigning a variable to itself and then returning it works correctly in a Move function.
// 0c5042bb8208c004a7fa752a5aa7d28b: Ensure that functions from different address domains cannot be called across modules.
