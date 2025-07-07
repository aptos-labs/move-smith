
//# publish
module 0xCAFE::NativeLayout {
    use std::signer;

    struct ResourceA has key {
        a: u64,
        b: u64,
    }

    struct StructB {
        a: u8,
        b: vector<u8>,
    }

    public inline fun inline_increment(x: u64): u64 {
        x + 1
    }

    public inline fun inline_double(x: u64): u64 {
        let incremented = inline_increment(x);
        incremented * 2
    }

    public fun create_resource(s: signer, a: u64, b: u64) {
        let resource = ResourceA { a, b };
        move_to<ResourceA>(&s, resource);
    }

    public fun read_resource(s: signer): (u64, u64) {
        let res = borrow_global<ResourceA>(signer::address_of(&s));
        (res.a, res.b)
    }

    public fun update_resource(s: signer) {
        let r_mut = borrow_global_mut<ResourceA>(signer::address_of(&s));
        r_mut.a = inline_double(r_mut.a);
        r_mut.b = inline_increment(r_mut.b);
    }

    public fun remove_resource(s: signer) {
        let r = move_from<ResourceA>(signer::address_of(&s));
        let ResourceA {a: _a, b: _b} = r;
    }

    public fun use_struct_b(): u8 {
        let v = vector[1u8, 2u8, 3u8];
        let s = StructB { a: 99, b: v };
        s.a
    }
}


//# run 0xCAFE::NativeLayout::create_resource --signers 0xBABA --args 5u64 7u64


//# run 0xCAFE::NativeLayout::read_resource --signers 0xBABA


//# run 0xCAFE::NativeLayout::update_resource --signers 0xBABA


//# run 0xCAFE::NativeLayout::read_resource --signers 0xBABA


//# run 0xCAFE::NativeLayout::remove_resource --signers 0xBABA


//# run 0xCAFE::NativeLayout::use_struct_b


// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 9577520d8232c98f76911a998b011e48: Convert 'resource StructName' to 'resource struct StructName' for clarity.
// 107f519cdb04a9583c77986ee754dd01: Define struct fields with types, and ensure each field has a unique name within the struct definition.
// 9a4f6586c3a8471e51b539c30c0736b8: Ensure inline functions are called in bottom-up order so that inline functions are processed before the functions that call them.
