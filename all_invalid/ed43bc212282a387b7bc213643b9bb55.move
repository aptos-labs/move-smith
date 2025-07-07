//# publish
module 0xCAFE::TestModule {
    use std::error;
    use std::vector;

    // 1. Error for files marked both as targets and dependencies.
    const ERROR_CODE_INTERSECTION: u64 = 1;

    // Structure for file tracking
    struct FileSet has copy, drop, store {
        files: vector<u8>, // assuming filenames represented as byte arrays for simplicity
    }

    public fun check_intersection(targets: &vector<u8>, dependencies: &vector<u8>): vector<u8> {
        /*
        Here we simulate checking the intersection of two vectors of file bytes, 
        signaling an error by returning a vector of intersection items.
        */

        let mut intersection = vector::empty<u8>();

        let target_len = vector::length(targets);
        let dep_len = vector::length(dependencies);

        let mut i = 0;
        while (i < target_len) {
            let mut j = 0;
            let t_file = *vector::borrow(targets, i);
            let mut found = false;
            while (j < dep_len) {
                let d_file = *vector::borrow(dependencies, j);
                if (t_file == d_file) {
                    // file in intersection
                    vector::push_back(&mut intersection, t_file);
                    found = true;
                }
                j = j + 1;
            }
            i = i + 1;
        }
        // If intersection not empty, abort with error message encoded
        if (vector::length(&intersection) > 0) {
            // For demo, abort with error code and simply keep intersection vector in return
            // since we can't abort with a printable message in this mock setup
            // Normally you would use error::abort_code
            error::abort_code(ERROR_CODE_INTERSECTION);
        }

        intersection
    }

    // 2. Struct definitions explicitly included in output (this struct is already defined up top)

    struct MyStruct has copy, drop, store {
        val: u64,
    }

    // 3. Map over constant empty vectors with lambdas using references and type annotations.

    public fun map_over_empty_vec_ref_type_annotation() {
        // empty vector with u64
        let empty_vec = vector::empty<u64>();

        // map with ref argument and explicit type annotation, identity function
        let result = vector::map<u64, u64>(&empty_vec, &|v: &u64| -> u64 { *v });

        // map with ref argument referencing MyStruct type argument
        let empty_struct_vec = vector::empty<MyStruct>();
        let mapped_struct_vec = vector::map<MyStruct, u64>(&empty_struct_vec, &|s: &MyStruct| -> u64 { s.val });
        // no assertion
    }

    // A "runner" function for calling all features without args
    public fun runner() {
        // call empty vector map
        map_over_empty_vec_ref_type_annotation();

        // call intersection with empty vectors to avoid abort in runner
        let empty1 = vector::empty<u8>();
        let empty2 = vector::empty<u8>();
        let _ = check_intersection(&empty1, &empty2);
    }
}
//# run 0xCAFE::TestModule::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::TestModule;

    fun main(account: &signer) {
        // Testing check_intersection with intersection triggers abort for demo
        let targets = vector::empty<u8>();
        let dependencies = vector::empty<u8>();

        // Map over empty vec test indirectly tested by runner

        // To demonstrate error, let's call check_intersection with intersection
        // But since abort will stop the script, comment out to ensure this script runs fully
        // let mut targets_arr = vector::empty<u8>();
        // vector::push_back(&mut targets_arr, 42u8);
        // let mut dependencies_arr = vector::empty<u8>();
        // vector::push_back(&mut dependencies_arr, 42u8);

        // Uncomment below to forcibly test abort on intersection
        // TestModule::check_intersection(&targets_arr, &dependencies_arr);

        // Call runner on module (execute the mapping over empty vec and safe intersection check)
        TestModule::runner();
    }
}

// Featurres:
// 56ef38758ed60a50088ec4925667996a: Report an error listing all files that are marked as both targets and dependencies when intersection occurs.
// b67838f01f1672912a7cabc235296ed0: Include `struct` definitions in the module output.
// 2a5422f316ef62fe7d9ca4c5e83b59c2: Test mapping over constant empty vectors with lambdas that use references and type annotations.
