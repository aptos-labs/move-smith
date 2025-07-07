//# publish
module 0xabc123::nested_control {

    // Testing nested loops with break to exit inner loop and update variables accordingly
    //# run
    script {
        fun main() {
            let outer_var = 0;
            let inner_var = 0;
            let mut count = 0;

            while (count < 2) {
                loop {
                    inner_var = inner_var + 10;
                    if (inner_var >= 20) {
                        break;
                    }
                };
                outer_var = outer_var + 1;
                count = count + 1;
                if (outer_var >= 2) {
                    break;
                }
            };

            assert!(outer_var == 2, 42);
            assert!(inner_var == 20, 42);
        }
    }

    //# run 0xabc123::nested_control::main
}

//# publish
module 0xdef456::struct_destruct {

    struct Point has copy, drop {
        x: u64,
        y: u64,
        z: u64,
    }

    public fun compute_sum(): u64 {
        let a = 3;
        let b = 4;
        let c = 5;
        // Destructure with inline initializations
        let Point { x, y, z } = Point { x: a + 1, y: b + 2, z: c + 3 };
        // Sum the fields
        x + y + z
    }
}

//# run 0xdef456::struct_destruct::compute_sum