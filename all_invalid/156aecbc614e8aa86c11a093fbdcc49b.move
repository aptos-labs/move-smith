
//# publish
module 0xCAFE::GenericDiagnosticsTest {
    use std::vector;
    use std::signer;

    // A generic struct to test generic parameter parsing and diagnostics
    struct Container<T> has store {
        value: T,
        items: vector<T>,
    }

    // A generic function to add an element to Container's items vector
    public fun add_item<T>(container: &mut Container<T>, item: T) {
        vector::push_back(&mut container.items, item);
    }

    // A generic function to return length of container's vector
    public fun len<T>(container: &Container<T>): u64 {
        vector::length(&container.items)
    }

    // A function to create a Container<u8> with initial value and empty vector
    public fun create_u8_container(val: u8): Container<u8> {
        Container {value: val, items: vector::empty<u8>()}
    }

    // Function deliberately producing a vector error by popping from empty vector
    // expected_failure(vector_error 12)]
    public fun error_pop_empty_vector() {
        let v = vector::empty<u64>();
        vector::pop_back(&mut (copy v));
        // The above should generate a vector underflow error diagnostic with minor code 12
    }

    // Diagnostic message simulation by calling a function with confusing generic params
    public fun diagnostic_message_test<T, U>(_: T, _: U) {
        // dummy function for diagnostic test
    }

    // Runner function calling diagnostic_message_test with concrete types to exercise diagnostics
    public fun run_diagnostics() {
        diagnostic_message_test<u8, vector<u64>>(1u8, vector::empty<u64>());
    }
}


//# run 0xCAFE::GenericDiagnosticsTest::add_item --args 0u8

//# run 0xCAFE::GenericDiagnosticsTest::len --args 0u8

//# run 0xCAFE::GenericDiagnosticsTest::create_u8_container --args 10u8


//# run 0xCAFE::GenericDiagnosticsTest::error_pop_empty_vector


//# run 0xCAFE::GenericDiagnosticsTest::run_diagnostics


// Featurres:
// 73265337ad08f8e478c741080579f48a: Receive and process diagnostic messages generated during Move code compilation
// 438a5a28c4b3a3d65c2b6eb8f4ca3992: Indicate a vector operation error expected in your test with `#[expected_failure(vector_error)]` attribute, with optional minor status code.
// 1d224cd473501aa415dc18790f5c282a: Define generic parameters for functions, structs, or modules using angle-bracket (<...>) syntax.
