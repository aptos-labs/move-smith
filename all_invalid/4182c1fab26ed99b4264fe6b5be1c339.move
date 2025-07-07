//# publish
module 0xCAFE::LabelUtil {
    /// A simple function to simulate removing leading labels from a vector<u8> simulating bytecode.
    /// The label is assumed to be a prefix sequence of bytes starting with 0xAA.
    public fun remove_leading_label(code: vector<u8>): vector<u8> {
        let mut start_index = 0u64;
        let len = Vector::length(&code);

        // Find first byte not equal to 0xAA prefix label byte
        while (start_index < len) {
            let byte = *Vector::borrow(&code, start_index as u64);
            // If not label byte, break
            if (byte != 0xAA) {
                break;
            };
            start_index = start_index + 1;
        };

        // Return slice from start_index to end
        Vector::sub_vector(&code, start_index, len)
    }

    /// A runner function that shows removing leading label on a demo bytecode vector.
    public fun runner(): vector<u8> {
        let code = b"\xAA\xAA\xAA\x01\x02\x03";
        remove_leading_label(code)
    }
}
//# run 0xCAFE::LabelUtil::runner


//# publish
module 0xCAFE::Destructuring {
    /// A struct with one type parameter T and two fields.
    struct Pair<T> has copy, drop, store {
        first: T,
        second: T,
    }

    /// Returns the sum of the two fields of a Pair<u64>
    public fun sum_pair(p: Pair<u64>): u64 {
        let Pair { first: a, second: b } = p;
        a + b
    }

    /// Demonstrates binding variables by name and destructuring a tuple and struct.
    public fun runner(): u64 {
        // Destructure struct
        let pair = Pair<u64> { first: 42, second: 58 };
        let Pair { first: x, second: y } = pair;

        // Destructure tuple
        let (u, v) = (x, y);

        // Use variables
        u + v + sum_pair(pair)
    }
}
//# run 0xCAFE::Destructuring::runner


//# run
script {
    use 0xCAFE::LabelUtil;
    use 0xCAFE::Destructuring;

    fun main() {
        // Test label removing utility
        let code_with_label = b"\xAA\xAA\xBB\xCC\xDD";
        let cleaned = LabelUtil::remove_leading_label(code_with_label);
        // Just bind to a variable to exercise the code
        let _ = cleaned;

        // Test destructuring solutiion
        let pair = Destructuring::Pair<u64> { first: 100, second: 23 };
        let result = Destructuring::sum_pair(pair);
        let (a, b) = (result, 77);
        let Pair { first, second } = pair;
        let _final_sum = first + second + a + b;
    }
}

// Featurres:
// 0c5654bd569406574cefb2f5df29c13d: Remove the leading label from a sequence of bytecode instructions to clean up or prepare code for further processing.
// 9b265d2bf6b06a6082cc900e138e6587: Define modules containing structs with type parameters
// 18f3da722b15398e9d31ffbe936f6a27: Bind variables by name or destructure them in Move assignments or let-bindings.
