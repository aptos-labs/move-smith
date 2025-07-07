
//# publish
module 0xCAFE::Module1 {
    struct Struct3 has copy, drop, store {
        a: u8,
        b: u16,
        c: bool,
    }

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // return 42 if sum equals 42, else sum itself
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);
        product
    }

    public fun create_struct3(): Struct3 {
        Struct3 { a: 10, b: 15, c: true }
    }

    public fun function6(): Struct3 {
        create_struct3()
    }
}

// A new module MyModule must be added with function f2 to fix linker errors used in Module2


//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x * 2)
    }
}


//# publish
module 0xCAFE::Module2 {
    use 0xCAFE::Module1;
    use 0xCAFE::MyModule;

    public fun call_inline_and_function6(x: u16): (u16, u16, Module1::Struct3) {
        // Call inline function from 0xCAFE::MyModule::f2 indirectly via nested calls
        let (a, b) = MyModule::f2(x);
        let s3 = Module1::function6();
        (a, b, s3)
    }
}


//# run 0xCAFE::Module1::add_two_values --args 40u8 2u8


//# run 0xCAFE::Module1::lambda_test --args 6u8 7u8


//# run 0xCAFE::Module1::function6


//# run 0xCAFE::Module2::call_inline_and_function6 --args 100u16
