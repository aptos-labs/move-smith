
//# publish
module 0xCAFE::ComputeModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun call_lambda_with_arg(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 5
        };
        lambda(x)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let result = 0xCAFE::ComputeModule::add_and_return_sum(x, y);
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            let inline_result = inline_fn(v);
            inline_result * 2
        };
        lambda(result)
    }

    public inline fun inline_fn(a: u8): u8 {
        a + 3
    }

    public fun utf8_string_examples() {
        // Move byte arrays support only ASCII characters directly with b""
        // For UTF-8 multi-byte characters, use vector<u8> with hex bytes or ascii char literals

        // Japanese "こんにちは" in UTF-8 bytes:
        let s1: vector<u8> = vector[
            0xE3, 0x81, 0x93, 0xE3, 0x82, 0x93, 0xE3, 0x81, 0xAB, 0xE3, 0x81, 0xA1, 0xE3, 0x81, 0xAF
        ];
        // Greek "Γειά σου Κόσμε":
        let s2: vector<u8> = vector[
            0xCE, 0x93, 0xCE, 0xB5, 0xCE, 0xB9, 0xCE, 0xAC, 0x20, 0xCF, 0x83, 0xCE, 0xBF, 0xCF, 0x85, 0x20,
            0xCE, 0x9A, 0xCF, 0x8C, 0xCF, 0x83, 0xCE, 0xBC, 0xCE, 0xB5
        ];
        // Emoji "😊👍🏽" (each emoji is multiple bytes):
        let s3: vector<u8> = vector[
            0xF0, 0x9F, 0x98, 0x8A,   // 😊
            0xF0, 0x9F, 0x91, 0x8D,   // 👍
            0xF0, 0x9F, 0x8F, 0xBD    // 🏽 (skin tone modifier)
        ];
    }
}



//# run 0xCAFE::ComputeModule::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::ComputeModule::call_lambda_with_arg --args 7u8



//# run 0xCAFE::ComputeModule::nested_call --args 4u8 6u8



//# run 0xCAFE::ComputeModule::utf8_string_examples
