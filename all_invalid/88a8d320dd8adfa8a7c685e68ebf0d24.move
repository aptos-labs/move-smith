invariant forall addr: address where exists<Counter>(addr):
    let c = borrow_global<Counter>(addr);
    c.value <= 100;
