//# publish
module 0x1::TestDiagnostics {
    /// This function contains an intentional compilation error to test diagnostics reporting.
    // Uncommenting the following line will cause an error:
    // let x: u64 = "string_instead_of_u64";
    // We simulate the error by having an unused invalid local type reference.
    // Note: Since tests should compile, this code is commented out.
    //
    // The real diagnostic test would involve a separate file with invalid code.
    // Here we provide a dummy function to trigger a diagnostic if uncommented.
    public fun check_diagnostics() {
        // To simulate a diagnostic error, let's reference an undefined variable.
        // let unused = DOES_NOT_EXIST;
    }
}

//# publish
module 0x1::UnpackFields {
    struct MyStruct has copy, drop, store {
        a: u8,
        b: u64,
        c: bool,
    }

    public fun create_struct(): MyStruct {
        MyStruct { a: 1, b: 42, c: true }
    }

    public fun unpack_and_process(s: MyStruct): u64 {
        // Unpack all fields from the struct
        let MyStruct { a, b, c } = s;
        // Process each separately
        let result_b = b + 10;     // add 10 to b
        let result_a = (a as u64) * 2; // multiply a by 2
        let result_c = if (c) { 100 } else { 0 };
        result_a + result_b + result_c
    }

    public fun runner() {
        let s = create_struct();
        let _ = unpack_and_process(s);
    }
}
//# run 0x1::UnpackFields::runner

//# publish
module 0x1::ParamRefCopy {

    public fun copy_from_ref(x: &u64): u64 {
        // Copy the value referenced by x and return it
        let copied = *x;
        copied
    }

    public fun runner(): u64 {
        let val: u64 = 123u64;
        let ref_val = &val;
        copy_from_ref(ref_val)
    }
}
//# run 0x1::ParamRefCopy::runner

//# run
script {
    use 0x1::UnpackFields;
    use 0x1::ParamRefCopy;

    fun main(_signer: &signer) {
        // Run unpack_and_process directly
        let s = UnpackFields::create_struct();
        let _ = UnpackFields::unpack_and_process(s);

        // Run ParamRefCopy runner and copy_from_ref
        let res = ParamRefCopy::runner();
        let res2 = ParamRefCopy::copy_from_ref(&456u64);

        // No asserts needed
    }
}