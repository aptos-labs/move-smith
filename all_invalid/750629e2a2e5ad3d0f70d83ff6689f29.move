//# publish
module 0xCAFE::RefAssignment {
    struct Wrapper {
        val: u64,
    }

    // Returns a mutable reference to the val field inside Wrapper
    public fun get_val_ref(w: &mut Wrapper): &mut u64 {
        &mut w.val
    }

    // Complex: gets a reference, updates it, then asserts it's updated.
    public fun runner() {
        let mut w = Wrapper { val: 7 };
        {
            // Let's create a complex expression:
            let r = { 
                let tmp = &mut w;
                Self::get_val_ref(tmp)
            };
            *r = 42;
        };
        let updated = w.val;
        // We should see w.val is now 42
        // Returns w.val for inspection
        updated
    }
}
//# run 0xCAFE::RefAssignment::runner

//# publish
module 0xCAFE::DestructuringTest {
    struct Foo {
        x: u8,
        y: u8,
        z: u16,
    }
    public fun sum_fields(f: Foo): u16 {
        let Foo { x, y, z } = f;
        // x and y are u8, promote to u16 for sum
        (x as u16) + (y as u16) + z
    }
    public fun runner(): u16 {
        let tuple_f = Foo { x: 2, y: 3, z: 100 };
        let total = Self::sum_fields(tuple_f);
        total
    }
}
//# run 0xCAFE::DestructuringTest::runner

//# publish
module 0xCAFE::InlineSpecFun {
    // Example with inline specification functions

    /// Inline function, always returns 77.
    public inline fun inline_constant(): u64 {
        77
    }

    /// Inline function to add two numbers.
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    /// Test calling inline functions
    public fun runner(): u8 {
        let val = Self::inline_constant();
        let sum = Self::inline_add(10, 5);
        // Just return the sum for simplicity
        sum
    }
}
//# run 0xCAFE::InlineSpecFun::runner

// Featurres:
// 4348616829064428dea6a8d9102a57dd: Test that an assignment to a mutable reference returned by a function (potentially after sequencing with semicolons and blocks) correctly updates the underlying variable, even when the reference is the result of a complex expression.
// 63eaf0ea8957190ee5813e1f280549cf: Test that destructuring a struct with nested expressions correctly assigns values and computes the sum of its fields.
// 0826263e309bbe8ed6cee2b0c62077ac: Create inline specification functions by setting the 'for_inline' parameter, resulting in functions with 'inline_' prefix in their names.
