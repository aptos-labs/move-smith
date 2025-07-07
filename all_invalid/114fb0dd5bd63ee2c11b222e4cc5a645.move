
//# publish
module 0xCAFE::MultiReturnAndGenerics {
    struct Wrapper<T> has copy, drop, store {
        data: T
    }

    public fun make_tuple(a: u8, b: u16): (u8, u16, bool) {
        (a, b, b > 10)
    }

    /// Since Move tuples cannot be nested, replace `(Wrapper<T>, (T, bool))`
    /// with a struct to hold the two parts.

    struct GenericReturn<T: copy> has copy, drop, store {
        w: Wrapper<T>,
        value: T,
        flag: bool,
    }

    public fun return_generic_with_tuple<T: copy>(value: T): GenericReturn<T> {
        let w = Wrapper<T> { data: value };
        GenericReturn {
            w,
            value,
            flag: true,
        }
    }

    /// Similarly for run_all, flatten the return types:
    struct RunAllReturn has copy, drop, store {
        x: u8,
        y: u16,
        z: bool,
        w: Wrapper<u8>,
        value: u8,
        flag: bool,
    }

    public fun run_all(): RunAllReturn {
        let (x, y, z) = make_tuple(7u8, 20u16);
        let ret = return_generic_with_tuple<u8>(42u8);
        RunAllReturn {
            x,
            y,
            z,
            w: ret.w,
            value: ret.value,
            flag: ret.flag,
        }
    }
}




//# run 0xCAFE::MultiReturnAndGenerics::make_tuple --args 5u8 15u16




//# run 0xCAFE::MultiReturnAndGenerics::return_generic_with_tuple<u8> --args 12u8




//# run 0xCAFE::MultiReturnAndGenerics::run_all
