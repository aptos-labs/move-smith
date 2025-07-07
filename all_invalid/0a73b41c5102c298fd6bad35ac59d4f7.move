
//# publish
module 0xCAFE::DepModule1 {
    public fun greet(): vector<u8> {
        b"Hello from DepModule1"
    }
}


//# publish
module 0xCAFE::DepModule2 {
    public fun number(): u64 {
        2024u64
    }
}


//# publish
module 0xCAFE::FormattingModule {
    use std::vector;
    use std::string;

    // Formats a list of u8 local variables with a specified header into a string
    public fun format_locals(header: vector<u8>, locals: vector<u8>): vector<u8> {
        let result = vector::empty<u8>();
        // append header + ": "
        vector::append(&mut result, header);
        vector::push_back(&mut result, 58); // ASCII ':'
        vector::push_back(&mut result, 32); // ASCII ' '
        let len = vector::length(&locals);
        let i = 0u64;
        // loop over locals vector, format each u8 as decimal string and separated by comma and space
        while (i < len) {
            let val = *vector::borrow(&locals, i as u64);
            // convert u8 to string using std::string::utf8
            // no built-in int to string; build manually
            // for simplicity, val < 100, so max two chars
            let tens = val / 10;
            let ones = val % 10;
            if (tens > 0) {
                vector::push_back(&mut result, (tens + 48) as u8); // '0' + tens
            };
            vector::push_back(&mut result, (ones + 48) as u8);
            if (i + 1 < len) {
                vector::push_back(&mut result, 44); // ','
                vector::push_back(&mut result, 32); // space
            };
            i = i + 1;
        };
        result
    }
}


//# publish
module 0xCAFE::MainModule {
    use 0xCAFE::DepModule1;
    use 0xCAFE::DepModule2;
    use 0xCAFE::FormattingModule;
    use std::vector;
    use std::string;

    public fun test_dependencies_and_format() {
        // Call DepModule1::greet
        let greeting = DepModule1::greet();

        // Call DepModule2::number
        let year = DepModule2::number();

        // Prepare local variables to format
        let locals = vector[10u8, 20u8, 30u8, 99u8];

        // Define header string
        let header = b"Local Variables";

        // Call FormattingModule::format_locals without Self.
        let formatted = FormattingModule::format_locals(header, locals);

        // Just assign to unused variable to test the features
        let _ = (greeting, year, formatted);
    }
}


//# run 0xCAFE::MainModule::test_dependencies_and_format


// Featurres:
// 9c0913bf37805fe400f5db6aa5661141: Establish explicit module dependencies by referencing other modules in your Move modules
// 91ef0faeb00e239e5e3b19a1db582516: Remove unnecessary 'Self.' references from Move code.
// b18a650edfc90c4987d2fa3194e9767a: Format a list of local variables with a specified header in a string.
