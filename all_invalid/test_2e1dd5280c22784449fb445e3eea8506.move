//# publish
module 0xabcde::ref_test {

    fun nested_ref(p: u64): u64 {
        let r1 = &p;
        let r2 = &r1;
        let r3 = &r2;
        *r3 // Should dereference back to p
    }

    fun modify_value_in_ref(p: &mut u64): () {
        *p = *p + 10;
    }

    public fun main() {
        // Test nested immutable references
        let val = 100;
        assert!(nested_ref(val) == 100, 1);

        // Test mutable reference dereference and modification
        let mut data = 50;
        modify_value_in_ref(&mut data);
        assert!(data == 60, 2);
    }
}

//# run 0xabcde::ref_test::main