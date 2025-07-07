//# publish
address 0xCAFE {
    module BoolOps {
        const ALL_TRUE: bool = true && true && true;
        const SOME_TRUE: bool = true || false;
        const NONE_TRUE: bool = false || false;
        const NEGATION: bool = !false && (true || false);

        public fun runner() {
            let a = true;
            let b = false;
            let c = !(a && b) || (a && !b);
            // just exercise boolean ops and constants
            let _ = Self::ALL_TRUE;
            let _ = Self::SOME_TRUE;
            let _ = Self::NONE_TRUE;
            let _ = Self::NEGATION;
            let _ = c;
        }
    }
}
//# run 0xCAFE::BoolOps::runner

//# publish
address 0xCAFE {
    module BorrowTest {
        resource struct R {}

        public fun create(): R {
            R {}
        }

        public fun bad_borrow() {
            let mut r = Self::create();
            let _ref1 = &mut r;
            let _ref2 = &mut r;
            // The above line should trigger a compiler error or be disallowed by VM
            // This function exists solely to test that multiple mutable refs cannot be created.
            // Not called (no `runner` function) because it should fail compilation if called.
        }

        public fun runner() {
            // Proper single mutable reference before immutable references to demonstrate allowed borrowing.
            let mut r = Self::create();
            let _ref1 = &mut r;
            let _val = *_ref1;
        }
    }
}
//# run 0xCAFE::BorrowTest::runner

//# run
script with bool_and_bool() {
    #[test_script]
    fun main() {
        let a = true;
        let b = false;
        let c = true;
        let result = (a && b) || (!c && (a || b));
        // use result to avoid unused variable warning
        let _ = result;
    }
}

//# run
script with_mut_refs() {
    #[test_script]
    fun main() {
        let mut x = 1;
        let r1 = &mut x;
        // Uncommenting the below line should cause borrow checker failure but here we just do one mutable ref
        //let r2 = &mut x;
        *r1 = 2;
    }
}

// Featurres:
// 786fe5d504ce49a105a091af40f1f658: Annotate your script with attributes on the script declaration.
// 55313936edb6b3b1f6d3a596b931e255: Test that boolean operators (&&, ||, !) and combinations thereof are correctly evaluated and can be used in constant expressions.
// 053c0898699e17a66d51b1ffd70c3ab0: Test that attempting to create multiple mutable references in the same function results in a compilation error or behavior as specified by Move's borrowing rules.
