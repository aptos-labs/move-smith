
//# publish
module 0xCAFE::LoopAndQualifiedNameTest {
    use std::vector;

    struct Container<T> has store {
        items: vector<T>
    }

    public fun create_container(): Container<u8> {
        let v = vector::empty<u8>();
        for (i in 0..4) {
            vector::push_back(&mut v, i as u8); 
        };
        Container { items: v }
    }

    public fun sum_container(container: Container<u8>): u8 {
        let sum = 0u8;
        let len = vector::length(&container.items);
        for (i in 0..len) {
            let val = *vector::borrow(&container.items, i);
            sum = sum + val;
        };
        sum
    }

    public fun qualified_name_test(): u32 {
        // The following line uses a number literal followed by ::
        // to access a qualified name (a struct or constant in an address).
        // Here we use 0xCAFE::LoopAndQualifiedNameTest::MAGIC_NUM
        // This tests the parser's handling of number literal with ::
        0xCAFE::LoopAndQualifiedNameTest::MAGIC_NUM
    }

    const MAGIC_NUM: u32 = 2024;

}



//# run 0xCAFE::LoopAndQualifiedNameTest::create_container



//# run 0xCAFE::LoopAndQualifiedNameTest::sum_container --args '[0xCAFE::LoopAndQualifiedNameTest::create_container]'



//# run 0xCAFE::LoopAndQualifiedNameTest::qualified_name_test
