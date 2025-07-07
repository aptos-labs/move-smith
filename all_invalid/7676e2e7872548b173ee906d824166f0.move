//# publish
module 0xCAFE::NestedBlocks {
    public fun nested_scopes_test(): u8 {
        let x = 1;
        {
            let x = x + 1;
            let _ = x; // should be 2 in this inner scope
        };
        {
            let x = x + 2;
            let _ = x; // should be 3 in this other inner scope
        };
        x
    }

    public fun ast_simplify_simulation(active: bool): u8 {
        if (active) {
            let a = 5u8;
            // Partially simplified block that does not eliminate code, simulate by a no-op addition
            let a = a + 0;
            a
        } else {
            0u8
        }
    }

    public fun abort_with_code(): u8 {
        abort 1000;
        1u8
    }
}

//# run 0xCAFE::NestedBlocks::nested_scopes_test

//# run 0xCAFE::NestedBlocks::ast_simplify_simulation --args true

//# run 0xCAFE::NestedBlocks::abort_with_code

//# script
script {
    use 0xCAFE::NestedBlocks;

    fun main() {
        let _ = NestedBlocks::nested_scopes_test();
        let _ = NestedBlocks::ast_simplify_simulation(true);
        // This will abort with code 1000
        NestedBlocks::abort_with_code();
    }
}