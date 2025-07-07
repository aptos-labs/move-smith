// Transactional test code for Aptos Move compiler and VM
// Testing:
// 1) Use sequences within binary operations only when trivial (single expression or side-effect free)
// 2) Group expressions or call functions using parentheses and braces
// 3) Declare struct fields with specific signatures and names

module 0x1::TestSeqBinOps {

    // Struct with specific field names and types (signatures)
    struct MyStruct has copy, drop, store {
        pub id: u64,
        pub flag: bool,
        data: vector<u8>,
    }

    // A pure, side-effect free function returning an integer
    fun pure_add(x: u64, y: u64): u64 {
        x + y
    }

    // Function with a side effect (writing to storage, in this isolated test, we'll simulate it by returning a struct)
    fun side_effect_fn(x: u64): MyStruct {
        MyStruct { id: x, flag: true, data: vector::empty<u8>() }
    }

    /// Helper function that returns single value wrapped in parentheses and braces
    fun wrapped_call(x: u64): u64 {
        ( { x + 1 } )
    }

    /// Test entry, annotated with #[test] for Move unit test
    #[test]
    public fun test_sequences_and_groupings() {
        // 1. Use sequences only when trivial (single expression or side-effect free)
        // Allowed: sequence with single expression (side-effect free)
        let a = (pure_add(10, 20));
        let b = ( { 5 + 3 } );  // trivial grouping with braces
        let c = pure_add( (1 + 2), (3 + 4) ); // sequences used in binary ops as single expressions

        // Disallowed (commented out): sequence with side effects inside binary ops (would fail compiler if not trivial)
        // let se = (side_effect_fn(10)).id + 10; // side_effect_fn returns struct, considered side-effect
        // Instead, call side_effect_fn outside binary op
        let se_struct = side_effect_fn(10);
        let d = se_struct.id + 10;

        // 2. Group expressions or call functions using parentheses and braces
        let e = (pure_add( (1 + 1), { 2 + 2 } ));
        let f = ({ pure_add(5, 5) } + { pure_add(2, 3) });

        // 3. Declare struct fields with specific signatures and names - done in struct MyStruct above
        let test_struct = MyStruct { id: 42, flag: true, data: vector::empty<u8>() };

        // Validate fields
        assert!(test_struct.id == 42, 1);
        assert!(test_struct.flag == true, 2);
        assert!(vector::length(&test_struct.data) == 0, 3);

        // Additional asserts to confirm all computations
        assert!(a == 30, 4);
        assert!(b == 8, 5);
        assert!(c == 10, 6);
        assert!(d == 20, 7);
        assert!(e == 6, 8);
        assert!(f == 15, 9);
    }
}

// Featurres:
// 60950f7a10df64626cbcbfcece55e39c: Use sequences within binary operations only when they are trivial, meaning they consist of a single expression or are potentially side-effect-free.
// 15f88aaf1be091ff2dd9fcdda4546618: Group expressions or call functions using parentheses and braces.
// 197cdcb39c3186bef4e6d6e229772907: Declare struct fields with specific signatures and names.
