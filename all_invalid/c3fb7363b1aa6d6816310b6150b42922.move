let a: u8 = 10; // 0b1010
let b: u8 = 12; // 0b1100
assert!(a & b == 8, 401);
assert!(a | b == 14, 402);
assert!(a ^ b == 6, 403);
assert!(!a == 5, 404);