
//# publish
module 0xCAFE::FieldAndLetTest {
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
        z: u64,
    }

    struct Shortcut has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
    }

    // package visibility function to test package visibility
    package fun create_point(x: u64, y: u64, z: u64): Point {
        let p = Point { x: x, y, z: z }; // mixing explicit and shorthand fields
        p
    }

    public fun create_shortcut(a: u8, b: u8): Shortcut {
        let c = b;
        Shortcut { a, b: b, c } // use shorthand and explicit syntax mixed
    }
}


//# run
script {
    use 0xCAFE::FieldAndLetTest;
    fun main() {
        // Call package function inside the same package (in script is outside, but will test compiler)
        // Actually this won't compile because package fun is only accessible inside package
        // So call create_shortcut (public) instead
        let s = FieldAndLetTest::create_shortcut(1u8, 2u8);
        let p = FieldAndLetTest::create_shortcut(10u8, 20u8);
        // Just do some no-op to use variables
        let _ = s.a + s.b + s.c;
        let _ = p.a + p.b + p.c;
    }
}


// Featurres:
// eb85dfc6ca4661f5fece0860b0988924: Specify struct or tuple fields with either an explicit value expression after a ':' or use shorthand syntax to use the field name as the value.
// 343df347c63616183bef714434732b09: Create a let-binding for a symbol with a specified expression.
// 40695500bde0323f00aa864d292abae6: Declare functions or modules with 'package' visibility to restrict access within the same package.
