//# publish
module 0xBADD::ClosureTypeConstraints {
    use std::vector;

    // Struct with a generic type parameter constrained to be a number
    struct NumericHolder<T: copy + drop + store> has copy, drop {
        value: T
    }

    // Function to create a NumericHolder for u8
    public fun create_u8_holder(val: u8): NumericHolder<u8> {
        NumericHolder { value: val }
    }

    // Function to accept a lambda (closure) and apply it to a value
    public fun apply_closure<T: copy + store>(f: |T|T, val: T): T {
        f(val)
    }

    // Function that returns true if the name adheres to rules (only alphanumeric, no reserved words)
    public fun is_valid_name(name: vector<u8>): bool {
        let len = vector::length(&name);
        let index: u64 = 0;
        while (index < len) {
            let c = *vector::borrow(&name, index);
            if (!(c >= 0x30 && c <= 0x39) || !(c >= 0x41 && c <= 0x5A) || !(c >= 0x61 && c <= 0x7A)) {
                // If the character is not a digit, uppercase letter, or lowercase letter
                return false;
            }
            index = index + 1;
        };
        true
    }

    // Nested closure usage: check constraints and apply nested lambdas
    public fun nested_closure_test(x: u8): u8 {
        let outer_lambda: |u8|u8 = |a: u8| {
            let inner_lambda: |u8|u8 = |b: u8| a + b;
            inner_lambda(x)
        };
        outer_lambda(x)
    }
}


//# run 0xBADD::ClosureTypeConstraints::create_u8_holder --args 42u8


//# run 0xBADD::ClosureTypeConstraints::apply_closure --signers 0xAAAA --args 10u8


//# run 0xBADD::ClosureTypeConstraints::nested_closure_test --args 7u8


//# run 0xBADD::ClosureTypeConstraints::is_valid_name --args b"ValidName123"
