//# publish
module 0xA11CE::counter {
    fun inc(count: &mut u64): u64 {
        *count = *count + 1;
        *count
    }

    public fun nested_incr1(): u64 {
        let mut total = 0;
        total = inc(&mut total);
        total
    }

    public fun nested_incr2(): u64 {
        let mut counter = 0;
        // First call
        inc(&mut counter);
        // Nested call that calls inc multiple times
        let nested_total = {
            let mut temp = 0;
            inc(&mut temp);
            inc(&mut temp);
            inc(&mut temp);
            temp
        };
        // Second nested block
        let nested_total2 = {
            let mut temp2 = counter;
            inc(&mut temp2);
            inc(&mut temp2);
            temp2
        };
        inc(&mut counter);
        counter + nested_total + nested_total2
    }
}

//# run 0xA11CE::counter::nested_incr1
//# run 0xA11CE::counter::nested_incr2

//# publish
module 0xB0B::MultiLayer {
    public inline fun double(x: u64): u64 {
        x * 2
    }

    public inline fun triple(x: u64): u64 {
        x * 3
    }
}

//# publish
module 0xB0B::Main {
    use 0xB0B::MultiLayer;

    public fun compute_value(): u64 {
        let base = 5;
        let doubled = MultiLayer::double(base);
        let tripled = MultiLayer::triple(doubled);
        tripled + MultiLayer::double(tripled)
    }

    public fun run(): u64 {
        compute_value()
    }
}

//# run 0xB0B::Main::run