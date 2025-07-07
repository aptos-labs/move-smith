//# publish
module 0xCAFE::DeepNestedLambda {

    use std::vector;

    /// A higher-order function that takes a function f and a vector<u8>, applies f to each element.
    public fun map_bytes<F>(v: vector<u8>, f: F): vector<u8>
        where
            F: fun(u8): u8,
    {
        let mut res = vector::empty<u8>();
        let len = vector::length(&v);
        let mut i = 0;
        while (i < len) {
            let b = vector::borrow(&v, i);
            vector::push_back(&mut res, f(*b));
            i = i + 1;
        }
        res
    }

    /// A function that returns a lambda that returns a lambda that increments by amount
    /// Demonstrates deep nested lambdas
    public fun make_adder(amount: u8): impl fun(u8): u8 {
        // first lambda returns a lambda that adds amount
        move |x: u8| {
            move |y: u8| {
                (x + y + amount)  // u8 addition, safe since inputs small in test
            }
        }
    }

    /// A runner function that exercises the nested lambdas and byte serialization
    public fun runner(): vector<u8> {
        let bytes = b"MoveTest"; // vector<u8>
        let adder = make_adder(10u8);
        let inner_lambda = adder(1u8); // inner lambda: takes u8 -> u8
        // map bytes applying inner_lambda to each byte
        let mapped = map_bytes(bytes, inner_lambda);
        mapped
    }

    spec module {
        spec_block {
            // Spec variable: example_vec (vector<u8>)
            example_vec: vector<u8>;

            initialize {
                example_vec = b"specdata";
            }

            // Spec function to check length of example_vec
            spec fun example_len(): u64 {
                vector::length(&example_vec)
            }

            // Spec function that uses example_vec and returns first element
            spec fun first_byte(): u8 {
                let len = vector::length(&example_vec);
                if (len > 0) {
                    *vector::borrow(&example_vec, 0)
                } else {
                    0
                }
            }
        }
    }
}
//# run 0xCAFE::DeepNestedLambda::runner