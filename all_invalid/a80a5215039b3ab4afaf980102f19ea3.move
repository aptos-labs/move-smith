
//# publish
module 0xCAFE::EarlyReturnTest {

    public fun check_and_return(x: u8) {
        if (x > 5) {
            return;
        };
        // This assertion should only run when x <= 5
        assert!(x <= 5, 999);
    }

    struct MRefHolder has copy, drop {
        imm_ref: &u8,
        mut_ref: &mut u8,
    }

    public fun demonstrate_references(x: &u8, y: &mut u8) {
        let imm_copy = *x;
        *y = imm_copy + 10;
    }

    public fun call_function_with_args(a: u8, b: u8): u8 {
        let c = a + b;
        c
    }

    public fun runner() {
        let val: u8 = 4;
        let val_mut: u8 = 10;

        // Immutable reference
        let imm_ref: &u8 = &val;
        // Mutable reference
        let mut_ref: &mut u8 = &mut val_mut;

        demonstrate_references(imm_ref, mut_ref);

        check_and_return(6u8); // Should return early, no assert triggered
        check_and_return(3u8); // Should not return early; assert should pass

        let res = call_function_with_args(2u8, 3u8);
        let _holder = MRefHolder { imm_ref, mut_ref };
    }
}


//# run 0xCAFE::EarlyReturnTest::runner


// Featurres:
// c971a0637cbb2005d5f215c962d97fe5: Test that the script returns early when the condition is true, preventing the assertion from executing.
// 731e7b66c340e61a359477160d73dcb1: Define reference types with mutable and immutable qualifiers using '&' and '&mut' syntax.
// c185274deb99a3838ded6c765228f460: Call functions with arguments by following a name with '(' and argument expressions (e.g., foo(1, 2)).
