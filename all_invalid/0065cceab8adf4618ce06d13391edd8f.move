
//# publish
module 0xBADD::SchemaTest {
    use std::vector;

    struct Spec has copy, drop, store {
        name: vector<u8>,
        fields: vector<vector<u8>>,
    }

    public fun create_spec(name: vector<u8>, fields: vector<vector<u8>>): Spec {
        Spec { name, fields }
    }

    public fun get_first_field(spec: &Spec): vector<u8> {
        vector::borrow(&spec.fields, 0).clone()
    }
}


//# publish
module 0xC0FF::TypeRecognition {
    struct GenericStruct<T> has copy, drop, store {
        value: T,
    }

    enum SimpleEnum {
        VariantA,
        VariantB(u64, u64),
        VariantC { flag: bool },
    }

    public fun identify_type_name() {
        let _type_name1 = "SimpleEnum";
        let _type_name2 = "GenericStruct";
    }
}


//# publish
module 0xFACE::ModuleImport {
    use 0xCAFE::MyModule;

    public fun call_f1(x: u8, y: bool): u8 {
        MyModule::f1(x, y)
    }

    public fun call_f3(x: u16): u16 {
        MyModule::f3(x)
    }
}


//# publish
module 0xDEAD::ExpressionAssign {
    struct ListHolder has store {
        items: vector<u8>,
    }

    public fun assign_multiple_expressions() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);
        let list = ListHolder { items: v };
        list
    }
}


//# publish
module 0xBEEF::FunctionStorage {
    struct FuncHolder has copy, drop, store {
        func: |u8| -> u8,
    }

    public fun store_lambda(): FuncHolder {
        let lambda = |x: u8| -> u8 { x + 1 };
        FuncHolder { func: lambda }
    }

    public fun call_stored_lambda(holder: &FuncHolder, val: u8): u8 {
        (holder.func)(val)
    }
}


//# publish
module 0xC0DE::ScriptTransformation {
    // This module tests converting scripts into script modules and metadata linking
    struct Metadata has key {
        description: vector<u8>,
        associated_scripts: vector<vector<u8>>,
    }

    public fun create_metadata(desc: vector<u8>, scripts: vector<vector<u8>>): Metadata {
        Metadata { description: desc, associated_scripts: scripts }
    }
}


//# run 0xBADD::SchemaTest::create_spec --args 

//# run 0xBADD::SchemaTest::get_first_field --args


//# run 0xC0FF::TypeRecognition::identify_type_name


//# run 0xFACE::ModuleImport::call_f1 --args 7u8 true

//# run 0xFACE::ModuleImport::call_f3 --args 15u16


//# run 0xDEAD::ExpressionAssign::assign_multiple_expressions


//# run 0xBEEF::FunctionStorage::store_lambda --signers 0xBEEF

//# run 0xBEEF::FunctionStorage::call_stored_lambda --signers 0xBEEF --args 5u8


//# run 0xC0DE::ScriptTransformation::create_metadata --args b"Test Metadata" [b"Script1", b"Script2"]


// Featurres:
// 843cbf156cbc53e45050badafe3d2551: Define 'spec' blocks with target schemas or modules, enabling implicit aliasing of their constituent members.
// 38d9f19717f4d38f588ea3ae0f8eb41f: Identify a type starting with an identifier, such as a type name or generic parameter.
// 7674a9dca6177b17be0aef022cb10f2f: Import modules in Move files using the 'use' statement.
// 6eb3067fc04ceed51227965b4d9b3fe9: Assign values to lists of expressions in a single statement
// 61a831562ef39570216673b8b23b57ab: Test that function values (lambdas/closures) can be stored and invoked as fields of structs and enum variants in Aptos Move.
// 8cafa46aed88e57dbcac81c9d4d701e6: Create script modules from compiled scripts with associated metadata.
