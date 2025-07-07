//# publish
address 0xCAFE {
    module ModuleA {
        use std::signer;
        use std::vector;

        // constants
        const CONST_ONE: u8 = 1;
        const CONST_TWO: u8 = 2;

        // copied struct
        struct CopyStruct has copy, drop, store, key {
            x: u8,
            y: u16,
        }

        // stored struct
        struct StoreStruct has drop, store {
            data: u64,
        }

        // public function without arguments
        public fun return_const_one(): u8 {
            CONST_ONE
        }

        // public function with argument and return result(x + y)
        public fun add_u8(x: u8, y: u8): u8 {
            x + y
        }

        // public function returning a struct
        public fun create_copy_struct(x: u8, y: u16): CopyStruct {
            CopyStruct { x, y }
        }

        // runner function for tests
        public fun runner() {
            let one = return_const_one();
            let sum = add_u8(one, CONST_TWO);
            let _cs = create_copy_struct(sum, 42);
        }

        spec module {
            // specification constants
            const SPEC_CONST: u8 = 10;

            // specification function with unary and binary operators and specification-only operator
            spec fun spec_add(x: u8, y: u8): u8 {
                let res = x + y;
                // using specification-only operator old to refer to previous state
                old(res)
            }

            spec fun spec_bit_ops(x: u8, y: u8): (u8, u8, u8) {
                // bitwise and, or, xor
                (x & y, x | y, x ^ y)
            }
        }
    }
}

//# run 0xCAFE::ModuleA::runner --signers 0xCAFE

//# publish
address 0xCAFE {
    module ModuleB {
        // import everything selectively from ModuleA
        use 0xCAFE::ModuleA::{CONST_ONE, CONST_TWO, CopyStruct, return_const_one, add_u8, create_copy_struct};

        // apply operators in functions
        public fun operators_example(): u64 {
            let a: u8 = CONST_ONE;
            let b: u8 = CONST_TWO;

            let sum: u8 = add_u8(a, b); // binary operator +

            // unary operator - does not exist on u8 for signed negation, let's do a cast to u16 and negate
            let neg = ((sum as u16) as i32) * (-1);

            // bitwise operations
            let and = a & b;
            let or = a | b;
            let xor = a ^ b;

            // Compose into a u64 (just some math)
            let combined = (neg as u64) + (and as u64) + (or as u64) + (xor as u64);
            combined
        }

        public fun create_struct(): CopyStruct {
            create_copy_struct(CONST_ONE, 1234)
        }

        // runner function
        public fun runner() {
            let val = return_const_one();
            let val2 = add_u8(CONST_ONE, CONST_TWO);
            let ops_result = operators_example();
            let cs = create_struct();
        }

        spec module {
            spec fun spec_binary_ops(x: u8, y: u8): u8 {
                x + y - CONST_ONE
            }
        }
    }
}

//# run 0xCAFE::ModuleB::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::ModuleA::{return_const_one};
    use 0xCAFE::ModuleB::{operators_example};

    fun main(account: signer) {
        let v1 = return_const_one();
        let v2 = operators_example();
        // no asserts or output, just test compilation and run
    }
}

// Featurres:
// e0f723b44afdc4c1f59c12350179c24a: Import all public functions, structs, and constants from another module using member imports in the 'use' statement.
// 41bd86b64e2f4b17255c024cdc513f19: Apply unary or binary operators, including specification-only operators in spec blocks.
// 2f1176a50aedba7210a09e1b87c0dc65: Define a module with a specific address or default address.
