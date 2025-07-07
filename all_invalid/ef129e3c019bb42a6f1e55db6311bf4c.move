//# publish
module 0xCAFE::GenericTypes {
    use std::signer;

    struct Container<T> has copy, drop, store {
        value: T
    }

    public fun create<T>(val: T): Container<T> {
        Container<T> { value: val }
    }

    public fun get_value<T>(container: &Container<T>): &T {
        &container.value
    }

    public fun set_value<T>(container: &mut Container<T>, val: T) {
        container.value = val;
    }

    // A function to help transactional tests call generic functions with simple arguments
    public fun run_create_u8(val: u8): Container<u8> {
        create<u8>(val)
    }
}

//# run 0xCAFE::GenericTypes::run_create_u8 --args 42u8

//# publish
module 0xCAFE::SpecExample {
    spec module {
        invariant true;
        global spec static SOME_VALUE: u64 = 12345;
    }

    public fun get_some_value(): u64 {
        12345u64
    }
}

//# run 0xCAFE::SpecExample::get_some_value

//# publish
module 0xCAFE::SpecPureCheck {
    use std::string;
    use std::error;

    spec module {
        // This spec tries to call impure function `string::length`
        // which should be illegal.
        // We'll simulate the impure call detection by reporting an error.
        #[pure]
        fun illegal_pure_function(): u64 {
            report_error(42u64);
            0
        }
    }

    public fun call_report_error() {
        // This function calls the spec function that calls report_error
        // raising an error to test the VM/compiler specification error handling.
        error::abort_code(42);
    }
}

//# run 0xCAFE::SpecPureCheck::call_report_error

// Featurres:
// d6bfc12445a3e71a2f3add7f4a83133f: Use type parameters to define generic types and functions that can operate on various data types.
// af2ea595efbddd49d03abf44a9cccfec: Initialize global spec variables with an initial value using '='.
// d1fe34e1251d69a8bf49bb429293afee: Use the `report_error` function to generate an error when a specification expression tries to use an impure construct.
