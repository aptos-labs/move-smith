//# publish
module 0xCAFE::AbilitiesExample {
    // Declaring a struct with abilities using postfix semicolon syntax
    struct HasKeyAbility has key;

    // Declaring a struct with multiple abilities
    struct HasCopyDropAbility copy, drop;

    // A native function declaration
    native public fun native_fun(): u64;

    // A regular function with a function body
    public fun regular_fun(): u64 {
        42
    }

    // A runner function to exercise functions without arguments
    public fun runner(): u64 {
        let x = regular_fun();
        let y = native_fun();
        x + y
    }
}

//# run 0xCAFE::AbilitiesExample::runner


//# publish
module AbilitiesDefaultAddress {
    // This module intentionally has no explicit address specified
    // This will test default addressing behavior

    struct DefaultStruct has key;

    public fun double(x: u64): u64 {
        x * 2
    }

    public fun runner(): u64 {
        double(21)
    }
}

//# run 0xCAFE::AbilitiesDefaultAddress::runner


//# publish
module 0xCAFE::NativeFunctionExample {
    native public fun native_fun(): u64;
}

//# run 0xCAFE::NativeFunctionExample::native_fun


//# run
script {
    // This script does nothing but exercises compiler and VM on a script with no args
}

// Featurres:
// a73c4f4766459a22b08b988583a7b0c9: Declare abilities as a postfix to a type declaration using a semicolon.
// f9bbd34c78be46a6c0da919866e42dab: Default to using a provided address when the module's address is not explicitly specified.
// c1112e7534433a22cde30e2de4593dc5: Define functions with a specified body, either native or with a sequence of statements.
