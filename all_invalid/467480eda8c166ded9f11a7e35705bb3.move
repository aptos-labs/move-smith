
//# publish
module 0xCAFE::GenericFunctions {
    use std::vector;

    struct Pair<T, U> has copy, drop, store {
        first: T,
        second: U,
    }

    // Generic function with type parameters and return generic struct
    public fun make_pair<T, U>(a: T, b: U): Pair<T, U> {
        Pair { first: a, second: b }
    }

    // Generic function that takes a Pair struct and returns a tuple of its fields
    public fun unpack_pair<T, U>(p: Pair<T, U>): (T, U) {
        let Pair { first: f, second: s } = p;
        (f, s)
    }

    // Function to demonstrate binding multiple fields via named unpacking
    public fun sum_pair(p: Pair<u64, u64>): u64 {
        let Pair { first: x, second: y } = p;
        x + y
    }

    // Runner with no args to test generic functions with concrete types
    public fun runner() {
        let p = make_pair<u8, bool>(42u8, true);
        let (a, b) = unpack_pair(p);
        let _ = sum_pair(make_pair<u64, u64>(10u64, 32u64));
    }
}


//# run 0xCAFE::GenericFunctions::runner



//# publish
module 0xCAFE::DataBinding {
    struct Rectangle has copy, drop, store {
        width: u64,
        height: u64,
        tag: u8,
    }

    // Unpack with named fields then rebind fields with new values, returning new struct
    public fun transform(rect: Rectangle): Rectangle {
        let Rectangle { width: w, height: h, tag: t } = rect;
        // Example of destructuring assignment with named binding
        let Rectangle { width: new_w, height: new_h, tag: new_t } = Rectangle { width: w * 2, height: h * 3, tag: t + 1 };
        Rectangle { width: new_w, height: new_h, tag: new_t }
    }

    // Function returning multiple unpacked values from a struct
    public fun extract_width_height(rect: Rectangle): (u64, u64) {
        let Rectangle { width, height, tag: _ } = rect;
        (width, height)
    }

    public fun runner() {
        let r = Rectangle { width: 3, height: 4, tag: 7 };
        let r2 = transform(r);
        let (w, h) = extract_width_height(r2);
        let _ = w + h;
    }
}


//# run 0xCAFE::DataBinding::runner



//# publish
module 0xCAFE::ResetEnvironment {
    use std::vector;

    // A dummy global resource for demonstration
    struct Dummy has key, store {
        value: u64,
    }

    // Initialize by moving a Dummy resource under signer's address
    public fun initialize(s: signer, val: u64) {
        move_to<Dummy>(&s, Dummy { value: val });
    }

    // Function to reset environment by removing Dummy resource if exists
    public fun reset(s: signer) {
        if (exists<Dummy>(signer::address_of(&s))) {
            let dummy = move_from<Dummy>(signer::address_of(&s));
            let Dummy { value: _ } = dummy; // destructure to satisfy pattern matching rules
        };
    }

    // Runner to test initialize and reset without args
    public fun runner(s: signer) {
        initialize(s, 100);
        reset(s);
    }
}


//# run 0xCAFE::ResetEnvironment::runner --signers 0xD00D


// Featurres:
// 489718260789658c9b35c888eb0c9513: Use type parameters within functions to enable generic programming.
// 19e7b9eb0c2af9697d14c36ad6ae53a4: Bind multiple fields of a struct or schema using named unpacking patterns in bindings and destructuring assignments.
// 97f60111f16e741afe23461b3eea8e48: Reset the environment to treat every component as a target after analysis, allowing for subsequent analyses without reinitialization.
