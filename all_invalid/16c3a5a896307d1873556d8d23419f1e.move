
//# publish
module 0xCAFE::ComplexScopesWithAttrs {
    use std::option;

    // doc = "This is a constant with an attribute"]
    const CONST_WITH_ATTR: u64 = 0xDEADBEEF;

    // allow(dead_code)]
    const MAX_LEVEL: u8 = 100;

    struct Container has store {
        val: u64,
        opt_ref: option::Option<&Container>,
        mut_ref: option::Option<&mut Container>,
    }

    public fun create_container(x: u64): Container {
        Container {
            val: x,
            opt_ref: option::none<&Container>(),
            mut_ref: option::none<&mut Container>(),
        }
    }

    public fun nested_scopes_example(x: u8): u8 {
        let result = {
            let inner_result = {
                if (x > 10) {
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


//# run 0xCAFE::ComplexScopesWithAttrs::nested_scopes_example --args 15u8


//# run 0xCAFE::ComplexScopesWithAttrs::use_references


// Featurres:
// 3d3f5b98f18ab88b84383a588733a309: Write sequences of code statements with proper scope handling and ensure the last statement is properly encapsulated as a sequence item.
// 1b37d852900ca0c0c83575f0860f317d: Attach attributes to constant declarations.
// d76b9ce10a67c45edb4d1950c476495c: Start a type with an opening parenthesis '(' or an ampersand '&' or '& mut' for mutable references.
