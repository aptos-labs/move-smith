// #publish
module 0xCAFE::TestMembers {
    public fun foo(): u64 {
        42
    }
    public fun bar(): bool {
        true
    }
    public fun alias_test(): u64 {
        100
    }
    public struct MyStruct has copy, drop, store {
        x: u64,
        y: bool,
    }
    public struct NamedFields has copy, drop, store {
        a: u8,
        b: u8,
    }
}

// #run 0xCAFE::TestMembers::foo
// #run 0xCAFE::TestMembers::bar
// #run 0xCAFE::TestMembers::alias_test

// #publish
module 0xCAFE::UseMembers {
    use 0xCAFE::TestMembers::{foo, bar as baz, MyStruct};

    public fun test_imports(): bool {
        let f = foo();
        let b = baz();
        // Creating struct variant with brace-enclosed named fields
        let s = MyStruct { x: f, y: b };
        s.y
    }

    public fun block_expr(): u64 {
        let x = { 
            let a = 10;
            let b = 20;
            a + b
        };
        x
    }

    // Runner function with no args that exercises above
    public fun runner(): bool {
        let res = test_imports();
        let sum = block_expr();
        res && (sum == 30)
    }
}
// #run 0xCAFE::UseMembers::runner

// #run 0xCAFE::UseMembers::test_imports
// #run 0xCAFE::UseMembers::block_expr

// Featurres:
// 4ebd003b016e539a91b7c9e4c96572c2: Use 'members' declarations to import specific members of a module with optional aliasing.
// 6192873014e042dc5a2e54f216cd6688: Write code blocks as expressions using curly braces ('{ ... }') to denote a block expression that evaluates to the last statement's value.
// d4c2fc54c14f3d271cc88c77b20e0a81: Create struct variants with brace-enclosed named fields.
