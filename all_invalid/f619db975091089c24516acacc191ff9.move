
//# publish
module 0xCAFE::TestModuleA {
    use std::vector;

    public fun add_and_return_specific_result(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let anon: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        anon(a, b)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun use_type_param<T: copy>(val: T): vector<T> {
        let result = vector::empty<T>();
        vector::push_back(&mut result, val);
        result
    }

    // Node struct for neighbor walk with potential cycles
    struct Node has store {
        value: u8,
        neighbors: vector<address>
    }

    public fun create_node(value: u8): Node {
        Node {value, neighbors: vector::empty<address>()}
    }

    public fun add_neighbor(node: &mut Node, neighbor: address) {
        vector::push_back(&mut node.neighbors, neighbor);
    }

    public fun get_neighbor_count(node: &Node): u64 {
        vector::length(&node.neighbors)
    }
}



//# publish
module 0xCAFE::TestModuleB {
    use 0xCAFE::TestModuleA;

    public fun call_inline_add_from_a(x: u8, y: u8): u8 {
        TestModuleA::inline_add(x, y)
    }

    public fun type_param_caller<T: copy>(val: T): vector<T> {
        TestModuleA::use_type_param<T>(val)
    }
}



//# publish
module 0xCAFE::TestModuleC {
    public fun test(cond: bool): u8 {
        if (cond) {
            1
        } else {
            9
        }
    }
}



//# run
script {
    use 0xCAFE::TestModuleA;
    use 0xCAFE::TestModuleB;
    use 0xCAFE::TestModuleC;

    fun main() {
        // Test 1: add_and_return_specific_result, expect 3+4+10=17
        let _r1 = TestModuleA::add_and_return_specific_result(3u8, 4u8);

        // Test 2: lambda_example, expect 5+6=11
        let _r2 = TestModuleA::lambda_example(5u8, 6u8);

        // Test 3: call inline function from TestModuleA via TestModuleB
        let _r3 = TestModuleB::call_inline_add_from_a(7u8, 8u8);

        // Test 4: use type parameter with u16 and bool
        let _vec_u16 = TestModuleB::type_param_caller<u16>(123u16);
        let _vec_bool = TestModuleB::type_param_caller<bool>(true);

        // Test 5: walk neighbors to explore cycles
        let node1 = TestModuleA::create_node(1);
        let node2 = TestModuleA::create_node(2);
        let addr_node2 = @0xCAFE; // For testing purpose, fake address as neighbor
        let node1_mut = node1;
        let node2_mut = node2;
        TestModuleA::add_neighbor(&mut node1_mut, addr_node2);
        TestModuleA::add_neighbor(&mut node2_mut, @0xDEAD); // another fake neighbor

        let _count1 = TestModuleA::get_neighbor_count(&node1_mut);
        let _count2 = TestModuleA::get_neighbor_count(&node2_mut);

        // Test 6: test function returns 1 when true, 9 when false
        let _rtrue = TestModuleC::test(true);
        let _rfalse = TestModuleC::test(false);
    }
}
