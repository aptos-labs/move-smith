
//# publish
module 0xCAFE::SpecAndAborts {
    use std::signer;

    /// A struct with variants, one of which is defined with named fields.
    enum AccountState has copy, drop, store {
        Active,
        Suspended { reason: vector<u8> },
        Closed
    }

    /// The main struct that we will perform spec and abort tests on.
    struct User has key, store {
        id: u64,
        state: AccountState
    }

    /// Spec section with code-rich block enclosed in { ... }
    spec User {
        invariant {
            // user's id must always be non-zero
            self.id > 0;

            // if state is Suspended, reason vector must not be empty
            matches!(self.state, AccountState::Suspended{reason} if vector::length(&reason) > 0);
        }

        /// A function spec to show multiple specs enclosed with code blocks
        public spec fn id_nonzero(self: &User) {
            ensures {
                self.id > 0;
            };
        }

        public spec fn is_active(self: &User) -> bool {
            // Using a code-rich spec block with braces to express logic
            {
                let result = matches!(self.state, AccountState::Active);
                result
            }
        }
    }

    /// Initializes a User resource under given signer address with Active state.
    public fun create_user(s: signer, id: u64) {
        // abort if id is zero
        abort_if!(id == 0, 1001);

        let user = User {
            id,
            state: AccountState::Active
        };
        move_to<User>(&s, user);
    }

    /// Updates user state to Suspended with provided reason.
    /// Aborts if no reason is provided.
    public fun suspend_user(s: signer, reason: vector<u8>) {
        abort_if!(vector::is_empty(&reason), 2001);

        let user_ref = borrow_global_mut<User>(signer::address_of(&s));
        user_ref.state = AccountState::Suspended {reason};
    }

    /// Updates user state back to Active.
    public fun activate_user(s: signer) {
        let user_ref = borrow_global_mut<User>(signer::address_of(&s));
        user_ref.state = AccountState::Active;
    }

    /// Closes the user account.
    /// Aborts if user id is less than 10.
    public fun close_user_account(s: signer) {
        let user_ref = borrow_global_mut<User>(signer::address_of(&s));
        abort_if!(user_ref.id < 10, 3001);
        user_ref.state = AccountState::Closed;
    }
}


//# run 0xCAFE::SpecAndAborts::create_user --signers 0xBEEF --args 123u64


//# run 0xCAFE::SpecAndAborts::suspend_user --signers 0xBEEF --args b"Violation of terms"


//# run 0xCAFE::SpecAndAborts::activate_user --signers 0xBEEF


//# run 0xCAFE::SpecAndAborts::suspend_user --signers 0xBEEF --args b""


//# run 0xCAFE::SpecAndAborts::close_user_account --signers 0xBEEF


//# run 0xCAFE::SpecAndAborts::create_user --signers 0xAA01 --args 5u64


//# run 0xCAFE::SpecAndAborts::close_user_account --signers 0xAA01


// Featurres:
// ee5a0f621a575cb5ff249c843181b8ec: Create code-rich spec sections enclosed in '{' and '}' within a spec block.
// 155007288c9ed8bcacb4766bb2688942: Define struct variants with named fields using braces ({ ... })
// 89fda4824f773ac88698dd0bee241f47: Declare 'aborts_if' conditions to specify runtime abort checks.
