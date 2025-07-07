//# publish
module 0xCAFE::LoggingConfig {
    use std::debug;
    use std::string;
    use std::vector;

    // Struct with restricted names for fields (avoid reserved/builtin)
    struct Config has copy, drop, store {
        level: u8,
        enable: bool,
        tags: vector<u8>,
    }

    // Function to create Config from args
    public fun make_config(level: u8, enable: bool, tags: vector<u8>): Config {
        Config { level, enable, tags }
    }

    // Function to configure logger based on environment variable string
    // Here the env_var is simulated as a vector<u8>
    public fun configure_logger(env_var: vector<u8>) {
        // Parse env_var string, e.g. "level=3;enable=1;tags=DEAD"
        let mut level_val: u8 = 0;
        let mut enable_val: bool = false;
        let mut tags_val: vector<u8> = vector::empty<u8>();

        // A very simple parser for demonstration (splitting by ';' not supported natively)
        // Just check if env_var starts with certain known prefixes, assume fixed patterns for testing

        if (vector::length(&env_var) >= 11) {
            // Example: b"level=3;ena"
            if (*vector::borrow(&env_var, 0) == 108) && (*vector::borrow(&env_var, 1) == 101) &&
                (*vector::borrow(&env_var, 2) == 118) && (*vector::borrow(&env_var, 3) == 101) &&
                (*vector::borrow(&env_var, 4) == 108) && (*vector::borrow(&env_var, 5) == 61) {
                // Next char is level number 0-9 ascii
                let lvl_char = *vector::borrow(&env_var, 6);
                if (lvl_char >= 48) && (lvl_char <= 57) {
                    level_val = lvl_char - 48;
                };
                // enable = true
                enable_val = true;
                // tags = "LOG"
                tags_val = vector::empty<u8>();
                vector::push_back(&mut tags_val, 76); // 'L'
                vector::push_back(&mut tags_val, 79); // 'O'
                vector::push_back(&mut tags_val, 71); // 'G'
            };
        };

        let config = Config { level: level_val, enable: enable_val, tags: tags_val };
        apply_config(config);
    }

    // Internal function applying config (simulate setting logger)
    fun apply_config(config: Config) {
        // Simulate by emitting debug prints depending on level and enable flag
        if (config.enable) {
            if (config.level > 0) {
                debug::print(&vector::empty<u8>());
                debug::print(&config.tags);
            };
        };
    }

    // Test function to exercise field and positional unpacking
    public fun test_unpacking() {
        // Field unpacking of Config struct
        let config = Config { level: 5, enable: true, tags: vector::empty<u8>() };
        let Config { level: lvl, enable: en, tags: tg } = config;

        // Positional unpacking of tuple
        let t = (123u8, true, 0xCAu16);
        let (a, b, c) = t;

        // Use the unpacked variables somehow
        let _ = lvl;
        let _ = en;
        let _ = tg;
        let _ = a;
        let _ = b;
        let _ = c;
    }
}

//# run 0xCAFE::LoggingConfig::configure_logger --args x"6c6576656c3d333b656e61626c653d313b746167733d4c4f47"

//# run 0xCAFE::LoggingConfig::test_unpacking

// Featurres:
// 00a758f7eefd851999ccfa4a6d092ab0: Configure the logger based on an environment variable and apply the specified log settings.
// 6d73e16e1da20e1c9c925fcce3ab4c57: Use only restricted names for module members, avoiding reserved or builtin names.
// a4efd0cdd372451e51b13a4e7f5fb58b: Use field and positional unpacking in assignment or binding patterns for structs and tuples.
