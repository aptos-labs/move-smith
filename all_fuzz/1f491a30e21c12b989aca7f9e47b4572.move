
//# publish
module 0xCAFE::AbilityAndAcquiresTest {
    use std::signer;

    // Structs with abilities to test 'Store' and ability constraints
    struct S1 has store, key { val: u8 }
    // Modified constraint from `T: store` to `T: store + key` to satisfy move_to requirements
    struct S2<T: store + key> has store, key { field: T }
    // Modified constraint from `U: store` to `U: store + key`; and added `key` to struct abilities
    struct S3<T: copy, U: store + key> has store, key {
        a: T,
        b: U
    }

    // Function that stores an S1 to global storage at signer address
    public fun store_s1(s: signer, val: u8) {
        let obj = S1 { val };
        move_to<S1>(&s, obj);
    }

    // Function that stores S2 instantiated with S1 to global storage at signer address
    public fun store_s2_s1(s: signer, val: u8) {
        let inner = S1 { val };
        let obj = S2<S1> { field: inner };
        move_to<S2<S1>>(&s, obj);
    }

    // Function that stores S3<u8, S1> to global storage at signer address
    public fun store_s3(s: signer, val_u8: u8, val_s1: u8) {
        let inner = S1 { val: val_s1 };
        let obj = S3<u8, S1> { a: val_u8, b: inner };
        move_to<S3<u8, S1>>(&s, obj);
    }

    // Another function with unique name storing S1 with modified value
    public fun store_s1_different(s: signer, val: u8) {
        let obj = S1 { val: val + 1 };
        move_to<S1>(&s, obj);
    }

    // Example function demonstrating ability constraints converted to a Set (simulated)
    // Since Move does not have real sets, we simulate by returning a vector of ability codes
    // Abilities codes: 0x1=copy, 0x2=drop, 0x4=store, 0x8=key
    public fun abilities_of_s1(): vector<u8> {
        let set = vector[4u8, 8u8];
        set
    }

    public fun abilities_of_s2(): vector<u8> {
        // S2 now has store and key abilities
        vector[4u8, 8u8]
    }

    public fun abilities_of_s3(): vector<u8> {
        // S3 now has store and key abilities
        vector[4u8, 8u8]
    }

    // Runner function with no args to satisfy run command
    public fun runner() {}

}
