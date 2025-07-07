
//# publish
module 0xCAFE::ControlFlowTestModule {
    use std::vector;

    // This function calls other functions within the module, testing function call identification
    public fun caller_function() {
        nested_function_1();
        nested_function_2(5);
        // Call with a variable argument
        let a = 10;
        nested_function_2(a);
        // Call others
        nested_function_3();
    }

    fun nested_function_1() {
        // simple internal function
    }

    fun nested_function_2(param: u64) {
        // perform some operation
        let _ = param + 1;
    }

    fun nested_function_3() {
        // Another internal function
    }

    // Function to test control flow graph transformations by replacing labels
    public fun label_replacement_test(flag: bool): u8 {
        let count = 0;
        if (flag) {
            // labeled block
            label_a:
            {
                count = count + 1;
                // Branch to label_b
                goto label_b;
            }
        } else {
            // alternative labeled block
            label_b:
            {
                count = count + 2;
            }
        }

        // Replace label references: simulate control flow change by rewriting labels
        if (count > 1) {
            // we simulate replacing label_b with label_c, so jump to label_c
            label_c:
            {
                // In actual CFG, label_b reference is replaced by label_c
                count = count + 10;
            }
        }
        count
    }
}


//# run 0xCAFE::ControlFlowTestModule::caller_function


//# run 0xCAFE::ControlFlowTestModule::label_replacement_test --args true


//# run 0xCAFE::ControlFlowTestModule::label_replacement_test --args false

// Module to test merging of specifications into the program before further processing

//# publish
module 0xCAFE::SpecMergeModule {
    // External spec modules to be merged before further processing
    use 0xCAFE::MyModule;

    // Function that combines features from other modules (simulate merge)
    public fun combined_feature() {
        // Call a function from the merged module
        let _ = 0xCAFE::MyModule::f4();
        // Use a working value from the merged module
        let _ = 0xCAFE::MyModule::f2(42);
    }
}


//# run 0xCAFE::SpecMergeModule::combined_feature

// Featurres:
// c275d7b911cf739ee3d9b05d148790bf: Identify functions within module M that are called by the current function. 
// e04f4e6393f3cc70f5b7a7eb7c919001: Replace block or label references with a new label during control flow graph transformations
// 4f191e6be768568f6249de18157b6c37: Merge specification modules into the program before further processing.
