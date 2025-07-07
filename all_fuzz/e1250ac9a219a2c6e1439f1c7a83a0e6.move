
//# publish
module 0xCAFE::PrimaryExpressions {
    use std::signer;

    const CONST_U8: u8 = 42u8;
    const CONST_BOOL: bool = true;
    const CONST_BYTES: vector<u8> = b"TestBytes";

    struct PrimaryKey has store, key {
        a: u8,
        b: bool,
        c: vector<u8>,
    }

    public fun create(s: signer) {
        let pk = PrimaryKey {
            a: CONST_U8,
            b: CONST_BOOL,
            c: CONST_BYTES,
        };
        move_to<PrimaryKey>(&s, pk);
    }

    public fun read(s: signer): (u8, bool, vector<u8>) {
        let pk_ref = borrow_global<PrimaryKey>(signer::address_of(&s));
        (pk_ref.a, pk_ref.b, pk_ref.c)
    }

    public fun update(s: signer, new_a: u8, new_b: bool, new_c: vector<u8>) {
        let pk_mut = borrow_global_mut<PrimaryKey>(signer::address_of(&s));
        pk_mut.a = new_a;
        pk_mut.b = new_b;
        pk_mut.c = new_c;
    }

    public fun remove(s: signer) {
        // consume the value instead of implicitly dropping it
        let pk = move_from<PrimaryKey>(signer::address_of(&s));
        let PrimaryKey { a: _, b: _, c: _ } = pk;
    }

    public fun runner() {
        let dummy = CONST_U8;
        let bool_val = CONST_BOOL;
        let bytes_val = CONST_BYTES;
        let _ = dummy;
        let _ = bool_val;
        let _ = bytes_val;
    }
}



//# run 0xCAFE::PrimaryExpressions::create --signers 0xDEAD



//# run 0xCAFE::PrimaryExpressions::read --signers 0xDEAD



//# run 0xCAFE::PrimaryExpressions::update --signers 0xDEAD --args 100u8 false b"NewBytes"



//# run 0xCAFE::PrimaryExpressions::read --signers 0xDEAD



//# run 0xCAFE::PrimaryExpressions::remove --signers 0xDEAD



//# run 0xCAFE::PrimaryExpressions::runner
