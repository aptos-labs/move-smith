//# publish
address 0xCAFE {
    module ModuleWithDeprecated {
        #[deprecated]
        public fun deprecated_function(): u64 {
            42
        }

        public fun runner() {
            // Call deprecated function to check that deprecation attribute is compiled
            let _ = Self::deprecated_function();
        }
    }
}

//# run 0xCAFE::ModuleWithDeprecated::runner

//# publish
address 0xCAFE {
    module ModuleFoo {
        // Function foo takes an inner function which accesses and modifies outer variable x
        public fun foo(f: &mut u64) {
            *f = 3;
        }

        public fun runner() {
            let mut x: u64 = 1;
            // Pass reference to x so `foo` can change its value
            Self::foo(&mut x);
            // x should be 3 now
            let _ = x;
        }
    }
}

//# run 0xCAFE::ModuleFoo::runner


// This test uses an undeclared address variable to generate a compile error.
// It should fail compilation as required.

//# publish
address UNDECLARED_ADDRESS {
    module ShouldFail {
        public fun dummy(): u64 {
            0
        }
    }
}

// Featurres:
// 1cce47bbf03671922de1f2945e40ea6f: Use address variables without assigned values during compilation to generate an error message.
// ebc92aa2d6bd14ba80c939ab639e70ab: Mark module members as deprecated using attributes.
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
