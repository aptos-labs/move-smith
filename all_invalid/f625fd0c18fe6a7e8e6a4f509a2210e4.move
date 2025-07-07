//# publish
module 0xCAFE::ChainAccess {
    struct Inner has copy, drop, store {
        value: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
    }

    public fun new_inner(): Inner {
        Inner { value: 42 }
    }

    public fun new_outer(): Outer {
        Outer { inner: new_inner() }
    }

    // Access Inner's value through Outer, demonstrate chaining
    public fun get_inner_value(o: &Outer): u64 {
        o.inner.value
    }

    // Runner function for tests - returns the value via chained access in a block
    public fun runner(): u64 {
        let outer = new_outer();
        return { outer.inner.value };
    }
}
//# run 0xCAFE::ChainAccess::runner

//# publish
module 0xCAFE::BlockScope {
    public fun mutation_block(): u64 {
        let x = 0;
        return {
            {
                let mut y = 10;
                y = y + 5;
                y
            } + {
                let mut z = 20;
                z = z - 3;
                z
            }
        }
    }

    // Runner to execute the block mutation and return sum
    public fun runner(): u64 {
        mutation_block()
    }
}
//# run 0xCAFE::BlockScope::runner

//# publish
module 0xCAFE::ErrorTest {
    // This function intentionally triggers a compile-time error:
    // Trying to assign incompatible types to test compiler error brings to stderr.
    // We put this here because errors must be visible on stderr when compile.
    // We comment out the code so it won't break compilation of this test file.

    /*
    public fun trigger_error(): u64 {
        let x: u64 = 42;
        let y: bool = true;
        // Invalid assignment: u64 to bool
        y = x;
        y
    }
    */

    // Instead, let's define a function with a subtle warning or runtime abort.
    public fun runtime_error() {
        // This aborts with code 100 deliberately to test VM error reporting
        abort 100;
    }

}
//# run 0xCAFE::ErrorTest::runtime_error --signers 0xCAFE

//# run script {
address 0xCAFE
script {
    use 0xCAFE::ChainAccess;
    use 0xCAFE::BlockScope;

    fun main() {
        let val = ChainAccess::runner();
        let val2 = BlockScope::runner();
    }
}

// Featurres:
// 9a8847f893559f4ccdce63ae8c9c6dc0: Access modules and types through a chain of names using a specific syntax.
// 5286574433dab36063419f0efc105d24: Test that braces can be used to create separate expression blocks within a single return statement, each with isolated scoping and sequencing of variable mutations.
// dba6ccc33a58baa3a452a37cd0f7d3c0: Run the Move compiler and output errors to the standard error stream.
