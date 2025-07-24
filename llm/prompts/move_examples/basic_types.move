//# publish
module 0xCAFE::BasicTypes {
    const MODULE_MAGIC: u32 = 0xCADE;

    struct S has copy, drop, store, key {
        x: u32,
        y: u32, // Fields name cannot start with a number
    }

    struct StructWithTypeParameter<T> has copy, drop {
        field: T
    }

    enum E has copy, drop {
        V1,
        V2(u32, u32),
        V3 {
            a: bool
        }
    }

    struct Obj has store, key {
        x: u8,
        y: u8,
    }

    public fun destructure_example() {
        let obj = Obj {x: 1, y: 2};
        // Obj doesn't have the `drop` ability, so it must be consumed
        // Destructuring patterns
        let Obj { .. } = obj;
    }

    public fun create_enum(): E {
        E::V2(10, 20)
    }

    public fun struct_creation_example(x: u16): S {
        // Basic struct creation
        let s = S {x: x as u32, y: (x + 1) as u32};

        // Instantiate generic struct with type parameter
        let s2 = StructWithTypeParameter<E> {field: E::V2(1, 2)};
        let s3 = StructWithTypeParameter<u16> {field: 3u16};
        s
    }

    public fun destroy_struct(s: S): (u32, u32) {
        let S { x, y } = s;
        (x, y)
    }
}

//# run 0xCAFE::BasicTypes::struct_creation_example --args 10u16
