//# publish
module 0xCAFE::FilterExample {
    use std::signer;

    struct Dummy has store {
        val: u8,
    }

    public fun check_type_annotation(x: u8): u8 {
        let y: u8 = x + 1;
        y
    }

    public fun create_dummy(s: signer, v: u8) {
        let d = Dummy { val: v };
        move_to<Dummy>(&s, d);
    }

    public fun read_dummy(s: signer): u8 {
        let d_ref: &Dummy = borrow_global<Dummy>(signer::address_of(&s));
        d_ref.val
    }

    public fun runner() {
        let _ = check_type_annotation(7u8);
    }
}

//# run 0xCAFE::FilterExample::create_dummy --signers 0xDEAD --args 42u8

//# run 0xCAFE::FilterExample::read_dummy --signers 0xDEAD

//# run 0xCAFE::FilterExample::runner

// Featurres:
// 6517c1eeb42e30f6fcb7ecda3e87fca7: Filter script attributes according to specific criteria during compilation.
// 5f869b549fde17cd795d12789f578890: Annotate expressions with types using the colon syntax (e: Type).
// b5d81a20a5398c9d5b7dc51584b5ca34: Define modules in Move that will be verified for bytecode correctness after compilation.
