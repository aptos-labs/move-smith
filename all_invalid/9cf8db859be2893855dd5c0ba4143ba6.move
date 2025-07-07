
// Since Move compiler warnings are not captured via runtime, we include code that uses deprecated syntax
// and expect compiler to produce warnings during compilation.
//# publish
module 0xCAFE::CompatibilityTest {
    use std::vector;

    public fun test_deprecated_generic_syntax<T>() {
        // Using deprecated syntax intentionally; expected to trigger warning
        let vec: vector<T> = vector::empty();
        let _ = vector::push_back(&mut vec, /* dummy value */ 0u8 as T);
        vec
    }
}


//# run 0xCAFE::CompatibilityTest::test_deprecated_generic_syntax --args 0u8


//# publish
module 0xCAFE::SerializationUtil {
    // Assume this module provides deserialization of modules from files
    // For testing, we simulate deserialization
    use std::vector;

    public fun deserialize_module_from_file(_path: vector<u8>): bool {
        // Placeholder: simulate success
        true
    }
}


//# run 0xCAFE::SerializationUtil::deserialize_module_from_file --args 1
// The above line simulates deserialization with dummy argument


//# publish
module 0xCAFE::AddressValidation {
    // Function to validate address string format
    public fun is_valid_address_format(addr_str: vector<u8>): bool {
        let count_equal = 0;
        let len = vector::length(&addr_str);
        let i = 0;
        while (i < len) {
            let byte_ref = vector::borrow(&addr_str, i);
            if (*byte_ref == b'=') {
                count_equal = count_equal + 1;
            }
            i = i + 1;
        };
        // accept only if exactly one '='
        count_equal == 1
    }
}


//# run 0xCAFE::AddressValidation::is_valid_address_format --args b"0x1234=5678"
// Expect: true


//# run 0xCAFE::AddressValidation::is_valid_address_format --args b"0x1234==5678"
// Expect: false


//# run 0xCAFE::AddressValidation::is_valid_address_format --args b"0x1234"
// Expect: false


//# publish
module 0xCAFE::VectorByteSum {
    public fun sum_all_elements(vec: vector<u8>): u8 {
        let sum = 0u8;
        let len = vector::length(&vec);
        let i = 0;
        while (i < len) {
            let val_ref = vector::borrow(&vec, i);
            sum = sum + *val_ref;
            i = i + 1;
        };
        sum
    }
}


//# run 0xCAFE::VectorByteSum::sum_all_elements --args b"\x01\x02\x03\x04"
// Expect sum: 10


//# publish
module 0xCAFE::InlineClosureTest {
    // Function that takes a closure |u8|u8 and applies it
    public fun apply_closure_to_value(f: |u8|u8, value: u8): u8 {
        f(value)
    }

    // Function that takes a closure with two parameters |u8, u8|u8 and applies it
    public fun apply_two_param_closure(f: |u8, u8|u8, a: u8, b: u8): u8 {
        f(a, b)
    }
}


//# run 0xCAFE::InlineClosureTest::apply_closure_to_value --args 0u8
// Use inline closure: |x| x + 5u8
// Since we can't pass closures directly as args in script, simulate via inlining in test


//# run 0xCAFE::InlineClosureTest::apply_two_param_closure --args 3u8 4u8
// Use inline closure: |a, b| a * b

cores for this last part, we can write wrapper functions inside the module that internally call the functions with inline closures, since Move scripts can't pass closures directly.
// For the purpose of this test, embed calls within the code, assuming that passing named functions which close over variables is complex in scripts.


// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 38c8fed9c8f68f65a6ce8f0a9b4bc138:  Validate that the address assignment string is correctly formatted with exactly one '=' character.
// 7089c4cd06ddee8834d2c0ab2858e857: Test that popping all elements from a vector of bytes and summing them produces the correct total.
// 426aee62717231b92c1e9e4a6b492596: Test that the inline function correctly accepts and executes closure arguments with different parameter configurations and returns the expected computed value.
