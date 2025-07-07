
//# publish
module 0xCAFE::ClosureTest {
    use std::vector;
    use std::bcs;

    // A function that returns a closure that adds a captured constant to input
    public fun make_adder(capture: u8): |u8|u8 {
        |x: u8| { x + capture }
    }

    // Compose two closures f and g into a closure h(x) = f(g(x))
    public fun compose(f: |u8|u8, g: |u8|u8): |u8|u8 {
        |x: u8| { f(g(x)) }
    }

    // Check whether two closures are structurally equal via BCS serialization of their bytecode
    public fun closure_struct_eq(f: &|u8|u8, g: &|u8|u8): bool {
        let f_bytes = bcs::to_bytes(f);
        let g_bytes = bcs::to_bytes(g);
        // vector::equals is not in std::vector, use vector::length and explicit comparison
        if (vector::length(&f_bytes) != vector::length(&g_bytes)) {
            return false;
        }
        let i = 0;
        while (i < vector::length(&f_bytes)) {
            if (vector::borrow(&f_bytes, i) != vector::borrow(&g_bytes, i)) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    // A runner that creates layered composed closures and tests their outputs and equality
    public fun runner(): bool {
        let add_2 = make_adder(2);
        let add_3 = make_adder(3);
        let add_5 = compose(add_2, add_3); // (x + 3) + 2 = x + 5
        let add_5_again = compose(add_3, add_2); // (x + 2) + 3 = x + 5
        let are_equal = closure_struct_eq(&add_5, &add_5_again);

        let result = add_5(10u8);
        assert!(result == 15, 0xDEAD);

        are_equal
    }

    // spec]
    public fun spec_example(x: u8): u8 {
        // Specification block example: just returns input + 1 in spec
        x + 1
    }
}



//# run 0xCAFE::ClosureTest::runner



//# publish
module 0xBABE::AnnotatedModule {
    use std::vector;

    /// A struct with spec and documentation comment
    struct A has copy, drop, store {
        val: u8
    }

    // spec]
    public fun spec_func(x: u8): u8 {
        x * 2
    }

    /// Public function annotated with spec block
    // spec]
    public fun annotated_func(x: u8): u8 {
        spec_func(x) + 1
    }
}



//# run 0xBABE::AnnotatedModule::annotated_func --args 21u8




//# publish
module 0xDEAD::ContextAddressModule {
    use std::signer;

    struct Ctx has key, store {  // <-- add the 'key' ability here
        owner: address,
        val: u64
    }

    public fun init(s: signer, val: u64) {
        let addr = signer::address_of(&s);
        let ctx = Ctx { owner: addr, val };
        move_to<Ctx>(&s, ctx);
    }

    public fun get_val(addr: address): u64 {
        let c = borrow_global<Ctx>(addr);
        c.val
    }

    public fun set_val(s: signer, val: u64) {
        let c = borrow_global_mut<Ctx>(signer::address_of(&s));
        c.val = val;
    }
}



//# run 0xDEAD::ContextAddressModule::init --signers 0xC0FF --args 123u64



//# run 0xDEAD::ContextAddressModule::get_val --args 0xC0FF



//# run 0xDEAD::ContextAddressModule::set_val --signers 0xC0FF --args 999u64



//# run 0xDEAD::ContextAddressModule::get_val --args 0xC0FF
