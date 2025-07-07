//# publish
module 0xCAFE::NestedStruct {
    struct Inner has copy, drop, store {
        a: u64,
        b: u64,
    }

    struct Outer has copy, drop, store {
        x: Inner,
        y: u64,
        z: u8,
    }

    public fun make_outer(): Outer {
        let inner = Inner { a: 10u64 + 5u64, b: 20u64 * 2u64 };
        let outer = Outer { x: inner, y: 7u64 + 3u64, z: (4 + 1) as u8 };
        outer
    }

    public fun sum_outer(outer: &Outer): u64 {
        let Inner { a, b } = outer.x;
        a + b + outer.y + (outer.z as u64)
    }

    public fun runner(): u64 {
        let o = make_outer();
        sum_outer(&o)
    }
}
//# run 0xCAFE::NestedStruct::runner

//# run
script {
    use 0xCAFE::NestedStruct;

    fun main() {
        let result = NestedStruct::runner();
        // no assertion per instructions
        let mut count = 0u64;
        loop {
            count = count + 1u64;
            if (count == 5u64) {
                break;
            }
        };
        // result and loop tested, no output needed
    }
}