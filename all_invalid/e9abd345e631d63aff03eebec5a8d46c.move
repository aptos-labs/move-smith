// This transactional test exercises visibility modifiers, variable shadowing and borrowing/moving in branches,
// and inline functions with closures.

//# publish
module 0xCAFE::Visibility {
    fun internal_fun(): u64 {
        1
    }

    public fun public_fun(): u64 {
        2
    }

    friend(friend_address) fun friend_fun(): u64 {
        3
    }

    // friend_address is 0xBEEF here for demo (cannot alias, so use constant inline)
}

//# publish
module 0xCAFE::Branching {
    /// A function that borrows, moves, and shadows variables inside branches,
    /// to stress borrowing/moving rules and shadowing.
    public fun branch_shadow_move(mut x: u64): u64 {
        let mut y = x;
        if y > 10 {
            // Shadow y
            let y = y + 10;
            // Move y into a new variable
            let z = y;
            z
        } else {
            // Borrow y as mutable and reassign
            let y_ref = &mut y;
            *y_ref = *y_ref + 5;
            y
        }
    }

    /// Runner function for tests without args
    public fun runner(): u64 {
        let a = branch_shadow_move(5);
        let b = branch_shadow_move(20);
        a + b // returns 5+5 + (20+10) = 10 + 30 =40
    }
}
//# run 0xCAFE::Branching::runner

//# publish
module 0xCAFE::InlineTest {
    /// inline function `foo` that takes a generic lambda `g` and two arguments,
    /// calls `g` on them and returns the result.
    public inline fun foo<T1, T2, R>(g: &fun(&T1, &T2): R, x: T1, y: T2): R {
        g(&x, &y)
    }

    /// A function `test` that defines a lambda that adds two u64 numbers and
    /// calls `foo` with that lambda and two arguments.
    public fun test(): u64 {
        let add = move |a: &u64, b: &u64| -> u64 { *a + *b };
        foo(&add, 10u64, 20u64)
    }
}
//# run 0xCAFE::InlineTest::test

//# run
script {
    use 0xCAFE::Visibility;
    use 0xCAFE::Branching;
    use 0xCAFE::InlineTest;

    fun main() {
        // Call public function
        let a = Visibility::public_fun();

        // Call internal function from within module by workaround is not possible outside the module,
        // so we skip direct call to internal in script.

        // Call branch_shadow_move through runner
        let b = Branching::runner();

        // Call inline test function
        let c = InlineTest::test();

        // Just ignore results - no assertions needed per instructions
        let _ = (a, b, c);
    }
}

// Featurres:
// e53ba031cf98586b83ffbeda13dc757c: Define functions with visibility modifiers, defaulting to internal visibility.
// 7b6b733a7e5e526b8654963b029a9e0b: Test that borrowing and moving of variables within different branches of a control flow statement handles variable shadowing and reassignment correctly.
// a21f70c31d56c0c8862aaa45671c6d95: Test that the inline function `foo` correctly calls the provided lambda `g` with the given arguments and returns its result in the `test` function.
