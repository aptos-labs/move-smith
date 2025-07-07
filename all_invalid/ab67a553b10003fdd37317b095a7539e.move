//# publish
module 0xA550C18::DependencyModule {
    resource struct R {
        v: u64,
    }

    public fun create_r(): R {
        R { v: 0 }
    }
}

//# publish
module 0xA550C18::TargetModule {
    use 0xA550C18::DependencyModule::{R, create_r};

    #[skip(lint_redundant_decl, lint_unused_var)]
    public friend 0xA550C18::DependencyModule;

    resource struct Container {
        r: R,
    }

    public fun new(): Self {
        Self { r: create_r() }
    }

    public fun do(self: &mut Self, v: u64) {
        if (v > 100) {
            self.r.v = v;
        }
    }

    public fun test_interaction() {
        let mut container = new();
        // initial v is 0 in R
        container.do(50);   // should not change r.v since 50 <= 100
        assert!(container.r.v == 0, 1);

        container.do(150);  // should update r.v to 150
        assert!(container.r.v == 150, 2);
    }
}

//# run 0xA550C18::TargetModule::test_interaction

//# publish
module 0xA550C18::FriendModule {
    use 0xA550C18::DependencyModule;

    // Demonstrate friend module access through access chain
    friend 0xA550C18::TargetModule;

    public fun access_r_from_dependency(r: &DependencyModule::R): u64 {
        r.v
    }
}

//# run 0xA550C18::FriendModule::access_r_from_dependency --args 0xA550C18::DependencyModule::R

//# run
script {
    use 0xA550C18::TargetModule;

    fun main() {
        let mut container = TargetModule::new();
        TargetModule::do(&mut container, 200);
    }
}
