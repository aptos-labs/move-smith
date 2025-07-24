//# publish
module 0xCAFE::PatternMatching {
    enum E has copy, drop {
        V1,
        V2(u32, u32),
        V3 {
            a: bool
        }
    }

    public fun match_example() {
        let e = E::V2(1, 2);
        let x = match (e) {
            E::V1 => 1,
            E::V2(x, y) => x+y,
            E::V3 { a } => if (a) {2} else {3},
        };

        // If assertion fails, abort with code 888
        assert!(x < 100, 888);
    }
}
