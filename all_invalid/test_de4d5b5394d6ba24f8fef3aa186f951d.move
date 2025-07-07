//# publish
module 0x1::calculator {
    fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    fun sum_of_three(x: u64, y: u64, z: u64): u64 {
        x + y + z
    }

    public fun compute_special_value() : u64 {
        let (a, b, c) = (2, 3, 4);
        let product = multiply(a, b);
        let sum = sum_of_three(a, b, c);
        add(product, sum)
    }

    fun add(a: u64, b: u64): u64 {
        a + b
    }
}

//# run 0x1::calculator::compute_special_value

//# run 0x1::calculator::multiply --args 5 6
//# run 0x1::calculator::sum_of_three --args 7 8 9