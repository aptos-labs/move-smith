// NOTE: address 0xCAFE used as test address as required.

//# publish
module 0xCAFE::CycleA {
    use std::vector;

    // Testing a cycle: CycleA depends on CycleB
    public fun call_b(): u8 {
        0xCAFE::CycleB::some_function()
    }

    // Runner to invoke call_b (which depends on CycleB)
    public fun runner() {
        let x = call_b();
        let _ = x;
    }
}
//# publish
module 0xCAFE::CycleB {
    // CycleB depends on CycleC
    public fun some_function(): u8 {
        0xCAFE::CycleC::yet_another_function()
    }

    public fun runner() {
        let x = some_function();
        let _ = x;
    }
}
//# publish
module 0xCAFE::CycleC {
    // CycleC depends on CycleA to form minimal cycle (A -> B -> C -> A)
    public fun yet_another_function(): u8 {
        0xCAFE::CycleA::call_b()
    }

    public fun runner() {
        let x = yet_another_function();
        let _ = x;
    }
}

//# run 0xCAFE::CycleA::runner
//# run 0xCAFE::CycleB::runner
//# run 0xCAFE::CycleC::runner


//# publish
module 0xCAFE::BlockScopes {
    /// This function tests block expressions with let bindings,
    /// variable shadowing, and pattern destructuring.
    public fun test_block_scopes(): u64 {
        let mut total: u64 = 0;

        // Outer scope variable
        let x: u64 = 10;

        // Block expression with shadowing
        let y = {
            let x = x + 5; // shadows outer x
            let (a, b) = (x, x * 2);
            total = total + a + b;
            a * b
        };

        // total should be 15 + 30 = 45
        total = total + y; // y = 15 * 30 = 450

        // Nested block with pattern matching (tuple unpacking) and shadowing total
        let final_val = {
            let (c, total) = (100, total + 50); // shadows outer total
            total + c // 500 + 100 = 600
        };

        return final_val + total; // 600 + 495 = 1095
    }

    // Runner function calls the above function (no args)
    public fun runner() {
        let res = test_block_scopes();
        let _ = res;
    }
}
//# run 0xCAFE::BlockScopes::runner


//# publish
module 0xCAFE::InlineWarn {
    // Private field
    struct Data has copy, drop, store {
        value: u64,
    }

    // Private inline function accessing private struct field
    // This should NOT trigger warnings (accessing private member inside same module)
    inline fun private_inline_access(data: &Data): u64 {
        data.value
    }

    // Public inline function accessing private struct field
    // This should EMIT a warning as public inline accessing private members is discouraged
    public inline fun public_inline_access_private(data: &Data): u64 {
        data.value
    }

    // Public non-inline function accessing private struct field (no warnings expected)
    public fun public_noninline_access_private(data: &Data): u64 {
        data.value
    }

    // Create a Data object
    public fun create_data(): Data {
        Data { value: 42 }
    }

    // Runner function to call the functions above (no args)
    public fun runner() {
        let d = create_data();

        let x = private_inline_access(&d);
        let y = public_inline_access_private(&d);
        let z = public_noninline_access_private(&d);

        let _ = (x, y, z);
    }
}
//# run 0xCAFE::InlineWarn::runner

// Featurres:
// 74454629fd6094069b32ea18cde73d14: Analyze dependency graphs to identify minimal cycles in module references
// b8a9c1c10b3e492d4bf690d9499d4e07: Use block expressions with let-bindings and pattern matching that can introduce new variable scopes and potentially modify variables within those scopes.
// 2bdc3075fded808d6ba722a57ae47c12: Emit warnings when non-private functions marked as inline access private or restricted members within the same module.
