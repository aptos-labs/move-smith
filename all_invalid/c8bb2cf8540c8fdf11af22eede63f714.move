//# publish
module 0xCAFE::RefSafety {
    use std::signer;

    struct RefObj has store {
        val: u8,
    }

    public fun create_obj(s: signer, v: u8) {
        let obj = RefObj {val: v};
        move_to<RefObj>(&s, obj);
    }

    public fun get_ref_val(s: signer): u8 {
        let obj_ref: &RefObj = borrow_global<RefObj>(signer::address_of(&s));
        obj_ref.val
    }

    public fun mutate_val(s: signer, new_val: u8) {
        let obj_mut_ref: &mut RefObj = borrow_global_mut<RefObj>(signer::address_of(&s));
        obj_mut_ref.val = new_val;
    }

    public fun create_and_mutate(s: signer) {
        create_obj(s, 10u8);
        mutate_val(s, 42u8);
    }
}

//# run 0xCAFE::RefSafety::create_and_mutate --signers 0xBABE

//# run 0xCAFE::RefSafety::get_ref_val --signers 0xBABE

//# publish
module 0xCAFE::FirstClassFunction {
    public fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_twice(f: |u8, u8| u8, x: u8, y: u8): u8 {
        let first_call = f(x, y);
        let second_call = f(first_call, y);
        second_call
    }

    public fun runner(): u8 {
        call_twice(add, 3u8, 4u8)
    }
}

//# run 0xCAFE::FirstClassFunction::runner

//# run 0xCAFE::FirstClassFunction::call_twice --args 2u8 3u8 --signers 0xBEEF

// Annotated script with attributes

//# run
script {
    #[public]
    #[script]
    fun main() {
        let f: |u8, u8| u8 = 0xCAFE::FirstClassFunction::add;
        let z = f(7u8, 8u8);
        let res = 0xCAFE::FirstClassFunction::call_twice(f, 1u8, z);
        let _ignored = res;
    }
}

// Featurres:
// 700188a5b9e6617dd97929cdf4048619: Use reference_safety checks to ensure reference safety.
// e0cc0eb5a0e248d117c73b8ec2f355c6: Call expressions as first-class values, passing argument lists dynamically.
// 786fe5d504ce49a105a091af40f1f658: Annotate your script with attributes on the script declaration.
