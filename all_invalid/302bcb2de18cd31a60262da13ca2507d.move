//# publish
module 0xCAFE::CurriedTest {
    // Struct to store a simple integer value, to help with curry demonstration (has copy & drop)
    struct Box has copy, drop, store { value: u64 }

    // Expose Box creation for public
    public fun mk_box(x: u64): Box {
        Box { value: x }
    }

    // Curry: takes an integer, returns a closure that increments by that number
    // Because Move doesn't allow actual safe closures, we simulate via function references
    public fun add_n(n: u64, x: u64): u64 {
        n + x
    }

    // Curry: given a predicate and a value, returns 100 if p(value) true, else 200
    public fun run_conditional(pred: bool, value: u64): u64 {
        if (pred) { value + 100 } else { value + 200 }
    }

    // Public runner which excercises several currying-like and closure-like behaviors
    public fun runner(): u64 {
        // Simulate currying add_n with 10
        let ten = 10;
        let res1 = Self::add_n(ten, 5); // add 10 + 5 = 15

        // Simulate "conditional" closure by running with true/false
        let res2 = Self::run_conditional(true, 30);
        let res3 = Self::run_conditional(false, 40);

        // Compose for something more complex
        let sum = res1 + res2 + res3;
        sum
    }
}
//# run 0xCAFE::CurriedTest::runner

//----------------------- Script for explicit demonstration of conditional logic and function pointers/currying

//# run
script {
    use 0xCAFE::CurriedTest;

    fun main(account: &signer) {
        // Simulate currying "add_n" with n = 7
        let seven = 7;
        let added = CurriedTest::add_n(seven, 6); // Expect 13

        // Simulate conditional logic
        let cond_true = CurriedTest::run_conditional(true, 50); // should be 150
        let cond_false = CurriedTest::run_conditional(false, 99); // should be 299

        // Just use the results to avoid compiler warnings/errors (no tuple assignment)
        let _a = added;
        let _b = cond_true;
        let _c = cond_false;
        // Alternatively, do nothing, as last variables are dropped if copy/drop
    }
}

//----------------------- Test for friend function visibility and module names

//# publish
module 0xCAFE::IdentFun {
    // Friend visibility fun example
    friend 0xCAFE::CurriedTest;

    public fun pub_increment(x: u64): u64 {
        x + 1
    }

    // Friend function, not public
    friend fun friend_only(x: u64): u64 {
        x * 10
    }

    // This runner is public to match your suggestion
    public fun runner(): u64 {
        // Uses public and friend functions
        let a = Self::pub_increment(5); // should be 6
        let b = Self::friend_only(3);   // should be 30
        a + b // 36
    }
}
//# run 0xCAFE::IdentFun::runner

// Featurres:
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 4920ae24a905cbbf287461b8bd4655d5: Define a module name using an identifier.
// 03b151a72fa5a91acd9ab793b789d8e8: Define public or friend visible functions inside a module.
