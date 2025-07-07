//# publish
module 0x42::m {
    use std::vector;

    // Define nested vectors of u8 and u64 for testing
    const KEYS: vector<vector<vector<u8>>> = vector[
        vector[
            b"alpha", b"beta"
        ],
        vector[
            b"gamma", b"delta"
        ]
    ];

    const VALUES: vector<vector<u64>> = vector[
        vector[10, 20, 30],
        vector[40, 50]
    ];

    // Function to process KEYS: map each inner vector of u8, appending a suffix byte
    public fun process_keys() {
        let transformed_keys: vector< vector< u8 > > = vector::map<vector< u8 >, vector< u8 > >( KEYS, |key_vec| {
            let len = vector::length::<u8>(key_vec);
            let mut result: vector<u8> = vector::empty();
            vector::borrow_mut(&mut result, vector::length::<u8>(&result));
            // Append a byte depending on the length
            vector::push_back(&mut result, b'X');
            vector::extend(&mut result, &key_vec);
            result
        });
        // For demonstration, just discard the result or perform further processing if needed
    }

    // Function to process VALUES: map each vector of u64 by adding 100 to each element
    public fun process_values() {
        let transformed_values: vector< vector< u64 > > = vector::map< vector< u64 >, vector< u64 > >( VALUES, |val_vec| {
            vector::map<u64, u64>( val_vec, |v| v + 100)
        });
        // For demonstration, just discard the result or perform further processing if needed
    }

    // Runner function to test both
    public fun run_tests() {
        process_keys();
        process_values();
    }
}

//# run 0x42::m::run_tests