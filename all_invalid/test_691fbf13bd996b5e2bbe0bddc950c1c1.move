//# publish
module 0xabcde::mutable_ref_tests {

/// 1. Test multiple updates to a mutable reference to ensure cumulative modifications are reflected.
/// We will chain several updates and verify the final value.
public fun test_cumulative_updates(): u64 {
    let value = 10;
    let r = &mut value;
    *r = *r + 5;        // value should now be 15
    *r = *r * 2;        // value should now be 30
    *r = *r - 10;       // value should now be 20
    *r
}

/// 2. Test that functions with varying parameter patterns work correctly, focusing on invocation and return value.
/// We define functions with different signatures and call them through a runner.
enum FuncPattern has copy {
    NoParam(|| u64),
    OneParam(|u64| u64),
    TwoParam(|u64, u64| u64),
}

public fun run_function_pattern(f: FuncPattern): u64 {
    match (f) {
        FuncPattern::NoParam(func) => func(),
        FuncPattern::OneParam(func) => func(3),
        FuncPattern::TwoParam(func) => func(2, 3),
    }
}

public fun test_function_patterns(): vector<u64> {
    let results = vector::empty<u64>();

    let f1 = FuncPattern::NoParam(|| 42);
    vector::push_back(&mut results, run_function_pattern(f1));

    let f2 = FuncPattern::OneParam(|x| x + 1);
    vector::push_back(&mut results, run_function_pattern(f2));

    let f3 = FuncPattern::TwoParam(|x, y| x + y);
    vector::push_back(&mut results, run_function_pattern(f3));

    results
}

/// 3. Verify calling an increment function multiple times updates a local variable correctly.
public fun test_increment_multiple(): u64 {
    let counter = &mut 0;
    let mut total = 0;
    // Increment and add to total thrice
    total = total + inc(counter);
    total = total + inc(counter);
    total = total + inc(counter);
    total
}

/// Increment function: increments the referenced value and returns the new value.
public fun inc(x: &mut u64): u64 {
    *x = *x + 1;
    *x
}

}
    
//# run 0xabcde::mutable_ref_tests::test_cumulative_updates
//# run 0xabcde::mutable_ref_tests::test_function_patterns
//# run 0xabcde::mutable_ref_tests::test_increment_multiple