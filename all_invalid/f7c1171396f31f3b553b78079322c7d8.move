// SPDX-License-Identifier: Apache-2.0

// Transactional test for Move compiler and VM
// Address used: 0xCAFE

//# publish
module 0xCAFE::AbilityTest {
    // This module tests proper handling of abilities and selective function visibility

    use std::signer;

    // Struct with all abilities: copy, drop, store, key (key for global storage)
    struct AllAbilities has copy, drop, store, key {
        a: u8,
        b: u64,
    }

    // Struct with limited abilities (no copy, no drop)
    struct LimitedAbilities has store {
        x: u8,
        y: u64,
    }

    // Public function that only accepts AllAbilities type (check ability constraints on params)
    public fun consume_all(a: AllAbilities) {
        // dummy body to consume the argument
        let _ = a.a + (a.b as u8);
    }

    // Package visibility function (only callable inside this module or package)
    fun package_function() {
        // Just a no-arg function to test package visibility
    }

    // Public function that calls the package function (tests proper visibility call)
    public fun call_package() {
        package_function();
    }

    // Inline public function, should be excluded from bytecode generation (test 3)
    public inline fun inline_helper(x: u8): u8 {
        x + 1
    }

    // Public function which calls the inline function and returns result to check in runtime
    public fun run_inline(x: u8): u8 {
        inline_helper(x)
    }

    // Function with &signer argument (ability test with signer)
    public fun signer_accept(s: &signer) {
        let addr = signer::address_of(s);
        // dummy use
        let _ = addr;
    }

    // Runner function with no args to exercise VM and compiler fully
    public fun runner() {
        let a = AllAbilities { a: 42u8, b: 1000u64 };
        consume_all(a);

        call_package();

        // call signer_accept will be tested with signers in runner
    }
}
//# run 0xCAFE::AbilityTest::runner --signers 0xCAFE

//# run 0xCAFE::AbilityTest::run_inline --args 100u8
//# run 0xCAFE::AbilityTest::signer_accept --signers 0xCAFE

//# publish
module 0xCAFE::VisibilityTest {
    // This module tests package visibility and direct calls across modules

    // Package function, only callable inside this module/package
    fun package_only_function(): u64 {
        999u64
    }

    // Public function calling the package function internally
    public fun call_package_only(): u64 {
        package_only_function()
    }

    // Public function calling package_only_function via friend pattern could be tested here,
    // but for simplicity just test the direct call inside module.

    // Runner function to test internal calls
    public fun runner() {
        let val = call_package_only();
        let _ = val;
    }
}
//# run 0xCAFE::VisibilityTest::runner

//# publish
module 0xCAFE::BytecodeGenTest {
    // This module tests bytecode generation for all non-inline functions
    // Define several functions to ensure the compiler generates bytecode for each

    // Simple struct for test, with copy and store for use in functions
    struct TestData has copy, store {
        x: u64,
        y: u64,
    }

    public fun simple_function(): u64 {
        123u64
    }

    public fun complex_function(t: TestData): u64 {
        let sum = t.x + t.y;
        sum
    }

    public inline fun inline_function(x: u64): u64 {
        x * 2
    }

    // Runner to call all functions except inline (which is inlined and no bytecode)
    public fun runner() {
        let val1 = simple_function();
        let data = TestData { x: 10u64, y: 20u64 };
        let val2 = complex_function(data);
        let val3 = inline_function(val2); // call inline function to ensure it's tested in VM

        let _ = val1 + val2 + val3;
    }
}
//# run 0xCAFE::BytecodeGenTest::runner

// Featurres:
// f1c17907be8ea222f783a0a1ab20a0a7: Encourage proper handling of abilities via ability checks on types and function signatures.
// a551f36d6b7299492bf1b78bc0c8db28: Call functions with package visibility restricted to certain contexts
// af34c34d028cde0ffe036333b37d9cfd: Generate bytecode for each non-inline function targeted for compilation.
