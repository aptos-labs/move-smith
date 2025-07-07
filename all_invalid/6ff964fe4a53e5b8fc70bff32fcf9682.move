
//# publish
module 0xCAFE::PatternTest {
    struct S has store {
        val: u8,
        flag: bool,
    }

    struct Container<T> has store {
        item: T,
    }

    public fun pattern_bind() {
        let (a, b) = (10u8, true);
        let s = S {val: a, flag: b};

        let Container<S> {item: inner_s} = Container<S> {item: s};
        let Container<u8> {item: n} = Container<u8> {item: 42u8};

        let Container<bool> {item: flag} = Container<bool> {item: false};
    }

    public fun while_modify_struct() {
        let s = S { val: 0u8, flag: true};
        while (s.val < 5) {
            // Use an inline block to get mutable reference and update field
            {
                let ref_mut_s: &mut S = &mut s;
                ref_mut_s.val = ref_mut_s.val + 1;
            };
        };
    }

    public fun generic_function<T>(item: T): Container<T> {
        Container<T> {item}
    }

    public fun generic_struct_usage() {
        let cont = generic_function<S>(S {val: 7u8, flag: false});
        let Container<S> {item} = cont;
        let _v = item.val;
        let _f = item.flag;
    }
}


//# run 0xCAFE::PatternTest::pattern_bind


//# run 0xCAFE::PatternTest::while_modify_struct


//# run 0xCAFE::PatternTest::generic_struct_usage


// Featurres:
// 0398755694b591d2da1013f326ff1117: Pattern-bind values to local variables in Move blocks, with or without an explicit type.
// beba1f5415671ca9544da1e91fa5f84a: Test that a while loop with mutable reference modification inside an inline block correctly updates the struct’s field and maintains valid bytecode without verifier errors.
// ed834f585afc143c8a555e6c1489a6cd: Declare type parameters for generic structs or functions in Move.
