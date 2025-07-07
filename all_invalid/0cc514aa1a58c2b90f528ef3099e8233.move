
//# publish
module 0xBADD::TestAbilitiesAndDestructuring {
    // You NEVER try to use this 0xBADD::TestAbilitiesAndDestructuring
    // It is only an example

    // Struct with abilities: copy, drop, store, key
    struct ResourceWithAbilities has copy, drop, store, key {
        a: u8,
        b: u8,
    }

    // Struct with only copy and drop, no store
    struct NonStorable has copy, drop {
        c: u16,
    }

    // Function returning multiple values as tuple
    public fun return_tuple(x: u16): (u16, u16, u16) {
        (x + 1, x + 2, x + 3)
    }

    // Function demonstrating destructuring, re-binding, and mutable assignment
    public fun test_destructuring_and_rebinding() {
        // Instantiate a resource with abilities
        let res = ResourceWithAbilities {a: 10, b: 20};
        
        // Destructure into separate variables
        let (a_val, b_val) = res;

        // Now, re-bind `res` to a new value with modified fields
        // Note: Since `res` is a resource, we can't modify it directly, but for test we use a local variable
        let res = ResourceWithAbilities {a: a_val + 1, b: b_val + 1};
        
        // Access fields after re-binding
        let a_new = res.a;
        let b_new = res.b;

        // Destructuring with mutable assignment (simulate—Move semantics in Move)
        // Correct syntax: use parentheses without 'mut' inside
        let (a_val2, b_val2) = (res.a, res.b);
        // Mutable reassignment of variables
        let a_val2 = a_val2;
        let b_val2 = b_val2;
        a_val2 = a_val2 + 1;
        b_val2 = b_val2 + 1;
    }

    // Helper function to call return_tuple and destructure the result
    public fun call_and_destructure(x: u16): u16 {
        let (t1, t2, t3) = return_tuple(x);
        // Use destructured values (here just return t2 for simplicity)
        t2
    }
}



//# run 0xBADD::TestAbilitiesAndDestructuring::test_destructuring_and_rebinding --signers 0xCAFE



//# run 0xBADD::TestAbilitiesAndDestructuring::call_and_destructure --signers 0xCAFE --args 7u16


// Features:
// e50f7ebef96acd475a77c80dd2e3b935: Annotate structs or resources with abilities such as Copy, Drop, Store, or Key using 'has' modifiers.
// 1300979e3b9b7c757af6fe6978a1cea6: Declare functions that return multiple values as a tuple
// 231fb386dc3fd9532a76e769bff5f658: Test destructuring a struct while allowing re-binding and mutable assignment of variables in the struct literal expression.
