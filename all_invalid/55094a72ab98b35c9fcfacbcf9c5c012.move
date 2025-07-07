
//# publish
module 0xDEAD::TestFeature {
    use std::vector;
    use std::debug;

    // 1. Function to find the greatest product of four consecutive digits
    public fun greatest_product_of_four(vec: vector<u8>): u64 {
        let max_product = 0u64;
        let len = vector::length(&vec);
        let i: u64 = 0;
        while (i + 3 < len) {
            let a = *vector::borrow(&vec, i);
            let b = *vector::borrow(&vec, i + 1);
            let c = *vector::borrow(&vec, i + 2);
            let d = *vector::borrow(&vec, i + 3);
            let product = (a as u64) * (b as u64) * (c as u64) * (d as u64);
            if (product > max_product) {
                max_product = product;
            };
            i = i + 1;
        };
        max_product
    }

    // Public runner function for feature 1
    public fun run_greatest_product_test() {
        // Correctly create vector using vector::empty and push_back, or use vector macro properly
        // move std::vector macro syntax isn't supported; instead, define vector inline
        let digits: vector<u8> = vector::empty();
        vector::push_back(&mut digits, 1u8);
        vector::push_back(&mut digits, 2u8);
        vector::push_back(&mut digits, 3u8);
        vector::push_back(&mut digits, 4u8);
        vector::push_back(&mut digits, 5u8);
        vector::push_back(&mut digits, 6u8);
        vector::push_back(&mut digits, 7u8);
        vector::push_back(&mut digits, 8u8);
        let result = greatest_product_of_four(digits);
        debug::print(&b"Greatest product of four in vector: ");
        debug::print_u64(&result);
    }

    // 2. Sorting diagnostics report entries (simulate report entries structure)
    // (This example assumes a simplified report entry struct)
    struct DiagnosticEntry has copy, drop, store {
        primary_location: u64,
        message: vector<u8>,
    }

    // Function to sort report entries by primary_location (simple bubble sort for example)
    fun sort_diagnostics(entries: &mut vector<DiagnosticEntry>) {
        let len = vector::length(entries);
        let i: u64 = 0;
        while (i < len) {
            let j: u64 = 0;
            while (j + 1 < len) {
                let entry1: &DiagnosticEntry = &vector::borrow(entries, j);
                let entry2: &DiagnosticEntry = &vector::borrow(entries, j + 1);
                if (entry1.primary_location > entry2.primary_location) {
                    // Swap
                    let temp = vector::extract(entries, j);
                    let next = vector::extract(entries, j);
                    vector::insert_at(entries, j, next);
                    vector::insert_at(entries, j + 1, temp);
                };
                j = j + 1;
            };
            i = i + 1;
        };
    }

    // Public runner for the diagnostics report sorting
    public fun run_sort_diagnostics() {
        // Construct sample report entries
        let entries: vector<DiagnosticEntry> = vector::empty();
        // Push back entries
        vector::push_back(&mut entries, DiagnosticEntry { primary_location: 300, message: b"Error at 300" });
        vector::push_back(&mut entries, DiagnosticEntry { primary_location: 100, message: b"Error at 100" });
        vector::push_back(&mut entries, DiagnosticEntry { primary_location: 200, message: b"Error at 200" });
        // Sort entries
        sort_diagnostics(&mut entries);
        let len = vector::length(&entries);
        let index: u64 = 0;
        while (index < len) {
            let entry: &DiagnosticEntry = &vector::borrow(&entries, index);
            debug::print(&entry.message);
            debug::print(&b" at location: ");
            debug::print_u64(&entry.primary_location);
            index = index + 1;
        };
    }

    // 3. Unused private functions (simulate detection)
    // Private function without friends and unused, should trigger a warning on cleanup
    fun private_unused_function(): u8 {
        // Does nothing, should be cleaned up
        42u8
    }

    // Another private function with no uses
    fun unused_helper(): bool {
        true
    }

    // Note: No calls to private_unused_function or unused_helper

    // Entry point for testing
    public fun run_all_tests() {
        run_greatest_product_test();
        run_sort_diagnostics();
        // No invocation for private_unused_function or unused_helper as they are intentionally unused
    }
}


//# run 0xDEAD::TestFeature::run_all_tests
