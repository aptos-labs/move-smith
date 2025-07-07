//# publish
module 0x1::FilterConstants {
    use std::string;
    use std::vector;

    /// A dummy AST node enum for demo purposes
    enum AstNode {
        Constant(u64),
        Variable(string::String),
        Add(Box<AstNode>, Box<AstNode>),
    }

    /// Returns a new vector with constants filtered out according to the predicate
    public fun filter_constants(nodes: vector<AstNode>, keep: bool): vector<AstNode> {
        let mut result = vector::empty<AstNode>();
        let len = vector::length(&nodes);
        let mut i = 0;
        while (i < len) {
            let node = vector::borrow(&nodes, i);
            match node {
                AstNode::Constant(_) => {
                    if (keep) {
                        vector::push_back(&mut result, *node);
                    }
                },
                _ => vector::push_back(&mut result, *node),
            }
            i = i + 1;
        }
        result
    }

    /// Runner function to test filtering constants both ways
    public fun run(): vector<AstNode> {
        let nodes = vector::empty<AstNode>();
        vector::push_back(&mut nodes, AstNode::Constant(10));
        vector::push_back(&mut nodes, AstNode::Variable(string::utf8(b"x")));
        vector::push_back(&mut nodes, AstNode::Constant(20));
        vector::push_back(&mut nodes, AstNode::Add(Box::new(AstNode::Constant(5)), Box::new(AstNode::Variable(string::utf8(b"y")))));

        // Remove constants
        let no_consts = filter_constants(nodes, false);
        no_consts
    }
}

//# run 0x1::FilterConstants::run

//# publish
module 0x1::DiagnosticNotes {
    use std::string;
    use std::vector;

    /// A note attached to a diagnostic message
    struct Note has copy, drop, store {
        message: string::String,
        suggestion: string::String,
    }

    /// Diagnostic message with multiple notes
    struct Diagnostic has copy, drop, store {
        message: string::String,
        notes: vector<Note>,
    }

    public fun new_note(msg: string::String, sugg: string::String): Note {
        Note { message: msg, suggestion: sugg }
    }

    public fun new_diagnostic(msg: string::String): Diagnostic {
        Diagnostic { message: msg, notes: vector::empty<Note>() }
    }

    public fun add_note(diag: &mut Diagnostic, note: Note) {
        vector::push_back(&mut diag.notes, note);
    }

    /// Runner: create a diagnostic with multiple notes
    public fun run(): Diagnostic {
        let mut diag = new_diagnostic(string::utf8(b"Error: Invalid operation"));

        let note1 = new_note(string::utf8(b"Note 1: Check variable types"), string::utf8(b"Try casting variable"));
        add_note(&mut diag, note1);

        let note2 = new_note(string::utf8(b"Note 2: Operation not supported on constants"), string::utf8(b"Use variables instead"));
        add_note(&mut diag, note2);

        diag
    }
}

//# run 0x1::DiagnosticNotes::run

//# publish
module 0x1::AstDebug {
    use std::string;
    use std::vector;

    enum AstNode {
        Constant(u64),
        Variable(string::String),
        Add(Box<AstNode>, Box<AstNode>),
        Mul(Box<AstNode>, Box<AstNode>),
    }

    fun indent(level: u8): string::String {
        let spaces = vector::empty<u8>();
        let mut i = 0;
        while (i < (level as u64)) {
            vector::push_back(&mut spaces, 32); // space char
            i = i + 1;
        }
        string::utf8(&spaces)
    }

    public fun to_verbose_string(node: &AstNode, level: u8): string::String {
        let indent_str = indent(level);
        let mut result = string::utf8(b"");
        let newline = string::utf8(b"\n");

        match node {
            AstNode::Constant(val) => {
                result = string::concat(&result, &indent_str);
                result = string::concat(&result, &string::utf8(b"Constant("));
                result = string::concat(&result, &string::to_string(*val));
                result = string::concat(&result, &string::utf8(b")"));
            }
            AstNode::Variable(name) => {
                result = string::concat(&result, &indent_str);
                result = string::concat(&result, &string::utf8(b"Variable("));
                result = string::concat(&result, name);
                result = string::concat(&result, &string::utf8(b")"));
            }
            AstNode::Add(lhs, rhs) => {
                result = string::concat(&result, &indent_str);
                result = string::concat(&result, &string::utf8(b"Add(\n"));
                result = string::concat(&result, &to_verbose_string(lhs, level + 2));
                result = string::concat(&result, &string::utf8(b",\n"));
                result = string::concat(&result, &to_verbose_string(rhs, level + 2));
                result = string::concat(&result, &string::utf8(b"\n"));
                result = string::concat(&result, &indent_str);
                result = string::concat(&result, &string::utf8(b")"));
            }
            AstNode::Mul(lhs, rhs) => {
                result = string::concat(&result, &indent_str);
                result = string::concat(&result, &string::utf8(b"Mul(\n"));
                result = string::concat(&result, &to_verbose_string(lhs, level + 2));
                result = string::concat(&result, &string::utf8(b",\n"));
                result = string::concat(&result, &to_verbose_string(rhs, level + 2));
                result = string::concat(&result, &string::utf8(b"\n"));
                result = string::concat(&result, &indent_str);
                result = string::concat(&result, &string::utf8(b")"));
            }
        }
        result
    }

    /// Runner: create an AST and output its verbose string representation
    public fun run(): string::String {
        let node = AstNode::Add(
            Box::new(AstNode::Variable(string::utf8(b"x"))),
            Box::new(
                AstNode::Mul(
                    Box::new(AstNode::Constant(3)),
                    Box::new(AstNode::Variable(string::utf8(b"y"))),
                )
            )
        );
        to_verbose_string(&node, 0)
    }
}

//# run 0x1::AstDebug::run