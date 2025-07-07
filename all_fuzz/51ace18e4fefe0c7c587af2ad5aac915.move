
//# publish
module 0xCAFE::LambdaModule {
    // Test lambda functions and compute addition

    // Simple add function with lambda usage
    public fun add_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = adder(a, b);
        sum
    }

    // Return a lambda closure and call it immediately
    public fun call_lambda_immediately(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |y: u8| y + 1;
        f(x)
    }

    // Runner function for testing
    public fun runner() {
        let _ = add_with_lambda(2u8, 3u8);
        let _ = call_lambda_immediately(5u8);
    }
}



//# run 0xCAFE::LambdaModule::add_with_lambda --args 7u8 8u8



//# run 0xCAFE::LambdaModule::call_lambda_immediately --args 10u8



//# run 0xCAFE::LambdaModule::runner




//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::LambdaModule;

    // Inline function returning a tuple, called in another module
    public inline fun inline_add_two_numbers(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }

    // Call the inline function from this module and from LambdaModule
    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let (sum, product) = inline_add_two_numbers(x, y);
        let lambda_sum = LambdaModule::add_with_lambda(x, y);
        assert!(sum == lambda_sum, 77);
        sum + product
    }

    // Runner without args
    public fun runner() {
        let _ = call_inline_and_lambda(4u8, 5u8);
    }
}



//# run 0xCAFE::InlineCallModule::call_inline_and_lambda --args 4u8 5u8



//# run 0xCAFE::InlineCallModule::runner




//# publish
module 0xCAFE::FriendModule {
    use std::signer;

    friend 0xCAFE::InlineCallModule;

    // Add key ability to allow storage under an address
    struct Secret has key, store {
        value: u8,
    }

    public fun create_secret(s: signer, v: u8) {
        let secret = Secret { value: v };
        move_to<Secret>(&s, secret);
    }

    public fun get_secret_value(s: signer): u8 {
        let secret_ref: &Secret = borrow_global<Secret>(signer::address_of(&s));
        secret_ref.value
    }

    public fun modify_secret_value(s: signer, v: u8) {
        let secret_mut_ref: &mut Secret = borrow_global_mut<Secret>(signer::address_of(&s));
        secret_mut_ref.value = v;
    }
}



//# run 0xCAFE::FriendModule::create_secret --signers 0xDEAD --args 42u8



//# run 0xCAFE::FriendModule::get_secret_value --signers 0xDEAD



//# run 0xCAFE::FriendModule::modify_secret_value --signers 0xDEAD --args 99u8



//# run 0xCAFE::FriendModule::get_secret_value --signers 0xDEAD


// Custom package info module simulating package definition with named address and optional whitespace handling


//# publish
module 0xCAFE::PackageDefinitions {
    // Remove invalid visibility modifiers from constants
    const NAMED_ADDRESS_1: address = @0xCAFE;
    const NAMED_ADDRESS_2: address = @0xBEEF;

    // Custom data structure representing package info
    struct PackageInfo has copy, drop, store {
        name: vector<u8>,
        version: u16,
        authors: vector<vector<u8>>,
    }

    // Function to create dummy package info
    public fun create_package_info(): PackageInfo {
        let name = b"MyPackage";
        let authors = vector[b"Alice", b"Bob"];

        PackageInfo {
            name,
            version: 1,
            authors,
        }
    }

    // Function demonstrating optional whitespace and tokens in a dummy list of addresses
    public fun parse_address_list(): vector<address> {
        // Simulated list: [@0xCAFE, @0xBEEF , @0xDEAD] with optional whitespace preserved by parse
        let addrs = vector[@0xCAFE, @0xBEEF, @0xDEAD];
        addrs
    }
}



//# run 0xCAFE::PackageDefinitions::create_package_info



//# run 0xCAFE::PackageDefinitions::parse_address_list
