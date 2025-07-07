
//# publish
module 0xCAFE::Computation {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 200) {
            42u8
        } else {
            24u8
        }
    }

    public inline fun add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Computation;

    public fun nested_calls(a: u8, b: u8): u8 {
        let s = Computation::add(a, b);
        Computation::add(s, 10u8)
    }
}



//# publish
module 0xCAFE::GreatestProduct {
    use std::vector;

    public fun greatest_product_of_4(): u64 {
        let digits = vector[1u8, 2u8, 3u8, 4u8, 5u8, 6u8, 7u8, 8u8, 9u8];
        let len = vector::length(&digits);
        let max_product = 0u64;
        let i = 0u64;
        while (i + 3 < (len as u64)) {
            let d0 = vector::borrow(&digits, i);
            let d1 = vector::borrow(&digits, i + 1);
            let d2 = vector::borrow(&digits, i + 2);
            let d3 = vector::borrow(&digits, i + 3);
            let product = (*d0 as u64) * (*d1 as u64) * (*d2 as u64) * (*d3 as u64);
            if (product > max_product) {
                max_product = product;
            };
            i = i + 1;
        };
        max_product
    }
}



//# publish
module 0xCAFE::NestedGenerics {
    struct Wrapper<T> has copy, drop, store {
        value: T,
    }

    struct DoubleWrapper<T> has copy, drop, store {
        inner: Wrapper<Wrapper<T>>,
    }

    public fun create_double_wrapper(value: u8): DoubleWrapper<u8> {
        let w1 = Wrapper { value };
        let w2 = Wrapper { value: w1 };
        DoubleWrapper { inner: w2 }
    }
}



//# run 0xCAFE::Computation::add_and_return --args 100u8 150u8



//# run 0xCAFE::NestedCall::nested_calls --args 20u8 22u8



//# run 0xCAFE::GreatestProduct::greatest_product_of_4



//# run 0xCAFE::NestedGenerics::create_double_wrapper --args 55u8
