//# publish
module 0xCAFE::TestAssignIfElse {
    public fun assign_if_else(x: u8, flag: bool): u8 {
        let val = if flag then 10u8 else 20u8;
        let sum = x + val;
        sum
    }
}

//# run 0xCAFE::TestAssignIfElse::assign_if_else --args 5u8 true

//# run 0xCAFE::TestAssignIfElse::assign_if_else --args 5u8 false

//# publish
module 0xCAFE::TestInlineFunctionWithLambda {
    public inline fun apply_lambda(f: |u8| u8, val: u8): u8 {
        f(val)
    }

    public fun call_runner(): u8 {
        let increment = |a: u8| { a + 1 };
        apply_lambda(increment, 7u8)
    }
}

//# run 0xCAFE::TestInlineFunctionWithLambda::apply_lambda --args 0x1::Std::vector::empty<u8>()

//# run 0xCAFE::TestInlineFunctionWithLambda::call_runner

//# publish
module 0xCAFE::MakeFilesSourceText {
    // Just a dummy struct to simulate what was requested: 
    // create a mapping from content hash to file contents
    use std::hash;
    use std::string;
    use std::vector;

    struct FileContent has store, copy, drop {
        name: vector<u8>,
        content: vector<u8>,
    }

    public fun make_files_source_text(): vector<FileContent> {
        let file1_name = b"file1.move";
        let file1_content = b"module 0xCAFE::Hello { public fun hello() {} }";
        let file2_name = b"file2.move";
        let file2_content = b"module 0xCAFE::World { public fun world() {} }";

        let fc1 = FileContent { name: vector::copy(&file1_name), content: vector::copy(&file1_content) };
        let fc2 = FileContent { name: vector::copy(&file2_name), content: vector::copy(&file2_content) };

        vector[fc1, fc2]
    }
}

//# run 0xCAFE::MakeFilesSourceText::make_files_source_text

// Featurres:
// 637de7a85680d386bdf7afa6060e776a: Use `make_files_source_text` to generate a mapping from file content hashes to file names and contents for a set of source files.
// 7c1276e62daf1f29cf6bb2d08c315f97: Test that variable assignment inside an if-else expression without surrounding braces is correctly handled by the Move language.
// ce0b87fbc06882d26f1bfd9a5b30df50: Test that an inline function can accept a function value (lambda/closure) as an argument and invoke it correctly.
