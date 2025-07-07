//# publish
module 0xA::tuple_destructure {
    struct Pair<T, U> {
        first: T,
        second: U,
    }

    fun compute_difference(x: u64, y: u64): u64 {
        let Pair(y, x) = Pair { first: x, second: y };
        x - y
    }

    fun test_difference() {
        assert!(compute_difference(10, 3) == 7, 42);
    }

    fun runner() {
        Self::test_difference();
    }
}

//# run --verbose -- 0xA::tuple_destructure::runner

//# publish
module 0xA::nested_destruct {
    struct Outer<T> {
        inner: T,
    }

    struct Inner<U> {
        a: U,
        b: U,
    }

    fun process_nested(outer: Outer<Inner<u64>>): u64 {
        let Outer { inner: Inner { a, b } } = outer;
        b - a
    }

    fun test_nested() {
        let inner = Inner { a: 5, b: 15 };
        let outer = Outer { inner };
        assert!(process_nested(outer) == 10, 42);
    }

    fun runner() {
        Self::test_nested();
    }
}

//# run --verbose -- 0xA::nested_destruct::runner