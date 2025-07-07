// Transactional test to cover:
// 1. Detecting target/dependency path collisions
// 2. Block expressions using { ... }
// 3. Nested #[test(...)] attributes

// (1) Target/Dependency Path Overlap
// We'll simulate this by publishing two modules in the same address with the same name in two steps. 
// The Move compiler should reject the publish if a module of that name/address is already present.

//# publish
module 0xCAFE::CollisionModule {
    public fun hello(): u8 { 42 }
}

//# publish
module 0xCAFE::CollisionModule {
    // identical or duplicate definition to simulate path collision
    public fun hello(): u8 { 99 }
}
// (In actual aptos-move, this will cause a redeclaration/path collision error).

// (2) Block expressions
//# publish
module 0xCAFE::BlockExpr {
    public fun block_demo(): u64 {
        let a = 10;
        let b = 5;
        // Block expression that computes a + b + 1
        let c = {
            let x = a + b;
            x + 1
        }; // c should be 16
        c
    }
}

//# run 0xCAFE::BlockExpr::block_demo

// (3) Nested test attributes

//# publish
module 0xCAFE::TestAttr {
    use std::test;

    /// Top-level grouping for tests
    #[test]
    public fun test_arith() {
        // Nested test grouping: addition tests
        #[test(name = "addition_tests")]
        {
            #[test(only)]
            fun add_one() { let _a = 1 + 1; }
            #[test(should_fail)]
            fun fail_test() { assert(false, 42); }
        }

        // Nested test grouping: multiplication tests
        #[test(name = "multiplication_tests")]
        {
            #[test(only)]
            fun mul_one() { let _b = 2 * 3; }
        }
    }

    public fun run() { /* does nothing, there for run command demo */ }
}

//# run 0xCAFE::TestAttr::run --signers 0xCAFE

//# run 0xCAFE::TestAttr::test_arith --signers 0xCAFE