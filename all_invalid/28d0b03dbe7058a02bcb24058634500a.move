//# publish
module 0x1::TestModule {
    use std::debug;
    use std::vector;

    // Top-level spec block. Could be a function spec or other construct.
    // For simplicity, define a function to demonstrate.
    public fun top_level_spec() {
        debug::print(&"Starting top-level spec");
    }

    // Function to log detailed debug info, including file name derivation.
    public fun log_debug_info(source_filename: &str) {
        debug::print(&"Debug: Bytecode dump for file: ");
        debug::print(source_filename);
        // Placeholder for actual bytecode dump logic, if supported.
    }

    // Declare a literal address specifier with a byte sequence.
    public fun declare_address_specifier(addr_bytes: vector<u8>) {
        debug::print(&"Address specifier bytes: ");
        debug::print_vector(&addr_bytes);
    }

    // Runner function to execute internal specs
    public fun run_all_specs() {
        top_level_spec();
        log_debug_info("source_file.move");
        declare_address_specifier(vector![@0x12, @0x34, @0x56]);
    }
}

//# run 0x1::TestModule::run_all_specs

//# publish
module 0x2::LoggingModule {
    use std::debug;

    // Function to log detailed debug info, including bytecode dump names.
    public fun log_detailed_debug(source: &str) {
        debug::print(&"Debug info for: ");
        debug::print(source);
        // Additional debug logic could be added here.
    }

    // A spec block that encapsulates logging behaviors.
    public fun log_specifications() {
        log_detailed_debug("LoggingModule.move");
    }
}

//# run 0x2::LoggingModule::log_specifications

//# publish
module 0x3::ErrorReporting {
    use std::debug;

    // Function to report intersection errors.
    public fun report_intersection_errors(files: vector<&str>) {
        let error_message = "Intersection error: Files marked both as target and dependency: ";
        debug::print(&error_message);
        let size = vector::length(&files);
        let mut i = 0;
        while (i < size) {
            debug::print(vector::borrow(&files, i));
            i = i + 1;
        }
    }

    // Function to identify intersecting files.
    public fun check_intersection(targets: vector<&str>, dependencies: vector<&str>) {
        let mut intersection_files = vector::empty<&str>();
        let target_size = vector::length(&targets);
        let dep_size = vector::length(&dependencies);
        let mut i = 0;
        while (i < target_size) {
            let target_file = vector::borrow(&targets, i);
            let mut j = 0;
            while (j < dep_size) {
                let dep_file = vector::borrow(&dependencies, j);
                if (target_file == dep_file) {
                    vector::push_back(&mut intersection_files, target_file);
                }
                j = j + 1;
            }
            i = i + 1;
        }
        if (vector::length(&intersection_files) > 0) {
            report_intersection_errors(intersection_files);
        }
    }
}

//# run 0x3::ErrorReporting::check_intersection --args ['"file1.move"', '"file2.move"'] ['"file2.move"', '"file3.move"']