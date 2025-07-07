//# publish
module 0xtest::swap_tests {
    // Function to perform a simple swap of u8 values
    fun swap_u8(a: u8, b: u8): (u8, u8) {
        (a, b) = (b, a);
        (a, b)
    }

    // Function to swap fields within a struct
    struct Data {
        field1: u64,
        field2: u64,
    }

    fun swap_structs(x: Data, y: Data): (Data, Data) {
        (x, y) = (y, x);
        (x, y)
    }

    // Function to swap with a loop, toggling values
    fun swap_loop(x: u64, y: u64, n: u64): (u64, u64) {
        let mut i = 0;
        let mut a = x;
        let mut b = y;
        while (i < n) {
            (a, b) = (b, a);
            i = i + 1;
        }
        (a, b)
    }

    // Function to test swaps involving references
    fun swap_references(x: &mut u64, y: &mut u64) {
        (*x, *y) = (*y, *x);
    }

    // Function to test variable shadowing during swap
    fun swap_shadowing(x: u64, y: u64): (u64, u64) {
        let (x, y) = (y, x);
        (x, y)
    }

    // Runner function calling various swap functions
    public fun run_tests() {
        let (res1a, res1b) = swap_u8(5, 10);
        assert(res1a == 10);
        assert(res1b == 5);

        let data1 = Data {field1: 1, field2: 2};
        let data2 = Data {field1: 3, field2: 4};
        let (d1, d2) = swap_structs(data1, data2);
        assert(d1.field1 == 3 && d1.field2 == 4);
        assert(d2.field1 == 1 && d2.field2 == 2);

        let (mut x, mut y) = (7, 14);
        swap_references(&mut x, &mut y);
        assert(x == 14);
        assert(y == 7);

        let (res2a, res2b) = swap_loop(1, 2, 3);
        // Because swap occurs 3 times, they should end up swapped
        assert(res2a == 2);
        assert(res2b == 1);

        let (res3a, res3b) = swap_shadowing(100, 200);
        assert(res3a == 200);
        assert(res3b == 100);
    }
}

//# run 0xtest::swap_tests::run_tests