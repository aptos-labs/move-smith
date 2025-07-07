public fun unpack_and_return<T, U>(cs: ComplexStruct<T, U>): (u64, option::Option<U>) {
    let ComplexStruct { a, b: _b, c } = cs;
    (a, c)
}
