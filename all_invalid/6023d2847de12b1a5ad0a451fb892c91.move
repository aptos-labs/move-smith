public fun foo(x: u64): u64 {
    let y = 10u64;
    let z = y + x;
    y = y + 1; // update y
    z + y
}
