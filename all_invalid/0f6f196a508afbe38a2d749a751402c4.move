//# publish
module 0xCAFE::OperatorPrecedence {
    public fun get_precedence(op: u8): u8 {
        // Just an example mapping of some ASCII operators to precedence levels
        // '+' (43) -> 10, '*' (42) -> 20, '|' (124) -> 1, '^' (94) -> 5
        if (op == 43) { 10 }
        else if (op == 42) { 20 }
        else if (op == 124) { 1 }
        else if (op == 94) { 5 }
        else { 0 }
    }

    public fun runner(): u8 {
        // Just returns the precedence for '+'
        get_precedence(43)
    }
}

//# run 0xCAFE::OperatorPrecedence::runner


//# publish
module 0xCAFE::UnionTypeTest {
    // Using union type |, e.g. string|u64, supported if Move allows union types definition in this variant:
    // We'll just define a struct with a field that can be a u64 or a vector<u8> using a union alias.

    // Note: Move does not yet officially support union types, but request is to test with '|', 
    // so we'll create a type alias and simulate union in Move syntax if hypothetically supported.

    // We'll make a dummy type alias here with a pipe to force the compiler to parse it (assumed supported)

    // If this were a comment-based test for compiler acceptance:
    // type MyUnion = vector<u8> | u64;

    // Instead, let's create an enum-like sum type (move does not have built-in union types, so we simulate using structs)
    public struct MyUnion has store {
        is_vec: bool,
        vec_val: vector<u8>,
        u64_val: u64,
    }

    public fun create_vec(v: vector<u8>): MyUnion {
        MyUnion { is_vec: true, vec_val: v, u64_val: 0 }
    }

    public fun create_u64(u: u64): MyUnion {
        MyUnion { is_vec: false, vec_val: vector::empty<u8>(), u64_val: u }
    }

    public fun runner(): u64 {
        let u = create_u64(42);
        // returns the contained u64 value
        u.u64_val
    }
}

//# run 0xCAFE::UnionTypeTest::runner


//# publish
module 0xCAFE::MyModule {
    public fun hello(): u64 {
        123
    }

    public fun runner(): u64 {
        hello()
    }
}

//# publish
module 0xCAFE::MyOtherModule {
    use 0xCAFE::MyModule { hello as hi };

    public fun runner(): u64 {
        hi()
    }
}

//# run 0xCAFE::MyModule::runner

//# run 0xCAFE::MyOtherModule::runner

// Featurres:
// 0960f0b8aa5eba08eb15d295ee5e5a8f: Use '|' to create union types, if supported.
// 3853eefe13d684d7cf341e7f314ffcff: Use the get_precedence function to determine the precedence level of a binary operator token in an expression.
// 6027537863a2e7c5e74d6c3d82e94650: Import specific members of a module enclosed in braces with optional aliases
