
//# publish
module 0xCAFE::ConstAndViewTest {
    use std::signer;

    // Constant of type u64
    const CONST_U64: u64 = 0xABCDEF123456_u64;

    // Constant of type bool
    const CONST_BOOL: bool = true;

    // Constant of type vector<u8>
    const CONST_BYTES: vector<u8> = b"TestBytes";

    // Constant struct
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    const CONST_POINT: Point = Point { x: 10u64, y: 20u64 };

    // A resource to test storing at address and reading values
    struct Resource has key, store {
        val: u64,
        flag: bool,
        data: vector<u8>,
        pt: Point,
    }

    // Function to store the resource with value from constants
    public fun store_constants(s: signer) {
        let r = Resource {
            val: CONST_U64,
            flag: CONST_BOOL,
            data: CONST_BYTES,
            pt: CONST_POINT,
        };
        move_to<Resource>(&s, r);
    }

    // Function reads values inside resource, uses constants in computations, exercises view variable coalescing
    public fun read_and_combine(s: &signer): u64 {
        let addr = signer::address_of(s);

        let r_ref: &Resource = borrow_global<Resource>(addr);

        // Use constant u64 and struct fields, create local view variables to test coalescing
        let val = r_ref.val;
        let flag = r_ref.flag;
        let data_len = vector::length(&r_ref.data);
        let pt_x = r_ref.pt.x;
        let pt_y = r_ref.pt.y;

        let add_const = val + CONST_U64;
        let sum_point = pt_x + pt_y;

        let cond = if (flag == CONST_BOOL) {
            add_const + sum_point + (data_len as u64)
        } else {
            0u64
        };

        cond
    }

    // A runner function to store at address and then read and combine without args
    public fun runner(s: signer): u64 {
        store_constants(s);
        read_and_combine(&s)
    }
}


//# run 0xCAFE::ConstAndViewTest::runner --signers 0xBEEFBEEF


// Featurres:
// 3c605606d345f39f10c9151d0ce26cf4: View variable coalescing optimizations as annotations on the bytecode.
// 8a5cb990b1570b78444d402787827539: Access constant types and values through move module constants.
// c5a0d477827863ddf81ca5a14e3c47b0: Use named constants from modules as u64 values in Move code.
