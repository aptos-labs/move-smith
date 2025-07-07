
//# publish
module 0xCAFE::ComplexScopesWithAttrs {
    use std::option;

    // doc = "This is a constant with an attribute"
    const CONST_WITH_ATTR: u64 = 0xDEADBEEF;

    // allow(dead_code)
    const MAX_LEVEL: u8 = 100;

    struct Container has store {
        val: u64,
        // References cannot be used as type arguments for Option because references do not have the store ability.
        // Change these fields to raw Container type or remove them if not needed.
        opt_ref: option::Option<Container>,
        mut_ref: option::Option<Container>,
    }

    public fun create_container(x: u64): Container {
        Container {
            val: x,
            opt_ref: option::none<Container>(),
            mut_ref: option::none<Container>(),
        }
    }

    public fun nested_scopes_example(x: u8): u8 {
        let result = {
            let inner_result = {
                let inner_result = if (x > 10) {
                    let base = (x as u64) + CONST_WITH_ATTR;
                    base as u8
                } else {
                    let base = 5u8;
                    base
                };
                inner_result + 1
            };
            inner_result + 2
        };
        result
    }

    public fun mutable_reference_test(c: &mut Container): u64 {
        c.val = c.val + CONST_WITH_ATTR;
        c.val
    }

    public fun use_references() {
        let c1 = create_container(42);
        let c1_ref: &Container = &c1;
        let _val_ref: u64 = c1_ref.val;

        let c2 = create_container(10);
        let c2_mut_ref: &mut Container = &mut c2;
        let _val_mut_ref: u64 = mutable_reference_test(c2_mut_ref);
    }
}
