//# publish
module 0x1::test_module {
    use std::debug;
    use std::string;
    use aptos_framework::package::{PackagePaths, Symbol};

    // Top-level spec block as a function
    public fun spec_block(id: u64) {
        debug::print(&string::utf8(b"Starting spec block: "));
        debug::print(&string::from_u64(id));
    }

    // Function to log detailed debug info, including source file name
    public fun log_debug_info(source_file: &string) {
        // Enable detailed bytecode dump with source file name
        debug::print(&string::utf8(b"Debug info from source: "));
        debug::print(source_file);
    }

    // Function declaring a literal address specifier
    public fun declare_literal_address() {
        let addr: vector<u8> = (0x1234);
        // Log the address bytes
        debug::print(&string::utf8(b"Literal address bytes: "));
        debug::print(&string::from_bytes(&addr));
    }

    // Function transforming 'name' field of PackagePaths from String to Symbol
    public fun transform_package_path_name() {
        let package_path = PackagePaths {
            name: string::utf8(b"example_module"),
            address: 0x1,
        };
        // Convert name string to Symbol
        let symbol_name = Symbol::from_str(&package_path.name);
        // For demonstration, assign back
        let _new_package_path = PackagePaths {
            name: symbol_name.to_string(),
            address: package_path.address,
        };
    }

    // Runner function to execute all steps
    public fun run_all() {
        spec_block(1);
        log_debug_info(&string::utf8(b"source_file_move.move"));
        declare_literal_address();
        transform_package_path_name();
        debug::print(&string::utf8(b"All tests executed."));
    }
}
//# run 0x1::test_module::run_all