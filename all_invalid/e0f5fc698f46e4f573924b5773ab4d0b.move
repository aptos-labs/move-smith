
//# publish
module 0xCAFE::AbilityConstraints {
    use std::signer;

    // Define a struct with an ability constraint on the type parameter T
    struct Container<T: copy + drop> has key {
        value: T,
    }

    // Struct with abilities key and store, with type parameter restricted to store ability
    struct DataHolder<T: store + key> has store {
        data: T,
    }

    // Define a public function that creates a Container<T> and returns the value field
    public fun create_and_get<T: copy + drop>(val: T): T {
        let container = Container<T> { value: val };
        container.value
    }

    // Function that demonstrates unpacking of Container<T> within the defining module
    public fun unpack_container<T: copy + drop>(c: Container<T>): T {
        let Container { value } = c;
        value
    }

    // Function that creates and returns DataHolder<T>
    public fun create_data_holder<T: store + key>(val: T): DataHolder<T> {
        DataHolder<T> { data: val }
    }

    // Function that unpacks DataHolder<T> and returns data field
    public fun unpack_data_holder<T: store + key>(holder: DataHolder<T>): T {
        let DataHolder { data } = holder;
        data
    }

    // Function with a statement sequence to test variable declarations and bindings
    public fun statements_sequence(x: u8): u8 {
        let a = x;
        let b = a + 3;
        let c = b * 2;
        let d = if (c > 10) {
            c - 10
        } else {
            c + 10
        };
        d
    }
}



//# run 0xCAFE::AbilityConstraints::create_and_get --args 42u8



//# run 0xCAFE::AbilityConstraints::unpack_container --args 42u8



//# run 0xCAFE::AbilityConstraints::statements_sequence --args 5u8



//# run 0xCAFE::AbilityConstraints::create_data_holder --args 123u8



//# run 0xCAFE::AbilityConstraints::unpack_data_holder --args 123u8




//# publish
module 0xCAFE::RestrictPackUnpack {
    struct PrivateStruct has copy, drop, store {
        a: u8,
        b: u64,
    }

    enum PrivateEnum has copy, drop {
        A,
        B(u8),
        C { x: u64, y: u16 },
    }

    // Public function to create PrivateStruct, packing inside module
    public fun pack_struct(a: u8, b: u64): PrivateStruct {
        PrivateStruct { a, b }
    }

    // Public unpack function returning fields as tuple
    public fun unpack_struct(s: PrivateStruct): (u8, u64) {
        let PrivateStruct { a, b } = s;
        (a, b)
    }

    // Public function to create PrivateEnum::B
    public fun pack_enum_b(x: u8): PrivateEnum {
        PrivateEnum::B(x)
    }

    // Public function to unpack PrivateEnum and return u64 for C variant or special values for others
    public fun unpack_enum(e: PrivateEnum): u64 {
        match (e) {
            PrivateEnum::A => 0,
            PrivateEnum::B(x) => x as u64,
            PrivateEnum::C { x, y: _ } => x,
        }
    }
}



//# run 0xCAFE::RestrictPackUnpack::pack_struct --args 7u8 100u64



//# run 0xCAFE::RestrictPackUnpack::unpack_struct --args 7u8 100u64



//# run 0xCAFE::RestrictPackUnpack::pack_enum_b --args 200u8



//# run 0xCAFE::RestrictPackUnpack::unpack_enum --args 1u8 200u8




//# publish
module 0xCAFE::StatementSequences {
    // Struct with two fields
    struct Pair has copy, drop {
        first: u8,
        second: u8,
    }

    // Function with multiple let statements, declarations, bindings, and expressions
    public fun complex_sequence(x: u8, y: u8): u8 {
        let p1 = Pair { first: x, second: y };
        let Pair { first, second } = p1;

        let sum = first + second;
        let diff = if (first > second) { first - second } else { second - first };
        let doubled_sum = sum * 2;

        let result = if (doubled_sum > 50) {
            doubled_sum - 50
        } else {
            doubled_sum + 50
        };

        result
    }

    public fun test_bindings() {
        let a = 1u8;
        let b = 2u8;
        let c = a + b;

        let d;
        if (c > 2) {
            d = c;
        } else {
            d = 0u8;
        };

        let _ = d;
    }
}



//# run 0xCAFE::StatementSequences::complex_sequence --args 10u8 15u8



//# run 0xCAFE::StatementSequences::test_bindings
