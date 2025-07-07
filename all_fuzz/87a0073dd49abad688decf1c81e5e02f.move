
//# publish
module 0xCAFE::ConstAndViewTest {
    use std::signer;
    use std::vector;

    // Constant of type u64
    const CONST_U64: u64 = 0xABCDEF123456_u64;

    // Constant of type bool
    const CONST_BOOL: bool = true;

    // Constant of type vector<u8>
    const CONST_BYTES: vector<u8> = b"TestBytes";

    // Struct definition remains the same
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Since Move does not allow struct constants, remove CONST_POINT constant
    // and instead create a pure function to return the Point instance
    public fun get_const_point(): Point {
        Point { x: 10u64, y: 20u64 }
    }

    // A resource to test storing at address and reading values
    struct Resource has key, store {
        val: u64,
        flag: bool,
        data: vector<u8>,
        pt: Point,
    }

    // Function to store the resource with value from constants and get_const_point function
    public fun store_constants(s: signer) {
        let r = Resource {
            val: CONST_U64,
            flag: CONST_BOOL,
            data: CONST_BYTES,
            pt: get_const_point(),
        };
        move_to<Resource>(&s, r);
    }

    // Function reads values inside resource, uses constants and function in computations, exercises view variable coalescing
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
