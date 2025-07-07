
//# publish
module 0xCAFEBABE::TupleAndMatchTest {
    use std::vector;

    // Enum with nested enum variants, with drop
    enum DropEnum has drop {
        A,
        B,
        C {
            inner: InnerEnum
        }
    }

    enum InnerEnum has copy, drop {
        X,
        Y,
        Z {
            flag: bool
        }
    }

    // Struct to test tuple assignment with side effects
    struct SideEffects has copy, drop {
        val1: u8,
        val2: u8,
    }

    // Function to mutate a global resource for side effect
    struct GlobalCounter {
        count: u8,
    }

    public fun increment_counter(counter: &mut GlobalCounter) {
        counter.count = counter.count + 1;
    }

    // Function to test tuple assignment order
    public fun test_tuple_assignment(counter: &mut GlobalCounter): (u8, u8) {
        // pre-increment side effect
        increment_counter(counter);
        // tuple assignment: evaluate right to left (but in Move, evaluation order is left to right)
        let (a, b) = (counter.count, counter.count);
        (a, b)
    }

    // Pattern matching function with nested enums
    public fun match_enum(e: DropEnum): u8 {
        match e {
            DropEnum::A => 1,
            DropEnum::B => 2,
            DropEnum::C { inner } => {
                match inner {
                    InnerEnum::X => 10,
                    InnerEnum::Y => 20,
                    InnerEnum::Z { flag } => if (flag) { 100 } else { 200 },
                }
            }
        }
    }

    // Test wildcard pattern usage with *)
    public fun wildcard_pattern(): u8 {
        match DropEnum::A {
            DropEnum::A => 1,
            DropEnum::B => 2,
            DropEnum::C { inner = * } => 255, // wildcard pattern
        }
    }

    // Runner function to perform tests
    public fun run_tests() {
        // Initialize global counter resource
        move_to<GlobalCounter>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer::borrow_global<signer::Signer>(&signer::address_of(&signer)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

        // Create enum instance for testing pattern matching
        let nested_enum = DropEnum::C { inner: InnerEnum::Z { flag: true } };
        let match_result = match_enum(nested_enum);
        // similar tests can be performed here

        // Test wildcard match
        let wildcard_result = wildcard_pattern();
    }
}


//# run 0xCAFEBABE::TupleAndMatchTest::run_tests


// Featurres:
// 262331dd465223cf1168aefcba6ed961: Test that tuple assignment correctly evaluates right-hand side expressions from left to right, ensuring side effects (like variable mutations) happen in the expected order.
// 4bb22676b955592fc645efbd305c704d: Test that the pattern matching correctly handles nested enum variants involving enums with drop semantics.
// f67ed0b98509b02f64e19d8afacf02a3: Use '*' as a wildcard pattern in places where a name is expected (such as in pattern matching or bindings).
