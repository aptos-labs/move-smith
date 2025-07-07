//# publish
module 0xCAFE::InvariantAndReferences {
    use std::signer;
    use std::vector;

    struct Data has store {
        value: u64,
        flag: bool,
    }

    spec struct Data {
        invariant value >= 100,
        invariant flag == true,
    }

    public fun create_data(s: signer, v: u64) {
        let data = Data { value: v, flag: true };
        move_to<Data>(&s, data);
    }

    public fun borrow_value(s: signer): u64 {
        let data_ref: &Data = borrow_global<Data>(signer::address_of(&s));
        data_ref.value
    }

    public fun borrow_flag(s: signer): bool {
        let data_ref: &Data = borrow_global<Data>(signer::address_of(&s));
        data_ref.flag
    }

    public fun runner() {
        // create with a value satisfying invariant
        // here we just create and borrow to generate bytecode for both
    }
}

//# run 0xCAFE::InvariantAndReferences::create_data --signers 0xDEAD --args 150u64

//# run 0xCAFE::InvariantAndReferences::borrow_value --signers 0xDEAD

//# run 0xCAFE::InvariantAndReferences::borrow_flag --signers 0xDEAD

//# run 0xCAFE::InvariantAndReferences::runner

// Featurres:
// a44da32fcb121bd1ee7c0a4b836c993e: Define invariant conditions within specifications.
// b209c36a585632f90e3d0971998eb855: Use reference types to borrow data immutably without taking ownership.
// af34c34d028cde0ffe036333b37d9cfd: Generate bytecode for each non-inline function targeted for compilation.
