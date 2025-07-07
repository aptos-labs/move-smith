//# publish
address 0xCAFE {
    module TestModule {
        // Use both numerical and symbolic addresses as attribute values
        #[test_attr(address = 0xCAFE)]
        #[test_attr(named_address = 0xCAFE)]
        #[spec_module(is_spec_module = true)]
        struct MyStruct has store {
            field1: u64,
            field2: u8,
        }

        public fun new_struct(): MyStruct {
            MyStruct { field1: 42, field2: 7 }
        }

        public fun runner() {
            let s = Self::new_struct();
            let f1 = s.field1;
            let f2 = s.field2;
            // just access fields with dot notation, no assertions
            let _ = f1;
            let _ = f2;
        }
    }
}

//# run 0xCAFE::TestModule::runner
//# run 0xCAFE::TestModule::new_struct

// Featurres:
// 6944f68830d8207340ad171d16b914ef: Use both numerical and symbolic (named) addresses as attribute values in annotations.
// 7436b27712b729874971d9d4406efa42: Identify spec modules by setting the 'is_spec_module' flag to true.
// 0262f9a999d19ef8348c84365785f4bf: Access fields of structs using dot notation, such as `my_struct.field`.
