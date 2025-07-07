//# publish
module 0x1::TestTempOptional {

    use std::signer;

    /// A generic struct with an optional type parameter T.
    struct Wrapper<T> has copy, drop, store {
        value: T,
    }

    /// Creates a Wrapper<T> given a value of type T.
    public fun create_wrapper<T>(val: T): Wrapper<T> {
        Wrapper<T> { value: val }
    }

    /// A function with multiple argument types.
    /// It takes a bool, u64, and address and returns a tuple.
    public fun multi_args(a: bool, b: u64, c: address): (bool, u64, address) {
        // Use temporary expressions to store intermediate calculations.
        let temp_bool = !a;
        let temp_u64 = b + 1;
        let temp_addr = c;

        (temp_bool, temp_u64, temp_addr)
    }

    /// A function demonstrating usage of optional type parameter and temporaries.
    public fun wrap_and_toggle<T: copy + drop + store>(val: T, flag: bool): (Wrapper<T>, bool) {
        let wrapped = create_wrapper<T>(val);
        let toggled_flag = !flag;
        (wrapped, toggled_flag)
    }

    /// A runner function with no arguments, exercises the above functions.
    public fun runner(s: &signer) {
        // create wrapper with u8
        let w_u8 = create_wrapper<u8>(42);
        // call multi_args
        let (_b, _u, _a) = multi_args(true, 100, signer::address_of(s));
        // call wrap_and_toggle with bool
        let (_w, _f) = wrap_and_toggle<bool>(false, true);
    }
}
//# run 0x1::TestTempOptional::runner --signers 0x1


//# run
script {
    use std::signer;
    use 0x1::TestTempOptional;

    fun main(account: signer) {
        // Run multi_args directly
        let (b, u, a) = TestTempOptional::multi_args(false, 999, signer::address_of(&account));

        // Run create_wrapper with address type
        let w_addr = TestTempOptional::create_wrapper(signer::address_of(&account));

        // Run wrap_and_toggle with u64 and bool flag
        let (wrapper, flag) = TestTempOptional::wrap_and_toggle<u64>(123456, true);

        // Just bind to variables to exercise code generation and Vm runtime.
        let _ = b;
        let _ = u;
        let _ = a;
        let _ = w_addr;
        let _ = wrapper;
        let _ = flag;
    }
}