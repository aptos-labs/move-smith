//# publish
module 0xCAFE::TypeParamTest {
    use std::signer;

    struct Wrapper<T> has key {
        value: T,
    }

    struct Token has key, store {
        id: u64,
    }

    struct Container<T> has key {
        inner: Wrapper<T>,
    }

    /// Mints a token resource with a given id under the signer’s account
    public fun mint_token(account: &signer, id: u64): Token {
        Token { id }
    }

    /// Create a Container with Wrapped token (Wrapper<Token>)
    public fun create_container_with_token(_account: &signer, id: u64): Container<Token> {
        let token = Self::mint_token(_account, id);
        let wrapped = Wrapper<Token> { value: token };
        Container<Token> { inner: wrapped }
    }

    /// Consume the token by unpacking the wrappers and extracting token id.
    /// This simulates consuming a token during parsing.
    public fun consume_token(container: Container<Token>) {
        let token = container.inner.value;
        // simulate consuming: token.id is accessed, token resource is consumed by letting it go out of scope
        let _token_id = token.id;
        // token is consumed here implicitly since function ends and container is dropped
    }

    /// Runner function to exercise creation and consumption
    public fun runner(account: &signer) {
        let container = Self::create_container_with_token(account, 42);
        Self::consume_token(container);
    }
}

//# run 0xCAFE::TypeParamTest::runner --signers 0xCAFE


//# run
script {
    use std::signer;
    use 0xCAFE::TypeParamTest;

    fun main(account: signer) {
        // Create a container with token id 777
        let container = TypeParamTest::create_container_with_token(&account, 777);
        // Consume the token (simulates parsing and consuming token resource)
        TypeParamTest::consume_token(container);
    }
}

// Featurres:
// 387c88deff9b93653cfee90c1d829532: Use type parameters properly within struct types.
// 86d48cb4e19bc09d4e4cb8649394fadc: Define script functions to act as the main function for transaction scripts
// f6432751aaae5d1f0274eec14763bd21: Consume a specific token during parsing
