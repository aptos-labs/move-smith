
//# publish
module 0xCAFE::AdditionTest {
    /// Adds two u8 numbers and returns addition result plus one
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 1;
        result
    }

    /// Contains functions to multiply two numbers and add a constant
    public fun multiply(x: u8, y: u8): u8 {
        x * y
    }

    public fun add_five(z: u8): u8 {
        z + 5
    }

    public fun lambda_operations(): u8 {
        let product = multiply(3u8, 4u8);
        let final_result = add_five(product);
        final_result
    }
}



//# run 0xCAFE::AdditionTest::add_and_increment --args 5u8 10u8



//# run 0xCAFE::AdditionTest::lambda_operations




//# publish
module 0xCAFE::NestedFunction {
    use 0xCAFE::AdditionTest;

    /// Call an inline function inside AdditionTest module via nested calls
    public fun nested_calls(a: u8, b: u8): u8 {
        let sum_inc = AdditionTest::add_and_increment(a, b);
        let lambda_result = AdditionTest::lambda_operations();
        let combined = sum_inc + lambda_result;
        combined
    }
}



//# run 0xCAFE::NestedFunction::nested_calls --args 2u8 3u8




//# publish
module 0xCAFE::BlockStatements {
    /// Function with sequence of statements modifying a variable and returns the final value
    public fun sequence_statements(): u8 {
        let mut_val = 0u8;

        // Sequence of statements updating mut_val
        let val1 = mut_val + 1;
        let val2 = val1 + 2;
        let val3 = val2 + 3;

        val3
    }
}



//# run 0xCAFE::BlockStatements::sequence_statements




//# publish
module 0xCAFE::AliasExample {
    use 0xCAFE::AdditionTest as AddTest;

    /// Uses module alias to call functions in AdditionTest
    public fun alias_calls(a: u8, b: u8): u8 {
        let added = AddTest::add_and_increment(a, b);
        let lambda_val = AddTest::lambda_operations();
        added + lambda_val
    }
}



//# run 0xCAFE::AliasExample::alias_calls --args 4u8 7u8
