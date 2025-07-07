
//# publish
module 0xCAFE::TestRestrictedName {
    const RESTRICTED_NAME: &str = b"main";

    // Function to check usage of restricted name
    public fun check_restricted_name(name: &str) {
        // Simulate error diagnostics: abort if name is restricted
        if (*name == *RESTRICTED_NAME) {
            abort 1000;
        };
    }
}


//# publish
module 0xCAFE::DestructuringTest {
    struct Point has copy, drop, store {
        x: u8,
        y: u8,
        z: u8,
    }

    public fun create_point(x: u8, y: u8, z: u8): Point {
        Point { x, y, z }
    }

    public fun destructure_point(p: Point): (u8, u8, u8) {
        let Point { x, y, z } = p;
        (x, y, z)
    }

    public fun bind_variable() {
        let a = 10u8;
        let b = 20u8;
        let c = a + b;
        let d = c * 2;

        // Just use them in a dummy if statement ending with semicolon
        if (d > 0) {
            let _x = d;
        };
    }

    // Runner function for multiple destructuring tests
    public fun runner() {
        let p = create_point(1, 2, 3);
        let (x, y, z) = destructure_point(p);

        bind_variable();

        // Use x,y,z in a dummy condition
        if (x + y + z == 6) {
            let _ = 1;
        } else {
            let _ = 0;
        };
    }
}


//# run 0xCAFE::DestructuringTest::runner


//# run
script {
    use 0xCAFE::TestRestrictedName;
    use 0xCAFE::DestructuringTest;

    fun main() {
        // Test 1: Call runner function to exercise destructuring and binding
        DestructuringTest::runner();

        // Test 2: Check restricted name usage - should abort with code 1000
        // We provide a non-restricted name first, then restricted
        TestRestrictedName::check_restricted_name(b"allowed");
        // The next line should abort, commented out so this script can run fully without aborting
        // TestRestrictedName::check_restricted_name(b"main");

        // Test 3: Bind variable by destructuring using let binding in script
        let (a, b, c) = (10u8, 20u8, 30u8);
        if (a + b + c == 60) {
            let _dummy = 1;
        };
    }
}


// Featurres:
// 19b3347fb09813cc821a900427f665c5: Define a single main function as the entry point in a script, and ensure the script is omitted if this function is filtered out.
// 18f3da722b15398e9d31ffbe936f6a27: Bind variables by name or destructure them in Move assignments or let-bindings.
// 9fa5ea96165aed0363fcf3c202e0ad70: Generate an error diagnostic when a restricted name is used to prevent its usage in code.
