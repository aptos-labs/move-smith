//# publish
@deprecated(reason = b"Use new module instead")
module 0xCAFE::DeprecatedModule {
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
        let mut val = 5u8;
        let moved_val = val;
        if (moved_val > 2) {
            val = 10;
        } else {
            val = 20;
        };

        let _container = DeprecatedModule::create_container(123u64, true);
    }
}

// Featurres:
// 390b5dabfa1eded9d6a07449255a295e: Mark entire modules as deprecated with an annotation.
// b0bb423b3ca1fb4d46acb223aba04828: Test that a variable can be reassigned after being moved from and used in an if-else control flow.
// ef8758a86bf601a8d562b28d5806c116: Define struct types within a module.
