//# publish
module 0xCAFE::StructsAndSpecsTest {
    use std::vector;
    use std::cmp;

    /// A simple struct with no recursion, has copy, drop, store and key for storage.
    struct Data has copy, drop, store, key {
        x: u64,
        y: bool,
        values: vector<u8>,
    }

    /// A non-recursive generic struct without key (hence cannot be stored globally)
    struct Wrapper<T> has copy, drop, store {
        inner: T,
        flag: bool,
    }

    /// Pure function (no side effects) for specification, allowed to call only pure functions.
    /// Computation involves standard vector and cmp module functions implicitly.
    /// This function doubles the sum of values and returns a boolean
    public fun pure_spec_function(data: &Data): bool {
        let sum: u64 = 0;
        let len = vector::length(&data.values);
        let mut i = 0;
        while (i < len) {
            // vector::borrow returns &u8, copy converts u8 -> u8 (copy)
            let val = *vector::borrow(&data.values, i) as u64;
            sum = sum + val;
            i = i + 1;
        };
        // compare sum * 2 with data.x using cmp::gt implicitly
        cmp::gt(sum * 2, data.x)
    }

    /// Function to create and return a Data struct
    public fun create_data(): Data {
        Data {
            x: 100,
            y: true,
            values: vector::empty<u8>()
        }
    }

    /// Function returning a Wrapper<Data> with specified values
    public fun create_wrapper(): Wrapper<Data> {
        let d = create_data();
        Wrapper<Data> {
            inner: d,
            flag: false,
        }
    }

    /// Entry function to run (no args), that calls our pure_spec_function and returns bool
    public fun runner(): bool {
        let data = create_data();
        pure_spec_function(&data)
    }
}
//# run 0xCAFE::StructsAndSpecsTest::runner

//# run
script {
    use 0xCAFE::StructsAndSpecsTest;

    fun main() {
        let result = StructsAndSpecsTest::runner();
        // no assert, just run to exercise compiler & VM
        let _ = result;
    }
}