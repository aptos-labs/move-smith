invariant forall addr: address where exists<Counter>(addr) {
    let c = borrow_global<Counter>(addr);
    assert!(c.value <= 100, 1);
}
