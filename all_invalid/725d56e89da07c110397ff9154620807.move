//# publish
module 0xCAFE::GenericFunctions {
    use std::debug;

    // A simple struct just to instantiate generic types with a type parameter
    struct Box<T> has copy, drop, store {
        value: T,
    }

    /// A generic function with one generic type parameter
    public fun id<T>(x: T): T {
        x
    }

    /// A generic function with two generic type parameters that returns a tuple of them swapped
    public fun swap<A, B>(a: A, b: B): (B, A) {
        (b, a)
    }

    /// A generic function that takes Box<T> and returns inner value
    public fun unpack_box<T>(b: Box<T>): T {
        b.value
    }

    /// A "runner" function to call the generic functions with concrete types
    public fun runner() {
        let x = id<u64>(42u64);
        let (b, a) = swap<u8, bool>(7u8, true);

        let boxed = Box<u32> { value: 999u32 };
        let val = unpack_box<u32>(boxed);

        // Use debug to avoid unused variable warnings
        debug::print(&x);
        debug::print(&b);
        debug::print(&a);
        debug::print(&val);
    }
}
 //# run 0xCAFE::GenericFunctions::runner


//# publish
module 0xCAFE::LoopReturnTest {
    /// A function with a loop and an `if` that breaks and returns from the caller directly.
    /// To test `loop return` functionality in script context.
    public fun test_loop_return(): bool {
        let mut x = 0u8;
        loop {
            if (x == 3u8) {
                // return from the function immediately
                return true;
            };
            x = x + 1u8;
        };
        // unreachable normally, but match function signature
        false
    }
}
 //# run 0xCAFE::LoopReturnTest::test_loop_return


//# publish
module 0xCAFE::AstDebugTest {
    use std::debug;

    /// A dummy AST node enum for demonstration
    enum AstNode {
        Number(u64),
        Add(Box<AstNode>, Box<AstNode>),
    }

    /// Implement a function ast_debug that formats the AstNode to the writer
    public fun ast_debug(node: &AstNode, w: &mut debug::Formatter) {
        match node {
            AstNode::Number(val) => {
                debug::write_fmt(w, b"Number(");
                debug::write_fmt(w, &debug::format_int(*val));
                debug::write_fmt(w, b")");
            },
            AstNode::Add(left, right) => {
                debug::write_fmt(w, b"Add(");
                ast_debug(left, w);
                debug::write_fmt(w, b", ");
                ast_debug(right, w);
                debug::write_fmt(w, b")");
            },
        }
    }

    /// A runner function to exercise ast_debug printing
    public fun runner() {
        // Construct ast: Add(Number(1), Add(Number(2), Number(3)))
        let ast = AstNode::Add(
            Box::new(AstNode::Number(1u64)),
            Box::new(AstNode::Add(
                Box::new(AstNode::Number(2u64)),
                Box::new(AstNode::Number(3u64))
            ))
        );
        let mut formatter = debug::new_formatter();
        ast_debug(&ast, &mut formatter);
        debug::print(&formatter.to_string());
    }
}
 //# run 0xCAFE::AstDebugTest::runner


//# run
script {
    use 0xCAFE::GenericFunctions;
    use 0xCAFE::LoopReturnTest;
    use 0xCAFE::AstDebugTest;

    fun main() {
        // Call the runner function of GenericFunctions (tests generics)
        GenericFunctions::runner();

        // Call loop return testing function and ignore result (tests loop and return)
        let _ = LoopReturnTest::test_loop_return();

        // Call ast debug runner function (tests custom formatting)
        AstDebugTest::runner();
    }
}

// Featurres:
// 0362c11170925d1fab2bbbc90bb94a42: Declare generic type parameters for functions
// 0152aafeff6b98a8df2dd0b869900afd: Test that the `loop return` statement correctly exits a script even when used inside an `if` block.
// 87e2cb067ecab53a90f4137349ead1fa: Implement custom formatting for AST nodes by calling 'ast_debug' with a writer.
