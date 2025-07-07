
//# publish
module 0xDEAD::InlineInteraction {
    // This module tests inline functions, their visibility, and cross-module invocation.

    // Public inline function
    public inline fun inline_public_func(x: u8): u8 {
        x + 1
    }

    // Friend inline function (simulate as public for testing)
    // Move currently doesn't have 'friend' concept explicitly, so for test, consider public.
    inline fun inline_friend_func(y: u8): u8 {
        y * 2
    }
}


//# publish
module 0xBADD::OtherModule {
    // This module tries to invoke inline functions from 0xDEAD, respecting visibility.

    // Call public inline function from 0xDEAD::InlineInteraction
    public fun call_inline_public(x: u8): u8 {
        0xDEAD::InlineInteraction::inline_public_func(x)
    }

    // Call inline 'friend' function from 0xDEAD::InlineInteraction
    public fun call_inline_friend(y: u8): u8 {
        0xDEAD::InlineInteraction::inline_friend_func(y)
    }
}


//# run 0xBADD::OtherModule::call_inline_public --args 5u8

//# run 0xBADD::OtherModule::call_inline_friend --args 7u8


//# publish
module 0xFEED::AnnotatedFunctions {
    // Functions with specification annotations.

    // Example precondition annotation
    // spec(pre = "x > 0")]
    public fun preconditioned_func(x: u64): u64 {
        x + 10
    }

    // Example postcondition annotation (note: in Move, annotations are structural, simulate with comments)
    // For actual verification, these annotations would be processed by tools.
    // spec(post = "result >= 10")]
    public fun postconditioned_func(x: u64): u64 {
        x + 10
    }

    // Loop invariant annotation
    // spec(invariant = "x >= 0")]
    public fun loop_with_invariant(x: u64): u64 {
        let v = x;
        while (v > 0) {
            // Loop body
            v = v - 1;
        };
        v
    }
}


//# run 0xFEED::AnnotatedFunctions::preconditioned_func --args 5u64

//# run 0xFEED::AnnotatedFunctions::postconditioned_func --args 5u64

//# run 0xFEED::AnnotatedFunctions::loop_with_invariant --args 5u64


//# publish
module 0xC001::SkipLints {
    // Functions annotated with // skip] to suppress specific lints.

    // Example: skip unused variable warning
    // skip(unused)]
    public fun skip_unused_variable() {
        let _ = 42; // intentionally unused, warning skipped
    }

    // Skip lint for dead code
    // skip(dead_code)]
    public fun dead_code_function() {
        // no call
        ()
    }

    // Skip multiple lints
    // skip(unused, dead_code)]
    public fun multiple_skip() {
        let unused_var = 10; // warning skipped
        // no other code
        ()
    }

    // Use inline functions with skip annotation
    // skip(unused)]
    public inline fun inline_skip_func(x: u8): u8 {
        x + 1
    }
}


//# run 0xC001::SkipLints::skip_unused_variable --args 0u8

//# run 0xC001::SkipLints::dead_code_function

//# run 0xC001::SkipLints::multiple_skip --args 0u8

//# run 0xC001::SkipLints::inline_skip_func --args 5u8


// Featurres:
// 6313f2fc4f513c9bfe7ae3313b8c4a5e: Inline public or friend functions across module boundaries when permitted by visibility rules.
// 522df60549cb236f4d9ecd7a30ca9aba: Annotate functions with specification blocks for formal verification or documentation.
// 934f25f8d7e4c1f5e940ba86173abd13: Use the `#[skip(...)]` attribute with a list of lint check names to skip certain lint checks.
