
//# publish
    module NativeAndOps {
        use std::signer;

        native public fun native_add(x: u64, y: u64): u64;

        native public fun native_subtract(x: u64, y: u64): u64;

        struct Data has store {
            value: u64,
            flags: u8,
        }

        public fun test_ops(x: u64, y: u64): (u64, u64, u64, u64, u64, u8, u8, u8, u8, u8, u8) {
            let a = x;
            let b = x;
            let c = x;
            let d = x;
            let e = x;
            let f: u8 = 0b0011_1100;
            let g: u8 = 0b0000_1111;
            let h: u8 = 0b1010_1010;
            let i: u8 = 0b1111_0000;
            let j: u8 = 2;
            let k: u8 = 240;

            // Combined assignments
            a += y;
            b -= y;
            c *= y;
            d /= y;
            e %= y;

            f |= g;     // bitwise OR
            h &= i;     // bitwise AND
            j ^= 1;     // bitwise XOR
            k <<= 2;    // left shift
            k >>= 3;    // right shift
            (a, b, c, d, e, f, h, j, k, f, g)
        }

        public fun create_data(s: signer, init_value: u64, init_flags: u8) {
            let data = Data { value: init_value, flags: init_flags };
            move_to<Data>(&s, data);
        }

        public fun update_data(s: signer) {
            let data_mut = borrow_global_mut<Data>(signer::address_of(&s));
            data_mut.value += 10;
            data_mut.flags |= 1;
        }

        public fun read_data(s: signer): (u64, u8) {
            let data_ref = borrow_global<Data>(signer::address_of(&s));
            (data_ref.value, data_ref.flags)
        }
    }
}


//# run 0xCAFE::NativeAndOps::test_ops --args 10u64 3u64


//# run 0xCAFE::NativeAndOps::create_data --signers 0xDEAD --args 100u64 12u8


//# run 0xCAFE::NativeAndOps::update_data --signers 0xDEAD


//# run 0xCAFE::NativeAndOps::read_data --signers 0xDEAD


// Featurres:
// ff0e1ae15b3f12bb2b442c47cdeae366: Declare a module inside an 'address <address> { ... }' block to assign the sender address.
// d1609e55ff669121ba8962ce845350fc: Define native functions that have no Move code body.
// 3df0ef442032dba0d5e22544d91c02b8: Use combined assignment operators such as +=, -=, *=, %=, /=, |=, &=, ^=, <<=, >>= in Move code.
