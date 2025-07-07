module 0x1::TestPositionalFields {

    use std::vector;
    use std::debug;

    /// A struct with positional fields (0, 1)
    struct Point has copy, drop, store {
        0: u64,
        1: u64,
    }

    /// A struct with a nested `Point` and another value — to test dotted field access and mutation
    struct Shape has copy, drop, store {
        0: Point,
        1: bool,
    }

    /// Entry function to test all requested features.
    public entry fun test(): bool {
        // 1. Use positional fields by numeric literals when referring to fields

        // Create a Point with coordinates (10, 20)
        let mut p = Point { 0: 10, 1: 20 };

        // Assert initial values using positional fields and destructuring
        debug::assert(p.0 == 10, 101);
        debug::assert(p.1 == 20, 102);

        // 2. Use pattern matching with `..` wildcard/rest pattern

        // Destructure Point with pattern matching - only capture the first field explicitly
        let Point { 0: x_coord, .. } = p;
        debug::assert(x_coord == 10, 103);

        // Destructure with the rest pattern, ignoring all fields except the second
        let Point { 1: y_coord, .. } = p;
        debug::assert(y_coord == 20, 104);

        // 3. Mutate a field of a dotted expression (nested mutation)

        // Create a Shape with the point p and a bool flag
        let mut s = Shape { 0: p, 1: false };

        // Mutate the nested Point inside Shape using dotted syntax
        s.0.0 = 30;   // Change x from 10 to 30
        s.0.1 = 40;   // Change y from 20 to 40
        
        // Mutate the bool flag too
        s.1 = true;

        // Verify mutations
        debug::assert(s.0.0 == 30, 105);
        debug::assert(s.0.1 == 40, 106);
        debug::assert(s.1 == true, 107);

        // Further destructure s.0 and match with .. pattern again after mutation
        let Point { 0: new_x, .. } = s.0;
        let Point { 1: new_y, .. } = s.0;

        debug::assert(new_x == 30, 108);
        debug::assert(new_y == 40, 109);

        true
    }
}

// Featurres:
// fb945d0ba577a3bb19b24dce900e88ac: Use positional fields represented by numeric literals (`0`, `1`, etc.) in your Move code when referring to positional data.
// 171c22c0369c26a126b96ee734d1fedb: Write patterns with `..` (dot-dot) syntax to denote a wildcard or rest pattern in pattern matching
// e5a9f20cbc4cc3520d50fe5de32ba095: Mutate a field of a dotted expression when possible, enabling nested field mutation.
