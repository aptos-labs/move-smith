
//# publish
module 0xCAFE::AddModule {
    public fun add(u: u8, v: u8): u8 {
        let sum = u + v;
        // Return sum + 10 to have a specific expected value
        sum + 10
    }
    
    // Runner for add function with fixed args
    public fun run_add(): u8 {
        add(5u8, 7u8)
    }
}




//# run 0xCAFE::AddModule::add --args 5u8 7u8




//# run 0xCAFE::AddModule::run_add




//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Calls inline function from AddModule if it existed, here replicate with call to run_add
    public fun call_add_module(): u8 {
        // call AddModule::run_add which does nested calls internally
        AddModule::run_add()
    }
}




//# run 0xCAFE::CallerModule::call_add_module




//# publish
module 0xCAFE::PathUtils {
    use std::vector;

    // skip(vec)]
    public fun canonicalize_path(path: vector<u8>): vector<u8> {
        let parts = vector::empty<vector<u8>>();
        let cur = vector::empty<u8>();
        let i = 0u64;
        while (i < vector::length(&path)) {
            let c = *vector::borrow(&path, i);
            if (c == 47u8) { // '/'
                if (vector::length(&cur) > 0) {
                    vector::push_back(&mut parts, cur);
                    cur = vector::empty<u8>();
                };
            }
            else {
                vector::push_back(&mut cur, c);
            };
            i = i + 1;
        };
        if (vector::length(&cur) > 0) {
            vector::push_back(&mut parts, cur);
        };
        // Allocate result and build canonical path without empty or "." parts
        let result = vector::empty<u8>();
        let k = 0u64;
        while (k < vector::length(&parts)) {
            let part = *vector::borrow(&parts, k);
            if (vector::length(&part) == 1 && *vector::borrow(&part, 0) == 46u8) {
                // Skip "."
            } else if (vector::length(&part) == 2 && *vector::borrow(&part, 0) == 46u8 && *vector::borrow(&part, 1) == 46u8) {
                // Handle ".." by removing last from result if any
                if (vector::length(&result) > 0) {
                    let last_index = vector::length(&result) - 1;
                    // remove until previous '/'
                    while (last_index > 0 && *vector::borrow(&result, last_index) != 47u8) {
                        last_index = last_index - 1;
                    };
                    // Manually truncate result vector by popping elements one by one until length == last_index
                    while (vector::length(&result) > last_index) {
                        vector::pop_back(&mut result);
                    };
                };
            } else {
                // append '/'
                vector::push_back(&mut result, 47u8);
                // append part
                let idx = 0u64;
                while (idx < vector::length(&part)) {
                    vector::push_back(&mut result, *vector::borrow(&part, idx));
                    idx = idx + 1;
                };
            };
            k = k + 1;
        };
        if (vector::length(&result) == 0) {
            // Represent root directory "/"
            vector::push_back(&mut result, 47u8);
        };
        result
    }
}




//# run 0xCAFE::PathUtils::canonicalize_path --args b"/a/./b/../../c/"

/// This function should be verified to be present and compiled by the compiler without error.
public fun verified_function(x: u8): u8 {
    x + 1
}




//# publish
module 0xCAFE::ComplianceModule {
    // skip(
    //   lints = ["doc_missing", "code_style", "unused_variables"]
    // )]

    public fun verified_function(x: u8): u8 {
        x + 1
    }

    public fun runner() {
        let _ = verified_function(100u8);
    }
}




//# run 0xCAFE::ComplianceModule::runner
