// # publish
module 0xCAFE::ApplyFunction {
    /// A module to test function application.
    ///
    /// We test `apply` function which accepts a function as argument,
    /// and uses it to add two u64 numbers.
    /// Also tests friend visibility vs package visibility.
    use std::signer;

    /// Friend function: add two u64 values.
    /// Should only be callable inside this module or by friends.
    friend fun add_impl(a: u64, b: u64): u64 {
        a + b
    }

    /// Package-visible function: multiply two u64 values.
    /// Accessible only inside this module because package visibility restricts to this module.
    fun mul_impl(a: u64, b: u64): u64 {
        a * b
    }

    /// Apply function takes an adder function as an argument and applies it to 2 and 3.
    /// The adder function must be a friend function so that the function param must be friend visibility.
    /// We test passing add_impl via a closure in caller later.
    public fun apply<F: fun(u64, u64): u64>(f: F): u64 {
        f(2, 3)
    }

    /// Direct test function visible publicly,
    /// calls apply passing add_impl as the function argument.
    public fun runner(): u64 {
        apply(add_impl)
    }
}

// # run 0xCAFE::ApplyFunction::runner --signers 0xCAFE

// # publish
module 0xCAFE::PhantomDropTest {
    /// Test a struct with a phantom type parameter is droppable even if phantom type has no abilities.

    /// A phantom type with no abilities.
    struct NoAbilities {}

    /// A struct with phantom type parameter `Ph` and value `val`.
    /// It is marked `drop` ability explicitly to allow dropping.
    struct MyStruct<Ph> has drop, store {
        val: u64,
        phantom: Ph,
    }

    /// Make a value of MyStruct with phantom NoAbilities, return val + 1
    public fun make_and_drop(): u64 {
        let s = MyStruct<NoAbilities> {
            val: 10,
            phantom: NoAbilities {}
        };
        // `s` will be dropped at function exit, no error.
        s.val + 1
    }
}

// # run 0xCAFE::PhantomDropTest::make_and_drop --signers 0xCAFE

// # run
script {
    use 0xCAFE::ApplyFunction;
    use 0xCAFE::PhantomDropTest;
    use std::debug;

    fun main(account: signer) {
        // Test 1: apply function with add_impl inside ApplyFunction
        let res = ApplyFunction::runner();
        debug::print(&b"Result of apply(add): "[ ]);  // will print bytes vector
        debug::print(&Vector::from_u8(res as u8));  // cast to u8 (safe since 5 fits in u8)

        // Test 2: call friend function add_impl directly from this script should fail if uncommented
        // let friend_res = ApplyFunction::add_impl(10, 20); // Cannot call friend from script, so commented.

        // Test 3: Phantom drop test
        let drop_result = PhantomDropTest::make_and_drop();
        debug::print(&b"Phantom drop result: "[ ]);
        debug::print(&Vector::from_u8(drop_result as u8));
    }
}

// Featurres:
// 9a60461cd8d1410783c49e8d5141a05e: Test that the `apply` function correctly invokes a provided function to add two values.
// 2056f17708d282991858422ba732d384: Use 'friend' visibility for functions accessible only within the same crate or to friends, and distinguish it from package visibility.
// 47d4fe8be244f0f72a6a7df1ebe788c5: Verify that a struct with a phantom type parameter can be dropped even if the phantom type parameter has no abilities.
