
//# publish
module 0xCAFE::FilterAndAnnotate {
    use std::vector;

    struct Item has copy, drop, store {
        id: u8,
        flag: bool,
    }

    public fun filter_items(v: vector<Item>, keep_flag: bool): vector<Item> {
        let result: vector<Item> = vector::empty<Item>();
        let i = 0;
        while (i < vector::length(&v)) {
            let item_ref: &Item = vector::borrow(&v, i);
            if (item_ref.flag == keep_flag) {
                vector::push_back(&mut result, *item_ref);
            };
            i = i + 1;
        };
        result
    }

    public inline fun square(x: u8): u8 {
        x * x
    }

    public inline fun sum_of_squares(a: u8, b: u8): u8 {
        let sa: u8 = square(a);
        let sb: u8 = square(b);
        sa + sb
    }

    public fun compute(): u8 {
        let a: u8 = 3;
        let b: u8 = 4;
        // nested inline function call usage, expecting 3^2 + 4^2 = 9 + 16 = 25
        let res: u8 = sum_of_squares(a, b);
        res
    }
}



//# run 0xCAFE::FilterAndAnnotate::filter_items --args "0xCAFE::FilterAndAnnotate::Item(id=1u8,flag=true)" "0xCAFE::FilterAndAnnotate::Item(id=2u8,flag=false)" "0xCAFE::FilterAndAnnotate::Item(id=3u8,flag=true)" true



//# run 0xCAFE::FilterAndAnnotate::compute
