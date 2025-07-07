
//# publish
module 0xCAFE::MyModule {
    // Enum E with variant V3
    public enum E has copy, store, drop {
        V1,
        V2,
        V3 { a: bool },
    }

    // f2 takes a u16 and returns a tuple (u16,u16)
    public fun f2(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    // Removed unused use std::signer;

    public fun add_and_return_constant(a: u8, b: u8): u8 {
        // Compute the sum but ignore it, return constant 42u8
        let _sum = a + b;
        42u8
    }

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| {
            n * 2
        };
        lambda(x)
    }

    public fun call_another_inline(a: u16): u16 {
        let (x, _y) = 0xCAFE::MyModule::f2(a);
        // x is a+1 as per f2, return x + 10u16
        x + 10u16
    }

    struct ComplexStruct<T1, T2> has store {
        first: T1,
        second: T2,
    }

    public fun create_complex_struct(): ComplexStruct<0xCAFE::MyModule::E, u8> {
        let enum_inst = 0xCAFE::MyModule::E::V3 { a: true };
        ComplexStruct<0xCAFE::MyModule::E, u8> { first: enum_inst, second: 255u8 }
    }
}
