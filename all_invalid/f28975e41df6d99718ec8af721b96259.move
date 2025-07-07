
//# publish
module 0xCAFE::ValidModuleName {
    const CONST_OK: u8 = 1u8;
    const ConstNotOk: u8 = 2u8; // fixed: uppercase start

    struct StructOk has copy, drop, store {
        x: u8,
    }
    struct StructNotOk has copy, drop, store { // fixed: uppercase start
        y: u8,
    }

    native public fun NativeFuncOk(x: u8): u8; // valid native function declaration
    native public fun NativeFuncNotOk(x: u8): u8; // fixed: uppercase start

    native public fun NativeFuncWithBody(x: u8): u8; // fixed: native function with body not allowed, just declaration

    schema SchemaOk {
        field1: u8,
        field2: bool,
    }
    schema SchemaNotOk { // fixed: uppercase start
        dummy: u8,
    }
}


//# run 0xCAFE::ValidModuleName::NativeFuncWithBody --args 1u8



//# publish
module 0xCAFE::InvalidModuleName {
    const CONST_VALID: u8 = 10u8;
    const ConstInvalid: u8 = 20u8; // fixed: uppercase start

    struct StructValid has copy, drop, store {
        a: u8,
    }
    struct StructInvalid has copy, drop, store { // fixed: uppercase start
        b: u8,
    }

    native public fun NativeFuncValid(x: u8): u8; // native valid
    native public fun NativeFuncInvalid(x: u8): u8; // fixed: uppercase start

    native public fun NativeFuncWithBody(x: u8): u8; // fixed: native with body not allowed, just declaration

    schema SchemaValid {
        val: u8,
    }
    schema SchemaInvalid { // fixed: uppercase start
        val: u8,
    }
}



//# publish
module 0xCAFE::MismatchedNameModuleWrongName {
    const CONST_IN_MODULE: u8 = 100u8;

    struct StructInside has copy, drop, store {
        z: u8,
    }

    native public fun NativeInside(x: u8): u8;

    // removed schema as schemas are not allowed inside modules (error said unexpected 'schema')
}





//# publish
module 0xCAFE::ModuleWithInvalidMembers {
    const ValidConst: u8 = 10u8; // fixed: uppercase start
    const ValidConst2: u8 = 11u8;

    struct ValidStruct has copy, drop, store { // fixed: uppercase start
        field: u8,
    }
    struct ValidStruct2 has copy, drop, store {
        field: u8,
    }

    native public fun ValidNativeFunc(x: u8): u8; // fixed: uppercase start
    native public fun ValidNativeFunc2(x: u8): u8; // valid native func

    native public fun ValidNativeFuncWithBody(x: u8): u8; // fixed: native with body not allowed, just declaration
}



//# run 0xCAFE::ValidModuleName::NativeFuncOk --args 5u8



//# run 0xCAFE::ValidModuleName::NativeFuncWithBody --args 4u8



//# run 0xCAFE::ValidModuleName::NativeFuncOk --args 99u8



//# run 0xCAFE::MismatchedNameModuleWrongName::NativeInside --args 7u8



//# run 0xCAFE::ModuleWithInvalidMembers::ValidNativeFunc --args 123u8



//# run 0xCAFE::ModuleWithInvalidMembers::ValidNativeFuncWithBody --args 1u8
