//# publish
module 0x42::mut_borrow_test {
    struct Config has drop {
        threshold: u64,
        max_value: u64,
    }

    struct DataHolder has drop {
        config: Config,
        value: u64,
    }

    /// Function to demonstrate immutable borrow to read nested struct fields
    fun read_config_fields(holder_ref: &DataHolder) {
        let Config { threshold, max_value } = &holder_ref.config;
        // Read fields via immutable reference
        assert!(*threshold == 10, *threshold);
        assert!(*max_value == 100, *max_value);
    }

    /// Function to demonstrate mutable borrow to update nested struct fields
    fun update_config_fields(holder_ref: &mut DataHolder) {
        let Config { threshold, max_value } = &mut holder_ref.config;
        *threshold = 20;
        *max_value = 200;
    }

    /// Function to demonstrate multiple borrows and updates
    fun borrow_and_update() {
        let mut holder = DataHolder {
            config: Config { threshold: 10, max_value: 100 },
            value: 42,
        };

        // Immutable borrow to read config fields
        read_config_fields(&holder);

        // Mutable borrow to update config fields
        update_config_fields(&mut holder);

        // Verify updates
        assert!(*holder.config.threshold == 20, *holder.config.threshold);
        assert!(*holder.config.max_value == 200, *holder.config.max_value);
    }

    /// Runner function to execute borrow_and_update
    public fun run_borrow_mut() {
        borrow_and_update();
    }
}

//# run 0x42::mut_borrow_test::run_borrow_mut