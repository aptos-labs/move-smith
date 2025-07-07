//--------------------------
// Test Case: Aptos Move Transactional Test
// Tests:
//   1. External lint annotations for modules and functions
//   2. Dotted expressions for nested fields
//   3. Parentheses in 'match' expressions
//--------------------------

//# publish
//~lint: allow (unused_struct) //~lint: allow (unused_function)
module 0xCAFE::TestMod {
    use std::option::{Option, none, some};
    use std::string;

    //~lint: deny (unreachable_code)
    struct Inner has copy, drop, store {
        val: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        desc: string::String,
    }

    public fun create_outer(val: u64, desc: string::String): Outer {
        Outer {
            inner: Inner { val },
            desc,
        }
    }

    public fun get_inner_val(o: &Outer): u64 {
        // Test dotted expressions for nested access
        o.inner.val
    }

    public fun test_match(opt: Option<u64>): u64 {
        // Test parens around match expression
        match (opt) {
            some(x) => x,
            none => 0,
        }
    }

    // Runner
    public entry fun runner(s: &signer) {
        let o = create_outer(42, string::utf8(b"MyStruct"));
        let v = get_inner_val(&o);
        let o2 = some(v);
        let _x = test_match(o2);
        let _y = test_match(none());
    }
}

//# run 0xCAFE::TestMod::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::TestMod;
    use std::signer;

    fun main(s: &signer) {
        // Create an Outer and get its inner value using dotted notation
        let outer = TestMod::create_outer(55, b"xyz".to_vec());
        let inner_val = TestMod::get_inner_val(&outer);
        // Use test_match to match on Option
        let x1 = TestMod::test_match(std::option::some(inner_val));
        let x2 = TestMod::test_match(std::option::none());
        // NOP: simply exercise the code
    }
}