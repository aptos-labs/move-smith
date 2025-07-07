
//# publish
module 0xCAFE::TestFeatures {
    // This module tests addition, lambdas, mutation, and list construction
    use std::vector;

    struct Pair has copy, drop {
        a: u8,
        b: u8,
    }

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_addition(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add(x, y)
    }

    public fun mutate_variables(x: u8): u8 {
        let mut_x = x + 1;
        let mut_y = mut_x * 2;
        let mut_y = mut_y + 3;
        mut_y
    }

    public fun mutate_struct_fields(): u8 {
        let pair = Pair {a: 1, b: 2};
        pair.a = pair.a + 10;
        pair.b = pair.b + 20;
        pair.a + pair.b
    }

    public fun build_comma_separated_list(): vector<u8> {
        // Use vector::empty and vector::push_back to build the vector explicitly
        let list = vector::empty<u8>();
        vector::push_back(&mut list, 49); // ASCII for '1'
        vector::push_back(&mut list, 44); // ASCII for ','
        vector::push_back(&mut list, 50); // ASCII for '2'
        vector::push_back(&mut list, 44); // ASCII for ','
        vector::push_back(&mut list, 51); // ASCII for '3'
        list
    }

    public fun runner() {
        let _ = add_and_return_sum(5u8, 7u8);
        let _ = lambda_addition(3u8, 4u8);
        let _ = mutate_variables(2u8);
        let _ = mutate_struct_fields();
        let _ = build_comma_separated_list();
    }
}


//# run 0xCAFE::TestFeatures::runner
