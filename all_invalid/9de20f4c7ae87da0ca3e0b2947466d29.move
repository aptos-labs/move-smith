// # publish
module 0xCAFE::PatternAssignLangVerTest {
    use std::debug;
    use std::version;

    /// A generic struct with one type parameter T.
    struct Container<T> has store, key {
        value: T,
    }

    /// A struct with two type parameters.
    struct Pair<A, B> has store {
        first: A,
        second: B,
    }

    /// A function that demonstrates assignments by pattern unpacking and binding.
    /// It assigns to some pattern variables, then emits debug prints of values.
    public fun test_assignments() {
        // Unpack a tuple into two variables and assign to them
        let (mut x, mut y) = (1u64, 2u64);
        x = x + 1;
        y = y + 2;

        // Unpack a struct value and assign
        let p = Pair { first: 10u8, second: 20u16 };
        let Pair { first: mut f, second: mut s } = p;
        f = f + 2;
        s = s + 3;

        // Using Container struct with a type param
        let mut container = Container<u8> { value: 5 };
        container.value = 10;

        // Emitting debug prints to record final values (no assertions needed)
        debug::print(&x);
        debug::print(&y);
        debug::print(&(f as u64));
        debug::print(&(s as u64));
        debug::print(&(container.value as u64));
    }

    /// A function that requires a minimum language version 6 or above.
    /// If version is insufficient, it aborts at runtime.
    public fun ensure_version() {
        version::require_language_version(6);
        // If the check passes, just do a dummy increment to test code flow
        let mut v = 0u8;
        v = v + 1;
        debug::print(&v);
    }

    /// Runner function without arguments testing both features: assign and version
    public fun run_test() {
        test_assignments();
        ensure_version();
    }
}
// # run 0xCAFE::PatternAssignLangVerTest::run_test --signers 0xCAFE


// # run
script {
    use 0xCAFE::PatternAssignLangVerTest;

    fun main(account: signer) {
        // Call the runner function to invoke tests inside the module
        PatternAssignLangVerTest::run_test();
    }
}

// Featurres:
// 5fc7c03fb100cc78231369da3d433efb: Perform assignments to variables bound in patterns and have the compiler detect which variables are assigned (thus, potentially modified).
// eb17b97aaa90d0d1a641c884cfa89cca: Use the 'require_language_version' function to enforce that a certain feature or syntax is only used when the language version meets a minimum requirement.
// 18fcecd82c824bb4e2905d9002af0910: Create struct types with type parameters and instantiate them with specific type arguments.
