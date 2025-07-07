//# publish
module 0xCAFE::DeprecatedModule {
    #[deprecated(reason = b"Use new module instead")]
    struct InnerStruct has store {
        id: u64,
        flag: bool,
    }

    struct Container has store {
        inner: InnerStruct,
    }

    public fun create_container(id: u64, flag: bool): Container {
        let inner = InnerStruct { id, flag };
        Container { inner }
    }

    public fun get_id(c: &Container): u64 {
        c.inner.id
    }
}

//# run
script {
    use 0xCAFE::DeprecatedModule;

    fun main() {
        let val = 5u8;
        let moved_val = val;
        if (moved_val > 2) {
            // val was copied (u8 is copyable), so no error reassigning
            // but val is immutable, so we shadow it here for "reassignment"
            let val = 10;
        } else {
            let val = 20;
        };

        let _container = DeprecatedModule::create_container(123u64, true);
    }
}