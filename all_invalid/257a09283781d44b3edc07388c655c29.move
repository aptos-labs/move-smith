
//# publish
module 0xCAFE::MultiReturnAndGenerics {
    use std::vector;
    use std::signer;

    struct Wrapper<T> has copy, drop, store {
        data: T
    }

    public fun make_tuple(a: u8, b: u16): (u8, u16, bool) {
        (a, b, b > 10)
    }

    public fun return_generic_with_tuple<T: copy>(value: T): (Wrapper<T>, (T, bool)) {
        let w = Wrapper<T> { data: value };
        let t = (value, true);
        (w, t)
    }

    public fun run_all(): (u8, u16, bool, Wrapper<u8>, (u8, bool)) {
        let (x, y, z) = make_tuple(7u8, 20u16);

        let (w, t) = return_generic_with_tuple<u8>(42u8);

        (x, y, z, w, t)
    }
}


//# run 0xCAFE::MultiReturnAndGenerics::make_tuple --args 5u8 15u16


//# run 0xCAFE::MultiReturnAndGenerics::return_generic_with_tuple --args 12u8


//# run 0xCAFE::MultiReturnAndGenerics::run_all


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 39a5276d71bb4576631a14e3c7dab09f: Support functions with multiple return values by generating appropriate result temporaries and labels.
// 747b4002faaa7e337217152de6e1ffb0: Automatically generate type parameter syntax with proper formatting and numbering.
