
//# publish
module 0xCAFE::LambdaEnumSpec {
    use std::vector;

    /// An enum with multiple variants
    enum MultiVariant has copy, drop, store {
        A,
        B { x: u8, y: u16, z: bool },
        C(u8, u64)
    }

    /// Struct to test field updates and lambda return
    struct Container has copy, drop, store {
        e: MultiVariant,
    }

    /// A function using lambda expressions, capturing an outer variable,
    /// to modify fields of `B` variant and return modified field sum.
    public fun lambda_field_update_sum(c: &mut Container, add_x: u8, add_y: u16): u16 {
        let lambda: |&mut MultiVariant, u8, u16| u16 has copy+drop = |mv: &mut MultiVariant, inc_x: u8, inc_y: u16| {
            let res: u16;
            match (*mv) {
                MultiVariant::B { x, y, z } => {
                    // update fields individually
                    mv.B.x = x + inc_x;
                    mv.B.y = y + inc_y;
                    // return sum of fields' numeric values (convert bool to 1 or 0)
                    let bool_val = if (z) { 1u16 } else { 0u16 };
                    res = (mv.B.x as u16) + mv.B.y + bool_val;
                },
                _ => {
                    res = 0u16;
                }
            };
            res
        };
        lambda(&mut c.e, add_x, add_y)
    }

    /// Function to instantiate Container with B variant
    public fun make_container(): Container {
        Container {
            e: MultiVariant::B { x: 2u8, y: 3u16, z: true }
        }
    }

    /// Same function as above but returns the sum without lambda,
    /// used for testing difference
    public fun direct_field_sum(c: &Container): u16 {
        match (&c.e) {
            Multivariant::B { x, y, z } => {
                let bool_val = if (*z) {1u16} else {0u16};
                (*x as u16) + *y + bool_val
            },
            _ => 0u16
        }
    }

    /// Functions to demonstrate Spec module extraction, which are no-op here
    spec module {
        fun spec1();
        fun spec2();
    }

    public fun runner() {
        let c = make_container();
        let _sum1 = lambda_field_update_sum(&mut c, 3u8, 4u16);
        // This matches the sum after modifying fields: (2+3)+(3+4)+1 = 13
        let _sum2 = lambda_field_update_sum(&mut c, 1u8, 1u16);
        // The sums are calculated but not asserted
    }
}


//# run 0xCAFE::LambdaEnumSpec::runner


// Featurres:
// e2044e4313b5dabba6686e18fdf18641: Write Move code that uses lambda expressions, with the compiler performing lambda lifting to support them.
// cae734b72a4664a20939900485392190: Test updating individual fields of a common enum variant to verify that field modifications are correctly reflected regardless of their offsets.
// 94f50777664de56affd91280a6812530: Extract and process special specification modules from package definitions.
