// This transactional test is designed to exercise the Aptos Move compiler and VM features,
// including live variable analysis, state formatting, and ability declarations.

//# publish
address 0xCAFE {
    module LiveVarAnalysis {
        // Declare a struct with multiple abilities to test ability declarations
        struct Data has store, drop, copy {
            a: u64,
            b: bool,
            c: vector<u8>,
        }

        // A function that mutably updates fields of Data to generate live variables
        public fun mutate_data(data: &mut Data) {
            data.a = data.a + 1;
            data.b = !data.b;
            let len = Vector::length(&data.c);
            if (len > 0) {
                Vector::push_back(&mut data.c, 42u8);
            }
        }

        // A runner function to call mutate_data and test live variables before and after mutations
        public fun runner() {
            // Initialize a Data instance
            let mut data = Data { a: 1, b: false, c: b"init".to_vec() };

            // Format initialized state before mutation
            let before = format_state(&data);

            // Mutate data (live variables should be updated in compiler analysis)
            mutate_data(&mut data);

            // Format initialized state after mutation
            let after = format_state(&data);

            // Note: No asserts as per instructions; just canonical calls
            // Normally output would be inspected by testing infrastructure
            let _ = before;
            let _ = after;
        }

        // Format the state of Data struct to a human-readable vector<u8> string representation
        public fun format_state(data: &Data): vector<u8> {
            // Compose a byte string with values; manual formatting since no string concat
            // Format: b"a=<val>", b" b=<val>", b" c_len=<val>"
            let mut res = b"a=".to_vec();
            res = Vector::append(&mut res, u64_to_bytes(data.a));

            res = Vector::append(&mut res, b" b=".to_vec());
            res = Vector::append(&mut res, bool_to_bytes(data.b));

            res = Vector::append(&mut res, b" c_len=".to_vec());
            let clen = Vector::length(&data.c);
            res = Vector::append(&mut res, u64_to_bytes((clen as u64)));

            res
        }

        // Helper: convert u64 to vector<u8> decimal representation
        fun u64_to_bytes(mut n: u64): vector<u8> {
            // Convert number to decimal string in bytes; simple implementation for test
            if (n == 0) {
                return b"0".to_vec();
            }
            let mut digits = Vector::empty<u8>();
            while (n > 0) {
                let d = (n % 10) as u8 + b'0'; // ascii digit
                Vector::push_back(&mut digits, d);
                n = n / 10;
            }
            // Reverse digits
            let len = Vector::length(&digits);
            let mut res = Vector::empty<u8>();
            let mut i = len;
            while (i > 0) {
                i = i - 1;
                Vector::push_back(&mut res, *Vector::borrow(&digits, i));
            }
            res
        }

        // Helper: convert bool to vector<u8> "true" or "false"
        fun bool_to_bytes(b: bool): vector<u8> {
            if (b) {
                b"true".to_vec()
            } else {
                b"false".to_vec()
            }
        }
    }
}
//# run 0xCAFE::LiveVarAnalysis::runner

//# run
script {
    use 0xCAFE::LiveVarAnalysis;

    fun main() {
        LiveVarAnalysis::runner();
    }
}

// Featurres:
// cec73c9384cb63d81368e9c1ec7f0ce0: Use LiveVarAnalysis to identify live variables at different points in the code.
// 43de0db466755c92c60ddc4728051400: Format the initialized state information before and after a given code offset into a human-readable string.
// 40b25a92ef0926381eceacf684bafd76: Declare abilities for a type by writing 'has' followed by the ability names after the type.
