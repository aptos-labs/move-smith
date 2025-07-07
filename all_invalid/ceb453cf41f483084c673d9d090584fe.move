test invariant_test {
    // Create a Counter resource at some address, for demonstration
    let addr = @0x1;
    if (!exists<Counter>(addr)) {
        move_to(&addr, Counter { value: 42 });
    }

    invariant forall addr: address where exists<Counter>(addr) {
        let c = borrow_global<Counter>(addr);
        assert!(c.value <= 100, 1);
    }
}
