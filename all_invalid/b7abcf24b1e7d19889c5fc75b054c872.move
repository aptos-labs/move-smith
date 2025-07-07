//# publish
module 0xCAFE::LambdaLift {
    use std::vector;

    // A function with an inline function inside to test lambda-lifting.
    public fun caller(x: u64, y: u64): u64 {
        // Inline function capturing x and y
        let inner = |z: u64| -> u64 { x + y + z };
        inner(10)
    }

    // A runner function for testing without params
    public fun runner(): u64 {
        caller(1, 2)
    }
}

//# run 0xCAFE::LambdaLift::runner

//# publish
module 0xCAFE::StarWildcard {
    // Using '*' as a wildcard type name or in some binding to test support

    // Function demonstrating wildcard pattern matching in a let binding
    public fun test_wildcard() {
        let (a, *, b) = (1u8, 2u8, 3u8);
        // use a and b somehow (noop)
        let _ = a + b;
    }

    // Function using '*' as a wildcard for a generic type placeholder in specs (allowed in spec lang)
    spec module {
        spec test_wildcard {
            // dummy spec using * in an assignable placeholder positions
            ensures true;
        }
    }

    // Runner function
    public fun runner() {
        test_wildcard();
    }
}

//# run 0xCAFE::StarWildcard::runner

//# publish
module 0xCAFE::SpecRewrite {

    struct Counter has store {
        value: u64,
    }

    public fun new(): Counter {
        Counter { value: 0 }
    }

    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    public fun get(counter: &Counter): u64 {
        counter.value
    }

    // Runner function increments counter multiple times
    public fun runner(): u64 {
        let mut c = new();
        increment(&mut c);
        increment(&mut c);
        get(&c)
    }

    // Rewritten specs - testing spec rewriting with improvements
    spec module {
        invariant forall c: Counter :: c.value >= 0;

        spec increment {
            requires true;
            ensures old(counter.value) + 1 == counter.value;
        }

        spec get {
            ensures result == counter.value;
        }
    }
}

//# run 0xCAFE::SpecRewrite::runner

// Featurres:
// 7d35bcdcd7fa95684809842a52652a35: Enable lambda-lifting on functions, including optionally lifting inline functions in Move 2.2 and above
// 01b3da323fc7fbad7b996ceadd3198ce: Use '*' as a wildcard name in Move code.
// b55ad2e03b67074aa23a762dfdf31657: Rewrite specifications for Move modules and functions to improve or transform them
