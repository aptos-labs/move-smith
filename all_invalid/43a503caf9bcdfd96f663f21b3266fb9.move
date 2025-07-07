
//# publish
module 0xCAFE::ValidModuleName {
    const CONST_OK: u8 = 1u8;
    const const_not_ok: u8 = 2u8; // invalid member, lowercase start - expect diagnostic

    struct StructOk has copy, drop, store {
        x: u8,
    }
    struct structNotOk has copy, drop, store { // invalid member, lowercase start - expect diagnostic
        y: u8,
    }

    native public fun NativeFuncOk(x: u8): u8; // valid native function declaration
    native public fun nativeFuncNotOk(x: u8): u8; // invalid native function name - lowercase start

    native public fun NativeFuncWithBody(x: u8): u8 {
        // native function with body - should be allowed if rules permit
        x + 1
    }

    schema SchemaOk {
        field1: u8,
        field2: bool,
    }
    schema schemaNotOk { // invalid schema name - lowercase start - expect diagnostic
        dummy: u8,
    }
}

//# run 0xCAFE::ValidModuleName::NativeFuncWithBody --args 1u8


//# publish
module 0xCAFE::invalid-module-name { // invalid module name with dash - expect diagnostic
    const CONST_VALID: u8 = 10u8;
    const constInvalid: u8 = 20u8; // invalid member, lowercase start

    struct StructValid has copy, drop, store {
        a: u8,
    }
    struct structinvalid has copy, drop, store { // invalid struct name - lowercase start
        b: u8,
    }

    native public fun NativeFuncValid(x: u8): u8; // native valid
    native public fun nativefuncinvalid(x: u8): u8; // invalid native name - lowercase start

    native public fun NativeFuncWithBody(x: u8): u8 {
        x * 2
    }

    schema SchemaValid {
        val: u8,
    }
    schema schemainvalid { // invalid schema name
        val: u8
    }
}


//# publish
module 0xCAFE::MismatchedNameModuleWrongName {
    const CONST_IN_MODULE: u8 = 100u8;

    struct StructInside has copy, drop, store {
        z: u8,
    }

    native public fun NativeInside(x: u8): u8;

    schema SchemaInside {
        f: u8,
    }
}


//# publish
module 0xCAFE::123NumericModule { // numeric start module name - invalid, expect diagnostic
    const AnotherConst: u8 = 1u8;
}


//# publish
module 0xCAFE::ModuleWithInvalidMembers {
    const validConst: u8 = 10u8; // invalid const name: lowercase start - expect diagnostic
    const ValidConst: u8 = 11u8;

    struct validStruct has copy, drop, store { // invalid struct name: lowercase start - expect diagnostic
        field: u8,
    }
    struct ValidStruct has copy, drop, store {
        field: u8,
    }

    native public fun validNativeFunc(x: u8): u8; // invalid native func name
    native public fun ValidNativeFunc(x: u8): u8; // valid native func

    native public fun ValidNativeFuncWithBody(x: u8): u8 {
        x
    }
}


//# run 0xCAFE::ValidModuleName::NativeFuncOk --args 5u8


//# run 0xCAFE::ValidModuleName::NativeFuncWithBody --args 4u8


//# run 0xCAFE::ValidModuleName::NativeFuncOk --args 99u8


//# run 0xCAFE::MismatchedNameModuleWrongName::NativeInside --args 7u8


//# run 0xCAFE::ModuleWithInvalidMembers::ValidNativeFunc --args 123u8


//# run 0xCAFE::ModuleWithInvalidMembers::ValidNativeFuncWithBody --args 1u8


// Featurres:
// 6cd4a42e5ac6afcaf25b8d3fd2bb08c1: Use valid module member names that start with an uppercase letter for constants, structs, and schemas.
// 035dcc6afc2143ad24f0438dd6123c77: Declare native functions with or without a body in Move code.
// 679df54e5b642029e610d50b58dbae39: Generate diagnostic messages when a module identifier is unexpected for a given context.
