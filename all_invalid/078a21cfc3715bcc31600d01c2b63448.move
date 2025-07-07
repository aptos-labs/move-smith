//# publish
address 0xCAFE {
    module UnpackVariadic {
        struct S {
            u64,
            bool,
            vector<u8>,
        }

        public fun create_s(): S {
            // Create a struct with fields 42u64, true, and vector [1,2,3]
            S {
                42u64,
                true,
                vector::empty<u8>(),
            }
        }

        public fun populate_vector(s: &mut S) {
            // Borrow s and push to the vector field (the 3rd field)
            // Unpack s to access fields using parentheses
            let (num, flag, vec) = s;
            vector::push_back(vec, 10u8);
            vector::push_back(vec, 11u8);
        }

        public fun unpack_positional() {
            // Create a struct instance
            let s = create_s();

            // Unpack s unnamed fields: (a, b, c)
            let (a, b, c) = s;

            // use a, b, c to avoid warning (we do nothing here)
            let _ = a;
            let _ = b;
            let _ = c;
        }

        public fun borrow_and_modify(s: &mut S) {
            // Show that s can be modified through mutable reference
            let (_num, _flag, vec) = s;
            vector::push_back(vec, 100u8);
        }

        public fun borrow_read_only(s: &S) {
            let (num, flag, vec) = s;
            let _ = num;
            let _ = flag;
            let _ = vector::length(vec);
        }

        public fun runner() {
            // Runner function to test parameter passing and modification
            let mut s = create_s();
            borrow_and_modify(&mut s);
            borrow_read_only(&s);
            unpack_positional();
            populate_vector(&mut s);
        }
    }
}

//# run 0xCAFE::UnpackVariadic::runner

//# run 0xCAFE::UnpackVariadic::borrow_and_modify --args  (0x0: UnpackVariadic::S) --signers 0xCAFE

//# run
script {
    use 0xCAFE::UnpackVariadic;

    fun main() {
        let mut s = UnpackVariadic::create_s();
        // Pass by mutable reference
        UnpackVariadic::borrow_and_modify(&mut s);
        // Pass by immutable reference
        UnpackVariadic::borrow_read_only(&s);

        // Unpack with positional pattern
        let (x, y, z) = s;
        let _ = x;
        let _ = y;
        let _ = z;
    }
}

// Featurres:
// 658c370286e5120b04fb80ff03facf17: Use positional unpacking syntax with parentheses for unnamed fields or variadic arguments
// d3ce1d7e9ed24a62b04be31501fee6e6: Declare the 'address' keyword to initiate an address block.
// ae3e0fd97f4a7a5808a654b0685098ad: Pass function parameters by reference or value and determine if parameters are possibly modified by move or borrow operations.
