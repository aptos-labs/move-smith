
//# publish
module 0xCAFE::ByteStringTest {
    use std::vector;

    public fun byte_string_vs_hex() {
        let empty_bs = b"";
        let _empty_hex = x"";
        assert!(vector::length(&empty_bs) == 0, 1);

        let ascii_bs = b"ABCD";
        let ascii_hex = x"41424344"; // ASCII codes for ABCD
        assert!(vector::length(&ascii_bs) == 4, 2);
        // Check byte equality for each index
        let i = 0;
        while (i < vector::length(&ascii_bs)) {
            assert!(*vector::borrow(&ascii_bs, i) == *vector::borrow(&ascii_hex, i), 3);
            i = i + 1;
        };

        // Mixed byte string with escape sequences
        let mixed_bs = b"A\n\x41Z"; // A, newline(0x0a), 'A', Z
        let mixed_hex = x"410a415a";
        let len = vector::length(&mixed_bs);
        assert!(len == 4, 4);
        let j = 0;
        while (j < len) {
            assert!(*vector::borrow(&mixed_bs, j) == *vector::borrow(&mixed_hex, j), 5);
            j = j + 1;
        };
    }
}



//# publish
module 0xCAFE::FunctionPointerEnums {
    use std::signer;
    use std::vector;
    use std::option;

    public fun foo_1(x: u8): u8 {
        x + 1
    }

    public fun foo_2(x: u8): u8 {
        x * 2
    }

    public struct FPContainer has key, store {
        fun_ptr: FPEnum,
    }

    public enum FPEnum has copy, drop, store {
        Standalone: fn(u8) -> u8,
        LambdaCapture {
            captured: u8,
            func: fn(u8, u8) -> u8,
        }
    }

    // Another enum wrapping FPEnum
    public enum NestedFPEnum has copy, drop {
        Inner(FPEnum),
        None,
    }

    // resource with vector of FPEnum
    public struct FunVecContainer has key {
        funcs: vector<FPEnum>
    }

    // Store resource at caller's address for tests
    public fun store_fp_container(s: signer) {
        let fpc = FPContainer {
            fun_ptr: FPEnum::Standalone(foo_1)
        };
        move_to<FPContainer>(&s, fpc);
    }

    public fun store_funvec_container(s: signer) {
        let funs = vector::empty<FPEnum>();
        vector::push_back(&mut funs, FPEnum::Standalone(foo_1));
        let lambda = FPEnum::LambdaCapture {captured: 5, func: add_captured};
        vector::push_back(&mut funs, lambda);
        let fvc = FunVecContainer {funcs: funs};
        move_to<FunVecContainer>(&s, fvc);
    }

    public fun add_captured(x: u8, y: u8): u8 {
        x + y
    }

    // Call the stored standalone function
    public fun call_fp_container(s: signer, input: u8): u8 acquires FPContainer {
        let c_ref = borrow_global<FPContainer>(signer::address_of(&s));
        match &c_ref.fun_ptr {
            FPEnum::Standalone(f) => f(input),
            FPEnum::LambdaCapture {captured, func} => func(*captured, input),
        }
    }

    // Call the nth function in FunVecContainer
    public fun call_funvec_n(s: signer, n: u64, input: u8): u8 acquires FunVecContainer {
        let c_ref = borrow_global<FunVecContainer>(signer::address_of(&s));
        let fpenum_ref = vector::borrow(&c_ref.funcs, n);
        match fpenum_ref {
            FPEnum::Standalone(f) => f(input),
            FPEnum::LambdaCapture {captured, func} => func(*captured, input),
        }
    }

    // Compose nested enum and test match
    public fun test_nested() {
        let f1 = FPEnum::Standalone(foo_2);
        let nested1 = NestedFPEnum::Inner(f1);

        match nested1 {
            NestedFPEnum::Inner(fp) => {
                let res = match(fp) {
                    FPEnum::Standalone(f) => f(3u8),
                    FPEnum::LambdaCapture {captured, func} => func(*captured, 3u8),
                };
                assert!(res == 6, 100);
            },
            NestedFPEnum::None => {
                assert!(false, 101);
            }
        };

        let nested2 = NestedFPEnum::None;
        match nested2 {
            NestedFPEnum::None => {},
            NestedFPEnum::Inner(_) => {
                assert!(false, 102);
            }
        };
    }
}



//# run 0xCAFE::ByteStringTest::byte_string_vs_hex



//# run 0xCAFE::FunctionPointerEnums::store_fp_container --signers 0xBEEF



//# run 0xCAFE::FunctionPointerEnums::call_fp_container --signers 0xBEEF --args 10u8



//# run 0xCAFE::FunctionPointerEnums::store_funvec_container --signers 0xBEEF



//# run 0xCAFE::FunctionPointerEnums::call_funvec_n --signers 0xBEEF --args 0u64 10u8



//# run 0xCAFE::FunctionPointerEnums::call_funvec_n --signers 0xBEEF --args 1u64 10u8



//# run 0xCAFE::FunctionPointerEnums::test_nested
