
//# publish
module 0xCAFE::ControlFlowMutabilityMatch {
    use std::signer;
    use std::vector;

    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    // 1. Loop and Variable Mutability
    // Returns the sum of numbers from 0 to 4 using a loop with immutable loop variable.
    public fun loop_sum(): u8 {
        let acc = 0u8;
        // Use loop with break 
        let i = 0u8;
        loop {
            if (i == 5) {
                break;
            };
            acc = acc + i;
            i = i + 1;
        };
        acc
    }

    // 1. Loop where we demonstrate reassignment of loop variable is not possible
    // because loop variable is explicitly immutable.
    // So, we simulate loop variable immutability by using separate mutable variable for loop.
    // We verify that `x` is immutable by trying to reassign it in comments (compile error otherwise).

    // 2. Struct Copy, Mutable References, and Field Mutation
    public fun struct_mutability(): (u8, u8) {
        let p1 = Point { x: 7, y: 8 };
        let p2 = p1; // copy p1 to p2
        let p2_copy = p2; // create a mutable copy
        let p2_ref: &mut Point = &mut p2_copy;
        // mutate p2_ref.x, should not affect p1.x
        p2_ref.x = 9;
        // return original p1.x and mutated p2_ref.x
        (p1.x, p2_ref.x)
    }

    // 3. Pattern Matching with Direct Binding

    // Function with tuple parameter - destructure inside the function body
    public fun match_tuple_param(val: (u8, u8)): u8 {
        let a = val.0;
        let b = val.1;
        a + b
    }

    // Function with struct parameter - destructure inside the function body
    public fun match_struct_param(p: Point): u8 {
        let x = p.x;
        let y = p.y;
        x * y
    }

    // Using match expressions to destructure and bind variables
    public fun match_expression(val: u8): u8 {
        let p = Point {x: val, y: val + 1};
        match (p) {
            Point {x, y} => x + y,
        }
    }

    // 4. Combined scenario:
    // Iterate over vector of Points, mutate y field of each via mutable reference,
    // Immutable loop variable i used for indexing.
    public fun loop_pattern_mutate(): u8 {
        let points = vector[Point {x: 1, y: 2}, Point {x: 3, y: 4}, Point {x: 5, y: 6}];
        let len = vector::length(&points);
        let sum_y = 0u8;

        let idx = 0u64;
        while (idx < len) {
            let p_ref: &mut Point = vector::borrow_mut(&mut points, idx);

            // Pattern matching bind fields
            let Point {x, y} = *p_ref;
            // mutate y field via mutable ref
            p_ref.y = y + 10;

            sum_y = sum_y + p_ref.y;
            idx = idx + 1;
        };
        sum_y
    }

    // Helper that calls functions that test patterns of multiple parameters and struct field mutation
    public fun runner() {
        let _ = loop_sum();
        let _ = struct_mutability();
        let _ = match_tuple_param((10u8, 20u8));
        let _ = match_struct_param(Point {x: 3, y: 4});
        let _ = match_expression(5u8);
        let _ = loop_pattern_mutate();
    }
}



//# run 0xCAFE::ControlFlowMutabilityMatch::loop_sum



//# run 0xCAFE::ControlFlowMutabilityMatch::struct_mutability



//# run 0xCAFE::ControlFlowMutabilityMatch::match_tuple_param --args 11u8 22u8



//# run 0xCAFE::ControlFlowMutabilityMatch::match_struct_param --args 3u8 4u8



//# run 0xCAFE::ControlFlowMutabilityMatch::match_expression --args 7u8



//# run 0xCAFE::ControlFlowMutabilityMatch::loop_pattern_mutate



//# run 0xCAFE::ControlFlowMutabilityMatch::runner
