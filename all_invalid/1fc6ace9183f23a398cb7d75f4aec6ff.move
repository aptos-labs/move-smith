
//# publish
module 0xCAFE::ExperimentalConstantsCopyable {
    // Test experimental attachment of source maps with constants and copyable types together.

    const CONST_U8: u8 = 42;
    const CONST_U64: u64 = 123456;

    struct CopyableStruct copyable has store {
        val: u8,
    }

    public fun create_copyable_struct(val: u8): CopyableStruct {
        CopyableStruct { val }
    }

    public fun get_const_u8(): u8 {
        CONST_U8
    }

    public fun get_const_u64(): u64 {
        CONST_U64
    }

    public fun add_constants(x: u8): u8 {
        x + CONST_U8
    }

    public fun copy_struct(s: CopyableStruct): CopyableStruct {
        // Copy the struct, valid because it is copyable
        copy s
    }

    public fun use_struct_and_constants(val: u8): u8 {
        let s = create_copyable_struct(val);
        let copied = copy_struct(copy s);
        copied.val + CONST_U8 as u8
    }

    public fun run_all() {
        let _ = get_const_u8();
        let _ = get_const_u64();
        let _ = add_constants(10u8);
        let s = create_copyable_struct(7u8);
        let _ = copy_struct(s);
        let _ = use_struct_and_constants(5u8);
    }
}


//# run 0xCAFE::ExperimentalConstantsCopyable::run_all


//# publish
module 0xCAFE::ConstOnlyModule {
    // Module with multiple constants, no copyable types

    const A: u8 = 1u8;
    const B: u64 = 100u64;
    const C: bool = true;

    public fun get_a(): u8 {
        A
    }

    public fun get_b(): u64 {
        B
    }

    public fun get_c(): bool {
        C
    }

    public fun sum_constants(): u64 {
        let a64 = A as u64;
        a64 + B
    }

    public fun run_consts() {
        let _ = get_a();
        let _ = get_b();
        let _ = get_c();
        let _ = sum_constants();
    }
}


//# run 0xCAFE::ConstOnlyModule::run_consts


//# publish
module 0xCAFE::CopyableTypesModule {
    // Module with several copyable types for testing storing and passing

    struct Point copyable has store {
        x: u64,
        y: u64,
    }

    struct Flag copyable has store {
        value: bool,
    }

    public fun make_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    public fun make_flag(value: bool): Flag {
        Flag { value }
    }

    public fun flip_flag(f: Flag): Flag {
        Flag { value: !f.value }
    }

    public fun add_points(p1: Point, p2: Point): Point {
        let x_new = p1.x + p2.x;
        let y_new = p1.y + p2.y;
        Point { x: x_new, y: y_new }
    }

    public fun run_copyable() {
        let p1 = make_point(10u64, 20u64);
        let p2 = make_point(5u64, 7u64);
        let _sum = add_points(p1, p2);
        let f = make_flag(true);
        let _flipped = flip_flag(f);
    }
}


//# run 0xCAFE::CopyableTypesModule::run_copyable


//# publish
module 0xCAFE::IntegrationModule {
    // Combine constants and copyable types, test usage and error resilience (no actual errors emitted here)

    const MAGIC_NUMBER: u128 = 0xFEED_FACE_DEAD_BEEF;

    struct CopyableData copyable has store {
        data: u128,
    }

    public fun get_magic(): u128 {
        MAGIC_NUMBER
    }

    public fun create_data(value: u128): CopyableData {
        CopyableData { data: value }
    }

    public fun add_magic_to_data(data: CopyableData): u128 {
        data.data + MAGIC_NUMBER
    }

    public fun run_integration() {
        let magic = get_magic();
        let d = create_data(100u128);
        let _sum = add_magic_to_data(d);
    }
}


//# run 0xCAFE::IntegrationModule::run_integration


//# run
script {
    use 0xCAFE::ExperimentalConstantsCopyable;
    use 0xCAFE::ConstOnlyModule;
    use 0xCAFE::CopyableTypesModule;
    use 0xCAFE::IntegrationModule;

    fun main() {
        // Test ExperimentalConstantsCopyable module's functions
        let c1 = ExperimentalConstantsCopyable::get_const_u8();
        let c2 = ExperimentalConstantsCopyable::get_const_u64();
        let sumc = ExperimentalConstantsCopyable::add_constants(10u8);
        let s = ExperimentalConstantsCopyable::create_copyable_struct(7u8);
        let s_copy = ExperimentalConstantsCopyable::copy_struct(s);
        let val_plus_const = ExperimentalConstantsCopyable::use_struct_and_constants(5u8);

        // Test ConstOnlyModule access
        let a = ConstOnlyModule::get_a();
        let b = ConstOnlyModule::get_b();
        let c = ConstOnlyModule::get_c();
        let sum_consts = ConstOnlyModule::sum_constants();

        // Test CopyableTypesModule functionality
        let p1 = CopyableTypesModule::make_point(1u64, 1u64);
        let p2 = CopyableTypesModule::make_point(2u64, 3u64);
        let p3 = CopyableTypesModule::add_points(p1, p2);
        let flag = CopyableTypesModule::make_flag(true);
        let flag_flipped = CopyableTypesModule::flip_flag(flag);

        // Test IntegrationModule usage
        let magic = IntegrationModule::get_magic();
        let data = IntegrationModule::create_data(123u128);
        let sum_magic_data = IntegrationModule::add_magic_to_data(data);
    }
}


// Featurres:
// 31814c30074ca60af14f830ebab8f9c5: Attach compiled modules or scripts with their source maps for further processing if the experimental feature is enabled.
// bc3939fb2e46dbf8095eb4f34042442f: Define constants within modules.
// e0de578d1f3cda2f1f6ff0a35d1d15dc: Annotate types as ': copyable' to indicate copyable types.
