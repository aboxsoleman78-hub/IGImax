extends Node3D

var player: CharacterBody3D
var player_collision: CollisionShape3D
var camera: Camera3D
var move_forward := false
var move_back := false
var move_left := false
var move_right := false
var movement_touch_ids := {}
var tower_ladders := []
var active_ladder = null
var jump_pressed := false
var shoot_pressed := false
var ammo := 12
var ammo_label: Label
var status_label: Label
var health_bar: ProgressBar
var health_fill_style: StyleBoxFlat
var ui_root: Control
var shoot_button: Button
var new_game_button: Button
var weapon_root: Node3D
var gun_model: Node3D
var muzzle_flash: MeshInstance3D
var shot_audio: AudioStreamPlayer
var enemies: Array[CharacterBody3D] = []
var pickups: Array[Area3D] = []
var enemies_defeated := 0
var player_health := 100
var mission_completed := false
var game_ended := false
var is_reloading := false
var game_started := false
var mission_number := 1
var enemy_goal := 3
var quiet_mode := false
var player_noise := 0.0
var alert_level := 0.0
var alert_label: Label
var stealth_button: Button
var stance_button: Button
var interact_button: Button
var stance := 0
var current_weapon := "sniper"
var weapon_damage := 3
var weapon_range := 220.0
var has_key := false
var has_gate_key := false
var has_building1_key := false
var has_building2_key := false
var gate_unlocked := false
var building1_unlocked := false
var building2_unlocked := false
var computer_accessed := false
var heavy_weapon_destroyed := false
var objective_nodes: Array[Node3D] = []
var objective_label: Label
var saved_mission := 1
var owned_weapons: Array[String] = ["sniper"]
var weapon_buttons := {}
var weapon_icons := {}
var zoom_button: Button
var zoomed := false
var ammo_box_collected := false
var health_box_collected := false
var health_kits := 0
var health_button: Button
var health_count_label: Label
var enemy_weapon_captured := false
var cross_label: Label
var doors: Array[AnimatableBody3D] = []
var gate_door: AnimatableBody3D
var speed_button: Button
var movement_mode := 1
var player_has_fired := false
var alarm_disabled := false
var explosives_collected := false
var documents_collected := false
var missile_depots_destroyed := 0
var data_downloaded := false
var extraction_reached := false
var reinforcements_spawned := false
var data_download_in_progress := false
var port_surveillance_disabled := false
var port_targets_destroyed := 0
var secret_briefcase_collected := false
var airbase_charges_planted := 0
var facility_charges_planted := 0
var facility_commander_defeated := false
var facility_escape_active := false
var facility_escape_time := 0.0
var train_lights_disabled := false
var train_prisoner_rescued := false
var rescued_prisoner: CharacterBody3D = null
var prisoner_health := 100
var mission_failure_reason := ""
var train_charge_planted := false
var train_commander_defeated := false
var train_escape_active := false
var train_escape_time := 0.0
var train_countdown_label: Label = null
var canyon_relays_disabled := 0
var canyon_intel_collected := false
var stage_seven_migrated := false
var stage_eight_migrated := false
var bridge_weapons_taken := false
var bridge_controls_taken := false
var bridge_explosives_taken := false
var bridge_charges_planted := 0
var bridge_escape_active := false
var bridge_escape_time := 0.0
var bridge_entry_gate: AnimatableBody3D = null
var bridge_exit_gate: AnimatableBody3D = null
var stage_nine_migrated := false
var stage_ten_migrated := false
var convoy_checkpoints := 0
var convoy_intel_taken := false
var convoy_tower_occupied := false
var convoy_ambush_started := false
var convoy_stopped := false
var convoy_documents_taken := false
var convoy_reinforcements_spawned := false
var convoy_escape_time := 0.0
var convoy_checkpoint_gates: Array[AnimatableBody3D] = []
var convoy_vehicles: Array[AnimatableBody3D] = []
var final_generators_disabled := 0
var final_allies_freed := false
var final_radio_disabled := false
var final_boss_defeated := false
var final_data_taken := false
var final_charges_planted := 0
var final_escape_active := false
var final_escape_time := 0.0
var final_reinforcements_spawned := false
var victory_continue_button: Button = null
var prisoner_stuck_time := 0.0
var selected_mission := 1
var settings_open := false
var settings_panel: Panel
var settings_summary: Label
var player_color_index := 0
var sound_level := 3
var brightness_level := 1

const SPEED := 6.0
const JUMP_VELOCITY := 5.5
const LOOK_SENS := 0.0030
const AIM_LOOK_SENS := 0.00165
const AIM_ASSIST_RADIUS := 72.0
const ENEMY_GOAL := 3
const ENEMY_SPEED := 1.55
const ENEMY_STOP_DISTANCE := 3.15
const ENEMY_SEPARATION := 1.65
const STEALTH_SPEED := 2.6
const SAVE_PATH := "user://operation_shadow_progress.cfg"
const COMPLETE_ANIMATED_SOLDIER_PATH := "res://characters/swat/Swat@Rifle Aiming Idle.fbx"
const SWAT_ANIMATION_FILES := {
    "SWAT_Aim": "res://characters/swat/Swat@Rifle Aiming Idle.fbx",
    "SWAT_Fire": "res://characters/swat/Swat@Firing Rifle.fbx",
    "SWAT_Walk": "res://characters/swat/Swat@Rifle Walk.fbx",
    "SWAT_Run": "res://characters/swat/Swat@Rifle Run.fbx",
    "SWAT_Reload": "res://characters/swat/Swat@Reloading.fbx"
}
const REAL_ENEMY_WEAPONS := {
    "rifle": "res://weapons/real/Assault Rifle.glb",
    "pistol": "res://weapons/real/Pistol.glb",
    "shotgun": "res://weapons/real/Shotgun.glb",
    "sniper": "res://weapons/real/Sniper Rifle.glb"
}

const STAGE_GROUND_TEXTURES := {
    1: ["res://textures/grounds/asphalt_02_diff_2k.jpg", "res://textures/grounds/asphalt_02_rough_2k.jpg"],
    2: ["res://textures/grounds/rocks_ground_02_col_2k.jpg", "res://textures/grounds/rocks_ground_02_rough_2k.jpg"],
    3: ["res://textures/grounds/concrete_floor_01_diff_2k.jpg", "res://textures/grounds/concrete_floor_01_rough_2k.jpg"],
    4: ["res://textures/grounds/clean_asphalt_diff_2k.jpg", ""],
    5: ["res://textures/grounds/concrete_floor_01_diff_2k.jpg", "res://textures/grounds/concrete_floor_01_rough_2k.jpg"],
    6: ["res://textures/grounds/gravel_road_diff_2k.jpg", ""],
    7: ["res://textures/grounds/dry_ground_rocks_diff_2k.jpg", "res://textures/grounds/dry_ground_rocks_rough_2k.jpg"],
    8: ["res://textures/grounds/asphalt_02_diff_2k.jpg", "res://textures/grounds/asphalt_02_rough_2k.jpg"],
    9: ["res://textures/grounds/dry_ground_rocks_diff_2k.jpg", "res://textures/grounds/dry_ground_rocks_rough_2k.jpg"],
    10: ["res://textures/grounds/asphalt_02_diff_2k.jpg", "res://textures/grounds/asphalt_02_rough_2k.jpg"]
}

var look_touch_id := -1
var touch_action_ids := {}
var yaw := 0.0
var pitch := 0.0

func _ready():
    _load_progress()
    # A fresh app launch always opens the highest unlocked mission. A mission
    # chosen from Settings is kept only for the current running app session.
    if stage_ten_migrated:
        Engine.set_meta("operation_shadow_session_mission", 10)
        mission_number = 10
    elif stage_nine_migrated:
        Engine.set_meta("operation_shadow_session_mission", 9)
        mission_number = 9
    elif stage_eight_migrated:
        Engine.set_meta("operation_shadow_session_mission", 8)
        mission_number = 8
    elif stage_seven_migrated:
        # An editor session may still remember stage 6 from V118. Open the new
        # stage once when upgrading the user's completed stage-6 save.
        Engine.set_meta("operation_shadow_session_mission", 7)
        mission_number = 7
    elif Engine.has_meta("operation_shadow_session_mission"):
        mission_number = clamp(int(Engine.get_meta("operation_shadow_session_mission")), 1, saved_mission)
    else:
        mission_number = saved_mission
    _build_world()
    _build_ui()

func _make_stage_ground_material(stage_number: int) -> StandardMaterial3D:
    var material = StandardMaterial3D.new()
    material.albedo_color = Color.WHITE
    material.roughness = 0.92
    material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
    material.uv1_scale = Vector3(36.0, 36.0, 36.0)
    var texture_paths: Array = STAGE_GROUND_TEXTURES.get(stage_number, STAGE_GROUND_TEXTURES[1])
    var color_texture = load(String(texture_paths[0]))
    if color_texture != null:
        material.albedo_texture = color_texture
    var roughness_path := String(texture_paths[1])
    if not roughness_path.is_empty():
        var roughness_texture = load(roughness_path)
        if roughness_texture != null:
            material.roughness_texture = roughness_texture
    return material

func _build_world():
    var floor_body = StaticBody3D.new()
    floor_body.name = "Floor"
    floor_body.set_meta("surface_type", "ground")
    add_child(floor_body)

    var floor_col = CollisionShape3D.new()
    var floor_shape = BoxShape3D.new()
    floor_shape.size = Vector3(150, 1, 380)
    floor_col.shape = floor_shape
    floor_col.position = Vector3(0, -0.5, 30)
    floor_body.add_child(floor_col)

    var floor_mesh = MeshInstance3D.new()
    var floor_box = BoxMesh.new()
    floor_box.size = Vector3(150, 1, 380)
    floor_mesh.mesh = floor_box
    floor_mesh.position = Vector3(0, -0.5, 30)
    var ground_material = _make_stage_ground_material(mission_number)
    floor_mesh.material_override = ground_material
    floor_body.add_child(floor_mesh)

    var light = DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-55, -25, 0)
    light.shadow_enabled = true
    light.light_color = Color(1.0, 0.90, 0.76)
    light.light_energy = 1.75
    add_child(light)

    var world_environment = WorldEnvironment.new()
    var environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color(0.36, 0.48, 0.62)
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.76, 0.80, 0.86)
    environment.ambient_light_energy = 1.18
    environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    world_environment.environment = environment
    add_child(world_environment)

    player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.1, 185)
    add_child(player)

    var col = CollisionShape3D.new()
    var capsule = CapsuleShape3D.new()
    capsule.radius = 0.45
    capsule.height = 1.8
    col.shape = capsule
    player.add_child(col)
    player_collision = col

    camera = Camera3D.new()
    camera.position = Vector3(0, 0.65, 0)
    camera.far = 350.0
    camera.current = true
    player.add_child(camera)
    _build_weapon()

    if mission_number == 10:
        _build_final_fortress()
    elif mission_number == 9:
        _build_convoy_road()
    elif mission_number == 8:
        _build_bridge_assault()
    elif mission_number == 7:
        _build_mountain_pass()
    elif mission_number == 6:
        _build_military_train_valley()
    elif mission_number == 5:
        _build_secret_mountain_facility()
    elif mission_number == 4:
        _build_airbase()
    elif mission_number == 3:
        _build_shadow_port()
    elif mission_number == 2:
        _build_missile_depot()
    else:
        _build_compound()
    _spawn_scenario_enemies()
    _make_pickup(Vector3(-6, 0.55, -7), "ammo")
    _make_pickup(Vector3(6, 0.55, -11), "health")
    _make_pickup(Vector3(-14, 0.55, 9), "sniper")
    _make_pickup(Vector3(14, 0.55, 9), "shotgun")
    _make_pickup(Vector3(18, 0.45, 6), "grenade")
    _spawn_extra_camp_pickups()
    _spawn_mission_objectives()
    _apply_mission_atmosphere()
    _apply_game_settings()

func _build_shadow_port():
    # A dedicated coastal port: docks, warehouses, container lanes, cranes,
    # fuel installations and a detailed cargo ship create several stealth routes.
    _make_structure(Vector3(-55, 0.20, 20), Vector3(34, 0.40, 220), Color(0.20, 0.24, 0.27))
    _make_structure(Vector3(55, 0.20, 5), Vector3(34, 0.40, 245), Color(0.20, 0.24, 0.27))
    # Continuous central service road. Previously the cross-docks were isolated
    # by water gaps, leaving mission targets visible but unreachable.
    _make_structure(Vector3(0, 0.14, 5), Vector3(44, 0.28, 300), Color(0.18, 0.21, 0.23))
    for dock_z in [105.0, 60.0, 15.0, -35.0, -82.0]:
        _make_structure(Vector3(0, 0.16, dock_z), Vector3(76, 0.32, 10), Color(0.24, 0.27, 0.28))
        for bollard_x in [-34.0, -22.0, 22.0, 34.0]:
            _make_port_bollard(Vector3(bollard_x, 0.36, dock_z))

    _make_port_water(Vector3(-68, 0.03, 12), Vector3(24, 0.08, 270))
    _make_port_water(Vector3(68, 0.03, 0), Vector3(24, 0.08, 290))
    _make_port_warehouse(Vector3(-29, 0, 67), Vector3(22, 7, 20), Color(0.28, 0.36, 0.42), "building1")
    _make_port_warehouse(Vector3(28, 0, 18), Vector3(25, 8, 22), Color(0.42, 0.28, 0.20), "building2")
    _make_port_warehouse(Vector3(-28, 0, -48), Vector3(26, 6, 19), Color(0.25, 0.31, 0.27), "auto")

    var container_colors = [Color(0.52, 0.13, 0.10), Color(0.10, 0.28, 0.48), Color(0.18, 0.39, 0.24), Color(0.56, 0.39, 0.08)]
    var container_positions = [
        Vector3(-22, 1.35, 118), Vector3(-13, 1.35, 118), Vector3(18, 1.35, 110),
        Vector3(28, 1.35, 110), Vector3(-22, 1.35, 28), Vector3(-12, 1.35, 28),
        Vector3(10, 1.35, -18), Vector3(20, 1.35, -18), Vector3(-8, 1.35, -78)
    ]
    for i in range(container_positions.size()):
        _make_shipping_container(container_positions[i], container_colors[i % container_colors.size()], i % 3 == 0)

    for tower_pos in [Vector3(-43, 0, 94), Vector3(44, 0, 76), Vector3(-43, 0, -12), Vector3(44, 0, -62)]:
        _make_guard_tower(tower_pos)
        _make_spotlight(tower_pos + Vector3(0, 7.0, 0))
    _make_port_crane(Vector3(-48, 0, 5), Color(0.88, 0.55, 0.05))
    _make_port_crane(Vector3(47, 0, -53), Color(0.78, 0.42, 0.04))
    _make_cargo_ship(Vector3(-56, 0.55, -42))
    _make_patrol_boat_visual(Vector3(58, 0.35, 84))
    _make_vehicle(Vector3(8, 0.75, 88), Color(0.18, 0.22, 0.18), false)
    _make_vehicle(Vector3(-6, 0.90, -4), Color(0.16, 0.19, 0.14), true)
    _make_tank(Vector3(30, 1.0, -72), Color(0.14, 0.17, 0.13))

func _build_airbase():
    # A compact night airbase designed for mobile performance: one connected
    # runway, two hangars, operations, a control tower and clear stealth lanes.
    _make_structure(Vector3(17, 0.11, 0), Vector3(32, 0.22, 286), Color(0.14, 0.16, 0.19))
    for stripe_z in range(-126, 127, 18):
        _make_visual_detail(Vector3(17, 0.235, float(stripe_z)), Vector3(0.34, 0.03, 7.5), Color(0.88, 0.90, 0.82))
    for edge_x in [1.2, 32.8]:
        _make_visual_detail(Vector3(edge_x, 0.23, 0), Vector3(0.18, 0.035, 278), Color(0.20, 0.58, 0.92))
    _make_building(Vector3(-37, 3.8, 63), Vector3(29, 7.6, 25), Color(0.25, 0.30, 0.35), "building1")
    _make_building(Vector3(-40, 3.1, -25), Vector3(24, 6.2, 20), Color(0.30, 0.34, 0.38), "auto")
    _make_building(Vector3(-39, 2.6, -91), Vector3(20, 5.2, 17), Color(0.23, 0.28, 0.33), "auto")
    _make_air_control_tower(Vector3(48, 0, -45))
    _make_cargo_aircraft(Vector3(14, 0.75, -76))
    _make_helicopter(Vector3(-10, 0.65, -123))
    for fuel_z in [-2.0, 5.0, 12.0]:
        _make_fuel_silo(Vector3(50, 0, fuel_z))
    for tower_pos in [Vector3(-62, 0, 112), Vector3(62, 0, 102), Vector3(-62, 0, -62), Vector3(62, 0, -112)]:
        _make_guard_tower(tower_pos)
        _make_spotlight(tower_pos + Vector3(0, 7.0, 0))
    _make_vehicle(Vector3(-19, 0.75, 102), Color(0.12, 0.16, 0.14), false)
    _make_vehicle(Vector3(45, 0.90, 67), Color(0.15, 0.19, 0.16), true)
    _make_tank(Vector3(-47, 1.0, 18), Color(0.12, 0.16, 0.12))
    # Perimeter walls leave a guarded entrance at the south approach.
    _make_structure(Vector3(-75, 2.0, 0), Vector3(0.8, 4, 290), Color(0.16, 0.18, 0.21))
    _make_structure(Vector3(75, 2.0, 0), Vector3(0.8, 4, 290), Color(0.16, 0.18, 0.21))
    _make_structure(Vector3(0, 2.0, -145), Vector3(150, 4, 0.8), Color(0.16, 0.18, 0.21))
    _make_structure(Vector3(-43, 2.0, 145), Vector3(64, 4, 0.8), Color(0.16, 0.18, 0.21))
    _make_structure(Vector3(43, 2.0, 145), Vector3(64, 4, 0.8), Color(0.16, 0.18, 0.21))

func _build_secret_mountain_facility():
    # Exterior canyon approach and a connected underground installation.
    for z in range(-120, 141, 26):
        _make_structure(Vector3(-55, 6.0, float(z)), Vector3(34, 12, 24), Color(0.20, 0.18, 0.16))
        _make_structure(Vector3(55, 6.0, float(z)), Vector3(34, 12, 24), Color(0.20, 0.18, 0.16))
    _make_structure(Vector3(0, 0.10, 45), Vector3(74, 0.20, 205), Color(0.17, 0.19, 0.20))
    # Low staggered cover lets the player approach the snipers tactically.
    # The gaps remain wide enough for walking and aiming on mobile.
    for cover_data in [
        [Vector3(-9.0, 0.62, 136.0), Vector3(7.0, 1.24, 0.75)],
        [Vector3(8.5, 0.58, 123.0), Vector3(6.2, 1.16, 0.75)],
        [Vector3(-7.5, 0.64, 109.0), Vector3(6.8, 1.28, 0.75)],
        [Vector3(9.0, 0.60, 95.0), Vector3(6.0, 1.20, 0.75)],
        [Vector3(-14.0, 0.58, 52.0), Vector3(5.2, 1.16, 0.70)],
        [Vector3(14.0, 0.58, -3.0), Vector3(5.2, 1.16, 0.70)],
        [Vector3(-14.0, 0.58, -57.0), Vector3(5.2, 1.16, 0.70)],
        [Vector3(14.0, 0.58, -110.0), Vector3(5.2, 1.16, 0.70)]
    ]:
        _make_structure(cover_data[0], cover_data[1], Color(0.29, 0.31, 0.30))
    # Armoured tunnel shell, central corridor and four functional chambers.
    _make_structure(Vector3(-22, 4.0, -42), Vector3(1.0, 8.0, 150), Color(0.19, 0.23, 0.25))
    _make_structure(Vector3(22, 4.0, -42), Vector3(1.0, 8.0, 150), Color(0.19, 0.23, 0.25))
    _make_structure(Vector3(0, 8.0, -42), Vector3(45, 0.6, 150), Color(0.12, 0.14, 0.16))
    _make_building(Vector3(-11, 3.4, 73), Vector3(20, 6.8, 18), Color(0.25, 0.29, 0.31), "building1")
    _make_building(Vector3(11, 3.4, 18), Vector3(20, 6.8, 20), Color(0.18, 0.28, 0.34), "auto")
    _make_building(Vector3(-11, 3.4, -35), Vector3(20, 6.8, 20), Color(0.27, 0.24, 0.20), "building2")
    _make_building(Vector3(11, 3.4, -88), Vector3(20, 6.8, 20), Color(0.24, 0.18, 0.18), "auto")
    # Blast doors, power conduits, warning lights and extraction vehicle.
    for z in [104.0, 48.0, -8.0, -62.0, -116.0]:
        _make_visual_detail(Vector3(-20.8, 3.8, z), Vector3(0.22, 0.22, 8.0), Color(0.05, 0.55, 0.82))
        _make_visual_detail(Vector3(20.8, 3.8, z), Vector3(0.22, 0.22, 8.0), Color(0.05, 0.55, 0.82))
        _make_visual_detail(Vector3(0, 7.55, z), Vector3(6.0, 0.16, 0.20), Color(0.90, 0.12, 0.04))
    _make_vehicle(Vector3(0, 0.80, -128), Color(0.10, 0.14, 0.12), true)
    for tower_pos in [Vector3(-36, 0, 112), Vector3(36, 0, 112)]:
        _make_guard_tower(tower_pos, 0.80)
        _make_spotlight(tower_pos + Vector3(0, 7.0, 0))

func _build_final_fortress():
    # A moonlit mountain fortress with a long approach, outer defences,
    # detention block, communications yard, command keep and helipad.
    _make_visual_detail(Vector3(0, 0.025, 22), Vector3(18, 0.05, 330), Color(0.19, 0.21, 0.22))
    for z in range(-140, 185, 18):
        _make_visual_detail(Vector3(0, 0.058, float(z)), Vector3(0.18, 0.012, 7.0), Color(0.62, 0.66, 0.66))
        for side in [-1.0, 1.0]:
            _make_visual_detail(Vector3(side * 42.0, 2.0, float(z)), Vector3(20, 4.0, 15), Color(0.18, 0.16, 0.15))
    # Three separated power compounds along the approach.
    for generator_data in [[Vector3(-24, 0.7, 123), -1.0], [Vector3(24, 0.7, 76), 1.0], [Vector3(-24, 0.7, 28), -1.0]]:
        var gp: Vector3 = generator_data[0]
        _make_structure(gp + Vector3(0, 0.45, 0), Vector3(9.0, 1.25, 7.0), Color(0.16, 0.20, 0.18))
        _make_visual_detail(gp + Vector3(0, 1.55, 0), Vector3(5.0, 0.18, 3.4), Color(0.05, 0.07, 0.07))
        for coil_x in [-1.4, 0.0, 1.4]:
            _make_visual_detail(gp + Vector3(coil_x, 2.0, 0), Vector3(0.35, 0.85, 2.2), Color(0.28, 0.31, 0.30))
    # Outer fortress wall with a broad central breach, towers and searchlights.
    _make_structure(Vector3(-27, 3.0, -5), Vector3(42, 6.0, 1.2), Color(0.24, 0.25, 0.24))
    _make_structure(Vector3(27, 3.0, -5), Vector3(42, 6.0, 1.2), Color(0.24, 0.25, 0.24))
    for tower_pos in [Vector3(-32, 0, 5), Vector3(32, 0, 5), Vector3(-34, 0, -87), Vector3(34, 0, -87)]:
        _make_guard_tower(tower_pos, 0.70)
        _make_spotlight(tower_pos + Vector3(0, 7.0, 0))
    _make_building(Vector3(-25, 2.8, -28), Vector3(15, 5.6, 17), Color(0.28, 0.30, 0.31), "auto")
    _make_building(Vector3(25, 2.8, -30), Vector3(16, 5.6, 18), Color(0.22, 0.27, 0.30), "auto")
    _make_building(Vector3(0, 4.5, -78), Vector3(25, 9.0, 24), Color(0.22, 0.20, 0.19), "auto")
    for cover_pos in [Vector3(-13, 0.55, -12), Vector3(13, 0.55, -15), Vector3(-12, 0.55, -52), Vector3(12, 0.55, -55), Vector3(-20, 0.55, -100), Vector3(20, 0.55, -104)]:
        _make_structure(cover_pos, Vector3(5.0, 1.1, 0.9), Color(0.25, 0.26, 0.25))
    # Helipad and evacuation helicopter, kept clear of the landing circle.
    _make_visual_detail(Vector3(0, 0.08, -132), Vector3(24, 0.16, 24), Color(0.13, 0.15, 0.16))
    _make_visual_detail(Vector3(0, 0.18, -132), Vector3(13, 0.04, 1.0), Color(0.92, 0.92, 0.86))
    _make_visual_detail(Vector3(0, 0.18, -132), Vector3(1.0, 0.04, 13), Color(0.92, 0.92, 0.86))
    _make_visual_detail(Vector3(-12, 2.2, -143), Vector3(5.8, 2.2, 2.6), Color(0.12, 0.18, 0.16))
    _make_visual_detail(Vector3(-12, 3.45, -143), Vector3(12.0, 0.12, 0.35), Color(0.05, 0.06, 0.06))
    _make_visual_detail(Vector3(-12, 2.2, -147), Vector3(1.0, 1.0, 7.0), Color(0.11, 0.16, 0.14))

func _final_squad_clear(tag: String) -> bool:
    for enemy in enemies:
        if is_instance_valid(enemy) and bool(enemy.get_meta(tag, false)):
            return false
    return true

func _final_area_clear(center: Vector3, radius: float) -> bool:
    for enemy in enemies:
        if is_instance_valid(enemy) and bool(enemy.get_meta("final_guard", false)) and enemy.global_position.distance_to(center) < radius:
            return false
    return true

func _spawn_final_reinforcements():
    if final_reinforcements_spawned:
        return
    final_reinforcements_spawned = true
    for pos in [Vector3(-26, 1, -93), Vector3(26, 1, -95), Vector3(-18, 1, -116), Vector3(18, 1, -120), Vector3(5, 1, -108)]:
        var enemy = _make_enemy(pos, "rifle")
        enemy.set_meta("final_reinforcement", true)
        enemy.set_meta("alert_time", 24.0)
        enemy.set_meta("last_known_position", player.global_position)
    enemy_goal = enemies_defeated + enemies.size()

func _spawn_final_ally(at_position: Vector3):
    rescued_prisoner = CharacterBody3D.new()
    rescued_prisoner.name = "FinalMissionAlly"
    rescued_prisoner.position = at_position
    rescued_prisoner.set_meta("civilian", true)
    rescued_prisoner.set_meta("outside_cell", true)
    add_child(rescued_prisoner)
    rescued_prisoner.add_collision_exception_with(player)
    var collider = CollisionShape3D.new()
    var capsule = CapsuleShape3D.new()
    capsule.radius = 0.32
    capsule.height = 1.65
    collider.shape = capsule
    rescued_prisoner.add_child(collider)
    var model = _create_civilian_model(rescued_prisoner)
    if model != null:
        rescued_prisoner.set_meta("civilian_model", model)
    var label = Label3D.new()
    label.text = "فريق المساندة"
    label.position = Vector3(0, 1.75, 0)
    label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    label.modulate = Color(0.25, 0.90, 1.0)
    rescued_prisoner.add_child(label)
    prisoner_health = 100

func _update_final_mission(delta: float):
    if final_radio_disabled and not final_boss_defeated and _final_squad_clear("final_boss"):
        final_boss_defeated = true
        status_label.text = "تم القضاء على قائد القلعة؛ خذ القرص السري من غرفة القيادة"
        _update_objective_text()
    if final_escape_active:
        final_escape_time = max(final_escape_time - delta, 0.0)
        train_countdown_label.visible = true
        train_countdown_label.text = "انهيار القلعة خلال %02d:%02d" % [int(ceil(final_escape_time) / 60), int(ceil(final_escape_time)) % 60]
        train_countdown_label.add_theme_color_override("font_color", Color(0.98, 0.12, 0.08) if final_escape_time < 45 else (Color(1.0, 0.82, 0.10) if final_escape_time < 105 else Color(0.18, 1.0, 0.28)))
        if final_escape_time <= 0.0:
            mission_failure_reason = "انهارت القلعة قبل وصولك إلى المروحية"
            _finish_game(false)
            return
        if _final_squad_clear("final_reinforcement") and player.global_position.distance_to(Vector3(0, 1.1, -132)) <= 7.0:
            extraction_reached = true
            _update_objective_text()
            _complete_mission()

func _build_convoy_road():
    # Long open desert highway. Checkpoints and sniper towers form distinct
    # encounters; the playable centre and both flanks remain unobstructed.
    _make_visual_detail(Vector3(0, 0.027, 17), Vector3(23, 0.054, 342), Color(0.30, 0.30, 0.27))
    for z in range(-145, 184, 17):
        _make_visual_detail(Vector3(0, 0.058, float(z)), Vector3(0.21, 0.008, 6.0), Color(0.86, 0.76, 0.48))
        for side in [-1.0, 1.0]:
            _make_visual_detail(Vector3(side * 11.25, 0.058, float(z)), Vector3(0.13, 0.008, 13.0), Color(0.84, 0.82, 0.69))
            _make_visual_detail(Vector3(side * 36.0, 0.18, float(z)), Vector3(18, 0.36, 16), Color(0.52, 0.40, 0.27))
    for checkpoint_z in [143.0, 93.0, 43.0]:
        var control_side = -1.0 if checkpoint_z != 93.0 else 1.0
        for post_x in [-19.0, 19.0]:
            _make_visual_detail(Vector3(post_x, 0.035, checkpoint_z), Vector3(8, 0.07, 7), Color(0.34, 0.31, 0.26))
        for cover_x in [-13.5, 13.5]:
            _make_structure(Vector3(cover_x, 0.48, checkpoint_z + 6), Vector3(3.8, 0.96, 0.72), Color(0.40, 0.34, 0.25))
        var gate = _make_bridge_gate(Vector3(0, 1.075, checkpoint_z - 13.0))
        convoy_checkpoint_gates.append(gate)
        _make_visual_detail(Vector3(control_side * 17, 2.1, checkpoint_z), Vector3(4.0, 0.20, 4.0), Color(0.31, 0.33, 0.31))
    for tower_pos in [Vector3(-24, 0, -19), Vector3(24, 0, -38)]:
        _make_guard_tower(tower_pos, 0.72)
    for cover_pos in [Vector3(-14, 0.49, 14), Vector3(13, 0.49, -2), Vector3(-13, 0.49, -62), Vector3(14, 0.49, -86), Vector3(-12, 0.49, -107)]:
        _make_structure(cover_pos, Vector3(4.0, 0.98, 0.75), Color(0.37, 0.34, 0.29))
    _make_visual_detail(Vector3(-17, 0.035, 15), Vector3(9, 0.07, 7), Color(0.27, 0.30, 0.28))
    for start_z in [-126.0, -139.0, -152.0]:
        convoy_vehicles.append(_make_convoy_truck(start_z, start_z == -126.0))
    _make_vehicle(Vector3(-26, 0.8, -146), Color(0.13, 0.19, 0.14), true)

func _make_convoy_truck(start_z: float, is_command: bool) -> AnimatableBody3D:
    var vehicle = AnimatableBody3D.new()
    vehicle.position = Vector3(0, 1.05, start_z)
    vehicle.set_meta("surface_type", "metal")
    add_child(vehicle)
    var collision = CollisionShape3D.new()
    var body_shape = BoxShape3D.new()
    body_shape.size = Vector3(3.9, 1.55, 6.8)
    collision.shape = body_shape
    vehicle.add_child(collision)
    var paint = Color(0.26, 0.32, 0.28) if is_command else Color(0.32, 0.30, 0.25)
    _add_vehicle_box(vehicle, Vector3(3.7, 1.2, 6.5), Vector3.ZERO, paint)
    _add_vehicle_box(vehicle, Vector3(3.55, 1.10, 2.05), Vector3(0, 1.05, 1.65), paint.lightened(0.08))
    _add_vehicle_box(vehicle, Vector3(3.4, 0.52, 3.6), Vector3(0, 1.0, -1.28), paint.darkened(0.20))
    for side_x in [-1.60, 1.60]:
        for wheel_z in [-2.25, 2.05]:
            _add_vehicle_wheel(vehicle, Vector3(side_x, -0.55, wheel_z))
    for lamp_x in [-1.3, 1.3]:
        _add_vehicle_box(vehicle, Vector3(0.40, 0.25, 0.12), Vector3(lamp_x, 0.10, 3.34), Color(0.96, 0.83, 0.40))
    if is_command:
        _add_vehicle_box(vehicle, Vector3(1.2, 0.42, 1.3), Vector3(0, 1.72, -1.5), Color(0.15, 0.20, 0.20))
    return vehicle

func _convoy_squad_clear(squad: String) -> bool:
    for enemy in enemies:
        if is_instance_valid(enemy) and bool(enemy.get_meta(squad, false)):
            return false
    return true

func _convoy_checkpoint_clear(checkpoint_index: int) -> bool:
    for enemy in enemies:
        if is_instance_valid(enemy) and int(enemy.get_meta("convoy_checkpoint", -1)) == checkpoint_index:
            return false
    return true

func _spawn_convoy_guards():
    for guard_pos in [Vector3(-7, 1, -75), Vector3(7, 1, -78), Vector3(-7, 1, -89), Vector3(7, 1, -94), Vector3(-7, 1, -108), Vector3(7, 1, -111)]:
        var guard = _make_enemy(guard_pos, "rifle")
        guard.set_meta("convoy_guard", true)
        guard.set_meta("patrol_radius", 3.0)
        guard.set_meta("alert_time", 16.0)
        guard.set_meta("last_known_position", player.global_position)
    enemy_goal = enemies_defeated + enemies.size()

func _spawn_convoy_reinforcements():
    if convoy_reinforcements_spawned:
        return
    convoy_reinforcements_spawned = true
    for guard_pos in [Vector3(-19, 1, -113), Vector3(18, 1, -119), Vector3(13, 1, -135)]:
        var guard = _make_enemy(guard_pos, "rifle")
        guard.set_meta("convoy_reinforcement", true)
        guard.set_meta("patrol_radius", 2.5)
        guard.set_meta("alert_time", 18.0)
        guard.set_meta("last_known_position", player.global_position)
    enemy_goal = enemies_defeated + enemies.size()

func _update_convoy_mission(delta: float):
    if convoy_checkpoints == 3 and convoy_intel_taken and not convoy_tower_occupied and _convoy_squad_clear("convoy_sniper"):
        for tower_pos in [Vector3(-24, 0, -19), Vector3(24, 0, -38)]:
            if player.global_position.y > 8.0 and Vector2(player.global_position.x, player.global_position.z).distance_to(Vector2(tower_pos.x, tower_pos.z)) < 3.0:
                convoy_tower_occupied = true
                convoy_ambush_started = true
                status_label.text = "تمركزت في البرج؛ القافلة تقترب من موقع الكمين"
                _update_objective_text()
                break
    if convoy_ambush_started and not convoy_stopped and convoy_vehicles.size() == 3:
        var step = 4.3 * delta
        for vehicle in convoy_vehicles:
            if is_instance_valid(vehicle):
                vehicle.position.z = min(vehicle.position.z + step, -78.0 - float(convoy_vehicles.find(vehicle)) * 13.0)
        if convoy_vehicles[0].position.z >= -78.0:
            convoy_stopped = true
            _spawn_convoy_guards()
            _make_objective(Vector3(5.2, 0.54, -79), "convoy_documents")
            status_label.text = "توقفت القافلة؛ اقضِ على حراسها وخذ وثائق عربة القيادة"
            _update_objective_text()
    if convoy_documents_taken:
        convoy_escape_time = max(convoy_escape_time - delta, 0.0)
        train_countdown_label.visible = true
        train_countdown_label.text = "التعزيزات خلال %02d:%02d" % [int(ceil(convoy_escape_time) / 60), int(ceil(convoy_escape_time)) % 60]
        train_countdown_label.add_theme_color_override("font_color", Color(0.96, 0.18, 0.12) if convoy_escape_time < 50 else (Color(0.98, 0.87, 0.18) if convoy_escape_time < 100 else Color(0.28, 0.98, 0.30)))
        if convoy_escape_time <= 0.0:
            mission_failure_reason = "وصلت تعزيزات القافلة قبل الإخلاء"
            _finish_game(false)
            return
        # The evacuation zone is deliberately in open ground in front of the
        # vehicle. Entering it completes the mission without requiring a
        # precise tap beside the vehicle collision body.
        if _convoy_squad_clear("convoy_reinforcement") and player.global_position.distance_to(Vector3(-21, 1.1, -137)) <= 5.5:
            extraction_reached = true
            _update_objective_text()
            _complete_mission()

func _make_bridge_gate(pos: Vector3) -> AnimatableBody3D:
    var gate = AnimatableBody3D.new()
    gate.position = pos
    gate.set_meta("surface_type", "metal")
    add_child(gate)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(16.3, 2.15, 0.36)
    collision.shape = shape
    gate.add_child(collision)
    var panel = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = shape.size
    panel.mesh = box
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.12, 0.17, 0.20)
    material.metallic = 0.45
    panel.material_override = material
    gate.add_child(panel)
    return gate

func _bridge_beam_between(a: Vector3, b: Vector3, radius: float, color: Color):
    # A slim visual beam with no collision: soldiers and player keep their routes.
    var beam = MeshInstance3D.new()
    var cylinder = CylinderMesh.new()
    cylinder.top_radius = radius
    cylinder.bottom_radius = radius
    cylinder.height = a.distance_to(b)
    beam.mesh = cylinder
    beam.position = (a + b) * 0.5
    beam.quaternion = Quaternion(Vector3.UP, (b - a).normalized())
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.metallic = 0.42
    beam.material_override = material
    add_child(beam)

func _make_bridge_emplacement(center: Vector3, color: Color):
    # Open, roofless guard post: no doorway or wall can trap a patrolling soldier.
    _make_visual_detail(center + Vector3(0, 0.035, 0), Vector3(19, 0.07, 12), color.darkened(0.24))
    for x in [-9.2, 9.2]:
        _make_structure(center + Vector3(x, 0.52, -1.6), Vector3(0.70, 1.04, 8.0), color)
    _make_structure(center + Vector3(0, 0.52, -5.1), Vector3(17.8, 1.04, 0.70), color)
    for x in [-6.0, 6.0]:
        _make_visual_detail(center + Vector3(x, 1.13, -5.1), Vector3(1.5, 0.18, 0.92), color.lightened(0.15))
    # One large entry on the front (toward increasing Z), always walkable.

func _build_bridge_assault():
    # A broad river cutting across the map rather than another walled valley.
    # The 140 m opening at spawn has an uninterrupted view of the river crossing.
    for z in range(128, 179, 16):
        for x in [-2.9, 2.9]:
            _make_visual_detail(Vector3(x, 0.009, float(z)), Vector3(0.34, 0.018, 10.0), Color(0.29, 0.25, 0.18))
    for bank_x in [-41.0, 41.0]:
        _make_visual_detail(Vector3(bank_x, 0.036, -8), Vector3(64, 0.065, 116), Color(0.06, 0.27, 0.34))
        _make_visual_detail(Vector3(bank_x, 0.071, -8), Vector3(64, 0.012, 116), Color(0.10, 0.34, 0.41, 0.85))
    # A narrow road deck and spaced steel pylons identify the bridge from afar.
    _make_visual_detail(Vector3(0, 0.062, -8), Vector3(17.2, 0.124, 118), Color(0.40, 0.41, 0.38))
    for z in range(-64, 48, 9):
        _make_visual_detail(Vector3(0, 0.127, float(z)), Vector3(16.8, 0.008, 0.055), Color(0.18, 0.19, 0.19))
    for x in [-8.8, 8.8]:
        _make_structure(Vector3(x, 0.53, -8), Vector3(0.42, 1.06, 117), Color(0.18, 0.25, 0.28))
        for tower_z in [30.0, -43.0]:
            _make_visual_detail(Vector3(x, 4.2, tower_z), Vector3(0.90, 8.4, 0.96), Color(0.14, 0.22, 0.25))
            _make_visual_detail(Vector3(x, 8.45, tower_z), Vector3(1.3, 0.28, 1.4), Color(0.72, 0.55, 0.19))
        _bridge_beam_between(Vector3(x, 8.2, 30), Vector3(x, 8.2, -43), 0.065, Color(0.20, 0.26, 0.29))
        for hanger_z in range(-37, 31, 12):
            _bridge_beam_between(Vector3(x, 1.1, float(hanger_z)), Vector3(x, 8.2, float(hanger_z)), 0.045, Color(0.23, 0.29, 0.31))
    _bridge_beam_between(Vector3(-8.8, 8.2, 30), Vector3(8.8, 8.2, 30), 0.10, Color(0.22, 0.28, 0.29))
    _bridge_beam_between(Vector3(-8.8, 8.2, -43), Vector3(8.8, 8.2, -43), 0.10, Color(0.22, 0.28, 0.29))
    # Continuous floor collider below the deck eliminates steps and soft locks.
    # Two low riverbanks block the water crossing outside the bridge, with a
    # 17.5 m central opening aligned with its road surface.
    for bank_z in [51.0, -68.0]:
        for x in [-45.0, 45.0]:
            _make_structure(Vector3(x, 1.6, bank_z), Vector3(72, 3.2, 1.0), Color(0.31, 0.30, 0.25))
    _make_bridge_emplacement(Vector3(-27, 0, 98), Color(0.30, 0.33, 0.28))
    _make_bridge_emplacement(Vector3(21, 0, -100), Color(0.32, 0.29, 0.25))
    # Open equipment station: three separate pickups rather than three rooms.
    _make_visual_detail(Vector3(-11, 0.025, 81), Vector3(18, 0.05, 13), Color(0.23, 0.28, 0.27))
    for x in [-19.0, -11.0, -3.0]:
        _make_visual_detail(Vector3(x, 0.06, 88), Vector3(3.3, 0.12, 0.10), Color(0.78, 0.63, 0.23))
    # Barricades are offset from every guard patrol circle and interaction spot.
    for cover_data in [[-12.0, 113.0], [11.0, 103.0], [12.0, 75.0], [-5.5, 22.0], [5.5, -15.0], [-5.5, -42.0], [-10.0, -79.0], [12.0, -113.0]]:
        _make_structure(Vector3(cover_data[0], 0.45, cover_data[1]), Vector3(3.0, 0.90, 0.62), Color(0.31, 0.31, 0.29))
    bridge_entry_gate = _make_bridge_gate(Vector3(0, 1.075, 48))
    bridge_exit_gate = _make_bridge_gate(Vector3(0, 1.075, -65))
    # Extraction truck is on the far bank, outside the second guard post.
    _make_vehicle(Vector3(-20, 0.8, -133), Color(0.13, 0.19, 0.16), true)

func _bridge_squad_clear(squad_name: String) -> bool:
    for enemy in enemies:
        if is_instance_valid(enemy) and bool(enemy.get_meta(squad_name, false)):
            return false
    return true

func _update_bridge_countdown():
    if not is_instance_valid(train_countdown_label):
        return
    train_countdown_label.visible = bridge_escape_active and not game_ended
    if train_countdown_label.visible:
        var seconds_left = int(ceil(bridge_escape_time))
        train_countdown_label.text = "انفجار الجسر خلال %02d:%02d" % [int(seconds_left / 60), seconds_left % 60]
        var fraction = bridge_escape_time / 240.0
        var color = Color(0.98, 0.20, 0.12) if fraction <= 0.25 else (Color(1.0, 0.87, 0.14) if fraction <= 0.5 else Color(0.22, 0.98, 0.27))
        train_countdown_label.add_theme_color_override("font_color", color)

func _build_mountain_pass():
    # Open sightline at the spawn. Stone walls mark the mountain pass, while
    # the center and both flanks stay wide enough for uninterrupted movement.
    for z in range(-132, 151, 24):
        var ridge_z = float(z)
        _make_structure(Vector3(-59, 5.0, ridge_z), Vector3(32, 10.0, 22.0), Color(0.27, 0.25, 0.21))
        _make_structure(Vector3(59, 5.0, ridge_z), Vector3(32, 10.0, 22.0), Color(0.26, 0.25, 0.23))
        _make_visual_detail(Vector3(-41, 1.7, ridge_z), Vector3(4.0, 3.0, 15.0), Color(0.34, 0.32, 0.27))
        _make_visual_detail(Vector3(41, 1.9, ridge_z + 4.0), Vector3(3.0, 3.3, 13.0), Color(0.32, 0.30, 0.26))
    # Staggered 1 m cover, with visible gaps and an alternative on each side.
    for cover_pos in [Vector3(-12, 0.45, 126), Vector3(11, 0.45, 110), Vector3(-12, 0.45, 85), Vector3(13, 0.45, 65), Vector3(-12, 0.45, 38), Vector3(12, 0.45, 2), Vector3(-11, 0.45, -26), Vector3(12, 0.45, -51), Vector3(-10, 0.45, -89)]:
        _make_structure(cover_pos, Vector3(4.3, 0.90, 0.85), Color(0.40, 0.38, 0.33))
    for tree_data in [Vector3(-27, 0, 136), Vector3(28, 0, 120), Vector3(26, 0, 87), Vector3(-27, 0, 57), Vector3(-27, 0, 14), Vector3(27, 0, -14), Vector3(-26, 0, -70), Vector3(29, 0, -102)]:
        _make_tree(tree_data, 4.5, false)
    for stone in [Vector3(-23, 0.33, 115), Vector3(23, 0.33, 93), Vector3(-24, 0.33, 48), Vector3(24, 0.33, 20), Vector3(-25, 0.33, -11), Vector3(25, 0.33, -68)]:
        _make_rock(stone)
    # Two distinct radio masts. The controls are at ground level and offset
    # from their solid supports so the player can reach each switch.
    for mast_data in [[-24.0, 81.0], [24.0, 12.0]]:
        var mast_x = mast_data[0]
        var mast_z = mast_data[1]
        _make_structure(Vector3(mast_x, 4.2, mast_z), Vector3(0.40, 8.4, 0.40), Color(0.23, 0.28, 0.29))
        for mast_y in [2.0, 4.5, 7.5]:
            _make_visual_detail(Vector3(mast_x, mast_y, mast_z), Vector3(3.0, 0.12, 0.12), Color(0.36, 0.40, 0.38))
        _make_visual_detail(Vector3(mast_x, 8.65, mast_z), Vector3(0.80, 0.12, 0.80), Color(0.84, 0.18, 0.07))
    # A walkable hut with an automatic door contains the communications data.
    _make_building(Vector3(-16, 2.4, -64), Vector3(12.0, 4.8, 12.0), Color(0.24, 0.29, 0.28), "auto")
    _make_vehicle(Vector3(13, 0.80, -122), Color(0.14, 0.20, 0.15), true)

func _build_military_train_valley():
    # Mountain valley, railway approach and fortified station.
    for z in range(-140, 151, 24):
        _make_structure(Vector3(-58, 6.0, float(z)), Vector3(30, 12, 22), Color(0.22, 0.19, 0.16))
        _make_structure(Vector3(58, 6.0, float(z)), Vector3(30, 12, 22), Color(0.22, 0.19, 0.16))
    _make_structure(Vector3(0, 0.08, 5), Vector3(82, 0.16, 300), Color(0.18, 0.17, 0.15))
    # Rails, sleepers and a short bridge section.
    for rail_x in [-3.2, 3.2]:
        _make_structure(Vector3(rail_x, 0.28, 0), Vector3(0.28, 0.22, 292), Color(0.13, 0.14, 0.14))
    for sleeper_z in range(-140, 145, 5):
        _make_visual_detail(Vector3(0, 0.19, float(sleeper_z)), Vector3(8.2, 0.18, 0.55), Color(0.24, 0.18, 0.12))
    _make_structure(Vector3(0, 2.2, -18), Vector3(18, 0.55, 34), Color(0.20, 0.22, 0.23))
    for bridge_x in [-8.0, 8.0]:
        _make_structure(Vector3(bridge_x, 1.15, -18), Vector3(0.55, 2.3, 36), Color(0.16, 0.18, 0.18))
    # Station and ammunition store.
    _make_building(Vector3(-24, 3.4, 79), Vector3(25, 6.8, 24), Color(0.30, 0.28, 0.24), "building1")
    _make_building(Vector3(24, 3.0, 79), Vector3(20, 6.0, 20), Color(0.25, 0.27, 0.25), "auto")
    # The prisoner is held in a locked, walkable room beside the railway.
    _make_building(Vector3(-17, 2.0, -39), Vector3(8, 4, 8), Color(0.36, 0.34, 0.30), "prison")
    _make_vehicle(Vector3(-15, 0.80, 122), Color(0.12, 0.16, 0.13), true)
    # Six connected train cars. The locomotive is the armored front car.
    for i in range(6):
        var car_z = 42.0 - float(i) * 27.0
        var car_color = Color(0.16, 0.23, 0.17) if i < 5 else Color(0.24, 0.16, 0.14)
        _make_train_panel(Vector3(0, 0.09, car_z), Vector3(11.5, 0.16, 22.0), car_color.darkened(0.10))
        # Split side walls leave a wide door on both sides of every car.
        for wall_x in [-5.55, 5.55]:
            _make_train_panel(Vector3(wall_x, 1.85, car_z - 6.7), Vector3(0.35, 3.0, 7.6), car_color)
            _make_train_panel(Vector3(wall_x, 1.85, car_z + 6.7), Vector3(0.35, 3.0, 7.6), car_color)
        _make_train_panel(Vector3(0, 1.85, car_z - 10.8), Vector3(11.5, 3.0, 0.35), car_color)
        _make_train_panel(Vector3(0, 1.85, car_z + 10.8), Vector3(11.5, 3.0, 0.35), car_color)
        _make_visual_detail(Vector3(0, 3.35, car_z), Vector3(12.2, 0.22, 22.8), car_color.darkened(0.18))
        # Corrugated sheet metal, an end hatch and windows distinguish rolling stock from buildings.
        for wall_x in [-5.76, 5.76]:
            for groove_z in range(-9, 10, 2):
                if abs(groove_z) > 3:
                    _make_visual_detail(Vector3(wall_x, 1.8, car_z + groove_z), Vector3(0.06, 2.6, 0.09), car_color.lightened(0.18))
            for window_z in [-7.1, 7.1]:
                _make_visual_detail(Vector3(wall_x + (0.04 if wall_x > 0 else -0.04), 2.25, car_z + window_z), Vector3(0.07, 0.55, 1.35), Color(0.14, 0.28, 0.35))
        _make_visual_detail(Vector3(0, 1.65, car_z + 11.03), Vector3(1.25, 2.1, 0.07), Color(0.38, 0.38, 0.31))
        _make_visual_detail(Vector3(0, 1.65, car_z - 11.03), Vector3(1.25, 2.1, 0.07), Color(0.38, 0.38, 0.31))
        for wheel_x in [-4.2, 4.2]:
            for wheel_z in [-7.0, 7.0]:
                _make_visual_detail(Vector3(wheel_x, 0.45, car_z + wheel_z), Vector3(1.2, 1.2, 0.45), Color(0.06, 0.07, 0.07))
        if i < 5:
            _make_structure(Vector3(0, 1.1, car_z - 13.5), Vector3(2.0, 0.45, 5.0), Color(0.10, 0.11, 0.10))
    # Low tactical cover along both sides of the tracks.
    for cover_data in [
        [Vector3(-13, 0.62, 137), Vector3(7.0, 1.24, 0.8)], [Vector3(13, 0.60, 122), Vector3(6.5, 1.20, 0.8)],
        [Vector3(-15, 0.62, 104), Vector3(7.0, 1.24, 0.8)], [Vector3(15, 0.58, 61), Vector3(6.0, 1.16, 0.8)],
        [Vector3(-15, 0.58, 18), Vector3(6.0, 1.16, 0.8)], [Vector3(15, 0.58, -42), Vector3(6.0, 1.16, 0.8)],
        [Vector3(-15, 0.58, -96), Vector3(6.0, 1.16, 0.8)]
    ]:
        _make_structure(cover_data[0], cover_data[1], Color(0.34, 0.32, 0.28))
    for tower_pos in [Vector3(-38, 0, 112), Vector3(38, 0, 92), Vector3(-38, 0, -68)]:
        _make_guard_tower(tower_pos, 0.80)
        _make_spotlight(tower_pos + Vector3(0, 7.0, 0))
    _make_vehicle(Vector3(18, 0.80, -132), Color(0.10, 0.14, 0.12), true)

func _make_air_control_tower(pos: Vector3):
    _make_structure(pos + Vector3(0, 5.0, 0), Vector3(5.0, 10.0, 5.0), Color(0.28, 0.31, 0.34))
    _make_structure(pos + Vector3(0, 10.4, 0), Vector3(8.5, 2.8, 8.5), Color(0.48, 0.54, 0.58))
    for side in [-1.0, 1.0]:
        _make_visual_detail(pos + Vector3(side * 4.3, 10.6, 0), Vector3(0.08, 1.65, 6.5), Color(0.04, 0.22, 0.34))
    _make_visual_detail(pos + Vector3(0, 13.2, 0), Vector3(10.0, 0.25, 10.0), Color(0.12, 0.14, 0.16))
    _make_visual_detail(pos + Vector3(0, 16.2, 0), Vector3(0.20, 6.0, 0.20), Color(0.16, 0.17, 0.18))

func _make_cargo_aircraft(pos: Vector3):
    var aircraft = Node3D.new()
    aircraft.position = pos
    add_child(aircraft)
    _pickup_cylinder(aircraft, 1.45, 17.0, Vector3(0, 2.1, 0), Color(0.33, 0.39, 0.36))
    _add_vehicle_box(aircraft, Vector3(24, 0.45, 5.2), Vector3(0, 2.1, 0), Color(0.27, 0.33, 0.31))
    _add_vehicle_box(aircraft, Vector3(7.5, 0.32, 6.0), Vector3(0, 4.0, 6.2), Color(0.24, 0.30, 0.28))
    for wheel_x in [-3.0, 3.0]:
        _add_vehicle_wheel(aircraft, Vector3(wheel_x, 0.45, 0.8))

func _make_helicopter(pos: Vector3):
    _make_visual_detail(pos + Vector3(0, 1.25, 0), Vector3(5.2, 2.1, 3.2), Color(0.16, 0.23, 0.20))
    _make_visual_detail(pos + Vector3(0, 2.55, 0), Vector3(12.0, 0.12, 0.28), Color(0.06, 0.07, 0.07))
    _make_visual_detail(pos + Vector3(0, 2.55, 0), Vector3(0.28, 0.12, 12.0), Color(0.06, 0.07, 0.07))
    _make_visual_detail(pos + Vector3(0, 1.35, 4.5), Vector3(0.65, 0.65, 8.0), Color(0.14, 0.20, 0.17))

func _make_fuel_silo(pos: Vector3):
    var silo = Node3D.new()
    silo.position = pos
    add_child(silo)
    _pickup_cylinder(silo, 1.65, 4.2, Vector3(0, 2.05, 0), Color(0.52, 0.17, 0.07))
    _add_vehicle_box(silo, Vector3(3.8, 0.15, 0.18), Vector3(0, 2.0, 0), Color(0.92, 0.72, 0.10))

func _make_port_water(pos: Vector3, size: Vector3):
    var water = MeshInstance3D.new()
    var water_mesh = BoxMesh.new()
    water_mesh.size = size
    water.mesh = water_mesh
    water.position = pos
    var water_material = StandardMaterial3D.new()
    water_material.albedo_color = Color(0.035, 0.16, 0.23, 0.82)
    water_material.metallic = 0.28
    water_material.roughness = 0.18
    water_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    water.material_override = water_material
    add_child(water)

func _make_port_bollard(pos: Vector3):
    var bollard = Node3D.new()
    bollard.position = pos
    add_child(bollard)
    _pickup_cylinder(bollard, 0.16, 0.50, Vector3.ZERO, Color(0.08, 0.09, 0.09))
    bollard.rotation_degrees.x = 90

func _make_shipping_container(pos: Vector3, color: Color, stacked: bool):
    var levels = 2 if stacked else 1
    for level in range(levels):
        var center = pos + Vector3(0, float(level) * 2.75, 0)
        _make_structure(center, Vector3(7.6, 2.55, 3.15), color.darkened(float(level) * 0.06))
        for rib in range(7):
            _make_visual_detail(center + Vector3(-3.0 + rib, 0, -1.60), Vector3(0.08, 2.28, 0.06), color.lightened(0.13))
        _make_visual_detail(center + Vector3(0, 0, -1.64), Vector3(7.2, 0.10, 0.08), Color(0.10, 0.11, 0.11))

func _make_port_warehouse(center: Vector3, size: Vector3, color: Color, lock_kind: String):
    _make_building(center + Vector3(0, size.y * 0.5, 0), size, color, lock_kind)
    for stripe in range(5):
        _make_visual_detail(center + Vector3(-size.x * 0.38 + stripe * size.x * 0.19, size.y * 0.62, size.z * 0.505), Vector3(0.12, size.y * 0.55, 0.08), color.lightened(0.16))
    for lamp_x in [-size.x * 0.34, size.x * 0.34]:
        _make_spotlight(center + Vector3(lamp_x, size.y * 0.76, size.z * 0.53))

func _make_port_crane(pos: Vector3, color: Color):
    _make_structure(pos + Vector3(0, 6.0, 0), Vector3(1.0, 12.0, 1.0), color)
    _make_structure(pos + Vector3(0, 11.5, -4.8), Vector3(1.0, 0.75, 10.5), color)
    _make_structure(pos + Vector3(0, 8.2, -9.6), Vector3(0.12, 6.2, 0.12), Color(0.06, 0.07, 0.07))
    _make_visual_detail(pos + Vector3(0, 5.7, -9.6), Vector3(1.15, 0.45, 1.15), Color(0.16, 0.17, 0.16))

func _make_spotlight(pos: Vector3):
    var lamp = SpotLight3D.new()
    lamp.position = pos
    lamp.rotation_degrees = Vector3(-58, 0, 0)
    lamp.light_color = Color(0.78, 0.88, 1.0)
    lamp.light_energy = 2.2
    lamp.spot_range = 24.0
    lamp.spot_angle = 32.0
    lamp.shadow_enabled = true
    add_child(lamp)
    _make_visual_detail(pos, Vector3(0.45, 0.32, 0.62), Color(0.09, 0.10, 0.10))

func _make_cargo_ship(pos: Vector3):
    _make_structure(pos, Vector3(12, 1.5, 38), Color(0.12, 0.16, 0.20))
    _make_structure(pos + Vector3(0, 1.5, 4), Vector3(10.5, 1.4, 27), Color(0.30, 0.12, 0.10))
    _make_structure(pos + Vector3(0, 3.1, 11), Vector3(8, 3.0, 8), Color(0.73, 0.75, 0.72))
    for window_x in [-2.5, -0.85, 0.85, 2.5]:
        _make_visual_detail(pos + Vector3(window_x, 3.6, 6.95), Vector3(0.85, 0.52, 0.08), Color(0.04, 0.22, 0.30))
    _make_visual_detail(pos + Vector3(0, 6.3, 12), Vector3(0.25, 4.0, 0.25), Color(0.12, 0.13, 0.13))

func _make_patrol_boat_visual(pos: Vector3):
    _make_structure(pos, Vector3(5.5, 0.65, 12), Color(0.12, 0.22, 0.29))
    _make_structure(pos + Vector3(0, 0.75, 1.1), Vector3(4.0, 1.25, 4.2), Color(0.72, 0.74, 0.70))
    _make_visual_detail(pos + Vector3(0, 1.1, -1.05), Vector3(3.1, 0.60, 0.08), Color(0.035, 0.18, 0.25))

func _build_compound():
    _make_building(Vector3(-24, 2.0, -15), Vector3(10, 4, 11), Color(0.54, 0.38, 0.23), "building1")
    _make_building(Vector3(24, 2.0, -32), Vector3(11, 4, 11), Color(0.38, 0.48, 0.56), "building2")
    _make_building(Vector3(-42, 2.0, 22), Vector3(12, 4, 10), Color(0.58, 0.52, 0.39))
    _make_building(Vector3(38, 2.0, 25), Vector3(13, 4, 9), Color(0.42, 0.52, 0.38))
    _make_building(Vector3(0, 2.0, -48), Vector3(15, 4, 10), Color(0.52, 0.43, 0.35))
    _make_building(Vector3(3, 2.0, 18), Vector3(10, 4, 8), Color(0.48, 0.38, 0.50))
    _make_building(Vector3(-48, 1.65, -32), Vector3(9, 3.3, 8), Color(0.60, 0.46, 0.30))
    _make_building(Vector3(48, 2.35, -30), Vector3(10, 4.7, 8), Color(0.32, 0.46, 0.55))
    _make_building(Vector3(-25, 1.55, 42), Vector3(8, 3.1, 7), Color(0.50, 0.55, 0.35))
    _make_building(Vector3(26, 2.55, 48), Vector3(11, 5.1, 7), Color(0.57, 0.37, 0.32))
    _make_building(Vector3(0, 1.45, -20), Vector3(8, 2.9, 7), Color(0.42, 0.47, 0.58))
    _make_starting_cover()
    _make_outside_nature()
    for tower_pos in [Vector3(-60, 0, -55), Vector3(0, 0, -62), Vector3(60, 0, -55), Vector3(-60, 0, 52), Vector3(60, 0, 52), Vector3(-12, 0, 64), Vector3(12, 0, 64), Vector3(-19, 0, 86)]:
        _make_guard_tower(tower_pos)
    _make_vehicle(Vector3(-15, 0.90, 35), Color(0.18, 0.24, 0.16), true)
    _make_vehicle(Vector3(20, 0.75, 42), Color(0.25, 0.22, 0.15), false)
    _make_vehicle(Vector3(-45, 0.75, -5), Color(0.14, 0.18, 0.14), false)
    _make_vehicle(Vector3(44, 0.90, -10), Color(0.20, 0.23, 0.17), true)
    _make_tank(Vector3(-5, 1.0, -22), Color(0.16, 0.21, 0.13))
    _make_tank(Vector3(42, 1.0, -48), Color(0.19, 0.20, 0.14))
    for cover_pos in [Vector3(-30, 1.0, 42), Vector3(31, 1.0, 8), Vector3(-8, 1.0, -38), Vector3(12, 1.0, 48)]:
        _make_structure(cover_pos, Vector3(5.0, 2.0, 0.65), Color(0.38, 0.35, 0.30))
    _make_structure(Vector3(0, 2.0, -70), Vector3(140, 4, 0.8), Color(0.20, 0.22, 0.24))
    _make_structure(Vector3(-36.8, 2.0, 70), Vector3(66.4, 4, 0.8), Color(0.20, 0.22, 0.24))
    _make_structure(Vector3(36.8, 2.0, 70), Vector3(66.4, 4, 0.8), Color(0.20, 0.22, 0.24))
    _make_locked_gate()
    _make_structure(Vector3(-70, 2.0, 0), Vector3(0.8, 4, 140), Color(0.20, 0.22, 0.24))
    _make_structure(Vector3(70, 2.0, 0), Vector3(0.8, 4, 140), Color(0.20, 0.22, 0.24))

func _build_missile_depot():
    # Stage two is an open valley; mountains replace the first camp's walls.
    _make_mountain_ridge(Vector3(-58, 0, 20), Vector3(24, 11, 145), 0.05)
    _make_mountain_ridge(Vector3(58, 0, 5), Vector3(26, 13, 150), -0.08)
    _make_mountain_ridge(Vector3(-28, 0, -72), Vector3(62, 12, 24), 0.12)
    _make_mountain_ridge(Vector3(32, 0, -74), Vector3(58, 10, 26), -0.10)
    _make_mountain_ridge(Vector3(-34, 0, 92), Vector3(34, 7, 28), -0.18)
    _make_mountain_ridge(Vector3(38, 0, 88), Vector3(32, 8, 30), 0.16)

    # Natural cover along the winding approach through the valley.
    for rock_pos in [Vector3(-12, 0.45, 132), Vector3(16, 0.45, 119), Vector3(-20, 0.45, 105), Vector3(22, 0.45, 88), Vector3(-15, 0.45, 70), Vector3(18, 0.45, 54), Vector3(-8, 0.45, 34)]:
        _make_rock(rock_pos)
    for tree_pos in [Vector3(-25, 0, 126), Vector3(27, 0, 111), Vector3(-30, 0, 78), Vector3(32, 0, 63), Vector3(-23, 0, 25), Vector3(28, 0, 8)]:
        _make_tree(tree_pos, 4.0, false)

    # Three visually different military positions linked by keys and passwords.
    _make_building(Vector3(-27, 2.1, 25), Vector3(14, 4.2, 12), Color(0.34, 0.40, 0.31), "building1")
    _make_tent(Vector3(24, 0, 38), Color(0.30, 0.36, 0.24))
    _make_tent(Vector3(-18, 0, -8), Color(0.42, 0.35, 0.23))
    _make_building(Vector3(7, 2.5, -48), Vector3(18, 5.0, 14), Color(0.27, 0.34, 0.45), "building2")
    _make_building(Vector3(36, 1.7, -18), Vector3(11, 3.4, 9), Color(0.48, 0.40, 0.29))

    # Keep every tower inside the playable valley. The former +/-42 positions
    # intersected the mountain collision masses and hid two snipers.
    for tower_pos in [Vector3(-34, 0, 76), Vector3(34, 0, 58), Vector3(-34, 0, -38), Vector3(34, 0, -58)]:
        _make_guard_tower(tower_pos)
    _make_vehicle(Vector3(13, 0.9, 72), Color(0.16, 0.20, 0.17), true)
    _make_vehicle(Vector3(-34, 0.75, 5), Color(0.25, 0.21, 0.14), false)
    _make_tank(Vector3(29, 1.0, -40), Color(0.15, 0.19, 0.13))

func _make_mountain_ridge(center: Vector3, ridge_size: Vector3, angle: float):
    var ridge = StaticBody3D.new()
    ridge.position = center
    ridge.rotation.y = angle
    ridge.set_meta("surface_type", "ground")
    add_child(ridge)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(ridge_size.x, ridge_size.y * 0.72, ridge_size.z)
    collision.shape = shape
    collision.position.y = ridge_size.y * 0.34
    ridge.add_child(collision)
    var rock_material = StandardMaterial3D.new()
    rock_material.albedo_color = Color(0.31, 0.24, 0.17)
    rock_material.albedo_texture = load("res://textures/desert_ground.svg")
    rock_material.roughness = 0.98
    for i in range(7):
        var mass = MeshInstance3D.new()
        var mass_mesh = SphereMesh.new()
        mass_mesh.radius = 1.0
        mass_mesh.height = 2.0
        mass.mesh = mass_mesh
        var along = (float(i) / 6.0 - 0.5) * ridge_size.z
        mass.position = Vector3(sin(float(i) * 1.7) * ridge_size.x * 0.12, ridge_size.y * 0.42, along)
        mass.scale = Vector3(ridge_size.x * (0.46 + float(i % 3) * 0.07), ridge_size.y * (0.55 + float(i % 2) * 0.16), ridge_size.z * 0.12)
        mass.material_override = rock_material
        ridge.add_child(mass)

func _make_tent(pos: Vector3, color: Color):
    var tent = Node3D.new()
    tent.position = pos
    add_child(tent)
    var cloth = StandardMaterial3D.new()
    cloth.albedo_color = color
    cloth.roughness = 0.96
    for side in [-1.0, 1.0]:
        var roof = MeshInstance3D.new()
        var roof_mesh = BoxMesh.new()
        roof_mesh.size = Vector3(3.8, 0.12, 8.0)
        roof.mesh = roof_mesh
        roof.position = Vector3(side * 1.18, 2.0, 0)
        roof.rotation_degrees.z = side * 36.0
        roof.material_override = cloth
        tent.add_child(roof)
    var pole_material = StandardMaterial3D.new()
    pole_material.albedo_color = Color(0.16, 0.13, 0.09)
    pole_material.metallic = 0.35
    for pole_pos in [Vector3(0, 1.45, -3.8), Vector3(0, 1.45, 3.8)]:
        var pole = MeshInstance3D.new()
        var pole_mesh = CylinderMesh.new()
        pole_mesh.top_radius = 0.07
        pole_mesh.bottom_radius = 0.07
        pole_mesh.height = 2.9
        pole.mesh = pole_mesh
        pole.position = pole_pos
        pole.material_override = pole_material
        tent.add_child(pole)
    _make_visual_detail(pos + Vector3(-1.4, 0.28, 0), Vector3(2.2, 0.35, 5.8), Color(0.18, 0.20, 0.16))
    _make_visual_detail(pos + Vector3(1.4, 0.28, 0), Vector3(2.2, 0.35, 5.8), Color(0.18, 0.20, 0.16))

func _make_starting_cover():
    # A staggered protected approach from the spawn point to the main gate.
    # Gaps alternate left/right so the player can advance without a straight exposed lane.
    _make_structure(Vector3(-3.2, 0.80, 137), Vector3(6.2, 1.60, 0.80), Color(0.36, 0.35, 0.32))
    _make_structure(Vector3(3.4, 0.80, 121), Vector3(6.5, 1.60, 0.80), Color(0.34, 0.34, 0.32))
    _make_structure(Vector3(-3.3, 0.80, 105), Vector3(6.2, 1.60, 0.80), Color(0.37, 0.35, 0.31))
    _make_structure(Vector3(3.0, 0.70, 89), Vector3(5.8, 1.40, 0.85), Color(0.31, 0.32, 0.30))
    _make_vehicle(Vector3(-10, 0.90, 128), Color(0.16, 0.20, 0.14), true)
    _make_vehicle(Vector3(10, 0.75, 98), Color(0.24, 0.20, 0.13), false)
    for column_pos in [Vector3(-8, 1.20, 112), Vector3(8, 1.20, 118), Vector3(-9, 1.20, 140)]:
        _make_column(column_pos, 2.9)

func _make_outside_nature():
    var tree_positions = [Vector3(-24, 0, 132), Vector3(27, 0, 137), Vector3(-38, 0, 116), Vector3(41, 0, 121), Vector3(-55, 0, 95), Vector3(55, 0, 101), Vector3(-30, 0, 82), Vector3(34, 0, 86), Vector3(-62, 0, 138), Vector3(63, 0, 126)]
    for i in range(tree_positions.size()):
        _make_tree(tree_positions[i], 3.7 + float(i % 4) * 0.45, i % 3 != 0)
    for rock_position in [Vector3(-17, 0.32, 126), Vector3(19, 0.28, 119), Vector3(-46, 0.35, 104), Vector3(49, 0.26, 110), Vector3(-57, 0.30, 82), Vector3(58, 0.38, 91)]:
        _make_rock(rock_position)

func _make_tree(pos: Vector3, height: float, palm := true):
    var tree = StaticBody3D.new()
    tree.position = pos
    add_child(tree)
    var trunk_collision = CollisionShape3D.new()
    var trunk_shape = CylinderShape3D.new()
    trunk_shape.radius = 0.22
    trunk_shape.height = height
    trunk_collision.shape = trunk_shape
    trunk_collision.position.y = height * 0.5
    tree.add_child(trunk_collision)
    var trunk = MeshInstance3D.new()
    var trunk_mesh = CylinderMesh.new()
    trunk_mesh.top_radius = 0.16
    trunk_mesh.bottom_radius = 0.29
    trunk_mesh.height = height
    trunk.mesh = trunk_mesh
    trunk.position.y = height * 0.5
    var bark = StandardMaterial3D.new()
    bark.albedo_color = Color(0.30, 0.19, 0.09)
    bark.roughness = 0.96
    trunk.material_override = bark
    tree.add_child(trunk)
    var leaf_material = StandardMaterial3D.new()
    leaf_material.albedo_color = Color(0.16, 0.34, 0.12) if palm else Color(0.20, 0.40, 0.15)
    leaf_material.roughness = 0.90
    if palm:
        for i in range(8):
            var leaf = MeshInstance3D.new()
            var leaf_mesh = BoxMesh.new()
            leaf_mesh.size = Vector3(0.30, 0.08, 2.8)
            leaf.mesh = leaf_mesh
            leaf.position = Vector3(0, height, 0)
            leaf.rotation_degrees = Vector3(-18.0 - float(i % 2) * 9.0, float(i) * 45.0, 0)
            leaf.material_override = leaf_material
            tree.add_child(leaf)
    else:
        for crown_offset in [Vector3(0, height, 0), Vector3(-0.65, height - 0.25, 0.18), Vector3(0.62, height - 0.18, -0.20)]:
            var crown = MeshInstance3D.new()
            var crown_mesh = SphereMesh.new()
            crown_mesh.radius = 1.15
            crown_mesh.height = 2.1
            crown.mesh = crown_mesh
            crown.position = crown_offset
            crown.material_override = leaf_material
            tree.add_child(crown)

func _make_rock(pos: Vector3):
    var rock = StaticBody3D.new()
    rock.position = pos
    add_child(rock)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(1.3, 0.65, 1.0)
    collision.shape = shape
    rock.add_child(collision)
    var mesh_instance = MeshInstance3D.new()
    var mesh = SphereMesh.new()
    mesh.radius = 0.72
    mesh.height = 0.92
    mesh_instance.mesh = mesh
    mesh_instance.scale = Vector3(1.15, 0.65, 0.88)
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.34, 0.30, 0.24)
    material.roughness = 0.98
    mesh_instance.material_override = material
    rock.add_child(mesh_instance)

func _make_locked_gate():
    gate_door = AnimatableBody3D.new()
    gate_door.name = "MainGate"
    gate_door.set_meta("surface_type", "metal")
    gate_door.position = Vector3(0, 2.0, 70)
    gate_door.set_meta("lock_kind", "gate")
    gate_door.set_meta("unlocked", false)
    gate_door.set_meta("closed_y", 2.0)
    gate_door.set_meta("open_y", 7.2)
    add_child(gate_door)
    doors.append(gate_door)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(7.2, 4.0, 0.32)
    collision.shape = shape
    gate_door.add_child(collision)
    for bar_x in [-3.2, -2.4, -1.6, -0.8, 0.0, 0.8, 1.6, 2.4, 3.2]:
        _add_gate_part(Vector3(0.14, 3.9, 0.24), Vector3(bar_x, 0, 0))
    _add_gate_part(Vector3(7.15, 0.16, 0.25), Vector3(0, 1.75, 0))
    _add_gate_part(Vector3(7.15, 0.16, 0.25), Vector3(0, -1.75, 0))

func _add_gate_part(part_size: Vector3, offset: Vector3):
    var part = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = part_size
    part.mesh = mesh
    part.position = offset
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.10, 0.12, 0.11)
    material.metallic = 0.82
    material.roughness = 0.30
    part.material_override = material
    gate_door.add_child(part)

func _make_guard_tower(pos: Vector3, rail_height_scale := 1.0):
    tower_ladders.append(pos)
    for step in range(1, 19):
        _make_visual_detail(pos + Vector3(0, float(step) * 0.48, 1.49), Vector3(1.15, 0.09, 0.12), Color(0.66, 0.55, 0.29))
    for ladder_x in [-0.62, 0.62]:
        _make_visual_detail(pos + Vector3(ladder_x, 4.8, 1.49), Vector3(0.10, 9.4, 0.12), Color(0.62, 0.53, 0.30))
    for leg in [Vector3(-0.80, 4.60, -0.80), Vector3(0.80, 4.60, -0.80), Vector3(-0.80, 4.60, 0.80), Vector3(0.80, 4.60, 0.80)]:
        _make_structure(pos + leg, Vector3(0.30, 9.20, 0.30), Color(0.20, 0.21, 0.19))
    _make_structure(pos + Vector3(0, 6.05, 0), Vector3(2.38, 0.34, 2.38), Color(0.17, 0.18, 0.16))
    _make_structure(pos + Vector3(0, 9.05, 0), Vector3(2.66, 0.25, 2.66), Color(0.16, 0.17, 0.15))
    var rail_height = 0.48 * rail_height_scale
    var rail_center_y = 9.175 + rail_height * 0.5
    for rail in [Vector3(0, rail_center_y, -1.08)]:
        _make_structure(pos + rail, Vector3(2.24, rail_height, 0.10), Color(0.12, 0.13, 0.12))
    for rail in [Vector3(-1.08, rail_center_y, 0), Vector3(1.08, rail_center_y, 0)]:
        _make_structure(pos + rail, Vector3(0.10, rail_height, 2.24), Color(0.12, 0.13, 0.12))
    var canopy_color = Color(0.13, 0.15, 0.14)
    for support in [Vector3(-1.12, 10.32, -1.12), Vector3(1.12, 10.32, -1.12), Vector3(-1.12, 10.32, 1.12), Vector3(1.12, 10.32, 1.12)]:
        _make_visual_detail(pos + support, Vector3(0.09, 2.28, 0.09), canopy_color)
    _make_visual_detail(pos + Vector3(0, 11.55, 0), Vector3(3.05, 0.18, 3.05), canopy_color)

func _make_tank(pos: Vector3, color: Color):
    var tank = StaticBody3D.new()
    tank.position = pos
    tank.set_meta("surface_type", "metal")
    add_child(tank)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(5.6, 1.7, 3.2)
    collision.shape = shape
    tank.add_child(collision)
    _add_vehicle_box(tank, Vector3(5.6, 1.15, 3.2), Vector3.ZERO, color)
    _add_vehicle_box(tank, Vector3(2.6, 0.85, 2.4), Vector3(0, 0.95, 0), color.lightened(0.08))
    _add_vehicle_box(tank, Vector3(0.34, 0.34, 4.7), Vector3(0, 1.10, -3.15), Color(0.08, 0.10, 0.07))
    for track_x in [-2.25, 2.25]:
        _add_vehicle_box(tank, Vector3(1.0, 0.85, 3.65), Vector3(track_x, -0.35, 0), Color(0.035, 0.04, 0.035))


func _spawn_scenario_enemies():
    if mission_number == 10:
        for guard_data in [
            [Vector3(-12, 1, 146), "rifle"], [Vector3(14, 1, 132), "pistol"],
            [Vector3(-18, 1, 111), "rifle"], [Vector3(19, 1, 91), "shotgun"],
            [Vector3(-15, 1, 63), "rifle"], [Vector3(16, 1, 42), "rifle"],
            [Vector3(-13, 1, 12), "shotgun"], [Vector3(14, 1, -13), "rifle"],
            [Vector3(-18, 1, -35), "rifle"], [Vector3(20, 1, -42), "pistol"],
            [Vector3(-12, 1, -65), "rifle"], [Vector3(12, 1, -67), "shotgun"]
        ]:
            var guard = _make_enemy(guard_data[0], guard_data[1])
            guard.set_meta("final_guard", true)
            guard.set_meta("patrol_radius", 3.0)
        for tower_pos in [Vector3(-32, 10.12, 5), Vector3(32, 10.12, 5), Vector3(-34, 10.12, -87), Vector3(34, 10.12, -87)]:
            var sniper = _make_enemy(tower_pos, "sniper")
            sniper.set_meta("tower_sniper", true)
            sniper.set_meta("final_sniper", true)
        var boss = _make_enemy(Vector3(0, 1, -79), "rifle")
        boss.set_meta("final_boss", true)
        boss.set_meta("health", 18)
        boss.set_meta("weapon_damage", 12)
        boss.set_meta("patrol_radius", 4.0)
        enemy_goal = enemies.size()
        return
    if mission_number == 9:
        for checkpoint_index in range(3):
            var center_z = 143.0 - float(checkpoint_index) * 50.0
            for guard_pos in [Vector3(-8, 1, center_z + 6), Vector3(8, 1, center_z + 6), Vector3(2, 1, center_z - 5)]:
                var guard = _make_enemy(guard_pos, "rifle" if checkpoint_index != 1 else "shotgun")
                guard.set_meta("convoy_checkpoint", checkpoint_index)
                guard.set_meta("patrol_radius", 2.2)
        for tower_pos in [Vector3(-24, 10.12, -19), Vector3(24, 10.12, -38)]:
            var sniper = _make_enemy(tower_pos, "sniper")
            sniper.set_meta("tower_sniper", true)
            sniper.set_meta("convoy_sniper", true)
        enemy_goal = enemies.size()
        return
    if mission_number == 8:
        # Never place a soldier inside a room, under the bridge pylons, or on
        # a collision barrier. Patrols have several metres of empty ground.
        for guard_data in [
            [Vector3(-24, 1, 111), "rifle"], [Vector3(21, 1, 107), "shotgun"],
            [Vector3(-24, 1, 97), "pistol"], [Vector3(23, 1, 84), "rifle"],
            [Vector3(-23, 1, 72), "rifle"]
        ]:
            var guard = _make_enemy(guard_data[0], guard_data[1])
            guard.set_meta("bridge_first_guard", true)
            guard.set_meta("patrol_radius", 3.2)
        for pos in [Vector3(1, 1, 34), Vector3(3, 1, 8), Vector3(-2, 1, -20), Vector3(4, 1, -54)]:
            var bridge_guard = _make_enemy(pos, "rifle")
            bridge_guard.set_meta("bridge_bridge_guard", true)
            bridge_guard.set_meta("patrol_radius", 2.4)
        for far_data in [
            [Vector3(-18, 1, -81), "rifle"], [Vector3(18, 1, -84), "shotgun"],
            [Vector3(-18, 1, -109), "pistol"], [Vector3(23, 1, -99), "rifle"]
        ]:
            var far_guard = _make_enemy(far_data[0], far_data[1])
            far_guard.set_meta("bridge_second_guard", true)
            far_guard.set_meta("patrol_radius", 3.2)
        enemy_goal = enemies.size()
        return
    if mission_number == 7:
        for guard_data in [
            [Vector3(-17, 1.0, 122), "rifle"], [Vector3(17, 1.0, 104), "pistol"],
            [Vector3(-20, 1.0, 78), "rifle"], [Vector3(15, 1.0, 51), "shotgun"],
            [Vector3(20, 1.0, 6), "rifle"], [Vector3(-17, 1.0, -27), "pistol"],
            [Vector3(18, 1.0, -73), "rifle"]
        ]:
            var guard = _make_enemy(guard_data[0], guard_data[1])
            guard.set_meta("patrol_radius", 3.0)
        # One sniper at ground level, visible and reachable from either flank.
        var marksman = _make_enemy(Vector3(26, 1.0, -43), "sniper")
        marksman.set_meta("patrol_radius", 0.0)
        enemy_goal = enemies.size()
        return
    if mission_number == 6:
        var station_officer = _make_enemy(Vector3(-12, 1.0, 112), "pistol")
        station_officer.set_meta("drops_access_card", true)
        station_officer.set_meta("patrol_radius", 7.0)
        var train_guard_positions = [
            Vector3(13, 1, 130), Vector3(-18, 1, 96), Vector3(18, 1, 82),
            Vector3(-14, 1, 58), Vector3(14, 1, 35), Vector3(-14, 1, 8),
            Vector3(14, 1, -18), Vector3(-14, 1, -46), Vector3(14, 1, -73),
            Vector3(-14, 1, -101), Vector3(13, 1, -122)
        ]
        var train_guard_weapons = ["rifle", "shotgun", "rifle", "pistol", "rifle", "shotgun", "rifle", "pistol", "rifle", "shotgun", "rifle"]
        for i in range(train_guard_positions.size()):
            var train_guard = _make_enemy(train_guard_positions[i], train_guard_weapons[i])
            train_guard.set_meta("patrol_radius", 4.0 + float(i % 3) * 1.5)
        for sniper_pos in [Vector3(-38, 10.12, 112), Vector3(38, 10.12, 92), Vector3(-38, 10.12, -68)]:
            var train_sniper = _make_enemy(sniper_pos, "sniper")
            train_sniper.set_meta("tower_sniper", true)
        var train_commander = _make_enemy(Vector3(12, 1.0, -113), "rifle")
        train_commander.set_meta("stage6_commander", true)
        train_commander.set_meta("health", 9)
        train_commander.set_meta("max_health", 9)
        train_commander.set_meta("weapon_damage", 8)
        train_commander.set_meta("patrol_radius", 4.0)
        enemy_goal = enemies.size()
        return
    if mission_number == 5:
        var facility_officer = _make_enemy(Vector3(-7, 1.0, 118), "pistol")
        facility_officer.set_meta("drops_access_card", true)
        facility_officer.set_meta("patrol_radius", 7.0)
        var facility_positions = [
            Vector3(8, 1, 128), Vector3(-16, 1, 96), Vector3(15, 1, 82),
            Vector3(-14, 1, 56), Vector3(12, 1, 37), Vector3(-13, 1, 10),
            Vector3(13, 1, -12), Vector3(-14, 1, -39), Vector3(12, 1, -61),
            Vector3(-13, 1, -87), Vector3(13, 1, -108)
        ]
        var facility_weapons = ["rifle", "shotgun", "rifle", "pistol", "rifle", "shotgun", "rifle", "pistol", "rifle", "shotgun", "rifle"]
        for i in range(facility_positions.size()):
            var facility_guard = _make_enemy(facility_positions[i], facility_weapons[i])
            facility_guard.set_meta("patrol_radius", 3.5 + float(i % 3) * 1.4)
        for sniper_pos in [Vector3(-36, 10.12, 112), Vector3(36, 10.12, 112)]:
            var facility_sniper = _make_enemy(sniper_pos, "sniper")
            facility_sniper.set_meta("tower_sniper", true)
        var commander = _make_enemy(Vector3(11, 1.0, -91), "rifle")
        commander.set_meta("stage5_commander", true)
        commander.set_meta("health", 9)
        commander.set_meta("max_health", 9)
        commander.set_meta("weapon_damage", 8)
        commander.set_meta("patrol_radius", 5.0)
        enemy_goal = enemies.size()
        return
    if mission_number == 4:
        var airbase_officer = _make_enemy(Vector3(-8, 1.0, 119), "pistol")
        airbase_officer.set_meta("drops_access_card", true)
        airbase_officer.set_meta("patrol_radius", 7.0)
        var airbase_positions = [
            Vector3(10, 1, 126), Vector3(-28, 1, 100), Vector3(43, 1, 82),
            Vector3(-48, 1, 48), Vector3(5, 1, 28), Vector3(52, 1, 18),
            Vector3(-28, 1, -12), Vector3(10, 1, -45), Vector3(-45, 1, -72),
            Vector3(35, 1, -92), Vector3(-12, 1, -112)
        ]
        var airbase_weapons = ["rifle", "shotgun", "rifle", "pistol", "rifle", "shotgun", "rifle", "pistol", "rifle", "rifle", "shotgun"]
        for i in range(airbase_positions.size()):
            var airbase_guard = _make_enemy(airbase_positions[i], airbase_weapons[i])
            airbase_guard.set_meta("patrol_radius", 5.0 + float(i % 4) * 1.5)
        for sniper_pos in [Vector3(-62, 10.12, 112), Vector3(62, 10.12, 102), Vector3(-62, 10.12, -62), Vector3(62, 10.12, -112)]:
            var airbase_sniper = _make_enemy(sniper_pos, "sniper")
            airbase_sniper.set_meta("tower_sniper", true)
        enemy_goal = enemies.size()
        return
    if mission_number == 3:
        var port_officer = _make_enemy(Vector3(8, 1.0, 102), "pistol")
        port_officer.set_meta("drops_access_card", true)
        port_officer.set_meta("patrol_radius", 8.0)
        var patrol_positions = [
            Vector3(-12, 1, 121), Vector3(22, 1, 97), Vector3(-25, 1, 84),
            Vector3(14, 1, 54), Vector3(-18, 1, 18), Vector3(12, 1, -8),
            Vector3(-26, 1, -37), Vector3(23, 1, -55), Vector3(-12, 1, -88)
        ]
        var patrol_weapons = ["rifle", "shotgun", "rifle", "pistol", "rifle", "shotgun", "rifle", "pistol", "rifle"]
        for i in range(patrol_positions.size()):
            var port_guard = _make_enemy(patrol_positions[i], patrol_weapons[i])
            port_guard.set_meta("patrol_radius", 5.0 + float(i % 4) * 1.5)
        for sniper_pos in [Vector3(-43, 10.12, 94), Vector3(44, 10.12, 76), Vector3(-43, 10.12, -12), Vector3(44, 10.12, -62)]:
            var port_sniper = _make_enemy(sniper_pos, "sniper")
            port_sniper.set_meta("tower_sniper", true)
        var ship_guard = _make_enemy(Vector3(-56, 2.2, -48), "rifle")
        ship_guard.set_meta("patrol_radius", 6.0)
        enemy_goal = enemies.size()
        return
    if mission_number == 2:
        var depot_guard = _make_enemy(Vector3(-12.0, 1.0, 94.0), "rifle")
        var depot_guard_two = _make_enemy(Vector3(14.0, 1.0, 82.0), "shotgun")
        var officer = _make_enemy(Vector3(5.0, 1.0, 108.0), "pistol")
        officer.set_meta("drops_access_card", true)
        for patrol in [depot_guard, depot_guard_two, officer]:
            patrol.set_meta("patrol_radius", 7.0)
        for sniper_pos in [Vector3(-34, 10.12, 76), Vector3(34, 10.12, 58), Vector3(-34, 10.12, -38), Vector3(34, 10.12, -58)]:
            var depot_sniper = _make_enemy(sniper_pos, "sniper")
            depot_sniper.set_meta("tower_sniper", true)
        var depot_positions = [Vector3(-24, 1, 36), Vector3(26, 1, 48), Vector3(-31, 1, 4), Vector3(34, 1, -8), Vector3(-18, 1, -25), Vector3(15, 1, -38), Vector3(-5, 1, 8), Vector3(7, 1, -58)]
        var depot_weapons = ["rifle", "shotgun", "pistol", "rifle", "rifle", "pistol", "shotgun", "rifle"]
        for i in range(depot_positions.size()):
            var patrol_enemy = _make_enemy(depot_positions[i], depot_weapons[i])
            patrol_enemy.set_meta("patrol_radius", 5.0 + float(i % 3) * 2.0)
        enemy_goal = enemies.size()
        return

    var gate_guard = _make_enemy(Vector3(-2.4, 1.0, 76.0), "rifle")
    gate_guard.set_meta("drops_gate_key", true)
    var second_guard = _make_enemy(Vector3(2.4, 1.0, 76.0), "rifle")
    gate_guard.look_at(Vector3(-2.4, gate_guard.global_position.y, 104), Vector3.UP)
    second_guard.look_at(Vector3(2.4, second_guard.global_position.y, 104), Vector3.UP)
    for sniper_pos in [Vector3(-60, 10.12, -55), Vector3(0, 10.12, -62), Vector3(60, 10.12, -55), Vector3(-60, 10.12, 52), Vector3(60, 10.12, 52), Vector3(-12, 10.12, 64), Vector3(12, 10.12, 64), Vector3(-19, 10.12, 86)]:
        var tower_sniper = _make_enemy(sniper_pos, "sniper")
        tower_sniper.set_meta("tower_sniper", true)
    var inside_positions = [Vector3(-35, 1.0, 30), Vector3(33, 1.0, 18), Vector3(-18, 1.0, 0), Vector3(12, 1.0, -20), Vector3(-40, 1.0, -35), Vector3(35, 1.0, -48), Vector3(0, 1.0, 8), Vector3(-48, 1.0, -22), Vector3(47, 1.0, -18), Vector3(-20, 1.0, 48), Vector3(22, 1.0, 38)]
    var inside_weapons = ["rifle", "pistol", "rifle", "shotgun", "rifle", "pistol", "rifle", "pistol", "rifle", "shotgun", "rifle"]
    for i in range(inside_positions.size()):
        _make_enemy(inside_positions[i], inside_weapons[i])
    enemy_goal = enemies.size()

func _spawn_extra_camp_pickups():
    _make_pickup(Vector3(-42, 0.38, 21), "rifle")
    _make_pickup(Vector3(-40, 0.38, 23), "ammo")
    _make_pickup(Vector3(38, 0.38, 24), "shotgun")
    _make_pickup(Vector3(40, 0.38, 26), "health")
    _make_pickup(Vector3(0, 0.38, -48), "sniper")
    _make_pickup(Vector3(3, 0.38, 18), "grenade")

func _make_building(center: Vector3, building_size: Vector3, color: Color, lock_kind := "auto"):
    var wall_thickness = 0.35
    var door_width = 1.7
    var front_z = center.z + building_size.z * 0.5
    var rear_z = center.z - building_size.z * 0.5
    _make_structure(Vector3(center.x, center.y, rear_z), Vector3(building_size.x, building_size.y, wall_thickness), color)
    _make_structure(Vector3(center.x - building_size.x * 0.5, center.y, center.z), Vector3(wall_thickness, building_size.y, building_size.z), color)
    _make_structure(Vector3(center.x + building_size.x * 0.5, center.y, center.z), Vector3(wall_thickness, building_size.y, building_size.z), color)
    var side_width = (building_size.x - door_width) * 0.5
    var side_offset = door_width * 0.5 + side_width * 0.5
    _make_structure(Vector3(center.x - side_offset, center.y, front_z), Vector3(side_width, building_size.y, wall_thickness), color)
    _make_structure(Vector3(center.x + side_offset, center.y, front_z), Vector3(side_width, building_size.y, wall_thickness), color)
    _make_structure(Vector3(center.x, center.y + building_size.y * 0.5, center.z), Vector3(building_size.x + 0.25, 0.30, building_size.z + 0.25), color.darkened(0.18))
    var door = AnimatableBody3D.new()
    door.position = Vector3(center.x, 1.15, front_z + 0.04)
    door.set_meta("surface_type", "metal")
    door.set_meta("lock_kind", lock_kind)
    door.set_meta("unlocked", lock_kind == "auto")
    door.set_meta("closed_y", 1.15)
    door.set_meta("open_y", 3.75)
    add_child(door)
    doors.append(door)
    var door_collision = CollisionShape3D.new()
    var door_shape = BoxShape3D.new()
    door_shape.size = Vector3(door_width, 2.3, 0.22)
    door_collision.shape = door_shape
    door.add_child(door_collision)
    var door_mesh = MeshInstance3D.new()
    var door_box = BoxMesh.new()
    door_box.size = Vector3(door_width, 2.3, 0.22)
    door_mesh.mesh = door_box
    var door_material = StandardMaterial3D.new()
    door_material.albedo_color = Color(0.13, 0.11, 0.08)
    door_material.metallic = 0.65
    door_material.roughness = 0.42
    door_mesh.material_override = door_material
    door.add_child(door_mesh)

    # Windows, stone bands and distinct roof silhouettes distinguish each building.
    var trim = color.lightened(0.20)
    _make_visual_detail(Vector3(center.x, 0.30, rear_z - 0.19), Vector3(building_size.x + 0.12, 0.55, 0.10), trim)
    for window_x in [-building_size.x * 0.28, building_size.x * 0.28]:
        _make_visual_detail(Vector3(center.x + window_x, center.y + 0.25, rear_z - 0.20), Vector3(1.25, 1.10, 0.08), Color(0.10, 0.24, 0.32))
        _make_visual_detail(Vector3(center.x + window_x, center.y + 0.25, front_z + 0.20), Vector3(1.05, 0.95, 0.08), Color(0.11, 0.25, 0.34))
    for band_y in [0.55, 1.35, 2.15, 2.95]:
        if band_y < building_size.y - 0.2:
            _make_visual_detail(Vector3(center.x - building_size.x * 0.5 - 0.20, band_y, center.z), Vector3(0.08, 0.10, building_size.z), trim.darkened(0.12))
    if int(abs(center.x + center.z)) % 2 == 0:
        _make_visual_detail(Vector3(center.x, center.y + building_size.y * 0.5 + 0.34, center.z), Vector3(building_size.x * 0.62, 0.38, building_size.z * 0.58), color.darkened(0.28))
    else:
        for roof_x in [-building_size.x * 0.38, building_size.x * 0.38]:
            _make_visual_detail(Vector3(center.x + roof_x, center.y + building_size.y * 0.5 + 0.38, center.z), Vector3(0.30, 0.75, building_size.z + 0.18), trim.darkened(0.25))
    var interior_light = OmniLight3D.new()
    interior_light.position = Vector3(center.x, building_size.y - 0.65, center.z)
    interior_light.light_color = Color(1.0, 0.88, 0.66)
    interior_light.light_energy = 2.4
    interior_light.omni_range = max(building_size.x, building_size.z) * 0.72
    interior_light.shadow_enabled = false
    add_child(interior_light)

    # Office furniture inside the accessible building: table, cabinet and chair.
    var wood = Color(0.25, 0.16, 0.09)
    var steel = Color(0.18, 0.20, 0.21)
    _make_structure(center + Vector3(-1.25, -1.20, -1.15), Vector3(2.15, 0.12, 0.85), wood)
    for leg_offset in [Vector3(-0.92, -1.55, -1.45), Vector3(0.92, -1.55, -1.45), Vector3(-0.92, -1.55, -0.85), Vector3(0.92, -1.55, -0.85)]:
        _make_structure(center + leg_offset, Vector3(0.10, 0.72, 0.10), steel)
    _make_structure(center + Vector3(1.75, -0.45, -2.15), Vector3(0.48, 2.25, 1.35), steel)
    _make_visual_detail(center + Vector3(1.48, -0.45, -2.15), Vector3(0.04, 1.95, 1.10), Color(0.10, 0.11, 0.12))
    _make_structure(center + Vector3(-1.10, -1.28, 1.55), Vector3(0.65, 0.12, 0.65), Color(0.22, 0.20, 0.17))
    _make_structure(center + Vector3(-1.10, -1.68, 1.82), Vector3(0.62, 0.78, 0.10), Color(0.20, 0.18, 0.15))

func _make_vehicle(pos: Vector3, color: Color, truck: bool):
    var vehicle = StaticBody3D.new()
    vehicle.position = pos
    vehicle.set_meta("surface_type", "metal")
    add_child(vehicle)
    var body_size = Vector3(3.8, 1.15, 1.75) if truck else Vector3(2.8, 0.85, 1.55)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = body_size
    collision.shape = shape
    vehicle.add_child(collision)
    _add_vehicle_box(vehicle, body_size, Vector3.ZERO, color)
    var cabin_size = Vector3(1.35, 0.85, 1.55) if truck else Vector3(1.45, 0.62, 1.42)
    _add_vehicle_box(vehicle, cabin_size, Vector3(-0.70, 0.82, 0), color.lightened(0.08))
    _add_vehicle_box(vehicle, Vector3(0.92, 0.44, 1.58), Vector3(-0.72, 0.86, 0), Color(0.05, 0.12, 0.15))
    _add_vehicle_box(vehicle, Vector3(0.18, 0.18, 1.88), Vector3(-body_size.x * 0.51, -0.28, 0), Color(0.12, 0.13, 0.13))
    _add_vehicle_box(vehicle, Vector3(0.18, 0.16, 1.88), Vector3(body_size.x * 0.51, -0.28, 0), Color(0.12, 0.13, 0.13))
    for lamp_z in [-0.56, 0.56]:
        _add_vehicle_box(vehicle, Vector3(0.06, 0.20, 0.30), Vector3(-body_size.x * 0.515, 0.10, lamp_z), Color(0.92, 0.82, 0.50))
        _add_vehicle_box(vehicle, Vector3(0.06, 0.18, 0.28), Vector3(body_size.x * 0.515, 0.06, lamp_z), Color(0.72, 0.04, 0.025))
    _add_vehicle_box(vehicle, Vector3(0.25, 0.14, 0.30), Vector3(-0.72, 1.22, -0.91), color.darkened(0.22))
    _add_vehicle_box(vehicle, Vector3(0.25, 0.14, 0.30), Vector3(-0.72, 1.22, 0.91), color.darkened(0.22))
    for wheel_x in [-1.0, 1.0]:
        for wheel_z in [-0.78, 0.78]:
            _add_vehicle_wheel(vehicle, Vector3(wheel_x * (1.45 if truck else 0.95), -0.48, wheel_z))

func _add_vehicle_box(parent: Node3D, box_size: Vector3, offset: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = box_size
    part.mesh = mesh
    part.position = offset
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.metallic = 0.35
    material.roughness = 0.58
    part.material_override = material
    parent.add_child(part)

func _add_vehicle_wheel(parent: Node3D, offset: Vector3):
    var wheel = MeshInstance3D.new()
    var tire = CylinderMesh.new()
    tire.top_radius = 0.34
    tire.bottom_radius = 0.34
    tire.height = 0.24
    wheel.mesh = tire
    wheel.position = offset
    wheel.rotation_degrees.x = 90
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.025, 0.025, 0.022)
    material.roughness = 0.90
    wheel.material_override = material
    parent.add_child(wheel)
    var hub = MeshInstance3D.new()
    var hub_mesh = CylinderMesh.new()
    hub_mesh.top_radius = 0.15
    hub_mesh.bottom_radius = 0.15
    hub_mesh.height = 0.255
    hub.mesh = hub_mesh
    hub.position = offset
    hub.rotation_degrees.x = 90
    var hub_material = StandardMaterial3D.new()
    hub_material.albedo_color = Color(0.40, 0.42, 0.43)
    hub_material.metallic = 0.80
    hub_material.roughness = 0.25
    hub.material_override = hub_material
    parent.add_child(hub)

func _make_column(pos: Vector3, height: float):
    _make_structure(pos, Vector3(0.55, height, 0.55), Color(0.42, 0.39, 0.33))
    _make_visual_detail(pos + Vector3(0, height * 0.5, 0), Vector3(0.82, 0.22, 0.82), Color(0.25, 0.24, 0.22))

func _make_visual_detail(pos: Vector3, detail_size: Vector3, color: Color):
    var detail = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = detail_size
    detail.mesh = mesh
    detail.position = pos
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.metallic = 0.25
    material.roughness = 0.55
    detail.material_override = material
    add_child(detail)

func _make_structure(pos: Vector3, structure_size: Vector3, color: Color):
    var body = StaticBody3D.new()
    body.position = pos
    body.set_meta("surface_type", "stone")
    add_child(body)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = structure_size
    collision.shape = shape
    body.add_child(collision)
    var mesh_node = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = structure_size
    mesh_node.mesh = mesh
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.88
    if structure_size.y > 1.2 and max(structure_size.x, structure_size.z) > 2.0:
        material.albedo_texture = load("res://textures/stone_wall.svg")
        material.uv1_scale = Vector3(max(structure_size.x * 0.45, 1.0), max(structure_size.y * 0.55, 1.0), max(structure_size.z * 0.45, 1.0))
    mesh_node.material_override = material
    body.add_child(mesh_node)

func _make_train_panel(pos: Vector3, dimensions: Vector3, color: Color):
    var body = StaticBody3D.new()
    body.position = pos
    body.set_meta("surface_type", "metal")
    add_child(body)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = dimensions
    collision.shape = shape
    body.add_child(collision)
    var panel = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = dimensions
    panel.mesh = mesh
    var paint = StandardMaterial3D.new()
    paint.albedo_color = color
    paint.metallic = 0.60
    paint.roughness = 0.52
    panel.material_override = paint
    body.add_child(panel)

func _make_pickup(pos: Vector3, kind: String):
    var pickup = Area3D.new()
    pickup.position = pos
    pickup.set_meta("pickup_kind", kind)
    add_child(pickup)
    pickups.append(pickup)
    _build_pickup_visual(pickup, kind)
    # Dropped equipment should match real handheld proportions instead of
    # looking like large scenery blocks.
    if kind == "health":
        pickup.scale = Vector3(0.29, 0.29, 0.29)
    elif kind in ["pistol", "rifle", "sniper", "shotgun", "grenade"]:
        pickup.scale = Vector3(0.23, 0.23, 0.23)
    if kind in ["pistol", "rifle", "sniper", "shotgun", "grenade", "ammo", "health"]:
        _add_pickup_marker(pickup)

func _add_pickup_marker(pickup: Node3D):
    var marker = MeshInstance3D.new()
    var triangle = CylinderMesh.new()
    triangle.top_radius = 0.0
    triangle.bottom_radius = 0.12
    triangle.height = 0.19
    triangle.radial_segments = 3
    marker.mesh = triangle
    marker.rotation_degrees.x = 180.0
    marker.scale = Vector3(1.0 / max(pickup.scale.x, 0.01), 1.0 / max(pickup.scale.y, 0.01), 1.0 / max(pickup.scale.z, 0.01))
    marker.position = Vector3(0, 1.35 / max(pickup.scale.y, 0.01), 0)
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.05, 0.45, 1.0, 0.92)
    material.emission_enabled = true
    material.emission = Color(0.02, 0.30, 1.0)
    material.emission_energy_multiplier = 2.4
    marker.material_override = material
    pickup.add_child(marker)
    pickup.set_meta("pickup_marker", marker)
    pickup.set_meta("marker_base_y", marker.position.y)
    pickup.set_meta("marker_phase", randf() * TAU)

func _build_pickup_visual(pickup: Area3D, kind: String):
    if kind == "health":
        _pickup_box(pickup, Vector3(0.92, 0.64, 0.34), Vector3.ZERO, Color(0.92, 0.92, 0.88))
        _pickup_box(pickup, Vector3(0.40, 0.12, 0.18), Vector3(0, 0.40, 0), Color(0.85, 0.85, 0.82))
        _pickup_box(pickup, Vector3(0.34, 0.12, 0.04), Vector3(0, 0.03, -0.19), Color(0.90, 0.02, 0.02), true)
        _pickup_box(pickup, Vector3(0.12, 0.34, 0.04), Vector3(0, 0.03, -0.19), Color(0.90, 0.02, 0.02), true)
    elif kind == "ammo":
        _pickup_box(pickup, Vector3(0.95, 0.58, 0.62), Vector3.ZERO, Color(0.16, 0.25, 0.12))
        _pickup_box(pickup, Vector3(1.00, 0.10, 0.66), Vector3(0, 0.18, 0), Color(0.72, 0.58, 0.12))
        _pickup_box(pickup, Vector3(1.00, 0.10, 0.66), Vector3(0, -0.18, 0), Color(0.72, 0.58, 0.12))
    elif kind == "pistol":
        _pickup_box(pickup, Vector3(0.22, 0.22, 0.82), Vector3(0, 0.10, 0), Color(0.07, 0.08, 0.09))
        _pickup_box(pickup, Vector3(0.20, 0.52, 0.22), Vector3(0, -0.23, 0.20), Color(0.10, 0.10, 0.11))
        _pickup_cylinder(pickup, 0.055, 0.72, Vector3(0, 0.10, -0.62), Color(0.04, 0.04, 0.045))
    elif kind == "sniper":
        _pickup_box(pickup, Vector3(0.18, 0.18, 1.85), Vector3.ZERO, Color(0.08, 0.10, 0.08))
        _pickup_box(pickup, Vector3(0.30, 0.22, 0.72), Vector3(0, 0, 0.38), Color(0.20, 0.15, 0.08))
        _pickup_box(pickup, Vector3(0.16, 0.16, 0.62), Vector3(0, 0.22, -0.15), Color(0.03, 0.04, 0.05))
        _pickup_cylinder(pickup, 0.055, 1.05, Vector3(0, 0, -1.18), Color(0.035, 0.04, 0.035))
    elif kind == "shotgun":
        _pickup_box(pickup, Vector3(0.22, 0.20, 1.55), Vector3.ZERO, Color(0.09, 0.09, 0.08))
        _pickup_box(pickup, Vector3(0.34, 0.28, 0.72), Vector3(0, -0.02, 0.48), Color(0.38, 0.16, 0.06))
        _pickup_cylinder(pickup, 0.07, 1.00, Vector3(-0.07, 0, -0.82), Color(0.035, 0.035, 0.032))
        _pickup_cylinder(pickup, 0.07, 1.00, Vector3(0.07, 0, -0.82), Color(0.035, 0.035, 0.032))
    elif kind == "grenade":
        _pickup_sphere(pickup, 0.34, Vector3.ZERO, Color(0.15, 0.23, 0.10))
        _pickup_box(pickup, Vector3(0.22, 0.16, 0.22), Vector3(0, 0.36, 0), Color(0.18, 0.18, 0.16))
    else:
        _pickup_box(pickup, Vector3(0.22, 0.24, 1.35), Vector3.ZERO, Color(0.06, 0.08, 0.07))
        _pickup_box(pickup, Vector3(0.20, 0.52, 0.22), Vector3(0, -0.28, 0.26), Color(0.12, 0.12, 0.11))
        _pickup_box(pickup, Vector3(0.32, 0.18, 0.55), Vector3(0, 0.02, 0.34), Color(0.18, 0.21, 0.16))
        _pickup_cylinder(pickup, 0.055, 0.82, Vector3(0, 0.02, -0.92), Color(0.03, 0.035, 0.03))

func _pickup_box(parent: Node3D, box_size: Vector3, box_position: Vector3, color: Color, glowing := false):
    var part = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = box_size
    part.mesh = box
    part.position = box_position
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.metallic = 0.35
    material.roughness = 0.48
    material.emission_enabled = glowing
    material.emission = color * 0.55
    part.material_override = material
    parent.add_child(part)

func _pickup_sphere(parent: Node3D, radius: float, sphere_position: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = radius
    sphere.height = radius * 2.0
    part.mesh = sphere
    part.position = sphere_position
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.metallic = 0.25
    material.roughness = 0.72
    part.material_override = material
    parent.add_child(part)

func _pickup_cylinder(parent: Node3D, radius: float, length: float, cylinder_position: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var cylinder = CylinderMesh.new()
    cylinder.top_radius = radius
    cylinder.bottom_radius = radius
    cylinder.height = length
    part.mesh = cylinder
    part.position = cylinder_position
    part.rotation_degrees.x = 90
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.metallic = 0.78
    material.roughness = 0.28
    part.material_override = material
    parent.add_child(part)

func _spawn_mission_objectives():
    has_key = false
    has_gate_key = false
    has_building1_key = false
    has_building2_key = false
    gate_unlocked = false
    building1_unlocked = false
    building2_unlocked = false
    computer_accessed = false
    heavy_weapon_destroyed = false
    ammo_box_collected = false
    health_box_collected = false
    enemy_weapon_captured = false
    alarm_disabled = false
    explosives_collected = false
    documents_collected = false
    missile_depots_destroyed = 0
    data_downloaded = false
    extraction_reached = false
    reinforcements_spawned = false
    data_download_in_progress = false
    port_surveillance_disabled = false
    port_targets_destroyed = 0
    secret_briefcase_collected = false
    airbase_charges_planted = 0
    facility_charges_planted = 0
    facility_commander_defeated = false
    facility_escape_active = false
    facility_escape_time = 0.0
    train_lights_disabled = false
    train_prisoner_rescued = false
    train_charge_planted = false
    train_commander_defeated = false
    train_escape_active = false
    train_escape_time = 0.0
    canyon_relays_disabled = 0
    canyon_intel_collected = false
    bridge_weapons_taken = false
    bridge_controls_taken = false
    bridge_explosives_taken = false
    bridge_charges_planted = 0
    bridge_escape_active = false
    bridge_escape_time = 0.0
    convoy_checkpoints = 0
    convoy_intel_taken = false
    convoy_tower_occupied = false
    convoy_ambush_started = false
    convoy_stopped = false
    convoy_documents_taken = false
    convoy_reinforcements_spawned = false
    convoy_escape_time = 0.0
    final_generators_disabled = 0
    final_allies_freed = false
    final_radio_disabled = false
    final_boss_defeated = false
    final_data_taken = false
    final_charges_planted = 0
    final_escape_active = false
    final_escape_time = 0.0
    final_reinforcements_spawned = false
    for node in objective_nodes.duplicate():
        if is_instance_valid(node):
            node.queue_free()
    objective_nodes.clear()
    if mission_number == 10:
        # Control panels sit outside the solid generator bodies so the player
        # can always reach the hand-interaction radius.
        for generator_position in [Vector3(-24, 1.05, 127.2), Vector3(24, 1.05, 80.2), Vector3(-24, 1.05, 32.2)]:
            _make_objective(generator_position, "final_generator")
        _make_objective(Vector3(-25, 0.8, -25), "final_allies")
        _make_objective(Vector3(25, 0.8, -27), "final_radio")
        _make_objective(Vector3(0, 0.6, -77), "final_data")
        for charge_position in [Vector3(-9, 0.6, -69), Vector3(9, 0.6, -70), Vector3(0, 0.6, -88)]:
            _make_objective(charge_position, "final_charge")
        _make_objective(Vector3(0, 0.25, -132), "final_extraction")
    elif mission_number == 9:
        for checkpoint_data in [[Vector3(-17, 0.72, 143), 0], [Vector3(17, 0.72, 93), 1], [Vector3(-17, 0.72, 43), 2]]:
            _make_objective(checkpoint_data[0], "convoy_checkpoint")
            var checkpoint = objective_nodes[objective_nodes.size() - 1]
            checkpoint.set_meta("checkpoint_index", checkpoint_data[1])
        _make_objective(Vector3(-17, 0.70, 15), "convoy_intel")
        _make_objective(Vector3(-21, 0.25, -137), "convoy_extraction")
    elif mission_number == 8:
        _make_objective(Vector3(-19, 0.55, 81), "bridge_weapons")
        _make_objective(Vector3(-11, 0.72, 81), "bridge_controls")
        _make_objective(Vector3(-3, 0.55, 81), "bridge_explosives")
        for charge_z in [30.0, -8.0, -46.0]:
            _make_objective(Vector3(0, 0.8, charge_z), "bridge_charge")
        _make_objective(Vector3(-20, 0.25, -130), "bridge_extraction")
    elif mission_number == 7:
        _make_objective(Vector3(-20, 0.72, 81), "canyon_relay")
        _make_objective(Vector3(20, 0.72, 12), "canyon_relay")
        _make_objective(Vector3(-16, 0.82, -64), "canyon_intel")
        _make_objective(Vector3(3, 0.25, -121), "canyon_extraction")
    elif mission_number == 6:
        _make_objective(Vector3(-10, 0.72, 126), "train_power")
        _make_objective(Vector3(-24, 0.40, 78), "train_explosives")
        _make_objective(Vector3(-16, 0.95, -41), "train_prisoner")
        _make_objective(Vector3(0, 0.80, -93), "train_charge_target")
        _make_objective(Vector3(18, 0.25, -132), "train_extraction")
    elif mission_number == 5:
        _make_objective(Vector3(-11, 0.72, 74), "facility_power")
        _make_objective(Vector3(11, 0.40, 19), "facility_code")
        _make_objective(Vector3(-11, 0.82, -34), "facility_terminal")
        _make_objective(Vector3(10, 0.40, -83), "facility_explosives")
        _make_objective(Vector3(-18, 0.80, -56), "facility_charge_target")
        _make_objective(Vector3(18, 0.80, -108), "facility_charge_target")
        _make_objective(Vector3(0, 0.25, -128), "facility_extraction")
    elif mission_number == 4:
        _make_objective(Vector3(-4, 0.72, 124), "airbase_security")
        _make_objective(Vector3(-37, 0.35, 63), "airbase_explosives")
        _make_objective(Vector3(-40, 0.82, -25), "airbase_terminal")
        _make_objective(Vector3(48, 0.80, -45), "airbase_charge_target")
        _make_objective(Vector3(50, 0.80, 5), "airbase_charge_target")
        _make_objective(Vector3(14, 0.80, -76), "airbase_charge_target")
        _make_objective(Vector3(-10, 0.25, -123), "airbase_extraction")
    elif mission_number == 3:
        _make_objective(Vector3(-5, 0.72, 116), "security_console")
        _make_objective(Vector3(-29, 0.35, 66), "shipping_manifest")
        _make_objective(Vector3(-23, 0.35, 60), "port_explosives")
        _make_objective(Vector3(28, 0.82, 17), "port_terminal")
        # All three sabotage targets now sit on the connected service route so
        # every blue marker can be reached without walking over water.
        _make_objective(Vector3(-12, 0.85, -47), "ammo_depot")
        _make_objective(Vector3(12, 0.85, -70), "fuel_tank")
        _make_objective(Vector3(12, 0.85, 84), "patrol_boat")
        _make_objective(Vector3(-12, 0.72, -94), "secret_briefcase")
        _make_objective(Vector3(12, 0.25, -125), "boat_extraction")
    elif mission_number == 2:
        # The officer's card opens barracks one; its password opens command.
        _make_objective(Vector3(-30, 0.80, 24), "alarm_panel")
        _make_objective(Vector3(-24, 0.35, 22), "documents")
        _make_objective(Vector3(24, 0.35, 38), "explosives")
        _make_objective(Vector3(-18, 0.70, -50), "missile_depot")
        _make_objective(Vector3(30, 0.70, -58), "missile_depot")
        _make_objective(Vector3(7, 0.82, -48), "data_terminal")
        _make_objective(Vector3(0, 0.25, 136), "extraction")
    else:
        # The gate key is dropped dynamically by the first gate guard.
        _make_objective(Vector3(-8, 0.28, 30), "building1_key")
        _make_objective(Vector3(-24, 0.28, -16), "building2_key")
        _make_objective(Vector3(24, 0.82, -33), "computer")

func _make_objective(pos: Vector3, kind: String):
    var objective = StaticBody3D.new()
    objective.position = pos
    objective.set_meta("objective_kind", kind)
    objective.set_meta("health", 5)
    add_child(objective)
    objective_nodes.append(objective)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    var is_access_card = kind == "access_card"
    var is_key_object = kind.ends_with("_key") or kind == "key"
    if is_key_object:
        objective.scale = Vector3(0.50, 0.50, 0.50)
        objective.position.y = 0.14
    elif is_access_card:
        objective.scale = Vector3(0.55, 0.55, 0.55)
        objective.position.y = 0.16
    elif kind == "computer":
        objective.scale = Vector3(0.20, 0.20, 0.20)
        objective.position.y = 0.18
    elif kind in ["data_terminal", "port_terminal", "airbase_terminal", "facility_terminal", "canyon_intel", "convoy_intel", "final_radio"]:
        objective.scale = Vector3(0.36, 0.36, 0.36)
        objective.position.y = 0.30
    shape.size = Vector3(0.72, 0.30, 0.48) if is_access_card else (Vector3(0.50, 0.30, 0.50) if is_key_object else (Vector3(1.65, 1.55, 0.90) if kind in ["computer", "data_terminal", "airbase_terminal", "facility_terminal", "canyon_intel", "convoy_intel", "final_radio"] else Vector3(1.7, 1.1, 2.2)))
    collision.shape = shape
    objective.add_child(collision)
    var mesh_node = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(0.08, 0.08, 0.44) if is_key_object else (Vector3(1.45, 0.82, 0.68) if kind in ["computer", "data_terminal", "airbase_terminal", "facility_terminal", "canyon_intel", "convoy_intel", "final_radio"] else Vector3(1.7, 1.1, 2.2))
    mesh_node.mesh = mesh
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.95, 0.75, 0.08) if is_key_object else (Color(0.08, 0.35, 0.55) if kind in ["computer", "data_terminal", "alarm_panel"] else (Color(0.78, 0.16, 0.05) if kind == "explosives" else (Color(0.12, 0.75, 0.28) if kind == "extraction" else Color(0.20, 0.22, 0.18))))
    material.emission_enabled = kind not in ["heavy", "missile_depot"]
    material.emission = material.albedo_color * 0.4
    mesh_node.material_override = material
    objective.add_child(mesh_node)
    # Detailed objectives keep only an invisible collision box; the old visible
    # rectangular placeholder is removed.
    mesh_node.visible = kind not in ["access_card", "computer", "data_terminal", "port_terminal", "airbase_terminal", "facility_terminal", "alarm_panel", "security_console", "airbase_security", "facility_power", "train_power", "explosives", "port_explosives", "airbase_explosives", "facility_explosives", "train_explosives", "airbase_charge_target", "facility_charge_target", "train_charge_target", "documents", "shipping_manifest", "facility_code", "secret_briefcase", "train_prisoner", "extraction", "boat_extraction", "airbase_extraction", "facility_extraction", "train_extraction", "missile_depot", "ammo_depot", "fuel_tank", "patrol_boat", "canyon_relay", "canyon_intel", "canyon_extraction", "bridge_weapons", "bridge_controls", "bridge_explosives", "bridge_charge", "bridge_extraction", "convoy_checkpoint", "convoy_intel", "convoy_documents", "convoy_extraction", "final_generator", "final_allies", "final_radio", "final_data", "final_charge", "final_extraction"]
    if is_access_card:
        _add_objective_part(objective, Vector3(0.88, 0.08, 0.54), Vector3.ZERO, Color(0.06, 0.22, 0.34), false)
        _add_objective_part(objective, Vector3(0.24, 0.025, 0.22), Vector3(-0.22, 0.055, -0.06), Color(0.92, 0.68, 0.12), true)
        _add_objective_part(objective, Vector3(0.70, 0.025, 0.09), Vector3(0, 0.055, 0.17), Color(0.025, 0.03, 0.035), false)
        _add_objective_part(objective, Vector3(0.08, 0.025, 0.08), Vector3(0.32, 0.055, -0.17), Color(0.10, 0.95, 0.28), true)
    elif is_key_object:
        # Small metal key: circular bow, narrow shaft and two teeth.
        var ring = MeshInstance3D.new()
        var torus = TorusMesh.new()
        torus.inner_radius = 0.095
        torus.outer_radius = 0.155
        ring.mesh = torus
        ring.position = Vector3(0, 0, 0.25)
        ring.rotation_degrees.x = 90
        ring.material_override = material
        objective.add_child(ring)
        _add_objective_part(objective, Vector3(0.13, 0.07, 0.13), Vector3(0.10, -0.03, -0.18), Color(0.95, 0.78, 0.12), true)
        _add_objective_part(objective, Vector3(0.13, 0.07, 0.10), Vector3(-0.07, -0.03, -0.13), Color(0.95, 0.78, 0.12), true)
    elif kind in ["computer", "data_terminal", "port_terminal", "airbase_terminal", "facility_terminal", "canyon_intel", "convoy_intel", "final_radio"]:
        # Desktop terminal with framed screen, stand, keyboard and side tower.
        _add_objective_part(objective, Vector3(1.12, 0.62, 0.055), Vector3(-0.15, 0.18, -0.375), Color(0.02, 0.55, 0.72), true)
        _add_objective_part(objective, Vector3(0.16, 0.40, 0.12), Vector3(-0.15, -0.42, -0.10), Color(0.09, 0.10, 0.11), false)
        _add_objective_part(objective, Vector3(0.64, 0.08, 0.38), Vector3(-0.15, -0.62, -0.25), Color(0.12, 0.13, 0.14), false)
        _add_objective_part(objective, Vector3(1.05, 0.09, 0.36), Vector3(-0.08, -0.56, -0.65), Color(0.14, 0.15, 0.16), false)
        _add_objective_part(objective, Vector3(0.42, 1.10, 0.62), Vector3(0.92, -0.05, 0.02), Color(0.07, 0.08, 0.09), false)
        _add_objective_part(objective, Vector3(0.08, 0.08, 0.04), Vector3(0.92, 0.20, -0.32), Color(0.10, 0.95, 0.22), true)
        for row in range(3):
            for column in range(6):
                _add_objective_part(objective, Vector3(0.12, 0.025, 0.055), Vector3(-0.43 + column * 0.17, -0.50, -0.73 + row * 0.075), Color(0.32, 0.35, 0.36), false)
        for vent in range(4):
            _add_objective_part(objective, Vector3(0.25, 0.025, 0.025), Vector3(0.92, 0.18 - vent * 0.12, -0.325), Color(0.42, 0.46, 0.48), false)
    elif kind in ["explosives", "port_explosives", "airbase_explosives", "facility_explosives", "train_explosives", "bridge_weapons", "bridge_explosives"]:
        _add_objective_part(objective, Vector3(1.35, 0.48, 1.15), Vector3(0, 0.08, 0), Color(0.16, 0.20, 0.12), false)
        for charge in range(3):
            _pickup_cylinder(objective, 0.16, 1.08, Vector3(-0.38 + charge * 0.38, 0.39, 0), Color(0.68, 0.10, 0.045))
        _add_objective_part(objective, Vector3(0.22, 0.16, 0.32), Vector3(0, 0.64, 0.05), Color(0.06, 0.07, 0.065), false)
        _add_objective_part(objective, Vector3(0.12, 0.025, 0.15), Vector3(0, 0.735, -0.12), Color(0.15, 0.95, 0.25), true)
        _add_objective_part(objective, Vector3(0.10, 0.07, 1.30), Vector3(-0.52, 0.40, 0), Color(0.92, 0.72, 0.08), false)
        _add_objective_part(objective, Vector3(0.10, 0.07, 1.30), Vector3(0.52, 0.40, 0), Color(0.92, 0.72, 0.08), false)
    elif kind in ["documents", "shipping_manifest", "facility_code", "convoy_documents", "final_data"]:
        _add_objective_part(objective, Vector3(1.30, 0.09, 1.62), Vector3(0, 0.18, 0), Color(0.34, 0.19, 0.07), false)
        for page in range(4):
            _add_objective_part(objective, Vector3(1.08, 0.025, 1.42), Vector3(0.04 - page * 0.018, 0.25 + page * 0.028, -0.03 + page * 0.015), Color(0.90, 0.86, 0.68), false)
        for line in range(5):
            _add_objective_part(objective, Vector3(0.66, 0.012, 0.025), Vector3(0, 0.385, -0.39 + line * 0.17), Color(0.16, 0.17, 0.16), false)
        _add_objective_disc(objective, 0.14, 0.035, Vector3(0.34, 0.405, 0.42), Color(0.70, 0.03, 0.02), true)
    elif kind in ["alarm_panel", "security_console", "airbase_security", "facility_power", "train_power", "canyon_relay", "bridge_controls", "convoy_checkpoint", "final_generator"]:
        _add_objective_part(objective, Vector3(1.15, 1.28, 0.24), Vector3(0, 0.16, 0), Color(0.08, 0.11, 0.12), false)
        _add_objective_part(objective, Vector3(0.82, 0.42, 0.035), Vector3(0, 0.42, -0.14), Color(0.02, 0.66, 0.78), true)
        for row in range(3):
            for column in range(3):
                _add_objective_part(objective, Vector3(0.12, 0.12, 0.035), Vector3(-0.18 + column * 0.18, 0.04 - row * 0.16, -0.14), Color(0.38, 0.42, 0.42), false)
        _add_objective_disc(objective, 0.11, 0.055, Vector3(0.40, -0.28, -0.16), Color(0.95, 0.05, 0.02), true)
    elif kind in ["extraction", "boat_extraction", "airbase_extraction", "facility_extraction", "train_extraction", "canyon_extraction", "bridge_extraction", "convoy_extraction", "final_extraction"]:
        _add_objective_disc(objective, 2.10, 0.08, Vector3(0, -0.49, 0), Color(0.05, 0.52, 0.18), false)
        _add_objective_disc(objective, 1.58, 0.025, Vector3(0, -0.43, 0), Color(0.08, 0.95, 0.30), true)
        _add_objective_part(objective, Vector3(1.85, 0.035, 0.22), Vector3(0, -0.40, 0), Color(0.88, 1.0, 0.90), true)
        _add_objective_part(objective, Vector3(0.22, 0.035, 1.85), Vector3(0, -0.39, 0), Color(0.88, 1.0, 0.90), true)
    elif kind in ["airbase_charge_target", "facility_charge_target", "train_charge_target", "bridge_charge", "final_charge"]:
        _add_objective_part(objective, Vector3(0.72, 0.20, 0.48), Vector3(0, 0.05, 0), Color(0.12, 0.14, 0.13), false)
        _pickup_cylinder(objective, 0.10, 0.58, Vector3(-0.16, 0.25, 0), Color(0.72, 0.08, 0.035))
        _pickup_cylinder(objective, 0.10, 0.58, Vector3(0.16, 0.25, 0), Color(0.72, 0.08, 0.035))
        _add_objective_part(objective, Vector3(0.16, 0.10, 0.12), Vector3(0, 0.48, 0), Color(0.12, 0.92, 0.20), true)
    elif kind in ["train_prisoner", "final_allies"]:
        objective.set_meta("civilian", true)
        var civilian_model = _create_civilian_model(objective)
        if civilian_model != null:
            objective.set_meta("civilian_model", civilian_model)
        var civilian_sign = Label3D.new()
        civilian_sign.text = "أسير - لا تطلق النار"
        civilian_sign.position = Vector3(0, 1.42, 0)
        civilian_sign.font_size = 44
        civilian_sign.pixel_size = 0.005
        civilian_sign.billboard = BaseMaterial3D.BILLBOARD_ENABLED
        civilian_sign.modulate = Color(1.0, 0.90, 0.32)
        objective.add_child(civilian_sign)
        if civilian_model == null:
            _add_objective_part(objective, Vector3(0.70, 0.78, 0.35), Vector3(0, 0.05, 0), Color(0.92, 0.72, 0.16), false)
            _add_objective_disc(objective, 0.27, 0.42, Vector3(0, 0.75, 0), Color(0.68, 0.48, 0.36), false)
    elif kind == "missile_depot":
        _add_objective_part(objective, Vector3(2.8, 0.35, 3.2), Vector3(0, -0.42, 0), Color(0.12, 0.14, 0.13), false)
        for missile in range(3):
            var missile_x = -0.72 + missile * 0.72
            _pickup_cylinder(objective, 0.20, 3.15, Vector3(missile_x, 0.42, -0.12), Color(0.34, 0.39, 0.31))
            _add_objective_part(objective, Vector3(0.50, 0.12, 0.42), Vector3(missile_x, 0.42, -1.68), Color(0.68, 0.07, 0.035), true)
            _add_objective_part(objective, Vector3(0.64, 0.06, 0.34), Vector3(missile_x, 0.42, 1.48), Color(0.22, 0.24, 0.20), false)
        _add_objective_part(objective, Vector3(0.20, 1.05, 2.75), Vector3(-1.12, 0.02, 0), Color(0.18, 0.20, 0.17), false)
        _add_objective_part(objective, Vector3(0.20, 1.05, 2.75), Vector3(1.12, 0.02, 0), Color(0.18, 0.20, 0.17), false)
    elif kind == "secret_briefcase":
        _add_objective_part(objective, Vector3(1.45, 0.28, 1.05), Vector3(0, 0.12, 0), Color(0.07, 0.08, 0.075), false)
        _add_objective_part(objective, Vector3(0.62, 0.12, 0.16), Vector3(0, 0.48, 0), Color(0.10, 0.11, 0.10), false)
        _add_objective_part(objective, Vector3(0.08, 0.26, 0.08), Vector3(-0.29, 0.38, 0), Color(0.18, 0.19, 0.18), false)
        _add_objective_part(objective, Vector3(0.08, 0.26, 0.08), Vector3(0.29, 0.38, 0), Color(0.18, 0.19, 0.18), false)
        _add_objective_part(objective, Vector3(0.18, 0.07, 0.12), Vector3(0, 0.29, -0.56), Color(0.91, 0.70, 0.10), true)
    elif kind == "fuel_tank":
        _pickup_cylinder(objective, 1.12, 2.65, Vector3(0, 0.45, 0), Color(0.66, 0.16, 0.06))
        _add_objective_part(objective, Vector3(2.55, 0.12, 0.16), Vector3(0, 0.48, 0), Color(0.90, 0.78, 0.10), false)
        _add_objective_part(objective, Vector3(2.55, 0.12, 0.16), Vector3(0, -0.05, 0), Color(0.90, 0.78, 0.10), false)
        _add_objective_part(objective, Vector3(0.18, 0.65, 0.18), Vector3(-0.72, -0.54, 0), Color(0.12, 0.13, 0.13), false)
        _add_objective_part(objective, Vector3(0.18, 0.65, 0.18), Vector3(0.72, -0.54, 0), Color(0.12, 0.13, 0.13), false)
    elif kind == "ammo_depot":
        _add_objective_part(objective, Vector3(2.6, 1.05, 2.2), Vector3(0, 0.05, 0), Color(0.22, 0.27, 0.16), false)
        for slat in range(5):
            _add_objective_part(objective, Vector3(2.35, 0.09, 0.10), Vector3(0, -0.32 + slat * 0.20, -1.14), Color(0.38, 0.29, 0.15), false)
        _add_objective_disc(objective, 0.24, 0.05, Vector3(0, 0.18, -1.18), Color(0.90, 0.66, 0.06), true)
    elif kind == "patrol_boat":
        _add_objective_part(objective, Vector3(2.8, 0.50, 4.2), Vector3(0, -0.24, 0), Color(0.08, 0.19, 0.27), false)
        _add_objective_part(objective, Vector3(2.0, 1.05, 1.55), Vector3(0, 0.48, 0.35), Color(0.68, 0.71, 0.69), false)
        _add_objective_part(objective, Vector3(1.35, 0.42, 0.06), Vector3(0, 0.64, -0.46), Color(0.03, 0.18, 0.25), false)
        _add_objective_part(objective, Vector3(0.15, 1.65, 0.15), Vector3(0, 1.30, 0.45), Color(0.12, 0.13, 0.13), false)
    else:
        _add_objective_part(objective, Vector3(0.28, 0.28, 2.4), Vector3(0, 0.38, -1.45), Color(0.06, 0.07, 0.06), false)
        _add_objective_part(objective, Vector3(2.2, 0.22, 0.35), Vector3(0, -0.42, 0), Color(0.11, 0.12, 0.10), false)
    # Every collectible, terminal, extraction point and destructible objective
    # receives the same compact blue marker so no mission target is ambiguous.
    _add_pickup_marker(objective)

func _add_objective_part(parent: Node3D, part_size: Vector3, part_position: Vector3, color: Color, glowing: bool):
    var part = MeshInstance3D.new()
    var part_mesh = BoxMesh.new()
    part_mesh.size = part_size
    part.mesh = part_mesh
    part.position = part_position
    var part_material = StandardMaterial3D.new()
    part_material.albedo_color = color
    part_material.metallic = 0.55
    part_material.roughness = 0.38
    part_material.emission_enabled = glowing
    part_material.emission = color * 0.45
    part.material_override = part_material
    parent.add_child(part)

func _add_objective_disc(parent: Node3D, radius: float, height: float, part_position: Vector3, color: Color, glowing: bool):
    var part = MeshInstance3D.new()
    var disc = CylinderMesh.new()
    disc.top_radius = radius
    disc.bottom_radius = radius
    disc.height = height
    part.mesh = disc
    part.position = part_position
    var part_material = StandardMaterial3D.new()
    part_material.albedo_color = color
    part_material.metallic = 0.48
    part_material.roughness = 0.34
    part_material.emission_enabled = glowing
    part_material.emission = color * 0.55
    part.material_override = part_material
    parent.add_child(part)

func _make_target(pos: Vector3):
    var body = StaticBody3D.new()
    body.name = "Target"
    body.position = pos
    # Keep targets hittable by raycasts while allowing the enemy to pass them.
    body.collision_layer = 2
    body.collision_mask = 0
    body.set_meta("target", true)
    add_child(body)

    var shape_node = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(1.5, 1.5, 1.5)
    shape_node.shape = shape
    body.add_child(shape_node)

    var mesh_node = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(1.5, 1.5, 1.5)
    mesh_node.mesh = mesh
    body.add_child(mesh_node)

func _create_civilian_model(parent: Node3D):
    var scene = load(COMPLETE_ANIMATED_SOLDIER_PATH) as PackedScene
    if scene == null:
        return null
    var soldier = scene.instantiate() as Node3D
    soldier.name = "CivilianEscort"
    soldier.scale = Vector3.ONE * 0.75
    soldier.rotation_degrees.y = 180.0
    parent.add_child(soldier)
    # The body, face, hands and feet share one skinned mesh and one texture.
    # Mask the garment regions in the mesh's rest coordinates; retain the
    # original skin texture on the face, palms and feet.
    var garment_shader = Shader.new()
    garment_shader.code = """shader_type spatial;
uniform sampler2D original_albedo : source_color;
varying float uncovered;
void vertex() {
    float face = smoothstep(1.42, 1.58, VERTEX.y) * (1.0 - smoothstep(0.30, 0.55, abs(VERTEX.x)));
    float palms = smoothstep(0.55, 0.72, abs(VERTEX.x)) * smoothstep(0.51, 0.68, VERTEX.y) * (1.0 - smoothstep(1.16, 1.38, VERTEX.y));
    float feet = 1.0 - smoothstep(0.12, 0.24, VERTEX.y);
    uncovered = clamp(max(face, max(palms, feet)), 0.0, 1.0);
}
void fragment() {
    vec3 original_skin = texture(original_albedo, UV).rgb;
    ALBEDO = mix(vec3(0.032, 0.035, 0.040), original_skin, uncovered);
    ROUGHNESS = 0.88;
}"""
    for child in soldier.find_children("*", "MeshInstance3D", true, false):
        var part = child as MeshInstance3D
        var part_name = String(part.name).to_lower()
        if "rifle" in part_name or "pistol" in part_name or "weapon" in part_name:
            part.visible = false
        elif "superhero" in part_name or "sphere.005" in part_name:
            var original_material = part.mesh.surface_get_material(0) as BaseMaterial3D
            if original_material != null and original_material.albedo_texture != null:
                var black_clothing = ShaderMaterial.new()
                black_clothing.shader = garment_shader
                black_clothing.set_shader_parameter("original_albedo", original_material.albedo_texture)
                part.material_override = black_clothing
    var players = soldier.find_children("*", "AnimationPlayer", true, false)
    if not players.is_empty():
        var animator = players[0] as AnimationPlayer
        _install_swat_animation_set(animator)
        animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
        animator.active = true
        if animator.has_animation("swat/SWAT_Walk"):
            animator.play("swat/SWAT_Walk")
            animator.advance(0.24)
            animator.speed_scale = 0.0
        soldier.set_meta("civilian_animator", animator)
    return soldier

func _make_enemy(pos: Vector3, forced_weapon := "") -> CharacterBody3D:
    var new_enemy = CharacterBody3D.new()
    new_enemy.name = "EnemySoldier"
    new_enemy.position = Vector3(pos.x, pos.y if pos.y > 1.2 else 0.58, pos.z)
    new_enemy.scale = Vector3(0.75, 0.75, 0.75)
    new_enemy.rotation.y = fmod(abs(pos.x * 0.37 + pos.z * 0.21), TAU)
    new_enemy.set_meta("enemy", true)
    new_enemy.set_meta("health", 3)
    new_enemy.set_meta("attack_cooldown", 0.0)
    new_enemy.set_meta("alert_time", 0.0)
    new_enemy.set_meta("last_known_position", pos)
    new_enemy.set_meta("search_angle", fmod(abs(pos.x + pos.z), TAU))
    new_enemy.set_meta("cover_target", pos)
    new_enemy.set_meta("cover_time", 0.0)
    new_enemy.set_meta("magazine_rounds", 5)
    new_enemy.set_meta("reload_time", 0.0)
    new_enemy.set_meta("maneuver_cooldown", 2.0 + randf() * 3.0)
    new_enemy.set_meta("roll_time", 0.0)
    new_enemy.set_meta("reaction_time", 0.0)
    new_enemy.set_meta("was_alerted", false)
    new_enemy.set_meta("search_pause", 0.0)
    new_enemy.set_meta("patrol_origin", pos)
    new_enemy.set_meta("patrol_radius", 0.0)
    new_enemy.set_meta("patrol_phase", fmod(abs(pos.x * 0.19 + pos.z * 0.13), TAU))
    new_enemy.set_meta("under_fire_time", 0.0)
    new_enemy.set_meta("incoming_fire_origin", pos)
    new_enemy.set_meta("tactical_state", "patrol")
    var enemy_weapon = forced_weapon if forced_weapon != "" else ("sniper" if pos.x < -6.0 else ("pistol" if pos.x > 6.0 else "rifle"))
    new_enemy.set_meta("weapon_kind", enemy_weapon)
    new_enemy.set_meta("weapon_damage", 9 if enemy_weapon == "sniper" else (5 if enemy_weapon == "pistol" else 6))
    add_child(new_enemy)
    enemies.append(new_enemy)

    var enemy_collision = CollisionShape3D.new()
    var enemy_shape = CapsuleShape3D.new()
    enemy_shape.radius = 0.48
    enemy_shape.height = 1.9
    enemy_collision.shape = enemy_shape
    new_enemy.add_child(enemy_collision)

    var body_mesh = MeshInstance3D.new()
    var body_box = BoxMesh.new()
    body_box.size = Vector3(0.9, 1.25, 0.48)
    body_mesh.mesh = body_box
    body_mesh.position = Vector3(0, 0.05, 0)
    var uniform = StandardMaterial3D.new()
    uniform.albedo_color = Color(0.16, 0.22, 0.12)
    uniform.albedo_texture = load("res://textures/uniform_fabric.svg")
    uniform.roughness = 0.85
    body_mesh.material_override = uniform
    new_enemy.add_child(body_mesh)
    new_enemy.set_meta("body_visual", body_mesh)

    var head_mesh = MeshInstance3D.new()
    var head = SphereMesh.new()
    head.radius = 0.28
    head.height = 0.56
    head_mesh.mesh = head
    head_mesh.position = Vector3(0, 0.92, 0)
    var skin = StandardMaterial3D.new()
    skin.albedo_color = Color(0.48, 0.34, 0.24)
    head_mesh.material_override = skin
    new_enemy.add_child(head_mesh)

    var eye_color = Color(0.025, 0.02, 0.018)
    for eye_x in [-0.105, 0.105]:
        _add_enemy_sphere(new_enemy, 0.038, Vector3(eye_x, 0.98, -0.255), Vector3(1.0, 0.72, 0.45), eye_color)
    _add_enemy_box(new_enemy, Vector3(0.07, 0.12, 0.08), Vector3(0, 0.89, -0.275), skin)
    var boot_material = StandardMaterial3D.new()
    boot_material.albedo_color = Color(0.045, 0.04, 0.035)
    boot_material.roughness = 0.78
    _add_enemy_box(new_enemy, Vector3(0.25, 0.16, 0.38), Vector3(-0.22, -1.23, -0.08), boot_material)
    _add_enemy_box(new_enemy, Vector3(0.25, 0.16, 0.38), Vector3(0.22, -1.23, -0.08), boot_material)

    _add_enemy_sphere(new_enemy, 0.31, Vector3(0, 1.07, 0), Vector3(1.05, 0.58, 1.08), Color(0.10, 0.16, 0.08))
    var vest_material = StandardMaterial3D.new()
    vest_material.albedo_color = Color(0.10, 0.15, 0.08)
    vest_material.roughness = 0.92
    _add_enemy_box(new_enemy, Vector3(0.78, 0.72, 0.16), Vector3(0, 0.14, -0.30), vest_material)
    _add_enemy_box(new_enemy, Vector3(0.86, 0.12, 0.52), Vector3(0, -0.42, 0), vest_material)
    var badge_material = StandardMaterial3D.new()
    badge_material.albedo_color = Color(0.68, 0.55, 0.12)
    badge_material.metallic = 0.45
    _add_enemy_box(new_enemy, Vector3(0.13, 0.14, 0.035), Vector3(-0.23, 0.29, -0.405), badge_material)
    _add_enemy_box(new_enemy, Vector3(0.23, 0.18, 0.18), Vector3(-0.25, -0.34, -0.34), vest_material)
    _add_enemy_box(new_enemy, Vector3(0.23, 0.18, 0.18), Vector3(0.25, -0.34, -0.34), vest_material)

    _add_enemy_box(new_enemy, Vector3(0.18, 0.72, 0.18), Vector3(-0.34, 0.02, 0), uniform)
    _add_enemy_box(new_enemy, Vector3(0.18, 0.72, 0.18), Vector3(0.34, 0.02, 0), uniform)
    var left_leg = _add_enemy_box(new_enemy, Vector3(0.22, 0.68, 0.22), Vector3(-0.22, -0.87, 0), uniform)
    var right_leg = _add_enemy_box(new_enemy, Vector3(0.22, 0.68, 0.22), Vector3(0.22, -0.87, 0), uniform)
    new_enemy.set_meta("left_leg", left_leg)
    new_enemy.set_meta("right_leg", right_leg)
    new_enemy.set_meta("walk_phase", fmod(abs(pos.x * 0.61 + pos.z * 0.33), TAU))
    var rifle_material = StandardMaterial3D.new()
    rifle_material.albedo_color = Color(0.075, 0.085, 0.095)
    rifle_material.metallic = 0.58
    rifle_material.roughness = 0.32
    var enemy_gun_length = 1.20 if enemy_weapon == "sniper" else (0.48 if enemy_weapon == "pistol" else 0.85)
    var weapon_y = 0.39
    var weapon_x = 0.02
    var body_width = 0.085 if enemy_weapon == "pistol" else 0.105
    var body_height = 0.10 if enemy_weapon == "pistol" else 0.115
    var enemy_gun_visual = _add_enemy_box(new_enemy, Vector3(body_width, body_height, enemy_gun_length), Vector3(weapon_x, weapon_y, -enemy_gun_length * 0.44), rifle_material)
    new_enemy.set_meta("gun_visual", enemy_gun_visual)
    var stock_size = Vector3(0.11, 0.12, 0.22) if enemy_weapon != "pistol" else Vector3(0.095, 0.12, 0.14)
    var enemy_gun_stock = _add_enemy_box(new_enemy, stock_size, Vector3(weapon_x, weapon_y - 0.015, 0.08), rifle_material)
    var magazine_size = Vector3(0.075, 0.17, 0.085) if enemy_weapon != "pistol" else Vector3(0.07, 0.13, 0.07)
    var enemy_gun_magazine = _add_enemy_box(new_enemy, magazine_size, Vector3(weapon_x, weapon_y - 0.13, -0.10), rifle_material)
    # Forward arms and visible hands make it clear the soldier is holding it.
    var left_arm = _add_enemy_box(new_enemy, Vector3(0.18, 0.20, 0.64), Vector3(-0.20, 0.12, -0.30), uniform)
    var right_arm = _add_enemy_box(new_enemy, Vector3(0.18, 0.20, 0.64), Vector3(0.31, 0.12, -0.30), uniform)
    new_enemy.set_meta("left_arm", left_arm)
    new_enemy.set_meta("right_arm", right_arm)
    var hand_material = StandardMaterial3D.new()
    hand_material.albedo_color = Color(0.48, 0.34, 0.24)
    _add_enemy_box(new_enemy, Vector3(0.20, 0.20, 0.22), Vector3(-0.20, 0.10, -0.62), hand_material)
    _add_enemy_box(new_enemy, Vector3(0.20, 0.20, 0.22), Vector3(0.31, 0.10, -0.62), hand_material)
    if enemy_weapon == "sniper":
        var enemy_scope = _add_enemy_box(new_enemy, Vector3(0.09, 0.085, 0.30), Vector3(weapon_x, weapon_y + 0.095, -0.32), rifle_material)
    var muzzle_marker = Node3D.new()
    muzzle_marker.position = Vector3(weapon_x, weapon_y, -enemy_gun_length)
    new_enemy.add_child(muzzle_marker)
    new_enemy.set_meta("muzzle_marker", muzzle_marker)

    var enemy_health_display = Node3D.new()
    enemy_health_display.position = Vector3(0, 1.42, 0)
    new_enemy.add_child(enemy_health_display)
    new_enemy.set_meta("health_display", enemy_health_display)
    for i in range(3):
        var segment = MeshInstance3D.new()
        var segment_mesh = BoxMesh.new()
        segment_mesh.size = Vector3(0.30, 0.12, 0.08)
        segment.mesh = segment_mesh
        segment.position = Vector3((float(i) - 1.0) * 0.27, 0, 0)
        var segment_material = StandardMaterial3D.new()
        segment_material.albedo_color = Color(0.05, 0.95, 0.12)
        segment_material.emission_enabled = true
        segment_material.emission = Color(0.02, 0.45, 0.05)
        segment.material_override = segment_material
        enemy_health_display.add_child(segment)
    _attach_universal_soldier(new_enemy, enemy_weapon)
    return new_enemy

func _attach_universal_soldier(enemy: CharacterBody3D, weapon_kind: String):
    var soldier_resource = load(COMPLETE_ANIMATED_SOLDIER_PATH) as PackedScene
    if soldier_resource == null:
        return
    # The skinned Mixamo file supplies the detailed SWAT mesh and skeleton.
    # The remaining files add clips authored for that exact same character.
    for child in enemy.get_children():
        if child is MeshInstance3D and not bool(child.get_meta("keep_with_swat", false)):
            child.visible = false
    var soldier = soldier_resource.instantiate()
    soldier.name = "SWATSoldier"
    # Final vertical placement is corrected against the real surface at runtime.
    soldier.position = Vector3.ZERO
    soldier.rotation_degrees.y = 180.0
    enemy.add_child(soldier)
    _attach_real_enemy_weapon(enemy, weapon_kind)
    # Preserve the authored SWAT uniform, boots, trousers and vest materials.
    enemy.set_meta("universal_soldier", soldier)
    var soldier_skeletons = soldier.find_children("*", "Skeleton3D", true, false)
    if not soldier_skeletons.is_empty():
        var soldier_skeleton = soldier_skeletons[0] as Skeleton3D
        enemy.set_meta("universal_skeleton", soldier_skeleton)
        enemy.set_meta("universal_root_bone", soldier_skeleton.find_bone("root"))
        enemy.set_meta("right_hand_bone", _find_swat_bone(soldier_skeleton, "RightHand"))
        enemy.set_meta("left_hand_bone", _find_swat_bone(soldier_skeleton, "LeftHand"))
        enemy.set_meta("right_index_grip_bone", _find_swat_bone(soldier_skeleton, "RightHandIndex1"))
        enemy.set_meta("right_middle_grip_bone", _find_swat_bone(soldier_skeleton, "RightHandMiddle1"))
        enemy.set_meta("left_index_grip_bone", _find_swat_bone(soldier_skeleton, "LeftHandIndex1"))
        enemy.set_meta("left_middle_grip_bone", _find_swat_bone(soldier_skeleton, "LeftHandMiddle1"))
    var health_display = enemy.get_meta("health_display", null)
    if health_display != null and is_instance_valid(health_display):
        health_display.position.y = 2.12
    var source_players = soldier.find_children("*", "AnimationPlayer", true, false)
    if not source_players.is_empty():
        var animator = source_players[0] as AnimationPlayer
        var largest_library = animator.get_animation_list().size()
        for candidate_node in source_players:
            var candidate = candidate_node as AnimationPlayer
            var candidate_size = candidate.get_animation_list().size()
            if candidate_size > largest_library:
                animator = candidate
                largest_library = candidate_size
        animator.active = true
        animator.speed_scale = 1.0
        _install_swat_animation_set(animator)
        # Manual advancement is reliable on the Android editor/runtime where
        # imported AnimationPlayers can otherwise remain on their first frame.
        animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
        for animation_name in animator.get_animation_list():
            var animation = animator.get_animation(animation_name)
            if animation != null and (String(animation_name).ends_with("_Loop") or String(animation_name) in ["Walk_Loop", "Jog_Fwd_Loop", "Sprint_Loop", "CharacterArmature|Walk", "CharacterArmature|Run", "CharacterArmature|Idle_Gun", "CharacterArmature|Idle_Gun_Pointing"]):
                animation.loop_mode = Animation.LOOP_LINEAR
        enemy.set_meta("universal_animator", animator)
        enemy.set_meta("animation_count", largest_library)
        _prepare_enemy_fire_rig(enemy)
        _set_enemy_safe_guard_pose(enemy)
        # Re-apply after the imported GLB has entered the scene tree.  This is
        # required on some Android Godot builds where the first immediate play
        # request can be overwritten by importer initialization.
        _start_enemy_animation_deferred.call_deferred(enemy)
    # Mixamo's rifle poses keep both hands aligned around the firearm.
    var detailed_muzzle = Node3D.new()
    var weapon_length = 1.42 if weapon_kind == "sniper" else (0.68 if weapon_kind == "pistol" else 1.08)
    detailed_muzzle.position = Vector3(0.20, 0.28, -weapon_length)
    enemy.add_child(detailed_muzzle)
    enemy.set_meta("muzzle_marker", detailed_muzzle)

func _attach_real_enemy_weapon(enemy: CharacterBody3D, weapon_kind: String):
    # Replace the temporary box weapon with the actual GLB models supplied in
    # Ultimate Guns Pack. These models use X as their barrel axis, so a 90° Y
    # rotation points the muzzle along the soldier's local forward direction.
    var weapon_path = String(REAL_ENEMY_WEAPONS.get(weapon_kind, REAL_ENEMY_WEAPONS["rifle"]))
    var weapon_scene = load(weapon_path) as PackedScene
    if weapon_scene == null:
        return
    var real_weapon = weapon_scene.instantiate() as Node3D
    real_weapon.name = "Real_%s" % weapon_kind.capitalize()
    # Screenshot calibration: 0.39 was at the shoulder and -0.10 was at the
    # hips. Their midpoint aligns the trigger and foregrip with both hands.
    var grip_height = 0.12 if weapon_kind == "pistol" else 0.145
    real_weapon.position = Vector3(0.01, grip_height, -0.10)
    real_weapon.rotation_degrees = Vector3(0.0, 90.0, 0.0)
    real_weapon.scale = Vector3.ONE * 0.16
    enemy.add_child(real_weapon)
    enemy.set_meta("real_weapon", real_weapon)

func _find_swat_bone(skeleton: Skeleton3D, short_name: String) -> int:
    var direct_index = skeleton.find_bone("mixamorig:%s" % short_name)
    if direct_index >= 0:
        return direct_index
    var wanted_suffix = short_name.to_lower()
    for bone_index in range(skeleton.get_bone_count()):
        if String(skeleton.get_bone_name(bone_index)).to_lower().ends_with(wanted_suffix):
            return bone_index
    return -1

func _sync_real_weapon_to_hands(enemy: CharacterBody3D):
    var real_weapon = enemy.get_meta("real_weapon", null)
    if real_weapon == null or not is_instance_valid(real_weapon):
        return
    var skeleton = enemy.get_meta("universal_skeleton", null) as Skeleton3D
    if skeleton == null or not is_instance_valid(skeleton):
        return
    var right_hand_bone = int(enemy.get_meta("right_hand_bone", -1))
    var left_hand_bone = int(enemy.get_meta("left_hand_bone", -1))
    if right_hand_bone < 0 or left_hand_bone < 0:
        return
    var right_hand_world = skeleton.global_transform * skeleton.get_bone_global_pose(right_hand_bone)
    var left_hand_world = skeleton.global_transform * skeleton.get_bone_global_pose(left_hand_bone)
    var right_position = right_hand_world.origin
    var left_position = left_hand_world.origin
    # Hand bones start at the wrists. Use the first index/middle finger joints
    # to locate the centers of the closed palms, where the firearm must sit.
    var right_index = int(enemy.get_meta("right_index_grip_bone", -1))
    var right_middle = int(enemy.get_meta("right_middle_grip_bone", -1))
    var left_index = int(enemy.get_meta("left_index_grip_bone", -1))
    var left_middle = int(enemy.get_meta("left_middle_grip_bone", -1))
    if right_index >= 0 and right_middle >= 0:
        var right_index_world = skeleton.global_transform * skeleton.get_bone_global_pose(right_index)
        var right_middle_world = skeleton.global_transform * skeleton.get_bone_global_pose(right_middle)
        right_position = (right_index_world.origin + right_middle_world.origin) * 0.5
    if left_index >= 0 and left_middle >= 0:
        var left_index_world = skeleton.global_transform * skeleton.get_bone_global_pose(left_index)
        var left_middle_world = skeleton.global_transform * skeleton.get_bone_global_pose(left_middle)
        left_position = (left_index_world.origin + left_middle_world.origin) * 0.5
    # The rifle mesh barrel runs along local +X. The right hand stays at the
    # trigger and the left hand stays on the foregrip, preventing mirroring.
    var barrel_axis = left_position - right_position
    if barrel_axis.length_squared() < 0.000001:
        return
    barrel_axis = barrel_axis.normalized()
    var up_axis = Vector3.UP - barrel_axis * Vector3.UP.dot(barrel_axis)
    if up_axis.length_squared() < 0.000001:
        up_axis = right_hand_world.basis.y
    up_axis = up_axis.normalized()
    var side_axis = barrel_axis.cross(up_axis).normalized()
    up_axis = side_axis.cross(barrel_axis).normalized()
    var weapon_scale = 0.12
    var aligned_basis = Basis(barrel_axis * weapon_scale, up_axis * weapon_scale, side_axis * weapon_scale)
    # A tiny downward offset seats the foregrip inside the curled fingers
    # instead of floating over the left hand.
    var grip_origin = right_position - barrel_axis * 0.020 - up_axis * 0.018
    real_weapon.global_transform = Transform3D(aligned_basis, grip_origin)

func _install_swat_animation_set(target_animator: AnimationPlayer):
    # Every Mixamo file was exported from the same SWAT character. Therefore
    # its skeleton paths match the skinned aiming file and the clips can share
    # one AnimationPlayer without retargeting or duplicating visible meshes.
    var swat_library = AnimationLibrary.new()
    for clip_name in SWAT_ANIMATION_FILES:
        var source_scene = load(String(SWAT_ANIMATION_FILES[clip_name])) as PackedScene
        if source_scene == null:
            continue
        var source_root = source_scene.instantiate()
        var source_players = source_root.find_children("*", "AnimationPlayer", true, false)
        if source_players.is_empty():
            source_root.free()
            continue
        var source_animator = source_players[0] as AnimationPlayer
        var source_animation: Animation = null
        for imported_name in source_animator.get_animation_list():
            if String(imported_name).to_lower() != "reset":
                source_animation = source_animator.get_animation(imported_name)
                break
        if source_animation != null:
            var installed_animation = source_animation.duplicate(true) as Animation
            if clip_name in ["SWAT_Aim", "SWAT_Walk", "SWAT_Run"]:
                installed_animation.loop_mode = Animation.LOOP_LINEAR
            else:
                installed_animation.loop_mode = Animation.LOOP_NONE
            swat_library.add_animation(StringName(clip_name), installed_animation)
        source_root.free()
    if target_animator.has_animation_library("swat"):
        target_animator.remove_animation_library("swat")
    target_animator.add_animation_library("swat", swat_library)

func _apply_green_uniform_skin(soldier: Node3D):
    # The animated body supplies the close-fitting undersuit. A fabric texture
    # makes it read as camouflage cloth rather than bare tinted skin.
    var green_uniform = StandardMaterial3D.new()
    green_uniform.albedo_color = Color(0.24, 0.30, 0.18)
    green_uniform.albedo_texture = load("res://textures/uniform_fabric.svg")
    green_uniform.uv1_scale = Vector3(5.0, 5.0, 5.0)
    green_uniform.roughness = 0.94
    green_uniform.metallic = 0.0
    for mesh_node in soldier.find_children("*", "MeshInstance3D", true, false):
        if String(mesh_node.name).contains("Weapon_Attached"):
            continue
        var body_mesh = mesh_node as MeshInstance3D
        body_mesh.material_override = green_uniform

func _add_light_field_clothing(soldier: Node3D):
    # Detailed rounded tactical equipment. Large square slabs were deliberately
    # removed; the body itself now carries the camouflage fabric while these
    # pieces add depth and a recognisable military silhouette.
    var uniform_root = Node3D.new()
    uniform_root.name = "DetailedFieldUniform"
    soldier.add_child(uniform_root)
    soldier.set_meta("field_uniform", uniform_root)
    var cloth = StandardMaterial3D.new()
    cloth.albedo_color = Color(0.20, 0.27, 0.13)
    cloth.albedo_texture = load("res://textures/uniform_fabric.svg")
    cloth.uv1_scale = Vector3(3.0, 3.0, 3.0)
    cloth.roughness = 0.96
    var armor = StandardMaterial3D.new()
    armor.albedo_color = Color(0.055, 0.075, 0.038)
    armor.roughness = 0.84
    var webbing = StandardMaterial3D.new()
    webbing.albedo_color = Color(0.018, 0.025, 0.014)
    webbing.roughness = 0.78
    var metal = StandardMaterial3D.new()
    metal.albedo_color = Color(0.09, 0.11, 0.085)
    metal.metallic = 0.38
    metal.roughness = 0.56

    # Rounded ballistic vest and waist protection.
    _add_uniform_capsule(uniform_root, 0.31, 0.67, Vector3(0, 1.16, 0.015), Vector3(1.0, 1.0, 0.60), cloth)
    _add_uniform_cylinder(uniform_root, 0.31, 0.105, Vector3(0, 0.82, 0.01), webbing)
    _add_uniform_capsule(uniform_root, 0.22, 0.48, Vector3(0, 0.68, 0.01), Vector3(1.08, 0.70, 0.68), cloth)

    # Chest plate, crossed harness, magazine pouches and belt buckle.
    _add_uniform_box(uniform_root, Vector3(0.43, 0.29, 0.055), Vector3(0, 1.17, -0.205), armor)
    var strap_left = _add_uniform_box(uniform_root, Vector3(0.065, 0.57, 0.035), Vector3(-0.12, 1.22, -0.244), webbing)
    strap_left.rotation_degrees.z = -18.0
    var strap_right = _add_uniform_box(uniform_root, Vector3(0.065, 0.57, 0.035), Vector3(0.12, 1.22, -0.244), webbing)
    strap_right.rotation_degrees.z = 18.0
    for pouch_x in [-0.16, 0.0, 0.16]:
        _add_uniform_box(uniform_root, Vector3(0.13, 0.18, 0.085), Vector3(pouch_x, 0.97, -0.255), armor)
    _add_uniform_box(uniform_root, Vector3(0.105, 0.075, 0.045), Vector3(0, 0.82, -0.19), metal)

    # Compact backpack, radio, antenna and shoulder identification patch.
    _add_uniform_capsule(uniform_root, 0.22, 0.48, Vector3(0, 1.15, 0.20), Vector3(0.88, 1.0, 0.48), armor)
    _add_uniform_box(uniform_root, Vector3(0.12, 0.22, 0.09), Vector3(0.31, 1.17, 0.02), webbing)
    _add_uniform_cylinder(uniform_root, 0.012, 0.34, Vector3(0.32, 1.44, 0.02), metal)
    _add_uniform_box(uniform_root, Vector3(0.10, 0.07, 0.025), Vector3(-0.27, 1.29, -0.19), metal)

    # Helmet dome, lower band and a small front mount.
    var helmet = MeshInstance3D.new()
    var helmet_mesh = SphereMesh.new()
    helmet_mesh.radius = 0.285
    helmet_mesh.height = 0.39
    helmet_mesh.radial_segments = 20
    helmet_mesh.rings = 10
    helmet.mesh = helmet_mesh
    helmet.position = Vector3(0, 1.80, 0)
    helmet.scale = Vector3(1.0, 0.64, 1.02)
    helmet.material_override = armor
    uniform_root.add_child(helmet)
    _add_uniform_cylinder(uniform_root, 0.29, 0.055, Vector3(0, 1.70, 0), webbing)
    _add_uniform_box(uniform_root, Vector3(0.075, 0.09, 0.045), Vector3(0, 1.79, -0.285), metal)

func _add_uniform_capsule(parent: Node3D, radius: float, height: float, part_position: Vector3, part_scale: Vector3, material: Material) -> MeshInstance3D:
    var part = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()
    capsule.radius = radius
    capsule.height = height
    capsule.radial_segments = 16
    capsule.rings = 5
    part.mesh = capsule
    part.position = part_position
    part.scale = part_scale
    part.material_override = material
    parent.add_child(part)
    return part

func _add_uniform_cylinder(parent: Node3D, radius: float, height: float, part_position: Vector3, material: Material) -> MeshInstance3D:
    var part = MeshInstance3D.new()
    var cylinder = CylinderMesh.new()
    cylinder.top_radius = radius
    cylinder.bottom_radius = radius
    cylinder.height = height
    cylinder.radial_segments = 16
    part.mesh = cylinder
    part.position = part_position
    part.material_override = material
    parent.add_child(part)
    return part

func _add_military_uniform(soldier: Node3D):
    # Layered field uniform fitted over the imported character: combat vest,
    # pouches, belt, trousers, knee guards, boots and helmet.
    var cloth = StandardMaterial3D.new()
    cloth.albedo_color = Color(0.19, 0.25, 0.12)
    cloth.roughness = 0.92
    var armor = StandardMaterial3D.new()
    armor.albedo_color = Color(0.12, 0.17, 0.09)
    armor.roughness = 0.78
    var dark = StandardMaterial3D.new()
    dark.albedo_color = Color(0.055, 0.065, 0.045)
    dark.roughness = 0.72
    _add_uniform_box(soldier, Vector3(0.62, 0.62, 0.32), Vector3(0, 1.16, 0), cloth)
    _add_uniform_box(soldier, Vector3(0.48, 0.36, 0.08), Vector3(0, 1.16, -0.19), armor)
    _add_uniform_box(soldier, Vector3(0.14, 0.18, 0.10), Vector3(-0.18, 0.96, -0.22), armor)
    _add_uniform_box(soldier, Vector3(0.14, 0.18, 0.10), Vector3(0.18, 0.96, -0.22), armor)
    _add_uniform_box(soldier, Vector3(0.60, 0.10, 0.34), Vector3(0, 0.80, 0), dark)
    _add_uniform_box(soldier, Vector3(0.50, 0.30, 0.30), Vector3(0, 0.66, 0), cloth)
    _add_uniform_box(soldier, Vector3(0.20, 0.46, 0.22), Vector3(-0.15, 0.37, 0), cloth)
    _add_uniform_box(soldier, Vector3(0.20, 0.46, 0.22), Vector3(0.15, 0.37, 0), cloth)
    _add_uniform_box(soldier, Vector3(0.23, 0.13, 0.25), Vector3(-0.15, 0.18, -0.02), armor)
    _add_uniform_box(soldier, Vector3(0.23, 0.13, 0.25), Vector3(0.15, 0.18, -0.02), armor)
    _add_uniform_box(soldier, Vector3(0.23, 0.28, 0.30), Vector3(-0.15, -0.08, 0), dark)
    _add_uniform_box(soldier, Vector3(0.23, 0.28, 0.30), Vector3(0.15, -0.08, 0), dark)
    var helmet = MeshInstance3D.new()
    var helmet_mesh = SphereMesh.new()
    helmet_mesh.radius = 0.27
    helmet_mesh.height = 0.34
    helmet.mesh = helmet_mesh
    helmet.position = Vector3(0, 1.80, 0)
    helmet.scale = Vector3(1.0, 0.58, 1.0)
    helmet.material_override = armor
    soldier.add_child(helmet)
    _add_uniform_box(soldier, Vector3(0.62, 0.055, 0.38), Vector3(0, 1.70, -0.01), armor)

func _add_uniform_box(parent: Node3D, box_size: Vector3, box_position: Vector3, material: Material):
    var part = MeshInstance3D.new()
    var part_mesh = BoxMesh.new()
    part_mesh.size = box_size
    part.mesh = part_mesh
    part.position = box_position
    part.material_override = material
    parent.add_child(part)

func _start_enemy_animation_deferred(enemy: CharacterBody3D):
    if not is_instance_valid(enemy):
        return
    var animator = enemy.get_meta("universal_animator", null)
    if animator == null or not is_instance_valid(animator):
        return
    animator.stop()
    enemy.remove_meta("active_visual_animation")
    _set_enemy_safe_guard_pose(enemy)

func _prepare_enemy_fire_rig(enemy: CharacterBody3D):
    # Play the firing FBX only on its own matching hidden skeleton. During the
    # shot we copy bone poses to the visible soldier; no foreign animation
    # tracks are ever attached to the visible model, preventing the T pose.
    var fire_scene = load(String(SWAT_ANIMATION_FILES["SWAT_Fire"])) as PackedScene
    if fire_scene == null:
        return
    var fire_root = fire_scene.instantiate() as Node3D
    if fire_root == null:
        return
    fire_root.name = "HiddenFirePoseRig"
    fire_root.visible = false
    enemy.add_child(fire_root)
    var fire_players = fire_root.find_children("*", "AnimationPlayer", true, false)
    var fire_skeletons = fire_root.find_children("*", "Skeleton3D", true, false)
    if fire_players.is_empty() or fire_skeletons.is_empty():
        fire_root.queue_free()
        return
    var fire_animator = fire_players[0] as AnimationPlayer
    var fire_animation_name := ""
    for animation_name in fire_animator.get_animation_list():
        if not String(animation_name).to_lower().ends_with("reset"):
            fire_animation_name = String(animation_name)
            break
    if fire_animation_name == "":
        fire_root.queue_free()
        return
    fire_animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
    fire_animator.active = true
    enemy.set_meta("fire_pose_root", fire_root)
    enemy.set_meta("fire_pose_animator", fire_animator)
    enemy.set_meta("fire_pose_skeleton", fire_skeletons[0])
    enemy.set_meta("fire_pose_animation", fire_animation_name)

func _start_enemy_fire_pose(enemy: CharacterBody3D):
    var fire_animator = enemy.get_meta("fire_pose_animator", null) as AnimationPlayer
    var fire_animation = String(enemy.get_meta("fire_pose_animation", ""))
    if fire_animator == null or not is_instance_valid(fire_animator) or fire_animation == "":
        return
    fire_animator.stop()
    fire_animator.play(fire_animation)
    fire_animator.advance(0.0)

func _apply_enemy_fire_pose(enemy: CharacterBody3D, delta: float):
    var target_skeleton = enemy.get_meta("universal_skeleton", null) as Skeleton3D
    var source_skeleton = enemy.get_meta("fire_pose_skeleton", null) as Skeleton3D
    var fire_animator = enemy.get_meta("fire_pose_animator", null) as AnimationPlayer
    if target_skeleton == null or source_skeleton == null or fire_animator == null:
        return
    if not is_instance_valid(target_skeleton) or not is_instance_valid(source_skeleton) or not is_instance_valid(fire_animator):
        return
    fire_animator.advance(delta)
    for target_bone in range(target_skeleton.get_bone_count()):
        var bone_name = target_skeleton.get_bone_name(target_bone)
        var source_bone = source_skeleton.find_bone(bone_name)
        if source_bone < 0:
            continue
        # Copy rotations only. Keeping the visible rig's translations and
        # scale prevents root motion, height jumps and body proportion changes.
        target_skeleton.set_bone_pose_rotation(target_bone, source_skeleton.get_bone_pose_rotation(source_bone))

func _set_enemy_safe_guard_pose(enemy: CharacterBody3D):
    # The walk clip is the animation that has visibly worked on the target
    # Android device. Freeze it on a two-handed weapon frame for every
    # stationary/aim/fire state, avoiding all clips that expose the T pose.
    var animator = enemy.get_meta("universal_animator", null) as AnimationPlayer
    if animator == null or not is_instance_valid(animator):
        return
    var safe_clip = "swat/SWAT_Walk"
    if not animator.has_animation(safe_clip):
        return
    var changed = String(enemy.get_meta("active_visual_animation", "")) != safe_clip
    if changed:
        enemy.set_meta("active_visual_animation", safe_clip)
        animator.active = true
        animator.speed_scale = 1.0
        animator.play(safe_clip, 0.08)
        animator.advance(0.22)
    animator.speed_scale = 0.0

func _set_enemy_animation(enemy: CharacterBody3D, wanted_name: String):
    var animator = enemy.get_meta("universal_animator", null)
    if animator == null or not is_instance_valid(animator):
        return
    var animation_aliases = {
        "Pistol_Idle_Loop": "swat/SWAT_Walk",
        "Pistol_Aim_Neutral": "swat/SWAT_Walk",
        "Pistol_Shoot": "swat/SWAT_Walk",
        "Pistol_Reload": "swat/SWAT_Walk",
        "Walk_Loop": "swat/SWAT_Walk",
        "Jog_Fwd_Loop": "swat/SWAT_Run",
        "SWAT_Aim": "swat/SWAT_Walk",
        "SWAT_Fire": "swat/SWAT_Walk",
        "SWAT_Reload": "swat/SWAT_Walk",
        "SWAT_Walk": "swat/SWAT_Walk",
        "SWAT_Run": "swat/SWAT_Run",
        "Roll": "CharacterArmature|Roll",
        "Death01": "CharacterArmature|Death"
    }
    var selected = String(animation_aliases.get(wanted_name, wanted_name))
    if not animator.has_animation(selected):
        selected = ""
        for animation_name in animator.get_animation_list():
            if String(animation_name).ends_with(wanted_name):
                selected = String(animation_name)
                break
    if selected == "":
        return
    # Under manual processing is_playing() can briefly report false on Android.
    # Using it here restarted the same clip every physics frame and held the
    # legs on the first pose while the CharacterBody slid over the ground.
    if String(enemy.get_meta("active_visual_animation", "")) == selected:
        return
    enemy.set_meta("active_visual_animation", selected)
    animator.active = true
    animator.play(selected, 0.16)
    animator.advance(0.0)

func _retire_enemy_with_animation(enemy: CharacterBody3D):
    if bool(enemy.get_meta("stage6_commander", false)):
        train_commander_defeated = true
        if is_instance_valid(status_label):
            status_label.text = "تم القضاء على قائد القطار - أكمل التخريب واتجه إلى الإخلاء"
        _update_objective_text()
        _check_mission_completion()
    if bool(enemy.get_meta("stage5_commander", false)):
        facility_commander_defeated = true
        if is_instance_valid(status_label):
            status_label.text = "تم القضاء على قائد الحراسة - أكمل التخريب وابدأ الهروب"
        _update_objective_text()
        _check_mission_completion()
    enemy.collision_layer = 0
    enemy.collision_mask = 0
    for child in enemy.get_children():
        if child is CollisionShape3D:
            child.set_deferred("disabled", true)
    var health_display = enemy.get_meta("health_display", null)
    if health_display != null and is_instance_valid(health_display):
        health_display.visible = false
    var death_animator = enemy.get_meta("universal_animator", null)
    if death_animator != null and is_instance_valid(death_animator):
        death_animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
    _set_enemy_animation(enemy, "Death01")
    # No death clip was included in the supplied Mixamo set, so use a short
    # physical fall instead of leaving a defeated SWAT model standing.
    var soldier_visual = enemy.get_meta("universal_soldier", null)
    if soldier_visual != null and is_instance_valid(soldier_visual):
        var fall_tween = create_tween()
        fall_tween.set_trans(Tween.TRANS_QUAD)
        fall_tween.set_ease(Tween.EASE_IN)
        fall_tween.tween_property(soldier_visual, "rotation_degrees", Vector3(-88.0, 180.0, 0.0), 0.42)
    enemy.set_meta("animation_action_time", 2.6)
    get_tree().create_timer(2.45).timeout.connect(func():
        if is_instance_valid(enemy):
            enemy.queue_free()
    )

func _add_enemy_box(enemy: Node3D, box_size: Vector3, box_position: Vector3, material: Material) -> MeshInstance3D:
    var part = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = box_size
    part.mesh = box
    part.position = box_position
    part.material_override = material
    enemy.add_child(part)
    return part

func _add_enemy_sphere(enemy: Node3D, radius: float, sphere_position: Vector3, sphere_scale: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = radius
    sphere.height = radius * 2.0
    part.mesh = sphere
    part.position = sphere_position
    part.scale = sphere_scale
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.88
    part.material_override = material
    enemy.add_child(part)

func _build_weapon():
    weapon_root = Node3D.new()
    weapon_root.position = Vector3(0.30, -0.36, -0.52)
    weapon_root.scale = Vector3(0.34, 0.34, 0.34)
    camera.add_child(weapon_root)
    gun_model = Node3D.new()
    weapon_root.add_child(gun_model)
    _build_player_gun_model("sniper")

    # Visible hands and sleeves holding the weapon in first person.
    _add_weapon_box(Vector3(0.16, 0.20, 0.20), Vector3(0.12, -0.17, 0.08), Color(0.52, 0.36, 0.24))
    _add_weapon_box(Vector3(0.18, 0.18, 0.30), Vector3(-0.10, -0.10, -0.19), Color(0.52, 0.36, 0.24))
    _add_weapon_box(Vector3(0.20, 0.23, 0.42), Vector3(0.18, -0.30, 0.24), Color(0.12, 0.18, 0.10))
    _add_weapon_box(Vector3(0.21, 0.21, 0.46), Vector3(-0.18, -0.20, 0.05), Color(0.12, 0.18, 0.10))

    muzzle_flash = MeshInstance3D.new()
    var flash_mesh = SphereMesh.new()
    flash_mesh.radius = 0.09
    flash_mesh.height = 0.18
    muzzle_flash.mesh = flash_mesh
    muzzle_flash.position = Vector3(0, 0.02, -0.64)
    var flash_material = StandardMaterial3D.new()
    flash_material.albedo_color = Color(1.0, 0.55, 0.08)
    flash_material.emission_enabled = true
    flash_material.emission = Color(1.0, 0.25, 0.02)
    flash_material.emission_energy_multiplier = 5.0
    muzzle_flash.material_override = flash_material
    muzzle_flash.visible = false
    weapon_root.add_child(muzzle_flash)

    shot_audio = AudioStreamPlayer.new()
    shot_audio.stream = _make_shot_sound()
    shot_audio.volume_db = _sound_volume_db()
    add_child(shot_audio)

func _build_player_gun_model(kind: String):
    if not is_instance_valid(gun_model):
        return
    for child in gun_model.get_children():
        child.queue_free()
    if kind == "pistol":
        _add_model_box(Vector3(0.20, 0.20, 0.62), Vector3(0, 0, -0.12), Color(0.06, 0.07, 0.08))
        _add_model_box(Vector3(0.18, 0.34, 0.20), Vector3(0, -0.22, 0.08), Color(0.10, 0.10, 0.11))
        _add_model_box(Vector3(0.12, 0.035, 0.42), Vector3(0, 0.12, -0.14), Color(0.32, 0.34, 0.35))
        _add_model_box(Vector3(0.07, 0.07, 0.05), Vector3(0, 0.16, -0.39), Color(0.82, 0.20, 0.08))
    elif kind == "sniper":
        _add_model_box(Vector3(0.18, 0.17, 1.18), Vector3(0, 0, -0.30), Color(0.07, 0.09, 0.07))
        _add_model_cylinder(0.14, 0.62, Vector3(0, 0.23, -0.28), Color(0.10, 0.12, 0.13))
        _add_model_cylinder(0.19, 0.13, Vector3(0, 0.23, -0.005), Color(0.08, 0.09, 0.10))
        _add_model_cylinder(0.165, 0.035, Vector3(0, 0.23, 0.075), Color(0.48, 0.53, 0.57, 0.62), true)
        _add_model_cylinder(0.16, 0.08, Vector3(0, 0.23, -0.60), Color(0.08, 0.09, 0.10))
        _add_model_box(Vector3(0.08, 0.18, 0.10), Vector3(-0.09, 0.08, -0.14), Color(0.12, 0.13, 0.14))
        _add_model_box(Vector3(0.08, 0.18, 0.10), Vector3(0.09, 0.08, -0.42), Color(0.12, 0.13, 0.14))
        _add_model_cylinder(0.045, 0.80, Vector3(0, 0, -1.25), Color(0.025, 0.03, 0.028))
        _add_model_box(Vector3(0.28, 0.30, 0.34), Vector3(0, -0.12, 0.14), Color(0.26, 0.14, 0.05))
        _add_model_box(Vector3(0.24, 0.07, 0.76), Vector3(0, 0.11, -0.35), Color(0.18, 0.20, 0.20))
        _add_model_box(Vector3(0.055, 0.25, 0.24), Vector3(0, -0.19, -0.22), Color(0.08, 0.09, 0.09))
    elif kind == "shotgun":
        _add_model_box(Vector3(0.25, 0.20, 1.05), Vector3(0, 0, -0.26), Color(0.05, 0.05, 0.05))
        _add_model_box(Vector3(0.34, 0.28, 0.42), Vector3(0, -0.10, 0.18), Color(0.34, 0.14, 0.04))
        _add_model_cylinder(0.055, 0.92, Vector3(0, -0.10, -0.70), Color(0.07, 0.075, 0.08))
        _add_model_box(Vector3(0.31, 0.18, 0.32), Vector3(0, -0.03, -0.45), Color(0.34, 0.16, 0.06))
    elif kind == "grenade":
        var grenade = MeshInstance3D.new()
        var grenade_mesh = SphereMesh.new()
        grenade_mesh.radius = 0.22
        grenade_mesh.height = 0.44
        grenade.mesh = grenade_mesh
        grenade.position = Vector3(0, 0, -0.08)
        var grenade_material = StandardMaterial3D.new()
        grenade_material.albedo_color = Color(0.12, 0.20, 0.08)
        grenade_material.roughness = 0.82
        grenade.material_override = grenade_material
        gun_model.add_child(grenade)
        _add_model_box(Vector3(0.16, 0.12, 0.16), Vector3(0, 0.25, -0.08), Color(0.12, 0.12, 0.10))
    else:
        _add_model_box(Vector3(0.18, 0.16, 0.72), Vector3(0, 0, -0.12), Color(0.06, 0.08, 0.07))
        _add_model_box(Vector3(0.10, 0.25, 0.18), Vector3(0, -0.19, 0.10), Color(0.04, 0.04, 0.045))
        _add_model_box(Vector3(0.30, 0.22, 0.34), Vector3(0, 0, 0.18), Color(0.14, 0.17, 0.12))
        _add_model_box(Vector3(0.22, 0.38, 0.20), Vector3(0, -0.23, -0.12), Color(0.10, 0.11, 0.10))
        _add_model_box(Vector3(0.11, 0.07, 0.60), Vector3(0, 0.14, -0.20), Color(0.25, 0.27, 0.25))
        _add_model_cylinder(0.040, 0.62, Vector3(0, 0, -0.76), Color(0.035, 0.04, 0.04))

func _add_model_box(box_size: Vector3, box_position: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = box_size
    part.mesh = box
    part.position = box_position
    var material = StandardMaterial3D.new()
    material.albedo_color = color.lightened(0.32)
    material.albedo_texture = load("res://textures/weapon_metal.svg")
    material.metallic = 0.58
    material.roughness = 0.36
    material.emission_enabled = true
    material.emission = color.lightened(0.38) * 0.13
    material.emission_energy_multiplier = 0.32
    part.material_override = material
    gun_model.add_child(part)

func _add_model_cylinder(radius: float, length: float, cylinder_position: Vector3, color: Color, glass := false):
    var part = MeshInstance3D.new()
    var cylinder = CylinderMesh.new()
    cylinder.top_radius = radius
    cylinder.bottom_radius = radius
    cylinder.height = length
    cylinder.radial_segments = 24
    part.mesh = cylinder
    part.position = cylinder_position
    part.rotation_degrees.x = 90
    var material = StandardMaterial3D.new()
    material.albedo_color = color.lightened(0.16) if glass else color.lightened(0.28)
    material.metallic = 0.82 if not glass else 0.20
    material.roughness = 0.22 if not glass else 0.08
    if glass:
        material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
        material.albedo_color.a = 0.62
        material.emission_enabled = true
        material.emission = Color(0.20, 0.24, 0.27) * 0.22
        material.emission_energy_multiplier = 0.35
    else:
        material.emission_enabled = true
        material.emission = color.lightened(0.35) * 0.10
        material.emission_energy_multiplier = 0.24
    part.material_override = material
    gun_model.add_child(part)

func _add_weapon_box(box_size: Vector3, box_position: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = box_size
    part.mesh = box
    part.position = box_position
    var material = StandardMaterial3D.new()
    var is_player_clothing = color.r < 0.20 and color.g < 0.25
    part.set_meta("player_clothing", is_player_clothing)
    material.albedo_color = _player_uniform_color() if is_player_clothing else color
    material.metallic = 0.65
    material.roughness = 0.35
    part.material_override = material
    weapon_root.add_child(part)

func _make_shot_sound() -> AudioStreamWAV:
    var sample_rate = 22050
    var sample_count = int(sample_rate * 0.10)
    var pcm = PackedByteArray()
    pcm.resize(sample_count * 2)
    var rng = RandomNumberGenerator.new()
    rng.seed = 7391
    for i in range(sample_count):
        var decay = 1.0 - float(i) / float(sample_count)
        var noise = rng.randf_range(-1.0, 1.0)
        var thump = sin(TAU * 95.0 * float(i) / float(sample_rate))
        var sample = clamp((noise * 0.72 + thump * 0.28) * decay, -1.0, 1.0)
        pcm.encode_s16(i * 2, int(sample * 26000.0))
    var stream = AudioStreamWAV.new()
    stream.format = AudioStreamWAV.FORMAT_16_BITS
    stream.mix_rate = sample_rate
    stream.stereo = false
    stream.data = pcm
    return stream

func _physics_process(delta):
    if not game_started or game_ended or settings_open:
        return
    if active_ladder != null:
        var climb = float(move_forward) - float(move_back)
        player.global_position = Vector3(active_ladder.x, clamp(player.global_position.y + climb * 3.2 * delta, 1.0, 10.10), active_ladder.z + 1.49)
        player.velocity = Vector3.ZERO
        if player.global_position.y >= 10.08:
            player.global_position = active_ladder + Vector3(0, 10.1, 0.10)
            active_ladder = null
            player_collision.disabled = false
        elif player.global_position.y <= 1.01 and move_back:
            player.global_position = active_ladder + Vector3(0, 1.1, 2.0)
            active_ladder = null
            player_collision.disabled = false
        _update_interact_button()
        _update_crosshair()
        return
    if not player.is_on_floor():
        player.velocity += player.get_gravity() * delta

    if jump_pressed and player.is_on_floor() and stance == 0:
        player.velocity.y = JUMP_VELOCITY
    jump_pressed = false

    var input_vec = Vector2.ZERO
    input_vec.x = float(move_right) - float(move_left)
    input_vec.y = float(move_back) - float(move_forward)
    if input_vec.length() > 1.0:
        input_vec = input_vec.normalized()

    var dir = player.transform.basis * Vector3(input_vec.x, 0, input_vec.y)
    dir.y = 0
    dir = dir.normalized()

    var active_speed = SPEED
    if stance == 0:
        active_speed = 3.2 if movement_mode == 0 else (9.0 if movement_mode == 2 else SPEED)
    elif stance == 1:
        active_speed = 3.8
    elif stance == 2:
        active_speed = 2.0
    elif quiet_mode:
        active_speed = STEALTH_SPEED
    if dir != Vector3.ZERO:
        player.velocity.x = dir.x * active_speed
        player.velocity.z = dir.z * active_speed
        var movement_noise = 0.8 if stance == 2 else (1.5 if stance == 1 or quiet_mode else (7.0 if movement_mode == 2 else (2.8 if movement_mode == 0 else 4.0)))
        player_noise = max(player_noise, movement_noise)
    else:
        player.velocity.x = move_toward(player.velocity.x, 0.0, SPEED * 2.0)
        player.velocity.z = move_toward(player.velocity.z, 0.0, SPEED * 2.0)

    player.move_and_slide()
    _update_rescued_prisoner(delta)
    player_noise = max(player_noise - delta * 3.0, 0.0)
    alert_level = max(alert_level - delta * 8.0, 0.0)
    if is_instance_valid(alert_label):
        alert_label.text = "الإنذار: %d%%  |  %s" % [int(alert_level), ("مشي هادئ" if quiet_mode else "حركة عادية")]
    if mission_number == 2 and alert_level >= 82.0 and not alarm_disabled and not reinforcements_spawned:
        status_label.text = "تم تشغيل الإنذار - وصلت تعزيزات إلى المستودع"
        _spawn_mission2_reinforcements()
    elif mission_number == 3 and alert_level >= 86.0 and not port_surveillance_disabled and not reinforcements_spawned:
        status_label.text = "كشفك نظام الميناء - وصلت دورية دعم"
        _spawn_mission2_reinforcements()
    _keep_player_inside_map()
    _update_doors(delta)
    _update_enemies(delta)
    _update_pickups()
    _update_interact_button()
    _update_crosshair()

    if mission_number == 10 and not game_ended:
        _update_final_mission(delta)

    if mission_number == 9 and not game_ended:
        _update_convoy_mission(delta)

    if mission_number == 6 and train_escape_active and not game_ended:
        var train_ready_to_extract = train_charge_planted and train_commander_defeated and train_prisoner_rescued
        if train_ready_to_extract and _prisoner_at_extraction() and player.global_position.distance_to(Vector3(18, 1.1, -132)) <= 6.0:
            extraction_reached = true
            _update_objective_text()
            _complete_mission()
            return
        train_escape_time = max(train_escape_time - delta, 0.0)
        _update_train_countdown()
        _update_objective_text()
        if train_escape_time <= 0.0:
            mission_failure_reason = "انتهى وقت الإخلاء قبل وصولك مع الأسير"
            _finish_game(false)

    if mission_number == 8 and bridge_escape_active and not game_ended:
        bridge_escape_time = max(bridge_escape_time - delta, 0.0)
        _update_bridge_countdown()
        if bridge_escape_time <= 0.0:
            mission_failure_reason = "انفجر الجسر قبل وصولك إلى عربة الإخلاء"
            _finish_game(false)
            return

    # Complete stage five automatically at the extraction vehicle after all
    # required objectives, avoiding a missed final touchscreen interaction.
    if mission_number == 5 and facility_escape_active and not game_ended:
        var facility_ready_to_extract = facility_charges_planted >= 2 and facility_commander_defeated and data_downloaded and explosives_collected
        if facility_ready_to_extract and player.global_position.distance_to(Vector3(0, 1.1, -128)) <= 6.0:
            extraction_reached = true
            _update_objective_text()
            _complete_mission()
            return

    if mission_number == 5 and facility_escape_active and not game_ended:
        facility_escape_time = max(facility_escape_time - delta, 0.0)
        _update_objective_text()
        if facility_escape_time <= 0.0:
            status_label.text = "انتهى وقت الهروب قبل الوصول إلى مركبة الإخلاء"
            _finish_game(false)

    if shoot_pressed:
        shoot_pressed = false
        _shoot()

func _remember_move_touch(event: InputEvent, direction: String):
    if event is InputEventScreenTouch and event.pressed:
        movement_touch_ids[event.index] = direction

func _input(event):
    # Route every Android finger independently. Regular Button signals are
    # mouse-oriented and could ignore the second finger while the first one
    # was aiming. This router keeps movement, aiming, scope and fire active at
    # the same time, while desktop mouse input continues to use the Buttons.
    if event is InputEventScreenTouch:
        var action := _touch_action_at(event.position)
        if event.pressed:
            if action != "":
                touch_action_ids[event.index] = action
                _start_touch_action(event.index, action)
                get_viewport().set_input_as_handled()
            elif look_touch_id == -1:
                look_touch_id = event.index
        else:
            if touch_action_ids.has(event.index):
                var released_action = String(touch_action_ids[event.index])
                touch_action_ids.erase(event.index)
                _stop_touch_action(event.index, released_action)
                get_viewport().set_input_as_handled()
            if event.index == look_touch_id:
                look_touch_id = -1
    elif event is InputEventScreenDrag and event.index == look_touch_id:
        _apply_look_drag(event.relative)
        get_viewport().set_input_as_handled()

func _touch_action_at(position: Vector2) -> String:
    var size := get_viewport().get_visible_rect().size
    var regions := {
        "forward": Rect2(Vector2(93, size.y - 245), Vector2(75, 65)),
        "left": Rect2(Vector2(13, size.y - 170), Vector2(75, 65)),
        "right": Rect2(Vector2(173, size.y - 170), Vector2(75, 65)),
        "back": Rect2(Vector2(93, size.y - 95), Vector2(75, 65)),
        "jump": Rect2(Vector2(size.x - 140, size.y - 245), Vector2(92, 92)),
        "stance": Rect2(Vector2(size.x - 262, size.y - 135), Vector2(96, 96)),
        "speed": Rect2(Vector2(size.x - 144, size.y - 135), Vector2(96, 88)),
        "zoom": Rect2(Vector2(size.x - 315, size.y - 540), Vector2(112, 112)),
        "shoot": Rect2(Vector2(size.x - 158, size.y - 540), Vector2(126, 126)),
        "interact": Rect2(Vector2(size.x * 0.40, size.y * 0.68), Vector2(92, 92))
    }
    for action_name in regions:
        if (regions[action_name] as Rect2).has_point(position):
            if action_name != "interact" or (is_instance_valid(interact_button) and interact_button.visible):
                return action_name
    return ""

func _start_touch_action(touch_id: int, action: String):
    match action:
        "forward":
            movement_touch_ids[touch_id] = action
            move_forward = true
        "back":
            movement_touch_ids[touch_id] = action
            move_back = true
        "left":
            movement_touch_ids[touch_id] = action
            move_left = true
        "right":
            movement_touch_ids[touch_id] = action
            move_right = true
        "jump": jump_pressed = true
        "stance": _cycle_stance()
        "speed": _cycle_movement_mode()
        "zoom": _toggle_zoom()
        "shoot": _on_action_button()
        "interact": _interact()

func _stop_touch_action(touch_id: int, action: String):
    movement_touch_ids.erase(touch_id)
    var still_held := false
    for held_action in touch_action_ids.values():
        if String(held_action) == action:
            still_held = true
            break
    if still_held:
        return
    match action:
        "forward": move_forward = false
        "back": move_back = false
        "left": move_left = false
        "right": move_right = false

func _notification(what):
    if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
        movement_touch_ids.clear()
        touch_action_ids.clear()
        look_touch_id = -1
        move_forward = false
        move_back = false
        move_left = false
        move_right = false
        shoot_pressed = false

func _keep_player_inside_map():
    var safe_position = player.global_position
    var minimum_x = -76.0 if mission_number >= 3 else -68.8
    var maximum_x = 76.0 if mission_number >= 3 else 68.8
    # Stage 9 continues beyond the convoy to its evacuation vehicle.
    # Its previous -140 limit blocked the player before the objective at -143.
    var minimum_z = -160.0 if mission_number >= 9 else (-140.0 if mission_number >= 3 else -68.8)
    safe_position.x = clamp(safe_position.x, minimum_x, maximum_x)
    safe_position.z = clamp(safe_position.z, minimum_z, 205.0)
    if safe_position.y < -2.0:
        safe_position = Vector3(0, 1.1, 185)
        player.velocity = Vector3.ZERO
        status_label.text = "تمت إعادتك إلى منطقة المهمة"
    player.global_position = safe_position

func _update_crosshair():
    if not is_instance_valid(cross_label):
        return
    var center = get_viewport().get_visible_rect().size * 0.5
    cross_label.position = center + Vector2(-10, -22)
    var origin = camera.project_ray_origin(center)
    var destination = origin + camera.project_ray_normal(center) * weapon_range
    var query = PhysicsRayQueryParameters3D.create(origin, destination)
    query.exclude = [player]
    var hit = get_world_3d().direct_space_state.intersect_ray(query)
    var collider = hit.get("collider") if not hit.is_empty() else null
    var on_visible_body = false
    if collider != null and collider.has_meta("enemy"):
        var local_hit = collider.to_local(hit.get("position"))
        on_visible_body = abs(local_hit.x) < (0.29 if local_hit.y > 0.5 else 0.38)
    cross_label.modulate = Color(1.0, 0.05, 0.03) if on_visible_body else Color.WHITE

func _get_next_objective_node():
    var wanted_kind = ""
    if not has_gate_key:
        wanted_kind = "gate_key"
    elif not gate_unlocked:
        return gate_door
    elif not has_building1_key:
        wanted_kind = "building1_key"
    elif not building1_unlocked:
        return _find_door_by_kind("building1")
    elif not has_building2_key:
        wanted_kind = "building2_key"
    elif not building2_unlocked:
        return _find_door_by_kind("building2")
    elif not computer_accessed:
        wanted_kind = "computer"
    for objective in objective_nodes:
        if is_instance_valid(objective) and String(objective.get_meta("objective_kind", "")) == wanted_kind:
            return objective
    return null

func _find_door_by_kind(kind: String):
    for door in doors:
        if is_instance_valid(door) and String(door.get_meta("lock_kind", "")) == kind:
            return door
    return null

func _get_aim_assist_target():
    if not is_instance_valid(camera):
        return null
    var screen_center = get_viewport().get_visible_rect().size * 0.5
    # Aim assistance is deliberately activated only when the centre of the +
    # actually touches an enemy collider. Nearby silhouettes are never pulled.
    var origin = camera.project_ray_origin(screen_center)
    var destination = origin + camera.project_ray_normal(screen_center) * weapon_range
    var query = PhysicsRayQueryParameters3D.create(origin, destination)
    query.exclude = [player]
    var hit = get_world_3d().direct_space_state.intersect_ray(query)
    if hit.is_empty():
        return null
    var collider = hit.get("collider")
    if collider != null and collider.has_meta("enemy"):
        return collider
    return null

func _update_doors(delta):
    for door in doors:
        if not is_instance_valid(door):
            continue
        var horizontal_player = Vector3(player.global_position.x, door.global_position.y, player.global_position.z)
        var near_door = bool(door.get_meta("unlocked", false)) and (String(door.get_meta("lock_kind", "")) == "prison" or horizontal_player.distance_to(door.global_position) < 2.6)
        var target_y = float(door.get_meta("open_y", 3.75)) if near_door else float(door.get_meta("closed_y", 1.15))
        door.position.y = move_toward(door.position.y, target_y, delta * 3.2)

func _update_rescued_prisoner(delta):
    if not is_instance_valid(rescued_prisoner) or prisoner_health <= 0:
        return
    var target = player.global_position + player.global_transform.basis.z * 2.2
    if not bool(rescued_prisoner.get_meta("outside_cell", false)):
        if rescued_prisoner.global_position.z < -32.5:
            target = Vector3(-16.75, 1.0, -31.5)
        elif rescued_prisoner.global_position.x < -10.0:
            target = Vector3(-9.5, 1.0, -31.5)
        else:
            rescued_prisoner.set_meta("outside_cell", true)
    # After the doorway, use the player's actual position on either side of
    # the rails. The old fixed x=-10 path stopped at the train/carriage wall.
    var horizontal = target - rescued_prisoner.global_position
    horizontal.y = 0
    if not rescued_prisoner.is_on_floor():
        rescued_prisoner.velocity += rescued_prisoner.get_gravity() * delta
    var moving = horizontal.length() > 0.9
    if moving:
        var direction = horizontal.normalized()
        var catchup_speed = 6.2 if horizontal.length() > 5.0 else 4.1
        rescued_prisoner.velocity.x = direction.x * catchup_speed
        rescued_prisoner.velocity.z = direction.z * catchup_speed
        # A low rail is ahead: jump before the capsule collides with it.
        if rescued_prisoner.is_on_floor() and bool(rescued_prisoner.get_meta("outside_cell", false)):
            var rail_ray = PhysicsRayQueryParameters3D.create(rescued_prisoner.global_position + Vector3(0, 0.28, 0), rescued_prisoner.global_position + direction * 1.35 + Vector3(0, 0.28, 0), 1)
            rail_ray.exclude = [rescued_prisoner.get_rid(), player.get_rid()]
            if not get_world_3d().direct_space_state.intersect_ray(rail_ray).is_empty():
                rescued_prisoner.velocity.y = 5.8
        rescued_prisoner.look_at(Vector3(target.x, rescued_prisoner.global_position.y, target.z), Vector3.UP)
    else:
        rescued_prisoner.velocity.x = 0.0
        rescued_prisoner.velocity.z = 0.0
    var before_move = rescued_prisoner.global_position
    rescued_prisoner.move_and_slide()
    var progress = Vector2(rescued_prisoner.global_position.x - before_move.x, rescued_prisoner.global_position.z - before_move.z).length()
    var player_gap = rescued_prisoner.global_position.distance_to(player.global_position)
    var blocked = moving and (progress < 0.018 or (bool(rescued_prisoner.get_meta("outside_cell", false)) and player_gap > 12.0 and progress < delta * 1.1))
    prisoner_stuck_time = prisoner_stuck_time + delta if blocked else 0.0
    if prisoner_stuck_time > 0.85:
        prisoner_stuck_time = 0.0
        if not bool(rescued_prisoner.get_meta("outside_cell", false)):
            rescued_prisoner.global_position = Vector3(-10.0, 1.05, -31.5)
            rescued_prisoner.set_meta("outside_cell", true)
        else:
            # Move directly behind the player if train geometry defeats a jump.
            var player_trail = player.global_position + player.global_transform.basis.z * 2.6
            rescued_prisoner.global_position = Vector3(player_trail.x, max(player_trail.y, 1.05), player_trail.z)
        rescued_prisoner.velocity = Vector3.ZERO
    var model = rescued_prisoner.get_meta("civilian_model", null)
    if model != null and is_instance_valid(model):
        var animator = model.get_meta("civilian_animator", null)
        if animator != null and is_instance_valid(animator):
            var clip = "swat/SWAT_Walk"
            if animator.has_animation(clip):
                animator.speed_scale = 1.0 if moving else 0.0
                if animator.current_animation != clip:
                    animator.play(clip)
                    animator.advance(0.24)
                elif moving:
                    animator.advance(delta)
        rescued_prisoner.set_meta("universal_soldier", model)
        _snap_enemy_visual_to_ground(rescued_prisoner)

func _prisoner_at_extraction() -> bool:
    return is_instance_valid(rescued_prisoner) and prisoner_health > 0 and rescued_prisoner.global_position.distance_to(Vector3(18, 1.1, -132)) < 10.0

func _update_train_countdown():
    if not is_instance_valid(train_countdown_label):
        return
    train_countdown_label.visible = train_escape_active and not game_ended
    if not train_countdown_label.visible:
        return
    var remaining = int(ceil(train_escape_time))
    train_countdown_label.text = "الانفجار خلال %02d:%02d" % [int(remaining / 60), remaining % 60]
    var fraction = train_escape_time / 360.0
    var timer_color = Color(0.96, 0.16, 0.12) if fraction <= 0.25 else (Color(1.0, 0.85, 0.12) if fraction <= 0.50 else Color(0.20, 1.0, 0.24))
    train_countdown_label.add_theme_color_override("font_color", timer_color)

func _update_enemies(delta):
    if player_health <= 0 or mission_completed:
        return
    for current_enemy in enemies.duplicate():
        if not is_instance_valid(current_enemy):
            continue
        if not current_enemy.is_on_floor():
            current_enemy.velocity += current_enemy.get_gravity() * delta
        var enemy_reload_time = max(float(current_enemy.get_meta("reload_time", 0.0)) - delta, 0.0)
        if float(current_enemy.get_meta("reload_time", 0.0)) > 0.0 and enemy_reload_time <= 0.0:
            current_enemy.set_meta("magazine_rounds", 5)
        current_enemy.set_meta("reload_time", enemy_reload_time)
        var health_display = current_enemy.get_meta("health_display", null)
        if health_display != null and is_instance_valid(health_display):
            health_display.look_at(camera.global_position, Vector3.UP)
        var to_player = player.global_position - current_enemy.global_position
        to_player.y = 0
        var distance = to_player.length()
        var alert_time = max(float(current_enemy.get_meta("alert_time", 0.0)) - delta, 0.0)
        var under_fire_time = max(float(current_enemy.get_meta("under_fire_time", 0.0)) - delta, 0.0)
        current_enemy.set_meta("under_fire_time", under_fire_time)
        var sight_distance = 95.0 if String(current_enemy.get_meta("weapon_kind", "")) == "sniper" else (24.0 if quiet_mode else 38.0)
        var is_tower_sniper = bool(current_enemy.get_meta("tower_sniper", false))
        var forward = -current_enemy.global_transform.basis.z
        forward.y = 0
        var facing_player = true if is_tower_sniper else (forward.normalized().dot(to_player.normalized()) > -0.15 if distance > 0.01 else true)
        var sees_player = distance < sight_distance and facing_player and _enemy_can_see_player(current_enemy)
        var hears_player = player_noise > 0.2 and distance < player_noise
        if sees_player or hears_player:
            alert_time = 17.0
            current_enemy.set_meta("last_known_position", player.global_position)
            alert_level = min(alert_level + delta * (45.0 if sees_player else 24.0), 100.0)
            if not bool(current_enemy.get_meta("was_alerted", false)):
                current_enemy.set_meta("was_alerted", true)
                current_enemy.set_meta("reaction_time", 0.45 + randf() * 0.55)
        current_enemy.set_meta("alert_time", alert_time)
        var reaction_time = max(float(current_enemy.get_meta("reaction_time", 0.0)) - delta, 0.0)
        current_enemy.set_meta("reaction_time", reaction_time)
        if alert_time <= 0.0:
            current_enemy.set_meta("was_alerted", false)

        if alert_time > 0.0 and not is_tower_sniper and under_fire_time <= 0.0:
            var maneuver_cooldown = max(float(current_enemy.get_meta("maneuver_cooldown", 0.0)) - delta, 0.0)
            if maneuver_cooldown <= 0.0 and current_enemy.is_on_floor() and distance < 18.0:
                if randf() < 0.48:
                    current_enemy.velocity.y = 3.8
                else:
                    current_enemy.set_meta("roll_time", 0.72)
                maneuver_cooldown = 4.0 + randf() * 4.5
            current_enemy.set_meta("maneuver_cooldown", maneuver_cooldown)

        if alert_time <= 0.0:
            var patrol_radius = float(current_enemy.get_meta("patrol_radius", 0.0))
            if patrol_radius > 0.0:
                var patrol_phase = float(current_enemy.get_meta("patrol_phase", 0.0)) + delta * 0.22
                var patrol_origin: Vector3 = current_enemy.get_meta("patrol_origin", current_enemy.global_position)
                var patrol_target = patrol_origin + Vector3(cos(patrol_phase), 0, sin(patrol_phase)) * patrol_radius
                var patrol_direction = patrol_target - current_enemy.global_position
                patrol_direction.y = 0
                if patrol_direction.length() > 0.7:
                    patrol_direction = patrol_direction.normalized()
                    current_enemy.velocity.x = patrol_direction.x * ENEMY_SPEED * 0.65
                    current_enemy.velocity.z = patrol_direction.z * ENEMY_SPEED * 0.65
                    current_enemy.look_at(Vector3(patrol_target.x, current_enemy.global_position.y, patrol_target.z), Vector3.UP)
                current_enemy.set_meta("patrol_phase", patrol_phase)
            else:
                current_enemy.velocity.x = move_toward(current_enemy.velocity.x, 0.0, delta * 3.0)
                current_enemy.velocity.z = move_toward(current_enemy.velocity.z, 0.0, delta * 3.0)
            _animate_enemy_legs(current_enemy, delta)
            current_enemy.move_and_slide()
            continue

        if is_tower_sniper:
            current_enemy.velocity.x = 0
            current_enemy.velocity.z = 0
            current_enemy.look_at(Vector3(player.global_position.x, current_enemy.global_position.y, player.global_position.z), Vector3.UP)
            var tower_cooldown = float(current_enemy.get_meta("attack_cooldown", 0.0)) - delta
            if tower_cooldown <= 0.0 and reaction_time <= 0.0 and _enemy_can_see_player(current_enemy):
                tower_cooldown = 1.65
                if _enemy_weapon_ready(current_enemy):
                    _enemy_fire_effect(current_enemy)
                if _enemy_can_see_prisoner(current_enemy) and randf() < 0.35:
                    _damage_rescued_prisoner(12)
                    if game_ended:
                        return
                elif float(current_enemy.get_meta("reload_time", 0.0)) <= 0.0 and _enemy_shot_hits(current_enemy, distance):
                    player_health = max(player_health - int(current_enemy.get_meta("weapon_damage", 9)), 0)
                    health_bar.value = player_health
                    _update_health_color()
                    _show_player_hit_effect()
                    status_label.text = "أصابك قناص البرج!"
                    if player_health <= 0:
                        _finish_game(false)
                else:
                    status_label.text = "أخطأت رصاصة القناص الهدف"
            current_enemy.set_meta("attack_cooldown", tower_cooldown)
            _animate_enemy_legs(current_enemy, delta)
            current_enemy.move_and_slide()
            continue

        var tactical_stop = 7.5
        if under_fire_time > 0.0:
            var incoming_origin: Vector3 = current_enemy.get_meta("incoming_fire_origin", player.global_position)
            var urgent_cover: Vector3 = current_enemy.get_meta("cover_target", current_enemy.global_position)
            var cover_distance = current_enemy.global_position.distance_to(urgent_cover)
            if cover_distance > 1.15:
                to_player = urgent_cover - current_enemy.global_position
                to_player.y = 0
                distance = to_player.length()
                tactical_stop = 0.65
                current_enemy.set_meta("tactical_state", "moving_to_cover")
            else:
                to_player = incoming_origin - current_enemy.global_position
                to_player.y = 0
                distance = to_player.length()
                if under_fire_time > 4.0:
                    tactical_stop = distance + 0.50
                    current_enemy.set_meta("tactical_state", "hidden_in_cover")
                else:
                    tactical_stop = 7.5
                    current_enemy.set_meta("tactical_state", "counter_attack")
        elif sees_player:
            var cover_time = float(current_enemy.get_meta("cover_time", 0.0)) - delta
            var cover_target: Vector3 = current_enemy.get_meta("cover_target", current_enemy.global_position)
            if cover_time <= 0.0:
                cover_target = _choose_enemy_cover(current_enemy)
                current_enemy.set_meta("cover_target", cover_target)
                cover_time = 3.5 + randf() * 2.5
            current_enemy.set_meta("cover_time", cover_time)
            if current_enemy.global_position.distance_to(cover_target) > 1.3:
                to_player = cover_target - current_enemy.global_position
                to_player.y = 0
                distance = to_player.length()
                tactical_stop = 0.9
        elif not hears_player:
            var last_known: Vector3 = current_enemy.get_meta("last_known_position", player.global_position)
            to_player = last_known - current_enemy.global_position
            to_player.y = 0
            distance = to_player.length()
            tactical_stop = 1.2
            if distance < 2.0:
                var search_angle = float(current_enemy.get_meta("search_angle", 0.0)) + delta * 0.85
                current_enemy.set_meta("search_angle", search_angle)
                var search_point = last_known + Vector3(cos(search_angle) * 4.5, 0, sin(search_angle) * 4.5)
                to_player = search_point - current_enemy.global_position
                to_player.y = 0
                distance = to_player.length()

        if distance > tactical_stop:
            var enemy_dir = to_player.normalized()
            var separation = Vector3.ZERO
            for other_enemy in enemies:
                if other_enemy == current_enemy or not is_instance_valid(other_enemy):
                    continue
                var away = current_enemy.global_position - other_enemy.global_position
                away.y = 0
                var gap = away.length()
                if gap > 0.01 and gap < ENEMY_SEPARATION:
                    separation += away.normalized() * (ENEMY_SEPARATION - gap)
            var move_dir = (enemy_dir + separation * 1.25).normalized()
            current_enemy.velocity.x = move_dir.x * ENEMY_SPEED
            current_enemy.velocity.z = move_dir.z * ENEMY_SPEED
            var look_target = player.global_position if sees_player else current_enemy.global_position + to_player
            current_enemy.look_at(Vector3(look_target.x, current_enemy.global_position.y, look_target.z), Vector3.UP)
        else:
            current_enemy.velocity.x = 0
            current_enemy.velocity.z = 0
            current_enemy.look_at(Vector3(player.global_position.x, current_enemy.global_position.y, player.global_position.z), Vector3.UP)
            var cooldown = float(current_enemy.get_meta("attack_cooldown", 0.0)) - delta
            if cooldown <= 0.0 and reaction_time <= 0.0 and _enemy_can_see_player(current_enemy):
                cooldown = 1.35
                var fired = _enemy_weapon_ready(current_enemy)
                if fired:
                    _enemy_fire_effect(current_enemy)
                if fired and _enemy_can_see_prisoner(current_enemy) and randf() < 0.35:
                    _damage_rescued_prisoner(9)
                    if game_ended:
                        return
                elif fired and _enemy_shot_hits(current_enemy, distance):
                    player_health = max(player_health - int(current_enemy.get_meta("weapon_damage", 6)), 0)
                    health_bar.value = player_health
                    _update_health_color()
                    _show_player_hit_effect()
                    status_label.text = "أصابك العدو!"
                    if player_health <= 0:
                        _finish_game(false)
                elif fired:
                    status_label.text = "أخطأ العدو إصابتك"
            current_enemy.set_meta("attack_cooldown", cooldown)
        _animate_enemy_legs(current_enemy, delta)
        current_enemy.move_and_slide()

func _choose_enemy_cover(enemy: CharacterBody3D) -> Vector3:
    var candidates = [Vector3(-30, 0.6, 42), Vector3(31, 0.6, 8), Vector3(-8, 0.6, -38), Vector3(12, 0.6, 48), Vector3(-20, 0.6, -8), Vector3(22, 0.6, -25), Vector3(-42, 0.6, 17), Vector3(39, 0.6, 20)]
    if mission_number == 10:
        candidates = [Vector3(-14, 0.6, 148), Vector3(14, 0.6, 135), Vector3(-20, 0.6, 118), Vector3(20, 0.6, 93), Vector3(-18, 0.6, 68), Vector3(18, 0.6, 45), Vector3(-14, 0.6, 18), Vector3(14, 0.6, -12), Vector3(-16, 0.6, -38), Vector3(16, 0.6, -48), Vector3(-11, 0.6, -66), Vector3(11, 0.6, -70), Vector3(-20, 0.6, -99), Vector3(20, 0.6, -105)]
    elif mission_number == 9:
        candidates = [Vector3(-16, 0.6, 150), Vector3(14, 0.6, 153), Vector3(-15, 0.6, 100), Vector3(15, 0.6, 103), Vector3(-15, 0.6, 50), Vector3(15, 0.6, 53), Vector3(-13, 0.6, 19), Vector3(13, 0.6, -1), Vector3(-13, 0.6, -63), Vector3(14, 0.6, -88), Vector3(-12, 0.6, -108), Vector3(-19, 0.6, -117), Vector3(16, 0.6, -121)]
    elif mission_number == 8:
        candidates = [Vector3(-29, 0.6, 106), Vector3(-16, 0.6, 102), Vector3(17, 0.6, 95), Vector3(28, 0.6, 91), Vector3(-24, 0.6, 77), Vector3(25, 0.6, 73), Vector3(-3, 0.6, 32), Vector3(3, 0.6, 15), Vector3(-3, 0.6, -10), Vector3(3, 0.6, -32), Vector3(-3, 0.6, -52), Vector3(-22, 0.6, -85), Vector3(22, 0.6, -90), Vector3(-18, 0.6, -105), Vector3(22, 0.6, -110)]
    var best = enemy.global_position
    var best_score = 99999.0
    for point in candidates:
        var travel = enemy.global_position.distance_to(point)
        if travel > 24.0:
            continue
        var query = PhysicsRayQueryParameters3D.create(camera.global_position, point + Vector3(0, 0.5, 0), 1)
        query.exclude = [player, enemy]
        var blocked = not get_world_3d().direct_space_state.intersect_ray(query).is_empty()
        var score = travel - point.distance_to(player.global_position) * 0.18 - (8.0 if blocked else 0.0)
        if score < best_score:
            best_score = score
            best = point
    return best

func _enemy_shot_hits(enemy: CharacterBody3D, distance: float) -> bool:
    var kind = String(enemy.get_meta("weapon_kind", "rifle"))
    var chance = 0.61 if kind == "sniper" else (0.52 if kind == "rifle" else (0.44 if kind == "pistol" else 0.48))
    chance -= clamp(distance / 105.0, 0.0, 0.28)
    var player_speed = Vector2(player.velocity.x, player.velocity.z).length()
    chance -= clamp(player_speed * 0.068, 0.0, 0.44)
    if stance == 1:
        chance -= 0.08
    elif stance == 2:
        chance -= 0.17
    return randf() < clamp(chance, 0.10, 0.68)

func _enemy_weapon_ready(enemy: CharacterBody3D) -> bool:
    if float(enemy.get_meta("reload_time", 0.0)) > 0.0:
        return false
    var rounds = int(enemy.get_meta("magazine_rounds", 5))
    if rounds <= 0:
        enemy.set_meta("reload_time", 2.2)
        return false
    enemy.set_meta("magazine_rounds", rounds - 1)
    return true

func _animate_enemy_legs(enemy: CharacterBody3D, delta: float):
    var universal_animator = enemy.get_meta("universal_animator", null)
    if universal_animator != null and is_instance_valid(universal_animator):
        var roll_time_3d = max(float(enemy.get_meta("roll_time", 0.0)) - delta, 0.0)
        var reload_time_3d = float(enemy.get_meta("reload_time", 0.0))
        var action_time = max(float(enemy.get_meta("animation_action_time", 0.0)) - delta, 0.0)
        enemy.set_meta("animation_action_time", action_time)
        enemy.set_meta("roll_time", roll_time_3d)
        if action_time > 0.0:
            universal_animator.advance(delta)
            _apply_enemy_fire_pose(enemy, delta)
            _stabilize_enemy_root_bone(enemy)
            _snap_enemy_visual_to_ground(enemy)
            _sync_real_weapon_to_hands(enemy)
            return
        if reload_time_3d > 0.0:
            _set_enemy_safe_guard_pose(enemy)
        elif roll_time_3d > 0.0:
            universal_animator.speed_scale = 1.0
            _set_enemy_animation(enemy, "Roll")
        else:
            var detailed_speed = Vector2(enemy.velocity.x, enemy.velocity.z).length()
            if detailed_speed > ENEMY_SPEED * 0.86:
                universal_animator.speed_scale = 1.28
                _set_enemy_animation(enemy, "Jog_Fwd_Loop")
            elif detailed_speed > 0.10:
                universal_animator.speed_scale = 1.0
                _set_enemy_animation(enemy, "Walk_Loop")
            elif float(enemy.get_meta("alert_time", 0.0)) > 0.0:
                _set_enemy_safe_guard_pose(enemy)
            else:
                _set_enemy_safe_guard_pose(enemy)
        universal_animator.advance(delta)
        _stabilize_enemy_root_bone(enemy)
        _snap_enemy_visual_to_ground(enemy)
        _sync_real_weapon_to_hands(enemy)
        return
    var left_leg = enemy.get_meta("left_leg", null)
    var right_leg = enemy.get_meta("right_leg", null)
    if left_leg == null or right_leg == null or not is_instance_valid(left_leg) or not is_instance_valid(right_leg):
        return
    var horizontal_speed = Vector2(enemy.velocity.x, enemy.velocity.z).length()
    var phase = float(enemy.get_meta("walk_phase", 0.0))
    var left_arm = enemy.get_meta("left_arm", null)
    var right_arm = enemy.get_meta("right_arm", null)
    var body_visual = enemy.get_meta("body_visual", null)
    var gun_visual = enemy.get_meta("gun_visual", null)
    if horizontal_speed > 0.10:
        phase += delta * 8.5
        var swing = sin(phase) * 31.0
        left_leg.rotation_degrees.x = swing
        right_leg.rotation_degrees.x = -swing
        if is_instance_valid(left_arm) and is_instance_valid(right_arm):
            left_arm.rotation_degrees.x = -swing * 0.34
            right_arm.rotation_degrees.x = swing * 0.34
        if is_instance_valid(body_visual):
            body_visual.position.y = 0.05 + abs(sin(phase)) * 0.055
    else:
        left_leg.rotation_degrees.x = move_toward(left_leg.rotation_degrees.x, 0.0, delta * 110.0)
        right_leg.rotation_degrees.x = move_toward(right_leg.rotation_degrees.x, 0.0, delta * 110.0)
        if is_instance_valid(left_arm) and is_instance_valid(right_arm):
            left_arm.rotation_degrees.x = move_toward(left_arm.rotation_degrees.x, 0.0, delta * 90.0)
            right_arm.rotation_degrees.x = move_toward(right_arm.rotation_degrees.x, 0.0, delta * 90.0)
        if is_instance_valid(body_visual):
            body_visual.position.y = move_toward(body_visual.position.y, 0.05, delta * 0.25)
    var reload_time = float(enemy.get_meta("reload_time", 0.0))
    if reload_time > 0.0:
        var reload_motion = sin(reload_time * 7.5)
        if is_instance_valid(left_arm):
            left_arm.rotation_degrees.z = 38.0 + reload_motion * 18.0
        if is_instance_valid(right_arm):
            right_arm.rotation_degrees.z = -22.0 - reload_motion * 12.0
        if is_instance_valid(gun_visual):
            gun_visual.rotation_degrees.z = -20.0 + reload_motion * 8.0
    else:
        if is_instance_valid(left_arm):
            left_arm.rotation_degrees.z = move_toward(left_arm.rotation_degrees.z, 0.0, delta * 120.0)
        if is_instance_valid(right_arm):
            right_arm.rotation_degrees.z = move_toward(right_arm.rotation_degrees.z, 0.0, delta * 120.0)
        if is_instance_valid(gun_visual):
            gun_visual.rotation_degrees.z = move_toward(gun_visual.rotation_degrees.z, 0.0, delta * 120.0)
    var roll_time = max(float(enemy.get_meta("roll_time", 0.0)) - delta, 0.0)
    if roll_time > 0.0:
        var roll_progress = 1.0 - roll_time / 0.72
        enemy.rotation.z = roll_progress * TAU
    else:
        enemy.rotation.z = 0.0
    enemy.set_meta("roll_time", roll_time)
    enemy.set_meta("walk_phase", phase)

func _stabilize_enemy_root_bone(enemy: CharacterBody3D):
    # Several source clips contain vertical root motion. CharacterBody3D owns
    # world movement, so keeping the skeleton root at its rest translation
    # prevents different clips from lifting or burying the soldier.
    var skeleton = enemy.get_meta("universal_skeleton", null)
    var root_bone = int(enemy.get_meta("universal_root_bone", -1))
    if skeleton == null or not is_instance_valid(skeleton) or root_bone < 0:
        return
    skeleton.set_bone_pose_position(root_bone, skeleton.get_bone_rest(root_bone).origin)

func _snap_enemy_visual_to_ground(enemy: CharacterBody3D):
    # Align the lowest point of the imported boots with the actual collision
    # surface instead of relying on one hard-coded height for every animation.
    var soldier = enemy.get_meta("universal_soldier", null)
    if soldier == null or not is_instance_valid(soldier):
        return
    var query = PhysicsRayQueryParameters3D.create(
        enemy.global_position + Vector3.UP * 2.0,
        enemy.global_position + Vector3.DOWN * 4.0,
        1
    )
    query.exclude = [enemy]
    query.collide_with_bodies = true
    query.collide_with_areas = false
    var hit = get_world_3d().direct_space_state.intersect_ray(query)
    if hit.is_empty():
        return
    var lowest_y = INF
    for mesh_node in soldier.find_children("*", "MeshInstance3D", true, false):
        var body_mesh = mesh_node as MeshInstance3D
        if not body_mesh.visible or body_mesh.mesh == null:
            continue
        var box = body_mesh.get_aabb()
        for x in [box.position.x, box.end.x]:
            for y in [box.position.y, box.end.y]:
                for z in [box.position.z, box.end.z]:
                    lowest_y = min(lowest_y, body_mesh.to_global(Vector3(x, y, z)).y)
    if lowest_y == INF:
        return
    var correction = float(hit.position.y) + 0.012 - lowest_y
    soldier.position.y += clamp(correction, -0.14, 0.14)

func _enemy_can_see_player(enemy: CharacterBody3D) -> bool:
    var muzzle = enemy.get_meta("muzzle_marker", null)
    if muzzle == null or not is_instance_valid(muzzle):
        return false
    # At least one ray must reach the player; walls and cover block the shot.
    var origin = muzzle.global_position
    var side = camera.global_transform.basis.x.normalized() * 0.16
    var destinations = [camera.global_position, camera.global_position - side, camera.global_position + side]
    for destination in destinations:
        var query = PhysicsRayQueryParameters3D.create(origin, destination, 1)
        query.exclude = [enemy]
        query.collide_with_bodies = true
        query.collide_with_areas = false
        var hit = get_world_3d().direct_space_state.intersect_ray(query)
        if not hit.is_empty() and hit.get("collider") == player:
            return true
    return false

func _enemy_can_see_prisoner(enemy: CharacterBody3D) -> bool:
    if not is_instance_valid(rescued_prisoner) or prisoner_health <= 0:
        return false
    if enemy.global_position.distance_to(rescued_prisoner.global_position) > 28.0:
        return false
    var muzzle = enemy.get_meta("muzzle_marker", null)
    if muzzle == null or not is_instance_valid(muzzle):
        return false
    var query = PhysicsRayQueryParameters3D.create(muzzle.global_position, rescued_prisoner.global_position + Vector3(0, 0.4, 0), 1)
    query.exclude = [enemy]
    var hit = get_world_3d().direct_space_state.intersect_ray(query)
    return not hit.is_empty() and hit.get("collider") == rescued_prisoner

func _damage_rescued_prisoner(amount: int):
    if not is_instance_valid(rescued_prisoner) or prisoner_health <= 0:
        return
    prisoner_health = max(prisoner_health - amount, 0)
    status_label.text = "الأسير تحت النار - صحته %d%%" % prisoner_health
    if prisoner_health <= 0:
        mission_failure_reason = "قُتل الأسير قبل وصوله إلى الإخلاء"
        _finish_game(false)

func _enemy_fire_effect(enemy: CharacterBody3D):
    _set_enemy_safe_guard_pose(enemy)
    _start_enemy_fire_pose(enemy)
    enemy.set_meta("animation_action_time", 0.38)
    var flash = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = 0.12
    sphere.height = 0.24
    flash.mesh = sphere
    flash.position = Vector3.ZERO
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(1.0, 0.08, 0.02)
    material.emission_enabled = true
    material.emission = Color(1.0, 0.02, 0.0)
    material.emission_energy_multiplier = 4.0
    flash.material_override = material
    var muzzle = enemy.get_meta("muzzle_marker", null)
    if muzzle != null and is_instance_valid(muzzle):
        muzzle.add_child(flash)
    else:
        enemy.add_child(flash)
    var enemy_shot = AudioStreamPlayer3D.new()
    enemy_shot.stream = _make_shot_sound()
    enemy_shot.unit_size = 7.0
    enemy_shot.max_distance = 90.0
    enemy_shot.volume_db = _sound_volume_db()
    enemy.add_child(enemy_shot)
    enemy_shot.play()
    get_tree().create_timer(0.12).timeout.connect(func():
        if is_instance_valid(flash):
            flash.queue_free()
    )
    get_tree().create_timer(0.35).timeout.connect(func():
        if is_instance_valid(enemy_shot):
            enemy_shot.queue_free()
    )

func _update_pickups():
    for pickup in pickups.duplicate():
        if not is_instance_valid(pickup):
            continue
        pickup.rotate_y(0.025)
        var marker = pickup.get_meta("pickup_marker", null)
        if marker != null and is_instance_valid(marker):
            var phase = float(pickup.get_meta("marker_phase", 0.0)) + 0.055
            var base_y = float(pickup.get_meta("marker_base_y", marker.position.y))
            marker.position.y = base_y + sin(phase) * (0.10 / max(pickup.scale.y, 0.01))
            marker.rotate_y(0.035)
            pickup.set_meta("marker_phase", phase)
        if player.global_position.distance_to(pickup.global_position) < 2.4:
            var kind = String(pickup.get_meta("pickup_kind", ""))
            if kind in ["pistol", "sniper", "rifle", "shotgun", "grenade"]:
                _store_captured_weapon(kind)
                pickups.erase(pickup)
                pickup.queue_free()
                status_label.text = "تمت إضافة السلاح تلقائيًا إلى خانة الأسلحة"
                _update_objective_text()
                _check_mission_completion()
                continue
            if kind in ["ammo", "health"]:
                status_label.text = "اضغط زر اليد مرة واحدة للالتقاط"
    for objective in objective_nodes:
        if not is_instance_valid(objective):
            continue
        var objective_marker = objective.get_meta("pickup_marker", null)
        if objective_marker != null and is_instance_valid(objective_marker):
            var objective_phase = float(objective.get_meta("marker_phase", 0.0)) + 0.055
            var objective_base_y = float(objective.get_meta("marker_base_y", objective_marker.position.y))
            objective_marker.position.y = objective_base_y + sin(objective_phase) * (0.10 / max(objective.scale.y, 0.01))
            objective_marker.rotate_y(0.035)
            objective.set_meta("marker_phase", objective_phase)

func _shoot():
    if game_ended or is_reloading:
        return
    if ammo <= 0:
        _reload_weapon()
        return
    ammo -= 1
    player_has_fired = true
    _update_ammo_text()
    player_noise = 34.0 if current_weapon == "grenade" else (30.0 if current_weapon == "shotgun" else (24.0 if current_weapon == "rifle" else (12.0 if current_weapon == "pistol" else 45.0)))
    alert_level = min(alert_level + 18.0, 100.0)
    _play_shot_effects()

    var center = get_viewport().get_visible_rect().size * 0.5
    var origin = camera.project_ray_origin(center)
    var end = origin + camera.project_ray_normal(center) * weapon_range
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.exclude = [player]
    var hit = get_world_3d().direct_space_state.intersect_ray(query)
    var travelled_end: Vector3 = hit.get("position", end) if not hit.is_empty() else end
    var directly_hit_enemy = hit.get("collider", null) if not hit.is_empty() else null
    _alert_enemies_near_shot(origin, travelled_end, directly_hit_enemy)
    if current_weapon == "grenade":
        var blast_point = hit.get("position", end) if not hit.is_empty() else end
        _explode_grenade(blast_point)
        return
    if hit:
        var collider = hit.get("collider")
        if collider and collider.has_meta("enemy"):
            _spawn_impact_effect(hit.get("position"), hit.get("normal", Vector3.UP), "blood")
            _pulse_crosshair_hit()
            var remaining_health = int(collider.get_meta("health", 3)) - weapon_damage
            collider.set_meta("health", remaining_health)
            _update_enemy_health_display(collider, remaining_health)
            if remaining_health <= 0:
                var dropped_weapon = String(collider.get_meta("weapon_kind", "rifle"))
                _make_pickup(collider.global_position + Vector3(0, -0.35, 0), dropped_weapon)
                _drop_special_enemy_item(collider)
                enemies.erase(collider)
                _retire_enemy_with_animation(collider as CharacterBody3D)
                enemies_defeated += 1
                _update_objective_text()
                _check_mission_completion()
                if not game_ended:
                    if enemies.is_empty() or enemies_defeated >= enemy_goal:
                        status_label.text = "تم القضاء على الحراس - أكمل بقية أهداف المهمة"
                    else:
                        status_label.text = "تم إسقاط حارس: %d / %d" % [enemies_defeated, enemy_goal]
            else:
                status_label.text = "أصبت العدو - بقي %d" % remaining_health
        elif collider and collider.has_meta("objective_kind") and String(collider.get_meta("objective_kind")) in ["heavy", "missile_depot", "ammo_depot", "fuel_tank", "patrol_boat"]:
            _spawn_impact_effect(hit.get("position"), hit.get("normal", Vector3.UP), "metal")
            var destroyed_kind = String(collider.get_meta("objective_kind"))
            if destroyed_kind == "missile_depot" and (not explosives_collected or not data_downloaded):
                status_label.text = "اجمع المتفجرات وانسخ بيانات الإطلاق أولاً"
                return
            if destroyed_kind in ["ammo_depot", "fuel_tank", "patrol_boat"] and (not explosives_collected or not data_downloaded):
                status_label.text = "اجمع المتفجرات واخترق غرفة الاتصالات أولاً"
                return
            var objective_health = int(collider.get_meta("health", 5)) - weapon_damage
            collider.set_meta("health", objective_health)
            status_label.text = "إصابة الهدف التخريبي - بقي %d" % max(objective_health, 0) if destroyed_kind in ["ammo_depot", "fuel_tank", "patrol_boat"] else ("إصابة مستودع الصواريخ - بقي %d" % max(objective_health, 0) if destroyed_kind == "missile_depot" else "إصابة السلاح الثقيل - بقي %d" % max(objective_health, 0))
            if objective_health <= 0:
                if destroyed_kind == "missile_depot":
                    missile_depots_destroyed += 1
                    status_label.text = "تم تدمير مستودع الصواريخ %d / 2" % missile_depots_destroyed
                elif destroyed_kind in ["ammo_depot", "fuel_tank", "patrol_boat"]:
                    port_targets_destroyed += 1
                    status_label.text = "تم تدمير أهداف الميناء %d / 3" % port_targets_destroyed
                else:
                    heavy_weapon_destroyed = true
                    status_label.text = "تم تدمير السلاح الثقيل"
                objective_nodes.erase(collider)
                collider.queue_free()
                _update_objective_text()
                _check_mission_completion()
        elif collider and collider.has_meta("target"):
            _spawn_impact_effect(hit.get("position"), hit.get("normal", Vector3.UP), "stone")
            status_label.text = "إصابة!"
            collider.queue_free()
        else:
            var surface_kind = String(collider.get_meta("surface_type", "stone")) if collider else "stone"
            _spawn_impact_effect(hit.get("position"), hit.get("normal", Vector3.UP), surface_kind)
            status_label.text = "طلقة"
    else:
        status_label.text = "طلقة"

func _alert_enemies_near_shot(shot_start: Vector3, shot_end: Vector3, directly_hit_enemy):
    var shot_vector = shot_end - shot_start
    var shot_length_squared = shot_vector.length_squared()
    if shot_length_squared < 0.01:
        return
    for enemy in enemies:
        if not is_instance_valid(enemy) or enemy == directly_hit_enemy:
            continue
        var enemy_center = enemy.global_position + Vector3(0, 0.45, 0)
        var along = clamp((enemy_center - shot_start).dot(shot_vector) / shot_length_squared, 0.0, 1.0)
        var nearest_point = shot_start + shot_vector * along
        var miss_distance = enemy_center.distance_to(nearest_point)
        # Only a bullet genuinely passing close to the body causes the sharp
        # near-miss reaction. A wall shortens shot_end and protects enemies behind it.
        if miss_distance > 2.35:
            continue
        enemy.set_meta("alert_time", 21.0)
        enemy.set_meta("under_fire_time", 8.0)
        enemy.set_meta("incoming_fire_origin", shot_start)
        enemy.set_meta("last_known_position", player.global_position)
        enemy.set_meta("was_alerted", true)
        enemy.set_meta("reaction_time", 0.08 + randf() * 0.16)
        enemy.set_meta("cover_target", _choose_cover_from_shot(enemy, shot_start))
        enemy.set_meta("cover_time", 8.0)
        enemy.set_meta("maneuver_cooldown", 5.0)
        enemy.set_meta("roll_time", 0.0)
        enemy.set_meta("tactical_state", "moving_to_cover")
        alert_level = min(alert_level + 14.0, 100.0)
        if not bool(enemy.get_meta("tower_sniper", false)):
            var away = enemy.global_position - player.global_position
            away.y = 0
            if away.length() < 0.1:
                away = Vector3.FORWARD
            var evade_side = Vector3(-away.z, 0, away.x).normalized()
            if randf() < 0.5:
                evade_side = -evade_side
            enemy.velocity.x = evade_side.x * ENEMY_SPEED * 2.1
            enemy.velocity.z = evade_side.z * ENEMY_SPEED * 2.1
        status_label.text = "حدد العدو مصدر الطلقة ويتحرك إلى ساتر!"

func _choose_cover_from_shot(enemy: CharacterBody3D, shot_origin: Vector3) -> Vector3:
    var away = enemy.global_position - shot_origin
    away.y = 0
    if away.length() < 0.1:
        away = Vector3.FORWARD
    away = away.normalized()
    var side = Vector3(-away.z, 0, away.x)
    var candidates = [
        enemy.global_position + side * 5.5 + away * 2.0,
        enemy.global_position - side * 5.5 + away * 2.0,
        enemy.global_position + away * 6.5,
        _choose_enemy_cover(enemy)
    ]
    var best = candidates[0]
    var best_score = -99999.0
    for candidate in candidates:
        candidate.x = clamp(candidate.x, -66.0, 66.0)
        candidate.z = clamp(candidate.z, -136.0 if mission_number >= 3 else -66.0, 146.0)
        candidate.y = enemy.global_position.y
        var path_query = PhysicsRayQueryParameters3D.create(enemy.global_position + Vector3(0, 0.6, 0), candidate + Vector3(0, 0.6, 0), 1)
        path_query.exclude = [enemy]
        var path_blocked = not get_world_3d().direct_space_state.intersect_ray(path_query).is_empty()
        if path_blocked:
            continue
        var cover_query = PhysicsRayQueryParameters3D.create(shot_origin + Vector3(0, 0.5, 0), candidate + Vector3(0, 0.5, 0), 1)
        cover_query.exclude = [player, enemy]
        var protected = not get_world_3d().direct_space_state.intersect_ray(cover_query).is_empty()
        var score = (12.0 if protected else 0.0) + candidate.distance_to(shot_origin) * 0.10 - candidate.distance_to(enemy.global_position) * 0.08
        if score > best_score:
            best_score = score
            best = candidate
    return best

func _spawn_impact_effect(hit_position: Vector3, hit_normal: Vector3, effect_kind: String):
    var particle_count = 13 if effect_kind == "blood" else (15 if effect_kind == "metal" else 11)
    var effect_color = Color(0.55, 0.015, 0.02) if effect_kind == "blood" else (Color(1.0, 0.65, 0.08) if effect_kind == "metal" else (Color(0.68, 0.55, 0.38) if effect_kind == "ground" else Color(0.62, 0.59, 0.53)))
    for i in range(particle_count):
        var fragment = MeshInstance3D.new()
        if effect_kind == "ground":
            var dust_mesh = SphereMesh.new()
            dust_mesh.radius = 0.045 + randf() * 0.055
            dust_mesh.height = dust_mesh.radius * 2.0
            fragment.mesh = dust_mesh
        else:
            var shard_mesh = BoxMesh.new()
            shard_mesh.size = Vector3(0.025 + randf() * 0.045, 0.025 + randf() * 0.08, 0.025 + randf() * 0.045)
            fragment.mesh = shard_mesh
        var material = StandardMaterial3D.new()
        material.albedo_color = effect_color.lightened(randf() * 0.18)
        if effect_kind == "metal":
            material.emission_enabled = true
            material.emission = Color(1.0, 0.32 + randf() * 0.35, 0.02)
            material.emission_energy_multiplier = 4.5
        fragment.material_override = material
        fragment.position = hit_position + hit_normal * 0.035
        fragment.rotation = Vector3(randf() * TAU, randf() * TAU, randf() * TAU)
        add_child(fragment)
        var spread = Vector3(randf_range(-1.0, 1.0), randf_range(0.15, 1.1), randf_range(-1.0, 1.0)).normalized()
        var travel_direction = (spread + hit_normal * 0.80).normalized()
        var travel = 0.45 + randf() * (1.30 if effect_kind == "metal" else 0.75)
        var impact_tween = create_tween().set_parallel(true)
        impact_tween.tween_property(fragment, "position", fragment.position + travel_direction * travel + Vector3(0, -0.22, 0), 0.42 + randf() * 0.28)
        impact_tween.tween_property(fragment, "scale", Vector3.ZERO, 0.55 + randf() * 0.25)
        impact_tween.chain().tween_callback(fragment.queue_free)

func _pulse_crosshair_hit():
    if not is_instance_valid(cross_label):
        return
    cross_label.pivot_offset = cross_label.size * 0.5
    cross_label.modulate = Color(1.0, 0.02, 0.01)
    cross_label.scale = Vector2(1.65, 1.65)
    var hit_tween = create_tween().set_parallel(true)
    hit_tween.tween_property(cross_label, "scale", Vector2.ONE, 0.16)
    hit_tween.tween_property(cross_label, "modulate", Color.WHITE, 0.28)
    Input.vibrate_handheld(28)

func _explode_grenade(blast_point: Vector3):
    var blast = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = 1.1
    sphere.height = 2.2
    blast.mesh = sphere
    blast.global_position = blast_point
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(1.0, 0.20, 0.02, 0.72)
    material.emission_enabled = true
    material.emission = Color(1.0, 0.08, 0.0)
    material.emission_energy_multiplier = 6.0
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    blast.material_override = material
    add_child(blast)
    for enemy in enemies.duplicate():
        if is_instance_valid(enemy) and enemy.global_position.distance_to(blast_point) < 5.0:
            var remaining = int(enemy.get_meta("health", 3)) - 4
            if remaining <= 0:
                var dropped_weapon = String(enemy.get_meta("weapon_kind", "rifle"))
                _make_pickup(enemy.global_position + Vector3(0, -0.35, 0), dropped_weapon)
                _drop_special_enemy_item(enemy)
                enemies.erase(enemy)
                _retire_enemy_with_animation(enemy)
                enemies_defeated += 1
            else:
                enemy.set_meta("health", remaining)
                _update_enemy_health_display(enemy, remaining)
    if player.global_position.distance_to(blast_point) < 3.2:
        player_health = max(player_health - 35, 0)
        health_bar.value = player_health
        _update_health_color()
    status_label.text = "انفجار قنبلة"
    _update_objective_text()
    _check_mission_completion()
    get_tree().create_timer(0.22).timeout.connect(func():
        if is_instance_valid(blast):
            blast.queue_free()
    )

func _update_enemy_health_display(enemy, remaining_health: int):
    var display = enemy.get_meta("health_display", null)
    if display == null or not is_instance_valid(display):
        return
    for i in range(display.get_child_count()):
        var maximum_health = max(int(enemy.get_meta("max_health", 3)), 1)
        var visible_segments = int(ceil(float(remaining_health) * float(display.get_child_count()) / float(maximum_health)))
        display.get_child(i).visible = i < visible_segments

func _drop_special_enemy_item(enemy: CharacterBody3D):
    if bool(enemy.get_meta("drops_gate_key", false)) and not has_gate_key:
        _make_objective(enemy.global_position + Vector3(0.55, -0.20, 0), "gate_key")
        status_label.text = "سقط مفتاح بوابة المعسكر من الحارس"
    if bool(enemy.get_meta("drops_access_card", false)) and not has_gate_key:
        _make_objective(enemy.global_position + Vector3(0.55, -0.20, 0), "access_card")
        status_label.text = "سقطت بطاقة دخول المستودع من الضابط"

func _interact():
    if game_ended or not game_started:
        return
    var nearby_ladder = _get_nearby_ladder()
    if nearby_ladder != null:
        active_ladder = nearby_ladder
        player_collision.disabled = true
        player.velocity = Vector3.ZERO
        if player.global_position.y > 8.0:
            player.global_position = active_ladder + Vector3(0, 9.75, 1.49)
        else:
            player.global_position = active_ladder + Vector3(0, 1.1, 1.49)
        status_label.text = "السهم للأمام للصعود، والخلف للنزول"
        return
    var locked_door = _get_nearby_locked_door()
    if locked_door != null and _has_key_for_door(String(locked_door.get_meta("lock_kind", ""))):
        var lock_kind = String(locked_door.get_meta("lock_kind", ""))
        locked_door.set_meta("unlocked", true)
        if lock_kind == "gate":
            gate_unlocked = true
            status_label.text = "تم فتح بوابة المعسكر"
        elif lock_kind == "building1":
            building1_unlocked = true
            status_label.text = "تم فتح مبنى محطة القطار" if mission_number == 6 else ("تم فتح بوابة نفق المنشأة" if mission_number == 5 else ("تم فتح حظيرة أسلحة المطار" if mission_number == 4 else ("تم فتح مستودع الأسلحة" if mission_number == 3 else ("تم فتح الثكنة الأولى" if mission_number == 2 else "تم فتح المبنى الأول"))))
        elif lock_kind == "prison":
            status_label.text = "فُتح باب غرفة الأسير؛ ادخل وتحدث معه"
        else:
            building2_unlocked = true
            status_label.text = "تم فتح المختبر السري" if mission_number == 5 else ("تم فتح غرفة اتصالات الميناء" if mission_number == 3 else ("تم فتح مركز القيادة بكلمة السر" if mission_number == 2 else "تم فتح مبنى الهدف الرئيسي"))
        _update_objective_text()
        return
    var nearest_pickup: Area3D = null
    var pickup_distance_limit = 2.4
    for pickup in pickups:
        if not is_instance_valid(pickup):
            continue
        var pickup_kind = String(pickup.get_meta("pickup_kind", ""))
        var distance_to_pickup = player.global_position.distance_to(pickup.global_position)
        if pickup_kind in ["pistol", "sniper", "rifle", "shotgun", "grenade", "ammo", "health"] and distance_to_pickup < pickup_distance_limit:
            nearest_pickup = pickup
            pickup_distance_limit = distance_to_pickup
    if nearest_pickup != null:
        var collected_kind = String(nearest_pickup.get_meta("pickup_kind"))
        if collected_kind in ["pistol", "sniper", "rifle", "shotgun", "grenade"]:
            _store_captured_weapon(collected_kind)
        elif collected_kind == "ammo":
            var maximum_ammo = 12 if current_weapon == "sniper" else (8 if current_weapon == "shotgun" else (15 if current_weapon == "pistol" else (3 if current_weapon == "grenade" else 30)))
            ammo = min(ammo + 15, maximum_ammo)
            ammo_box_collected = true
            status_label.text = "تم التقاط صندوق الذخيرة"
            _update_ammo_text()
        elif collected_kind == "health":
            health_kits += 1
            health_box_collected = true
            status_label.text = "تم التقاط حقيبة علاج"
            _refresh_health_button()
        pickups.erase(nearest_pickup)
        nearest_pickup.queue_free()
        _update_objective_text()
        _check_mission_completion()
        return

    var nearest: Node3D = null
    var nearest_distance = 3.0
    for objective in objective_nodes:
        if not is_instance_valid(objective):
            continue
        var distance = player.global_position.distance_to(objective.global_position)
        if distance < nearest_distance:
            nearest = objective
            nearest_distance = distance
    if nearest == null:
        status_label.text = "اقترب من المفتاح أو الحاسوب للتفاعل"
        return
    var kind = String(nearest.get_meta("objective_kind", ""))
    if kind == "final_generator":
        if not _final_area_clear(nearest.global_position, 25.0):
            status_label.text = "اقضِ على حراس المولد قبل تعطيله"
            return
        final_generators_disabled += 1
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل مولد %d من 3" % final_generators_disabled
    elif kind == "final_allies":
        if final_generators_disabled < 3:
            status_label.text = "عطّل المولدات الثلاثة لفتح جناح الاحتجاز"
            return
        final_allies_freed = true
        _spawn_final_ally(nearest.global_position + Vector3(0, 0.25, 2.2))
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تحرير فريق المساندة؛ سيبقى معك أثناء الاقتحام"
    elif kind == "final_radio":
        if not final_allies_freed:
            status_label.text = "حرر فريق المساندة قبل اقتحام مركز الاتصالات"
            return
        if not _final_squad_clear("final_sniper"):
            status_label.text = "اقضِ على قناصي الأبراج قبل قطع الاتصالات"
            return
        final_radio_disabled = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم قطع الاتصالات؛ اقتحم مبنى القيادة واقضِ على القائد"
    elif kind == "final_data":
        if not final_boss_defeated:
            status_label.text = "اهزم قائد القلعة قبل أخذ القرص السري"
            return
        final_data_taken = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "أخذت القرص السري؛ ازرع ثلاث عبوات في مبنى القيادة"
    elif kind == "final_charge":
        if not final_data_taken:
            status_label.text = "خذ القرص السري من غرفة القيادة أولاً"
            return
        final_charges_planted += 1
        objective_nodes.erase(nearest)
        nearest.queue_free()
        if final_charges_planted >= 3:
            final_escape_active = true
            final_escape_time = 210.0
            _spawn_final_reinforcements()
            status_label.text = "زرعت العبوات؛ قاتل طريقك إلى المروحية قبل انهيار القلعة"
        else:
            status_label.text = "تم زرع عبوة %d من 3" % final_charges_planted
    elif kind == "final_extraction":
        if not final_escape_active or not _final_squad_clear("final_reinforcement"):
            status_label.text = "ازرع العبوات واقضِ على القوة الأخيرة قبل ركوب المروحية"
            return
        extraction_reached = true
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "convoy_checkpoint":
        var checkpoint_index = int(nearest.get_meta("checkpoint_index", -1))
        if checkpoint_index != convoy_checkpoints:
            status_label.text = "أمّن نقاط الطريق بالترتيب قبل تشغيل هذه البوابة"
            return
        if not _convoy_checkpoint_clear(checkpoint_index):
            status_label.text = "اقضِ على حراس نقطة الطريق أولاً"
            return
        convoy_checkpoints += 1
        convoy_checkpoint_gates[checkpoint_index].position.y = -3.0
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تأمين نقطة الطريق %d من 3" % convoy_checkpoints
    elif kind == "convoy_intel":
        if convoy_checkpoints < 3:
            status_label.text = "اعبر نقاط الحراسة الثلاث قبل جمع معلومات القافلة"
            return
        convoy_intel_taken = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "عرفت موعد مرور القافلة؛ اقضِ على القناصين واصعد إلى أحد البرجين"
    elif kind == "convoy_documents":
        if not convoy_stopped or not _convoy_squad_clear("convoy_guard"):
            status_label.text = "اقضِ على حراس القافلة قبل أخذ الوثائق"
            return
        convoy_documents_taken = true
        convoy_escape_time = 150.0
        objective_nodes.erase(nearest)
        nearest.queue_free()
        _spawn_convoy_reinforcements()
        status_label.text = "استوليت على الوثائق؛ انسحب إلى عربة الإخلاء قبل وصول بقية التعزيزات"
    elif kind == "convoy_extraction":
        if not convoy_documents_taken or not _convoy_squad_clear("convoy_reinforcement"):
            status_label.text = "احصل على الوثائق واقضِ على دورية التعزيزات أولاً"
            return
        extraction_reached = true
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "gate_key":
        has_gate_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "أخذت مفتاح بوابة المعسكر"
    elif kind == "building1_key":
        has_building1_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "عثرت على مفتاح المبنى الأول"
    elif kind == "building2_key":
        has_building2_key = true
        has_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "عثرت داخل المبنى الأول على مفتاح مبنى الحاسوب"
    elif kind == "access_card":
        has_building1_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "أخذت بطاقة محطة القطار" if mission_number == 6 else ("أخذت بطاقة بوابة النفق" if mission_number == 5 else ("أخذت بطاقة دخول حظيرة المطار" if mission_number == 4 else ("أخذت بطاقة مستودع الأسلحة" if mission_number == 3 else "أخذت بطاقة دخول الثكنة الأولى")))
    elif kind == "alarm_panel":
        alarm_disabled = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل جهاز الإنذار"
    elif kind == "security_console":
        port_surveillance_disabled = true
        alarm_disabled = true
        for scene_node in get_children():
            if scene_node is SpotLight3D:
                scene_node.visible = false
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل كاميرات المراقبة وكشافات الميناء"
    elif kind == "airbase_security":
        port_surveillance_disabled = true
        alarm_disabled = true
        for scene_node in get_children():
            if scene_node is SpotLight3D:
                scene_node.visible = false
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل كاميرات وكشافات المطار"
    elif kind == "facility_power":
        if not building1_unlocked:
            status_label.text = "افتح بوابة النفق ببطاقة الضابط أولاً"
            return
        alarm_disabled = true
        port_surveillance_disabled = true
        for scene_node in get_children():
            if scene_node is SpotLight3D:
                scene_node.visible = false
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل مولد الكهرباء وكاميرات المنشأة"
    elif kind == "bridge_weapons":
        if not _bridge_squad_clear("bridge_first_guard"):
            status_label.text = "اقضِ على حراس الثكنة الأولى قبل أخذ معداتهم"
            return
        bridge_weapons_taken = true
        _store_captured_weapon("rifle")
        _equip_weapon("rifle")
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "استوليت على أسلحة الحراسة والذخيرة"
    elif kind == "bridge_controls":
        if not _bridge_squad_clear("bridge_first_guard"):
            status_label.text = "أمّن الثكنة الأولى قبل تشغيل لوحة البوابات"
            return
        bridge_controls_taken = true
        if is_instance_valid(bridge_entry_gate):
            bridge_entry_gate.position.y = -3.0
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "فُتحت البوابة الأولى؛ يمكنك دخول الجسر"
    elif kind == "bridge_explosives":
        if not _bridge_squad_clear("bridge_first_guard"):
            status_label.text = "اقضِ على حراس الثكنة قبل أخذ المتفجرات"
            return
        bridge_explosives_taken = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "حصلت على ثلاث عبوات؛ ازرعها في مواقع الجسر المحددة"
    elif kind == "bridge_charge":
        if not bridge_weapons_taken or not bridge_controls_taken or not bridge_explosives_taken:
            status_label.text = "استولِ على السلاح ولوحة التحكم والمتفجرات من الثكنة أولاً"
            return
        bridge_charges_planted += 1
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم زرع العبوة %d من 3" % bridge_charges_planted
        if bridge_charges_planted == 3:
            if is_instance_valid(bridge_exit_gate):
                bridge_exit_gate.position.y = -3.0
            bridge_escape_active = true
            bridge_escape_time = 240.0
            _update_bridge_countdown()
            status_label.text = "العبوات جاهزة؛ اعبر إلى الثكنة الثانية وأخلِ المكان قبل انفجار الجسر"
    elif kind == "bridge_extraction":
        if bridge_charges_planted < 3 or not _bridge_squad_clear("bridge_bridge_guard") or not _bridge_squad_clear("bridge_second_guard"):
            status_label.text = "ازرع العبوات الثلاث واقضِ على حراس الجسر والثكنة الثانية أولاً"
            return
        extraction_reached = true
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "canyon_relay":
        canyon_relays_disabled += 1
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل برج الاتصال %d من 2" % canyon_relays_disabled
    elif kind == "canyon_intel":
        if canyon_relays_disabled < 2:
            status_label.text = "عطّل برجي الاتصال قبل نسخ بيانات المحطة"
            return
        canyon_intel_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم نسخ بيانات الاتصالات؛ اتجه إلى مركبة الإخلاء"
    elif kind == "canyon_extraction":
        if canyon_relays_disabled < 2 or not canyon_intel_collected:
            status_label.text = "عطّل البرجين واجمع بيانات الاتصالات أولاً"
            return
        extraction_reached = true
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "train_power":
        train_lights_disabled = true
        alarm_disabled = true
        for scene_node in get_children():
            if scene_node is SpotLight3D:
                scene_node.visible = false
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تعطيل كشافات المحطة ونظام الإنذار"
    elif kind == "explosives":
        if not documents_collected:
            status_label.text = "صندوق المتفجرات مقفل - ابحث عن كلمة السر"
            return
        explosives_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم جمع العبوات المتفجرة"
    elif kind == "port_explosives":
        if not documents_collected:
            status_label.text = "خزانة المتفجرات مقفلة - ابحث عن جدول السفينة"
            return
        explosives_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم أخذ عبوات تخريب أهداف الميناء"
    elif kind == "airbase_explosives":
        if not building1_unlocked:
            status_label.text = "افتح حظيرة الأسلحة ببطاقة الضابط أولاً"
            return
        explosives_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم أخذ ثلاث عبوات لتخريب المطار"
    elif kind == "facility_explosives":
        if not documents_collected:
            status_label.text = "تحتاج رمز المختبر لفتح خزانة المتفجرات"
            return
        explosives_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم أخذ عبوتين لتخريب المنشأة"
    elif kind == "train_explosives":
        if not building1_unlocked:
            status_label.text = "افتح مستودع المحطة ببطاقة الضابط أولاً"
            return
        explosives_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم أخذ عبوة تخريب عربة الأسلحة"
    elif kind == "documents":
        documents_collected = true
        has_building2_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "وجدت كلمة سر مركز القيادة ومواقع الصواريخ"
    elif kind == "shipping_manifest":
        if not building1_unlocked:
            status_label.text = "تحتاج بطاقة الضابط لفتح المستودع"
            return
        documents_collected = true
        has_building2_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "وجدت جدول السفينة وكلمة سر غرفة الاتصالات"
    elif kind == "facility_code":
        if not alarm_disabled:
            status_label.text = "عطّل مولد الكهرباء قبل دخول غرفة الضباط"
            return
        documents_collected = true
        has_building2_key = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "وجدت رمز المختبر السري"
    elif kind == "data_terminal":
        if not building2_unlocked or not documents_collected:
            status_label.text = "افتح مركز القيادة باستخدام كلمة السر أولاً"
            return
        if not data_download_in_progress:
            _start_data_download(nearest)
        return
    elif kind == "port_terminal":
        if not building2_unlocked or not documents_collected:
            status_label.text = "افتح غرفة الاتصالات بكلمة السر أولاً"
            return
        if not data_download_in_progress:
            _start_data_download(nearest)
        return
    elif kind == "airbase_terminal":
        if not port_surveillance_disabled:
            status_label.text = "عطّل مراقبة المطار قبل اختراق غرفة العمليات"
            return
        if not data_download_in_progress:
            _start_data_download(nearest)
        return
    elif kind == "facility_terminal":
        if not building2_unlocked or not documents_collected or not alarm_disabled:
            status_label.text = "عطّل الكهرباء وافتح المختبر بالرمز السري أولاً"
            return
        if not data_download_in_progress:
            _start_data_download(nearest)
        return
    elif kind == "train_prisoner":
        if not bool(_get_prison_door().get_meta("unlocked", false)):
            status_label.text = "افتح غرفة الأسير ببطاقة الضابط أولاً"
            return
        if not train_lights_disabled:
            status_label.text = "عطّل كشافات المحطة قبل تحرير الأسير"
            return
        rescued_prisoner = CharacterBody3D.new()
        rescued_prisoner.name = "EscortedPrisoner"
        rescued_prisoner.position = nearest.global_position
        rescued_prisoner.set_meta("civilian", true)
        add_child(rescued_prisoner)
        rescued_prisoner.add_collision_exception_with(player)
        var prisoner_collider = CollisionShape3D.new()
        var prisoner_shape = CapsuleShape3D.new()
        prisoner_shape.radius = 0.32
        prisoner_shape.height = 1.65
        prisoner_collider.shape = prisoner_shape
        rescued_prisoner.add_child(prisoner_collider)
        var model = nearest.get_meta("civilian_model", null)
        if model != null and is_instance_valid(model):
            model.reparent(rescued_prisoner, false)
            rescued_prisoner.set_meta("civilian_model", model)
        var label = Label3D.new()
        label.text = "أسير تحت حمايتك"
        label.position = Vector3(0, 1.72, 0)
        label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
        label.modulate = Color(1.0, 0.85, 0.18)
        rescued_prisoner.add_child(label)
        prisoner_health = 100
        train_prisoner_rescued = true
        documents_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم تحرير الأسير؛ سيرافقك حتى نقطة الإخلاء"
    elif kind == "extraction":
        if not data_downloaded:
            status_label.text = "يجب تحميل بيانات العملية أولاً"
            return
        extraction_reached = true
        status_label.text = "وصلت إلى نقطة الإخلاء"
    elif kind == "secret_briefcase":
        if port_targets_destroyed < 3:
            status_label.text = "دمّر أهداف الميناء الثلاثة قبل أخذ الحقيبة"
            return
        secret_briefcase_collected = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم الاستيلاء على الحقيبة السرية - اتجه إلى زورق الإخلاء"
    elif kind == "boat_extraction":
        if not secret_briefcase_collected:
            status_label.text = "استولِ على الحقيبة السرية من سفينة الشحن أولاً"
            return
        extraction_reached = true
        status_label.text = "وصلت إلى زورق الإخلاء"
    elif kind == "airbase_charge_target":
        if not explosives_collected:
            status_label.text = "احصل على العبوات من الحظيرة أولاً"
            return
        airbase_charges_planted += 1
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم زرع العبوة %d من 3" % airbase_charges_planted
        if airbase_charges_planted >= 3:
            _spawn_mission2_reinforcements()
            status_label.text = "تم زرع العبوات الثلاث - انسخ المعلومات واتجه إلى المروحية"
    elif kind == "airbase_extraction":
        if airbase_charges_planted < 3 or not data_downloaded:
            status_label.text = "أكمل زرع العبوات ونسخ المعلومات قبل الإخلاء"
            return
        extraction_reached = true
        status_label.text = "وصلت إلى مروحية الإخلاء"
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "facility_charge_target":
        if not explosives_collected or not data_downloaded:
            status_label.text = "احصل على المتفجرات وانسخ معلومات المشروع أولاً"
            return
        facility_charges_planted += 1
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم زرع العبوة %d من 2" % facility_charges_planted
        if facility_charges_planted >= 2:
            facility_escape_active = true
            facility_escape_time = 120.0
            _spawn_mission2_reinforcements()
            status_label.text = "بدأ عدّاد الهروب: اهزم القائد واتجه إلى مركبة الإخلاء"
    elif kind == "facility_extraction":
        if not facility_escape_active or facility_charges_planted < 2 or not facility_commander_defeated:
            status_label.text = "ازرع العبوتين واقضِ على قائد الحراسة قبل الإخلاء"
            return
        extraction_reached = true
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "train_charge_target":
        if not explosives_collected or not train_prisoner_rescued:
            status_label.text = "حرر الأسير وخذ المتفجرات قبل تخريب عربة الأسلحة"
            return
        train_charge_planted = true
        train_escape_active = true
        train_escape_time = 360.0
        _update_train_countdown()
        objective_nodes.erase(nearest)
        nearest.queue_free()
        _spawn_mission2_reinforcements()
        status_label.text = "تم زرع العبوة - اقضِ على قائد القطار وأخلِ الأسير خلال 360 ثانية"
    elif kind == "train_extraction":
        if not train_charge_planted or not train_commander_defeated or not train_prisoner_rescued:
            status_label.text = "أكمل التخريب واقضِ على القائد قبل الإخلاء"
            return
        if not _prisoner_at_extraction():
            status_label.text = "اقترب مع الأسير من نقطة الإخلاء"
            return
        extraction_reached = true
        _update_objective_text()
        _complete_mission()
        return
    elif kind == "computer":
        if not building2_unlocked:
            status_label.text = "افتح باب مبنى الحاسوب أولاً"
            return
        computer_accessed = true
        objective_nodes.erase(nearest)
        nearest.queue_free()
        status_label.text = "تم الاستيلاء على الحاسوب والبيانات الرئيسية"
    else:
        status_label.text = "دمّر السلاح الثقيل بإطلاق النار عليه"
        return
    _update_objective_text()
    _check_mission_completion()

func _update_interact_button():
    if not is_instance_valid(interact_button):
        return
    var needed = false
    interact_button.text = "✋"
    if _get_nearby_ladder() != null:
        needed = true
        interact_button.text = "🪜"
    var locked_door = _get_nearby_locked_door()
    if locked_door != null and _has_key_for_door(String(locked_door.get_meta("lock_kind", ""))):
        needed = true
        interact_button.text = "🔑"
    for pickup in pickups:
        if needed:
            break
        if not is_instance_valid(pickup):
            continue
        var kind = String(pickup.get_meta("pickup_kind", ""))
        if kind in ["ammo", "health"] and player.global_position.distance_to(pickup.global_position) < 2.4:
            needed = true
            break
    if not needed:
        for objective in objective_nodes:
            if not is_instance_valid(objective):
                continue
            var objective_kind = String(objective.get_meta("objective_kind", ""))
            if (objective_kind.ends_with("_key") or objective_kind in ["access_card", "computer", "alarm_panel", "explosives", "documents", "data_terminal", "extraction", "security_console", "port_explosives", "shipping_manifest", "port_terminal", "secret_briefcase", "boat_extraction", "airbase_security", "airbase_explosives", "airbase_terminal", "airbase_charge_target", "airbase_extraction", "facility_power", "facility_code", "facility_terminal", "facility_explosives", "facility_charge_target", "facility_extraction", "train_power", "train_explosives", "train_prisoner", "train_charge_target", "train_extraction", "canyon_relay", "canyon_intel", "canyon_extraction", "bridge_weapons", "bridge_controls", "bridge_explosives", "bridge_charge", "bridge_extraction", "convoy_checkpoint", "convoy_intel", "convoy_documents", "convoy_extraction", "final_generator", "final_allies", "final_radio", "final_data", "final_charge", "final_extraction"]) and player.global_position.distance_to(objective.global_position) < 3.1:
                needed = true
                break
    interact_button.visible = needed and game_started and not game_ended

func _get_nearby_locked_door():
    var nearest = null
    var nearest_distance = 3.0
    for door in doors:
        if not is_instance_valid(door) or bool(door.get_meta("unlocked", false)):
            continue
        var horizontal_player = Vector3(player.global_position.x, door.global_position.y, player.global_position.z)
        var distance = horizontal_player.distance_to(door.global_position)
        if distance < nearest_distance:
            nearest = door
            nearest_distance = distance
    return nearest

func _get_prison_door():
    for door in doors:
        if is_instance_valid(door) and String(door.get_meta("lock_kind", "")) == "prison":
            return door
    return null

func _get_nearby_ladder():
    if active_ladder != null:
        return null
    for ladder_pos in tower_ladders:
        var access = ladder_pos + Vector3(0, 0, 1.7)
        var player_horizontal = Vector2(player.global_position.x, player.global_position.z)
        if player_horizontal.distance_to(Vector2(access.x, access.z)) > 2.2:
            continue
        if player.global_position.y > 2.0 and player.global_position.y < 8.7:
            continue
        var sniper_alive = false
        for enemy in enemies:
            if is_instance_valid(enemy) and bool(enemy.get_meta("tower_sniper", false)):
                if Vector2(enemy.global_position.x, enemy.global_position.z).distance_to(Vector2(ladder_pos.x, ladder_pos.z)) < 4.0:
                    sniper_alive = true
                    break
        if not sniper_alive:
            return ladder_pos
    return null

func _has_key_for_door(lock_kind: String) -> bool:
    if lock_kind == "gate":
        return has_gate_key
    if lock_kind == "building1":
        return has_building1_key
    if lock_kind == "prison":
        return has_building1_key
    if lock_kind == "building2":
        return has_building2_key
    return false

func _start_data_download(terminal: Node3D):
    data_download_in_progress = true
    status_label.text = "جارٍ تحميل البيانات... ابقَ قرب الحاسوب"
    await get_tree().create_timer(4.0).timeout
    if game_ended or not is_instance_valid(terminal):
        data_download_in_progress = false
        return
    if player.global_position.distance_to(terminal.global_position) > 4.5:
        data_download_in_progress = false
        status_label.text = "توقف التحميل لأنك ابتعدت عن الحاسوب"
        return
    data_downloaded = true
    data_download_in_progress = false
    objective_nodes.erase(terminal)
    terminal.queue_free()
    status_label.text = "تم نسخ معلومات المشروع السري - خذ المتفجرات وازرع العبوتين" if mission_number == 5 else ("تم نسخ معلومات المطار السرية - أكمل زرع العبوات" if mission_number == 4 else ("تم اختراق اتصالات الميناء - دمّر الأهداف الثلاثة" if mission_number == 3 else "اكتمل تحميل البيانات! اهرب إلى نقطة الإخلاء"))
    _spawn_mission2_reinforcements()
    _update_objective_text()

func _spawn_mission2_reinforcements():
    if reinforcements_spawned:
        return
    reinforcements_spawned = true
    var reinforcement_positions = [Vector3(-10, 1.0, 62), Vector3(10, 1.0, 62), Vector3(-34, 1.0, 5), Vector3(34, 1.0, 5)]
    if mission_number == 6:
        reinforcement_positions = [Vector3(-16, 1.0, 48), Vector3(16, 1.0, 20), Vector3(-16, 1.0, -58), Vector3(16, 1.0, -105)]
    elif mission_number == 5:
        reinforcement_positions = [Vector3(-12, 1.0, 42), Vector3(12, 1.0, 42), Vector3(-12, 1.0, -62), Vector3(12, 1.0, -62)]
    for reinforcement_position in reinforcement_positions:
        var reinforcement = _make_enemy(reinforcement_position, "rifle")
        reinforcement.set_meta("alert_time", 20.0)
        reinforcement.set_meta("last_known_position", player.global_position)
        reinforcement.set_meta("was_alerted", true)
        reinforcement.set_meta("reaction_time", 0.8 + randf() * 0.5)
    enemy_goal = enemies_defeated + enemies.size()
    alert_level = 100.0

func _apply_mission_atmosphere():
    for child in get_children():
        if mission_number == 10:
            if child is DirectionalLight3D:
                child.light_color = Color(0.64, 0.72, 0.94)
                child.light_energy = 1.85
            elif child is WorldEnvironment and child.environment != null:
                child.environment.background_color = Color(0.035, 0.055, 0.105)
                child.environment.ambient_light_color = Color(0.42, 0.53, 0.72)
                child.environment.ambient_light_energy = 1.72
            continue
        if mission_number == 9:
            if child is DirectionalLight3D:
                child.light_color = Color(1.0, 0.93, 0.79)
                child.light_energy = 2.2
            elif child is WorldEnvironment and child.environment != null:
                child.environment.background_color = Color(0.55, 0.67, 0.76)
                child.environment.ambient_light_color = Color(0.80, 0.81, 0.78)
                child.environment.ambient_light_energy = 1.55
            continue
        if mission_number == 8:
            if child is DirectionalLight3D:
                child.light_color = Color(1.0, 0.79, 0.58)
                child.light_energy = 2.15
            elif child is WorldEnvironment and child.environment != null:
                child.environment.background_color = Color(0.64, 0.50, 0.41)
                child.environment.ambient_light_color = Color(0.82, 0.74, 0.65)
                child.environment.ambient_light_energy = 1.60
            continue
        if mission_number == 7:
            if child is DirectionalLight3D:
                child.light_color = Color(0.98, 0.87, 0.74)
                child.light_energy = 2.1
            elif child is WorldEnvironment and child.environment != null:
                child.environment.background_color = Color(0.40, 0.55, 0.68)
                child.environment.ambient_light_color = Color(0.73, 0.78, 0.80)
                child.environment.ambient_light_energy = 1.5
            continue
        if child is DirectionalLight3D:
            child.light_color = Color(0.72, 0.79, 0.92) if mission_number == 6 else (Color(0.54, 0.68, 0.84) if mission_number == 5 else (Color(0.68, 0.78, 1.0) if mission_number == 4 else (Color(0.78, 0.84, 1.0) if mission_number == 3 else (Color(0.70, 0.78, 0.94) if mission_number == 2 else Color(1.0, 0.90, 0.76)))))
            child.light_energy = 2.0 if mission_number == 6 else (1.55 if mission_number == 5 else (1.85 if mission_number == 4 else (2.15 if mission_number == 3 else (1.45 if mission_number == 2 else 1.75))))
        elif child is WorldEnvironment and child.environment != null:
            child.environment.background_color = Color(0.09, 0.14, 0.23) if mission_number == 6 else (Color(0.018, 0.030, 0.050) if mission_number == 5 else (Color(0.025, 0.055, 0.12) if mission_number == 4 else (Color(0.11, 0.18, 0.28) if mission_number == 3 else (Color(0.12, 0.18, 0.28) if mission_number == 2 else Color(0.36, 0.48, 0.62)))))
            child.environment.ambient_light_color = Color(0.56, 0.64, 0.78) if mission_number == 6 else (Color(0.32, 0.44, 0.58) if mission_number == 5 else (Color(0.38, 0.50, 0.76) if mission_number == 4 else (Color(0.56, 0.66, 0.82) if mission_number == 3 else (Color(0.42, 0.50, 0.66) if mission_number == 2 else Color(0.76, 0.80, 0.86)))))
            child.environment.ambient_light_energy = 2.15 if mission_number == 6 else (1.55 if mission_number == 5 else (1.75 if mission_number == 4 else (2.05 if mission_number == 3 else (1.10 if mission_number == 2 else 1.18))))

func _sound_volume_db() -> float:
    return [-80.0, -12.0, -5.0, 0.0][clamp(sound_level, 0, 3)]

func _player_uniform_color() -> Color:
    return [Color(0.10, 0.24, 0.11), Color(0.045, 0.055, 0.050), Color(0.34, 0.25, 0.14), Color(0.10, 0.20, 0.34)][clamp(player_color_index, 0, 3)]

func _apply_game_settings():
    _apply_brightness_setting()
    if is_instance_valid(shot_audio):
        shot_audio.volume_db = _sound_volume_db()
    if is_instance_valid(weapon_root):
        for child in weapon_root.get_children():
            if child is MeshInstance3D and bool(child.get_meta("player_clothing", false)):
                var clothing_material = StandardMaterial3D.new()
                clothing_material.albedo_color = _player_uniform_color()
                clothing_material.metallic = 0.12
                clothing_material.roughness = 0.72
                child.material_override = clothing_material

func _apply_brightness_setting():
    var factor = [0.72, 1.0, 1.28, 1.58][clamp(brightness_level, 0, 3)]
    if mission_number == 10:
        for child in get_children():
            if child is DirectionalLight3D:
                child.light_energy = 1.85 * factor
            elif child is WorldEnvironment and child.environment != null:
                child.environment.ambient_light_energy = 1.72 * factor
        return
    if mission_number == 9:
        for child in get_children():
            if child is DirectionalLight3D:
                child.light_energy = 2.2 * factor
            elif child is WorldEnvironment and child.environment != null:
                child.environment.ambient_light_energy = 1.55 * factor
        return
    if mission_number == 8:
        for child in get_children():
            if child is DirectionalLight3D:
                child.light_energy = 2.05 * factor
            elif child is WorldEnvironment and child.environment != null:
                child.environment.ambient_light_energy = 1.45 * factor
        return
    if mission_number == 7:
        for child in get_children():
            if child is DirectionalLight3D:
                child.light_energy = 2.1 * factor
            elif child is WorldEnvironment and child.environment != null:
                child.environment.ambient_light_energy = 1.5 * factor
        return
    var directional_base = 2.0 if mission_number == 6 else (1.55 if mission_number == 5 else (1.85 if mission_number == 4 else (2.15 if mission_number == 3 else (1.45 if mission_number == 2 else 1.75))))
    var ambient_base = 2.15 if mission_number == 6 else (1.55 if mission_number == 5 else (1.75 if mission_number == 4 else (2.05 if mission_number == 3 else (1.10 if mission_number == 2 else 1.18))))
    for child in get_children():
        if child is DirectionalLight3D:
            child.light_energy = directional_base * factor
        elif child is WorldEnvironment and child.environment != null:
            child.environment.ambient_light_energy = ambient_base * factor

func _equip_weapon(kind: String, captured := false):
    if not owned_weapons.has(kind):
        owned_weapons.append(kind)
    if captured:
        enemy_weapon_captured = true
        _save_progress()
    current_weapon = kind
    _build_player_gun_model(kind)
    if kind == "sniper":
        weapon_damage = 3
        weapon_range = 260.0
        ammo = 12
        weapon_root.scale = Vector3(0.34, 0.34, 0.36)
        status_label.text = "استبدلت السلاح بالقناصة بعيدة المدى"
    elif kind == "shotgun":
        weapon_damage = 2
        weapon_range = 55.0
        ammo = 8
        weapon_root.scale = Vector3(0.28, 0.28, 0.31)
        status_label.text = "استبدلت السلاح ببندقية الخرطوش"
    elif kind == "pistol":
        weapon_damage = 1
        weapon_range = 70.0
        ammo = 15
        weapon_root.scale = Vector3(0.30, 0.30, 0.32)
        status_label.text = "استبدلت السلاح بالمسدس"
    elif kind == "grenade":
        weapon_damage = 4
        weapon_range = 32.0
        ammo = 3
        weapon_root.scale = Vector3(0.25, 0.25, 0.25)
        status_label.text = "تم تجهيز القنبلة"
    else:
        weapon_damage = 1
        weapon_range = 100.0
        ammo = 30
        weapon_root.scale = Vector3(0.30, 0.30, 0.30)
        status_label.text = "استبدلت السلاح ببندقية الجندي"
    _update_ammo_text()
    _refresh_weapon_bar()
    _update_objective_text()
    _check_mission_completion()

func _select_owned_weapon(kind: String):
    if owned_weapons.has(kind) and not game_ended:
        _equip_weapon(kind)

func _store_captured_weapon(kind: String):
    if not owned_weapons.has(kind):
        owned_weapons.append(kind)
        status_label.text = "تمت إضافة السلاح إلى خانة الأسلحة"
    else:
        status_label.text = "السلاح موجود في خانة الأسلحة"
    enemy_weapon_captured = true
    _save_progress()
    _refresh_weapon_bar()
    _update_objective_text()
    _check_mission_completion()

func _update_ammo_text():
    if not is_instance_valid(ammo_label):
        return
    if current_weapon == "sniper":
        ammo_label.text = "القناصة: %d / 12" % ammo
    elif current_weapon == "shotgun":
        ammo_label.text = "الخرطوش: %d / 8" % ammo
    elif current_weapon == "pistol":
        ammo_label.text = "المسدس: %d / 15" % ammo
    elif current_weapon == "grenade":
        ammo_label.text = "القنابل: %d / 3" % ammo
    else:
        ammo_label.text = "البندقية: %d / 30" % ammo

func _refresh_weapon_bar():
    var weapon_order = ["pistol", "rifle", "sniper", "shotgun", "grenade"]
    for kind in weapon_order:
        var button: Button = weapon_buttons[kind]
        button.visible = owned_weapons.has(kind)
        button.disabled = false
        button.z_index = 140
        button.text = ""
        button.icon = weapon_icons.get(kind, null)
        button.modulate = Color(1.0, 0.82, 0.18, 1.0) if current_weapon == kind else Color(1.0, 1.0, 1.0, 0.82)
    _layout_top_inventory()

func _layout_top_inventory():
    if weapon_buttons.is_empty():
        return
    var weapon_order = ["pistol", "rifle", "sniper", "shotgun", "grenade"]
    var visible_kinds: Array[String] = []
    for kind in weapon_order:
        if owned_weapons.has(kind):
            visible_kinds.append(kind)
    var slot_count = visible_kinds.size() + 1
    var screen_width = get_viewport().get_visible_rect().size.x
    var start_x = max((screen_width - float(slot_count * 84)) * 0.5, 150.0)
    for i in range(visible_kinds.size()):
        var item_button: Button = weapon_buttons[visible_kinds[i]]
        item_button.position = Vector2(start_x + float(i * 84), 7)
    if is_instance_valid(health_button):
        health_button.position = Vector2(start_x + float(visible_kinds.size() * 84), 7)
        health_button.visible = true
        health_button.move_to_front()

func _use_health_kit():
    if game_ended or not game_started:
        return
    if health_kits <= 0:
        status_label.text = "لا توجد حقيبة علاج"
        return
    if player_health >= 100:
        status_label.text = "الطاقة ممتلئة"
        return
    health_kits -= 1
    player_health = min(player_health + 40, 100)
    health_bar.value = player_health
    _update_health_color()
    _refresh_health_button()
    status_label.text = "تم استخدام حقيبة العلاج"

func _refresh_health_button():
    if not is_instance_valid(health_button):
        return
    health_button.text = ""
    if is_instance_valid(health_count_label):
        health_count_label.text = str(health_kits)
    health_button.disabled = false
    health_button.visible = true
    health_button.modulate = Color(1, 1, 1, 1)
    _layout_top_inventory()

func _show_player_hit_effect():
    if not is_instance_valid(ui_root):
        return
    var screen_size = get_viewport().get_visible_rect().size
    var red_flash = ColorRect.new()
    red_flash.color = Color(0.72, 0.0, 0.0, 0.30)
    red_flash.position = Vector2.ZERO
    red_flash.size = screen_size
    red_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
    red_flash.z_index = 300
    ui_root.add_child(red_flash)
    for i in range(12):
        var drop = ColorRect.new()
        drop.color = Color(0.58 + float(i % 3) * 0.08, 0.0, 0.015, 0.80)
        drop.size = Vector2(5 + (i % 4) * 4, 14 + (i % 5) * 7)
        drop.position = Vector2(18 + (i * 101) % int(max(screen_size.x - 45, 1.0)), 24 + (i * 67) % int(max(screen_size.y - 80, 1.0)))
        drop.rotation = float(i - 6) * 0.11
        drop.mouse_filter = Control.MOUSE_FILTER_IGNORE
        drop.z_index = 301
        ui_root.add_child(drop)
        var drop_tween = create_tween()
        drop_tween.tween_property(drop, "position:y", drop.position.y + 75.0, 0.48)
        drop_tween.parallel().tween_property(drop, "modulate:a", 0.0, 0.62)
        drop_tween.tween_callback(drop.queue_free)
    var flash_tween = create_tween()
    flash_tween.tween_property(red_flash, "color:a", 0.0, 0.52)
    flash_tween.tween_callback(red_flash.queue_free)

func _check_mission_completion():
    if mission_number == 10:
        if final_generators_disabled >= 3 and final_allies_freed and final_radio_disabled and final_boss_defeated and final_data_taken and final_charges_planted >= 3 and _final_squad_clear("final_reinforcement") and extraction_reached:
            _complete_mission()
        return
    if mission_number == 9:
        if convoy_checkpoints == 3 and convoy_intel_taken and convoy_tower_occupied and convoy_stopped and convoy_documents_taken and _convoy_squad_clear("convoy_reinforcement") and extraction_reached:
            _complete_mission()
        return
    if mission_number == 8:
        if bridge_charges_planted >= 3 and _bridge_squad_clear("bridge_bridge_guard") and _bridge_squad_clear("bridge_second_guard") and extraction_reached:
            _complete_mission()
        return
    if mission_number == 7:
        if canyon_relays_disabled >= 2 and canyon_intel_collected and extraction_reached:
            _complete_mission()
        return
    if mission_number == 6:
        var stage_six_done = train_lights_disabled and has_building1_key and building1_unlocked and explosives_collected and train_prisoner_rescued and train_charge_planted and train_commander_defeated and extraction_reached
        if stage_six_done:
            _complete_mission()
        return
    if mission_number == 5:
        var stage_five_done = has_building1_key and building1_unlocked and alarm_disabled and documents_collected and building2_unlocked and data_downloaded and explosives_collected and facility_charges_planted >= 2 and facility_commander_defeated and extraction_reached
        if stage_five_done:
            _complete_mission()
        return
    if mission_number == 4:
        var stage_four_done = has_building1_key and building1_unlocked and port_surveillance_disabled and explosives_collected and data_downloaded and airbase_charges_planted >= 3 and extraction_reached
        if stage_four_done:
            _complete_mission()
        return
    if mission_number == 3:
        var stage_three_done = port_surveillance_disabled and building1_unlocked and documents_collected and explosives_collected and building2_unlocked and data_downloaded and port_targets_destroyed >= 3 and secret_briefcase_collected and extraction_reached
        if stage_three_done:
            _complete_mission()
        return
    if mission_number == 2:
        var stage_two_done = building1_unlocked and alarm_disabled and explosives_collected and documents_collected and building2_unlocked and missile_depots_destroyed >= 2 and data_downloaded and extraction_reached
        if stage_two_done:
            _complete_mission()
        return
    var guards_done = enemies.is_empty() or enemies_defeated >= enemy_goal
    var all_done = guards_done and enemy_weapon_captured and health_box_collected and gate_unlocked and building1_unlocked and building2_unlocked and has_building2_key and computer_accessed
    if all_done:
        _complete_mission()
    elif guards_done and is_instance_valid(status_label):
        status_label.text = "تم القضاء على الحراس - أكمل بقية أهداف المهمة"

func _update_objective_text():
    if not is_instance_valid(objective_label):
        return
    if mission_number == 10:
        var boss_text = "✓" if final_boss_defeated else "✗"
        var escape_text = "%dث" % int(ceil(final_escape_time)) if final_escape_active else "—"
        objective_label.text = "المولدات %d/3 | الفريق %s | الاتصالات %s | القائد %s\nالقرص %s | العبوات %d/3 | المروحية %s | الوقت %s" % [final_generators_disabled, ("✓" if final_allies_freed else "✗"), ("✓" if final_radio_disabled else "✗"), boss_text, ("✓" if final_data_taken else "✗"), final_charges_planted, ("✓" if extraction_reached else "✗"), escape_text]
    elif mission_number == 9:
        objective_label.text = "النقاط %d/3 | الخريطة %s | القناصان %s | البرج %s\nالقافلة %s | الحراس %s | الوثائق %s | الإخلاء %s" % [convoy_checkpoints, ("✓" if convoy_intel_taken else "✗"), ("✓" if _convoy_squad_clear("convoy_sniper") else "✗"), ("✓" if convoy_tower_occupied else "✗"), ("✓" if convoy_stopped else "✗"), ("✓" if convoy_stopped and _convoy_squad_clear("convoy_guard") else "✗"), ("✓" if convoy_documents_taken else "✗"), ("✓" if extraction_reached else "✗")]
    elif mission_number == 8:
        var near_done = "✓" if _bridge_squad_clear("bridge_first_guard") else "✗"
        var bridge_done = "✓" if _bridge_squad_clear("bridge_bridge_guard") else "✗"
        var far_done = "✓" if _bridge_squad_clear("bridge_second_guard") else "✗"
        objective_label.text = "الثكنة الأولى %s | السلاح %s | البوابات %s | المتفجرات %s\nعبوات الجسر %d/3 | حراس الجسر %s | الثكنة الثانية %s | الإخلاء %s" % [near_done, ("✓" if bridge_weapons_taken else "✗"), ("✓" if bridge_controls_taken else "✗"), ("✓" if bridge_explosives_taken else "✗"), bridge_charges_planted, bridge_done, far_done, ("✓" if extraction_reached else "✗")]
    elif mission_number == 7:
        objective_label.text = "أبراج الاتصال %d/2 | البيانات %s | الإخلاء %s" % [canyon_relays_disabled, ("✓" if canyon_intel_collected else "✗"), ("✓" if extraction_reached else "✗")]
    elif mission_number == 6:
        var train_escape_text = "%dث" % int(ceil(train_escape_time)) if train_escape_active else "—"
        objective_label.text = "الكشافات %s | بطاقة القطار %s | المحطة %s | المتفجرات %s\nالأسير %s | العبوة %s | القائد %s | الهروب %s" % [("✓" if train_lights_disabled else "✗"), ("✓" if has_building1_key else "✗"), ("✓" if building1_unlocked else "✗"), ("✓" if explosives_collected else "✗"), ("✓" if train_prisoner_rescued else "✗"), ("✓" if train_charge_planted else "✗"), ("✓" if train_commander_defeated else "✗"), train_escape_text]
    elif mission_number == 5:
        var escape_text = "%dث" % int(ceil(facility_escape_time)) if facility_escape_active else "—"
        objective_label.text = "بطاقة النفق %s | الطاقة %s | الشفرة %s | المختبر %s\nالبيانات %s | المتفجرات %s | العبوات %d/2 | القائد %s | الهروب %s" % [("✓" if has_building1_key else "✗"), ("✓" if alarm_disabled else "✗"), ("✓" if documents_collected else "✗"), ("✓" if building2_unlocked else "✗"), ("✓" if data_downloaded else "✗"), ("✓" if explosives_collected else "✗"), facility_charges_planted, ("✓" if facility_commander_defeated else "✗"), escape_text]
    elif mission_number == 4:
        objective_label.text = "المراقبة %s | بطاقة الضابط %s | الحظيرة %s | المتفجرات %s\nالمعلومات %s | العبوات %d/3 | الإخلاء %s" % [("✓" if port_surveillance_disabled else "✗"), ("✓" if has_building1_key else "✗"), ("✓" if building1_unlocked else "✗"), ("✓" if explosives_collected else "✗"), ("✓" if data_downloaded else "✗"), airbase_charges_planted, ("✓" if extraction_reached else "✗")]
    elif mission_number == 3:
        objective_label.text = "المراقبة %s | المستودع %s | جدول السفينة %s | الاتصالات %s\nالمتفجرات %s | التخريب %d/3 | الحقيبة %s | الإخلاء %s" % [("✓" if port_surveillance_disabled else "✗"), ("✓" if building1_unlocked else "✗"), ("✓" if documents_collected else "✗"), ("✓" if building2_unlocked and data_downloaded else "✗"), ("✓" if explosives_collected else "✗"), port_targets_destroyed, ("✓" if secret_briefcase_collected else "✗"), ("✓" if extraction_reached else "✗")]
    elif mission_number == 2:
        objective_label.text = "الثكنة %s | المراقبة %s | كلمة السر %s | القيادة %s\nالمتفجرات %s | منصات الصواريخ %d/2 | البيانات %s | الإخلاء %s" % [("✓" if building1_unlocked else "✗"), ("✓" if alarm_disabled else "✗"), ("✓" if documents_collected else "✗"), ("✓" if building2_unlocked else "✗"), ("✓" if explosives_collected else "✗"), missile_depots_destroyed, ("✓" if data_downloaded else "✗"), ("✓" if extraction_reached else "✗")]
    else:
        objective_label.text = "الحراس %d/%d | البوابة %s | المبنى الأول %s | المبنى الثاني %s\nسلاح %s | علاج %s | الحاسوب الرئيسي %s" % [enemies_defeated, enemy_goal, ("✓" if gate_unlocked else "✗"), ("✓" if building1_unlocked else "✗"), ("✓" if building2_unlocked else "✗"), ("✓" if enemy_weapon_captured else "✗"), ("✓" if health_box_collected else "✗"), ("✓" if computer_accessed else "✗")]

func _reload_weapon():
    if is_reloading or game_ended:
        return
    is_reloading = true
    status_label.text = "جارٍ إعادة التلقيم..."
    shoot_button.text = ""
    await get_tree().create_timer(1.25).timeout
    if game_ended:
        return
    ammo = 12 if current_weapon == "sniper" else (8 if current_weapon == "shotgun" else (15 if current_weapon == "pistol" else (3 if current_weapon == "grenade" else 30)))
    _update_ammo_text()
    status_label.text = "تمت إعادة التلقيم"
    shoot_button.text = ""
    is_reloading = false

func _play_shot_effects():
    muzzle_flash.visible = true
    shot_audio.play()
    var rest_position = Vector3(0.30, -0.36, -0.52)
    weapon_root.position = rest_position + Vector3(0, 0.015, 0.09)
    var recoil = create_tween()
    recoil.set_trans(Tween.TRANS_QUAD)
    recoil.set_ease(Tween.EASE_OUT)
    recoil.tween_property(weapon_root, "position", rest_position, 0.09)
    get_tree().create_timer(0.055).timeout.connect(func():
        if is_instance_valid(muzzle_flash):
            muzzle_flash.visible = false
    )

func _build_ui():
    var layer = CanvasLayer.new()
    layer.layer = 100
    add_child(layer)
    var screen_size = get_viewport().get_visible_rect().size

    # Controls anchored directly under CanvasLayer do not get a reliable
    # Control parent size on Android.  A full-screen root makes every anchor
    # resolve against the actual viewport.
    ui_root = Control.new()
    layer.add_child(ui_root)
    ui_root.position = Vector2.ZERO
    ui_root.size = screen_size
    ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    ui_root.layout_direction = Control.LAYOUT_DIRECTION_LTR

    var look_area = Control.new()
    ui_root.add_child(look_area)
    look_area.position = Vector2.ZERO
    look_area.size = screen_size
    # Touch aiming is routed by _input so a second or third finger can operate
    # the scope and fire buttons without replacing the aiming finger.
    look_area.mouse_filter = Control.MOUSE_FILTER_IGNORE

    # Add every direction directly to the root with absolute coordinates.
    # This prevents Arabic RTL layout from mirroring or stacking the D-pad.
    var up = _make_btn("▲", Vector2.ZERO, Vector2(75, 65))
    var left = _make_btn("◀", Vector2.ZERO, Vector2(75, 65))
    var right = _make_btn("▶", Vector2.ZERO, Vector2(75, 65))
    var down = _make_btn("▼", Vector2.ZERO, Vector2(75, 65))
    ui_root.add_child(up); ui_root.add_child(left); ui_root.add_child(right); ui_root.add_child(down)
    # Movement D-pad: fixed on the lower-left in all three missions.
    up.position = Vector2(93, screen_size.y - 245)
    left.position = Vector2(13, screen_size.y - 170)
    right.position = Vector2(173, screen_size.y - 170)
    down.position = Vector2(93, screen_size.y - 95)

    up.button_down.connect(func(): move_forward = true)
    up.button_up.connect(func(): move_forward = false)
    up.gui_input.connect(func(event): _remember_move_touch(event, "forward"))
    down.button_down.connect(func(): move_back = true)
    down.button_up.connect(func(): move_back = false)
    down.gui_input.connect(func(event): _remember_move_touch(event, "back"))
    left.button_down.connect(func(): move_left = true)
    left.button_up.connect(func(): move_left = false)
    left.gui_input.connect(func(event): _remember_move_touch(event, "left"))
    right.button_down.connect(func(): move_right = true)
    right.button_up.connect(func(): move_right = false)
    right.gui_input.connect(func(event): _remember_move_touch(event, "right"))

    var jump = _make_btn("🤸", Vector2.ZERO, Vector2(92, 92))
    ui_root.add_child(jump)
    # Jump, running and stance controls: lower-right under the mission row.
    jump.position = Vector2(screen_size.x - 140, screen_size.y - 245)
    jump.button_down.connect(func(): jump_pressed = true)

    stance_button = _make_btn("🧍", Vector2.ZERO, Vector2(96, 96))
    ui_root.add_child(stance_button)
    stance_button.position = Vector2(screen_size.x - 262, screen_size.y - 135)
    stance_button.button_down.connect(_cycle_stance)

    interact_button = _make_btn("✋", Vector2.ZERO, Vector2(92, 92))
    ui_root.add_child(interact_button)
    interact_button.position = Vector2(screen_size.x * 0.40, screen_size.y * 0.68)
    interact_button.visible = false
    interact_button.button_down.connect(_interact)

    zoom_button = _make_btn("◉", Vector2.ZERO, Vector2(112, 112))
    ui_root.add_child(zoom_button)
    zoom_button.position = Vector2(screen_size.x - 315, screen_size.y - 540)
    zoom_button.button_down.connect(_toggle_zoom)

    speed_button = _make_btn("🏃", Vector2.ZERO, Vector2(96, 88))
    ui_root.add_child(speed_button)
    speed_button.position = Vector2(screen_size.x - 144, screen_size.y - 135)
    speed_button.button_down.connect(_cycle_movement_mode)

    shoot_button = _make_btn("", Vector2.ZERO, Vector2(126, 126))
    ui_root.add_child(shoot_button)
    shoot_button.icon = load("res://icons/bullet.svg")
    shoot_button.expand_icon = true
    shoot_button.add_theme_constant_override("icon_max_width", 82)
    shoot_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    # Fire is on the same horizontal line as the scope button.
    shoot_button.position = Vector2(screen_size.x - 158, screen_size.y - 540)
    shoot_button.button_down.connect(_on_action_button)

    cross_label = Label.new()
    ui_root.add_child(cross_label)
    cross_label.text = "+"
    cross_label.add_theme_font_size_override("font_size", 34)
    cross_label.position = screen_size * 0.5 + Vector2(-10, -22)

    weapon_icons = {
        "pistol": load("res://icons/pistol.svg"),
        "rifle": load("res://icons/rifle.svg"),
        "sniper": load("res://icons/sniper.svg"),
        "shotgun": load("res://icons/shotgun.svg"),
        "grenade": load("res://icons/grenade.svg")
    }
    var pistol_select = _make_btn("", Vector2.ZERO, Vector2(78, 48))
    var rifle_select = _make_btn("", Vector2.ZERO, Vector2(78, 48))
    var sniper_select = _make_btn("", Vector2.ZERO, Vector2(78, 48))
    var shotgun_select = _make_btn("", Vector2.ZERO, Vector2(78, 48))
    var grenade_select = _make_btn("", Vector2.ZERO, Vector2(78, 48))
    for weapon_button in [pistol_select, rifle_select, sniper_select, shotgun_select, grenade_select]:
        weapon_button.expand_icon = true
        weapon_button.add_theme_constant_override("icon_max_width", 64)
        weapon_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
        weapon_button.z_index = 140
        ui_root.add_child(weapon_button)
    # Responsive row keeps every weapon and the medical bag visible on phones.
    var weapon_row_x = max(screen_size.x * 0.5 - 252.0, 145.0)
    pistol_select.position = Vector2(weapon_row_x, 7)
    rifle_select.position = Vector2(weapon_row_x + 84, 7)
    sniper_select.position = Vector2(weapon_row_x + 168, 7)
    shotgun_select.position = Vector2(weapon_row_x + 252, 7)
    grenade_select.position = Vector2(weapon_row_x + 336, 7)
    weapon_buttons["pistol"] = pistol_select
    weapon_buttons["rifle"] = rifle_select
    weapon_buttons["sniper"] = sniper_select
    weapon_buttons["shotgun"] = shotgun_select
    weapon_buttons["grenade"] = grenade_select
    pistol_select.button_down.connect(func(): _select_owned_weapon("pistol"))
    rifle_select.button_down.connect(func(): _select_owned_weapon("rifle"))
    sniper_select.button_down.connect(func(): _select_owned_weapon("sniper"))
    shotgun_select.button_down.connect(func(): _select_owned_weapon("shotgun"))
    grenade_select.button_down.connect(func(): _select_owned_weapon("grenade"))
    _refresh_weapon_bar()

    health_button = _make_btn("", Vector2.ZERO, Vector2(78, 48))
    health_button.icon = load("res://icons/health.svg")
    health_button.expand_icon = true
    health_button.add_theme_constant_override("icon_max_width", 34)
    health_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    health_button.position = Vector2(weapon_row_x + 420, 7)
    health_button.z_index = 190
    health_button.add_theme_font_size_override("font_size", 18)
    var medical_style = StyleBoxFlat.new()
    medical_style.bg_color = Color(0.94, 0.96, 0.98, 0.88)
    medical_style.border_color = Color(0.86, 0.05, 0.08, 1.0)
    medical_style.border_width_left = 3
    medical_style.border_width_top = 3
    medical_style.border_width_right = 3
    medical_style.border_width_bottom = 3
    medical_style.corner_radius_top_left = 12
    medical_style.corner_radius_top_right = 12
    medical_style.corner_radius_bottom_left = 12
    medical_style.corner_radius_bottom_right = 12
    health_button.add_theme_stylebox_override("normal", medical_style)
    ui_root.add_child(health_button)
    health_count_label = Label.new()
    health_count_label.text = "0"
    health_count_label.position = Vector2(52, 24)
    health_count_label.size = Vector2(24, 22)
    health_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    health_count_label.add_theme_font_size_override("font_size", 17)
    health_count_label.add_theme_color_override("font_color", Color.WHITE)
    health_count_label.add_theme_color_override("font_outline_color", Color(0.72, 0.0, 0.03))
    health_count_label.add_theme_constant_override("outline_size", 6)
    health_count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    health_button.add_child(health_count_label)
    health_button.button_down.connect(_use_health_kit)
    _refresh_health_button()
    _refresh_weapon_bar()

    ammo_label = Label.new()
    ammo_label.text = "القناصة: 12 / 12"
    ammo_label.add_theme_font_size_override("font_size", 26)
    ammo_label.position = Vector2(20, 20)
    ammo_label.size = Vector2(260, 48)
    ammo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    ammo_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    ammo_label.z_index = 50
    var ammo_box = StyleBoxFlat.new()
    ammo_box.bg_color = Color(0.03, 0.04, 0.06, 0.88)
    ammo_box.corner_radius_top_left = 10
    ammo_box.corner_radius_top_right = 10
    ammo_box.corner_radius_bottom_left = 10
    ammo_box.corner_radius_bottom_right = 10
    ammo_box.border_width_left = 2
    ammo_box.border_width_top = 2
    ammo_box.border_width_right = 2
    ammo_box.border_width_bottom = 2
    ammo_box.border_color = Color(0.25, 0.70, 1.0, 1.0)
    ammo_label.add_theme_stylebox_override("normal", ammo_box)
    ui_root.add_child(ammo_label)
    ammo_label.visible = false

    var stage_background = ColorRect.new()
    stage_background.color = Color(0.02, 0.04, 0.07, 0.92)
    stage_background.position = Vector2(screen_size.x * 0.5 + 310, 55)
    stage_background.size = Vector2(116, 50)
    stage_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    stage_background.z_index = 899
    ui_root.add_child(stage_background)
    var version_label = Label.new()
    version_label.text = "المرحلة %d" % mission_number
    version_label.position = stage_background.position
    version_label.size = stage_background.size
    version_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    version_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    version_label.add_theme_font_size_override("font_size", 24)
    version_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.2))
    version_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    version_label.z_index = 900
    ui_root.add_child(version_label)

    train_countdown_label = Label.new()
    train_countdown_label.position = Vector2(screen_size.x * 0.5 - 150, 98)
    train_countdown_label.size = Vector2(300, 46)
    train_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    train_countdown_label.add_theme_font_size_override("font_size", 26)
    train_countdown_label.add_theme_color_override("font_color", Color(0.20, 1.0, 0.24))
    train_countdown_label.add_theme_color_override("font_shadow_color", Color.BLACK)
    train_countdown_label.add_theme_constant_override("shadow_offset_x", 2)
    train_countdown_label.add_theme_constant_override("shadow_offset_y", 2)
    train_countdown_label.z_index = 850
    train_countdown_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    train_countdown_label.visible = false
    ui_root.add_child(train_countdown_label)
    if mission_number == 10:
        train_countdown_label.position = Vector2(screen_size.x * 0.5 - 180, 230)
        train_countdown_label.size = Vector2(360, 42)
        train_countdown_label.add_theme_font_size_override("font_size", 25)
    elif mission_number == 9:
        train_countdown_label.position = Vector2(screen_size.x * 0.5 - 165, 230)
        train_countdown_label.size = Vector2(330, 42)
    elif mission_number == 8:
        train_countdown_label.position = Vector2(screen_size.x * 0.5 - 155, 232)
        train_countdown_label.size = Vector2(310, 42)
        train_countdown_label.add_theme_font_size_override("font_size", 25)
    _build_settings_menu(screen_size)

    alert_label = Label.new()
    alert_label.text = "الإنذار: 0% | حركة عادية"
    alert_label.add_theme_font_size_override("font_size", 21)
    alert_label.position = Vector2(20, 112)
    alert_label.size = Vector2(350, 38)
    alert_label.modulate = Color(1.0, 0.82, 0.20)
    ui_root.add_child(alert_label)

    objective_label = Label.new()
    objective_label.add_theme_font_size_override("font_size", 17)
    objective_label.position = Vector2(screen_size.x * 0.5 - 360, 102)
    objective_label.size = Vector2(720, 62)
    objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    objective_label.modulate = Color(0.92, 0.95, 1.0)
    ui_root.add_child(objective_label)
    _update_objective_text()

    health_bar = ProgressBar.new()
    ui_root.add_child(health_bar)
    health_bar.min_value = 0
    health_bar.max_value = 100
    health_bar.value = 100
    health_bar.show_percentage = true
    health_bar.position = Vector2(screen_size.x * 0.5 - 140, 62)
    health_bar.size = Vector2(280, 34)
    health_bar.add_theme_font_size_override("font_size", 20)
    var health_background = StyleBoxFlat.new()
    health_background.bg_color = Color(0.18, 0.03, 0.03, 0.95)
    health_background.corner_radius_top_left = 8
    health_background.corner_radius_top_right = 8
    health_background.corner_radius_bottom_left = 8
    health_background.corner_radius_bottom_right = 8
    health_fill_style = StyleBoxFlat.new()
    health_fill_style.bg_color = Color(0.08, 0.72, 0.20, 0.98)
    health_fill_style.corner_radius_top_left = 8
    health_fill_style.corner_radius_top_right = 8
    health_fill_style.corner_radius_bottom_left = 8
    health_fill_style.corner_radius_bottom_right = 8
    health_bar.add_theme_stylebox_override("background", health_background)
    health_bar.add_theme_stylebox_override("fill", health_fill_style)

    status_label = Label.new()
    ui_root.add_child(status_label)
    status_label.text = "المهمة: اقض على 3 أعداء"
    status_label.add_theme_font_size_override("font_size", 24)
    status_label.position = Vector2(screen_size.x * 0.5 - 350, 150)
    status_label.size = Vector2(700, 74)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _show_start_menu()

func _show_start_menu():
    var screen_size = get_viewport().get_visible_rect().size
    status_label.visible = false
    shoot_button.icon = null
    shoot_button.text = "ابدأ اللعب"
    shoot_button.position = screen_size * 0.5 - Vector2(115, 45)
    shoot_button.size = Vector2(230, 90)
    shoot_button.z_index = 230

func _build_settings_menu(screen_size: Vector2):
    # Its own CanvasLayer prevents scene Controls from clipping or covering it.
    var settings_layer = CanvasLayer.new()
    settings_layer.name = "SettingsLayer"
    settings_layer.layer = 500
    add_child(settings_layer)
    var settings_button = _make_btn("⚙  الإعدادات", Vector2(20, 58), Vector2(190, 68))
    settings_button.name = "SettingsButton"
    settings_button.z_index = 2000
    settings_button.add_theme_font_size_override("font_size", 25)
    var gear_style = StyleBoxFlat.new()
    gear_style.bg_color = Color(0.035, 0.13, 0.18, 0.96)
    gear_style.border_color = Color(0.22, 0.78, 1.0, 1.0)
    gear_style.set_border_width_all(3)
    gear_style.set_corner_radius_all(22)
    settings_button.add_theme_stylebox_override("normal", gear_style)
    var gear_pressed = gear_style.duplicate()
    gear_pressed.bg_color = Color(0.08, 0.38, 0.52, 1.0)
    settings_button.add_theme_stylebox_override("pressed", gear_pressed)
    settings_button.add_theme_stylebox_override("hover", gear_style)
    settings_button.add_theme_stylebox_override("focus", gear_style)
    settings_layer.add_child(settings_button)
    settings_button.button_down.connect(_toggle_settings)

    settings_panel = Panel.new()
    settings_panel.position = Vector2(20, 138)
    settings_panel.size = Vector2(430, min(500.0, screen_size.y - 150.0))
    settings_panel.z_index = 980
    settings_panel.mouse_filter = Control.MOUSE_FILTER_STOP
    var panel_style = StyleBoxFlat.new()
    panel_style.bg_color = Color(0.025, 0.045, 0.065, 0.96)
    panel_style.border_color = Color(0.20, 0.68, 0.92, 0.95)
    panel_style.set_border_width_all(3)
    panel_style.set_corner_radius_all(18)
    settings_panel.add_theme_stylebox_override("panel", panel_style)
    settings_layer.add_child(settings_panel)

    var title = Label.new()
    title.text = "إعدادات اللعبة"
    title.position = Vector2(20, 12)
    title.size = Vector2(390, 42)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 28)
    title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.20))
    settings_panel.add_child(title)

    settings_summary = Label.new()
    settings_summary.position = Vector2(28, 58)
    settings_summary.size = Vector2(374, 104)
    settings_summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    settings_summary.add_theme_font_size_override("font_size", 20)
    settings_panel.add_child(settings_summary)

    var color_button = _make_btn("تغيير لون اللاعب", Vector2(24, 166), Vector2(182, 58))
    var sound_button = _make_btn("صوت الإطلاق", Vector2(224, 166), Vector2(182, 58))
    var light_button = _make_btn("تغيير الإضاءة", Vector2(24, 236), Vector2(182, 58))
    var close_button = _make_btn("إغلاق", Vector2(224, 236), Vector2(182, 58))
    for button in [color_button, sound_button, light_button, close_button]:
        settings_panel.add_child(button)
    color_button.button_down.connect(_cycle_player_color)
    sound_button.button_down.connect(_cycle_sound_level)
    light_button.button_down.connect(_cycle_brightness)
    close_button.button_down.connect(_toggle_settings)

    var stage_title = Label.new()
    stage_title.text = "اختيار المرحلة المفتوحة"
    stage_title.position = Vector2(24, 304)
    stage_title.size = Vector2(382, 38)
    stage_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stage_title.add_theme_font_size_override("font_size", 22)
    settings_panel.add_child(stage_title)
    var stage_one = _make_btn("1", Vector2(10, 350), Vector2(62, 62))
    var stage_two = _make_btn("2", Vector2(78, 350), Vector2(62, 62))
    var stage_three = _make_btn("3", Vector2(146, 350), Vector2(62, 62))
    var stage_four = _make_btn("4", Vector2(214, 350), Vector2(62, 62))
    var stage_five = _make_btn("5", Vector2(282, 350), Vector2(62, 62))
    var stage_six = _make_btn("6", Vector2(350, 350), Vector2(62, 62))
    var stage_seven = _make_btn("7", Vector2(180, 422), Vector2(62, 62))
    var stage_eight = _make_btn("8", Vector2(250, 422), Vector2(62, 62))
    var stage_nine = _make_btn("9", Vector2(320, 422), Vector2(62, 62))
    var stage_ten = _make_btn("10", Vector2(110, 422), Vector2(62, 62))
    stage_two.disabled = saved_mission < 2
    stage_three.disabled = saved_mission < 3
    stage_four.disabled = saved_mission < 4
    stage_five.disabled = saved_mission < 5
    stage_six.disabled = saved_mission < 6
    stage_seven.disabled = saved_mission < 7
    stage_eight.disabled = saved_mission < 8
    stage_nine.disabled = saved_mission < 9
    stage_ten.disabled = saved_mission < 10
    settings_panel.add_child(stage_one)
    settings_panel.add_child(stage_two)
    settings_panel.add_child(stage_three)
    settings_panel.add_child(stage_four)
    settings_panel.add_child(stage_five)
    settings_panel.add_child(stage_six)
    settings_panel.add_child(stage_seven)
    settings_panel.add_child(stage_eight)
    settings_panel.add_child(stage_nine)
    settings_panel.add_child(stage_ten)
    stage_one.button_down.connect(func(): _select_mission_from_settings(1))
    stage_two.button_down.connect(func(): _select_mission_from_settings(2))
    stage_three.button_down.connect(func(): _select_mission_from_settings(3))
    stage_four.button_down.connect(func(): _select_mission_from_settings(4))
    stage_five.button_down.connect(func(): _select_mission_from_settings(5))
    stage_six.button_down.connect(func(): _select_mission_from_settings(6))
    stage_seven.button_down.connect(func(): _select_mission_from_settings(7))
    stage_eight.button_down.connect(func(): _select_mission_from_settings(8))
    stage_nine.button_down.connect(func(): _select_mission_from_settings(9))
    stage_ten.button_down.connect(func(): _select_mission_from_settings(10))
    _update_settings_summary()
    settings_panel.visible = false

func _toggle_settings():
    if not is_instance_valid(settings_panel):
        return
    settings_open = not settings_open
    settings_panel.visible = settings_open
    if settings_open:
        move_forward = false
        move_back = false
        move_left = false
        move_right = false
        shoot_pressed = false

func _update_settings_summary():
    if not is_instance_valid(settings_summary):
        return
    var color_names = ["أخضر", "أسود", "رملي", "أزرق"]
    var sound_names = ["مغلق", "منخفض", "متوسط", "مرتفع"]
    var light_names = ["منخفضة", "عادية", "واضحة", "مرتفعة"]
    settings_summary.text = "لون اللاعب: %s\nصوت الإطلاق: %s\nالإضاءة: %s\nالمراحل المفتوحة: 1 إلى %d" % [color_names[player_color_index], sound_names[sound_level], light_names[brightness_level], saved_mission]

func _cycle_player_color():
    player_color_index = (player_color_index + 1) % 4
    _apply_game_settings()
    _update_settings_summary()
    _save_progress()

func _cycle_sound_level():
    sound_level = (sound_level + 1) % 4
    _apply_game_settings()
    _update_settings_summary()
    _save_progress()

func _cycle_brightness():
    brightness_level = (brightness_level + 1) % 4
    _apply_game_settings()
    _update_settings_summary()
    _save_progress()

func _select_mission_from_settings(wanted_mission: int):
    if wanted_mission < 1 or wanted_mission > saved_mission:
        return
    Engine.set_meta("operation_shadow_session_mission", wanted_mission)
    get_tree().reload_current_scene()

func _show_center_message(message: String, box_color: Color):
    var screen_size = get_viewport().get_visible_rect().size
    status_label.position = screen_size * 0.5 - Vector2(310, 120)
    status_label.size = Vector2(620, 240)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 40)
    status_label.z_index = 200
    var box = StyleBoxFlat.new()
    box.bg_color = box_color
    box.corner_radius_top_left = 18
    box.corner_radius_top_right = 18
    box.corner_radius_bottom_left = 18
    box.corner_radius_bottom_right = 18
    box.border_width_left = 4
    box.border_width_top = 4
    box.border_width_right = 4
    box.border_width_bottom = 4
    box.border_color = Color(0.9, 0.9, 0.2, 1.0)
    status_label.add_theme_stylebox_override("normal", box)
    status_label.text = message

func _show_victory_message(message: String):
    var screen_size = get_viewport().get_visible_rect().size
    status_label.remove_theme_stylebox_override("normal")
    status_label.position = screen_size * 0.5 - Vector2(360, 90)
    status_label.size = Vector2(720, 180)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 48)
    status_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.18))
    status_label.add_theme_color_override("font_shadow_color", Color(0.05, 0.02, 0.0, 0.95))
    status_label.add_theme_constant_override("shadow_offset_x", 4)
    status_label.add_theme_constant_override("shadow_offset_y", 4)
    status_label.text = message
    status_label.z_index = 220
    status_label.pivot_offset = status_label.size * 0.5
    status_label.scale = Vector2(0.35, 0.35)
    status_label.modulate = Color(1, 1, 1, 0)
    var victory_tween = create_tween().set_parallel(true)
    victory_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    victory_tween.tween_property(status_label, "scale", Vector2.ONE, 0.85)
    victory_tween.tween_property(status_label, "modulate", Color.WHITE, 0.55)
    for i in range(24):
        var spark = ColorRect.new()
        spark.color = [Color(1.0, 0.78, 0.05), Color(0.12, 0.85, 0.30), Color(0.20, 0.65, 1.0)][i % 3]
        spark.size = Vector2(7 + (i % 4) * 2, 14)
        spark.position = Vector2(90 + (i * 47) % int(screen_size.x - 180), -20 - (i % 5) * 24)
        spark.z_index = 210
        ui_root.add_child(spark)
        var spark_tween = create_tween().set_parallel(true)
        spark_tween.tween_property(spark, "position:y", screen_size.y + 30, 1.8 + (i % 5) * 0.18)
        spark_tween.tween_property(spark, "rotation", float(i + 2) * 1.4, 1.8)
        spark_tween.finished.connect(spark.queue_free)

func _show_loss_message():
    var screen_size = get_viewport().get_visible_rect().size
    status_label.remove_theme_stylebox_override("normal")
    status_label.visible = true
    status_label.position = screen_size * 0.5 - Vector2(300, 75)
    status_label.size = Vector2(600, 150)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 54)
    status_label.add_theme_color_override("font_color", Color(1.0, 0.12, 0.08))
    status_label.add_theme_color_override("font_shadow_color", Color(0.02, 0.0, 0.0, 0.95))
    status_label.add_theme_constant_override("shadow_offset_x", 4)
    status_label.add_theme_constant_override("shadow_offset_y", 4)
    status_label.text = "لقد خسرت\n" + (mission_failure_reason if mission_failure_reason != "" else "نفدت صحة اللاعب")
    status_label.add_theme_font_size_override("font_size", 36)
    status_label.z_index = 220

func _restore_mission_status():
    var screen_size = get_viewport().get_visible_rect().size
    status_label.remove_theme_stylebox_override("normal")
    status_label.position = Vector2(screen_size.x * 0.5 - 350, 150)
    status_label.size = Vector2(700, 74)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status_label.add_theme_font_size_override("font_size", 24)
    status_label.add_theme_color_override("font_color", Color.WHITE)
    status_label.scale = Vector2.ONE
    status_label.modulate = Color.WHITE
    status_label.z_index = 0

func _complete_mission():
    _finish_game(true)

func _finish_game(success: bool):
    if game_ended:
        return
    game_ended = true
    if is_instance_valid(train_countdown_label):
        train_countdown_label.visible = false
    mission_completed = success
    move_forward = false
    move_back = false
    move_left = false
    move_right = false
    shoot_pressed = false
    if is_instance_valid(new_game_button):
        new_game_button.visible = false

    if success:
        saved_mission = max(saved_mission, min(mission_number + 1, 10))
        _save_progress()
    var message = "لقد خسرت"
    if success and mission_number == 1:
        message = "انتهت المهمة بنجاح\nتم الاستيلاء على الحاسوب وبيانات المعسكر"
    elif success and mission_number == 2:
        message = "انتهت المهمة بنجاح\nتم اختراق المعسكر وفتح المهمة الأخيرة"
    elif success and mission_number == 3:
        message = "انتهت المهمة بنجاح\nتم تخريب الميناء واستعادة الحقيبة السرية"
    elif success and mission_number == 4:
        message = "انتهت المهمة بنجاح\nتم تعطيل المطار العسكري ومنع طائرة الشحن من الإقلاع"
    elif success:
        message = "انتهت المهمة بنجاح\nتم تدمير المشروع السري والهروب من المنشأة الجبلية"
    if success and mission_number == 5:
        message = "تمت العملية بنجاح\nتم تدمير المشروع السري والهروب من المنشأة الجبلية"
    if success and mission_number == 8:
        message = "تمت المهمة بنجاح\nأمنت الجسر وزرعت العبوات وأخليت المنطقة بعد هزيمة الثكنتين"
    if success and mission_number == 9:
        message = "تمت المهمة بنجاح\nأمّنت الطريق ونصبت كمين القافلة واستعدت الوثائق ووصلت إلى الإخلاء"
    if success and mission_number == 10:
        message = "تمت العملية الأخيرة بنجاح\nتم إسقاط القلعة واستعادة القرص السري والإخلاء بالمروحية"
    if success and mission_number == 7:
        message = "تمت المهمة بنجاح\nتم تعطيل شبكة الاتصالات والحصول على البيانات والإخلاء من الجبال"
    if success and mission_number == 6:
        message = "تمت العملية بنجاح\nتم تحرير الأسير وتدمير عربة الأسلحة وإيقاف القطار العسكري"
    if success:
        _show_victory_message(message)
        if mission_number >= 7:
            var victory_shade = ColorRect.new()
            victory_shade.color = Color(0.015, 0.025, 0.035, 0.78)
            victory_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
            victory_shade.mouse_filter = Control.MOUSE_FILTER_STOP
            victory_shade.z_index = 210
            ui_root.add_child(victory_shade)
            shoot_button.visible = false
            shoot_button.disabled = true
            victory_continue_button = Button.new()
            victory_continue_button.text = "الانتقال إلى المرحلة العاشرة" if mission_number == 9 else ("الانتقال إلى المرحلة التاسعة" if mission_number == 8 else ("الانتقال إلى المرحلة الثامنة" if mission_number == 7 else "إعادة لعب المرحلة العاشرة"))
            victory_continue_button.position = get_viewport().get_visible_rect().size * 0.5 + Vector2(-165, 118)
            victory_continue_button.size = Vector2(330, 78)
            victory_continue_button.z_index = 230
            victory_continue_button.visible = false
            victory_continue_button.pressed.connect(_continue_after_victory)
            ui_root.add_child(victory_continue_button)
            get_tree().create_timer(1.7).timeout.connect(_reveal_victory_continue)
            return
    else:
        _show_loss_message()
    var screen_size = get_viewport().get_visible_rect().size
    shoot_button.icon = null
    shoot_button.text = "الانتقال إلى المرحلة القادمة" if success and mission_number < 10 else "إعادة اللعب"
    shoot_button.position = Vector2(screen_size.x * 0.5 - 155, screen_size.y * 0.5 + 115)
    shoot_button.size = Vector2(310, 78)
    shoot_button.z_index = 230

func _reveal_victory_continue():
    if game_ended and mission_completed and is_instance_valid(victory_continue_button):
        victory_continue_button.visible = true

func _continue_after_victory():
    if not game_ended or not mission_completed:
        return
    if mission_number < 10:
        _start_next_mission()
    else:
        get_tree().reload_current_scene()

func _on_action_button():
    if not game_started:
        game_started = true
        if is_instance_valid(new_game_button):
            new_game_button.visible = false
        _restore_mission_status()
        status_label.visible = true
        if mission_number == 10:
            status_label.text = "تسلل عبر الوادي وعطّل مولدات القلعة الثلاثة"
        elif mission_number == 9:
            status_label.text = "أمّن نقاط الطريق الثلاث للوصول إلى موقع كمين القافلة"
        else:
            status_label.text = "تقدم نحو الثكنة الأولى وأمّن معدات الجسر" if mission_number == 8 else ("تقدم عبر الممر الجبلي وعطّل برجي الاتصال" if mission_number == 7 else ("تسلل إلى محطة القطار وعطّل الكشافات واحصل على بطاقة الضابط" if mission_number == 6 else ("تسلل إلى المنشأة الجبلية واحصل على بطاقة بوابة النفق" if mission_number == 5 else ("تسلل إلى المطار وعطّل المراقبة واحصل على بطاقة الضابط" if mission_number == 4 else ("عطّل مراقبة الميناء واحصل على بطاقة الضابط" if mission_number == 3 else ("تسلل إلى مستودع الصواريخ واحصل على بطاقة الضابط" if mission_number == 2 else "تقدم نحو المعسكر واقض على حراس البوابة"))))))
        shoot_button.text = ""
        shoot_button.icon = load("res://icons/bullet.svg")
        shoot_button.expand_icon = true
        shoot_button.add_theme_constant_override("icon_max_width", 82)
        shoot_button.position = Vector2(get_viewport().get_visible_rect().size.x - 158, get_viewport().get_visible_rect().size.y - 540)
        shoot_button.size = Vector2(126, 126)
        shoot_button.z_index = 0
    elif game_ended and mission_completed and mission_number >= 7:
        return
    elif game_ended and mission_completed and mission_number < 8:
        _start_next_mission()
    elif game_ended:
        get_tree().reload_current_scene()
    elif not is_reloading:
        # Execute immediately so short touchscreen taps are never lost before
        # the next physics frame on Android.
        shoot_pressed = false
        _shoot()

func _start_next_mission():
    selected_mission = min(mission_number + 1, 10)
    saved_mission = max(saved_mission, selected_mission)
    Engine.set_meta("operation_shadow_session_mission", selected_mission)
    _save_progress()
    # Reloading removes the complete first map before the dedicated depot is built.
    get_tree().reload_current_scene()

func _start_new_game():
    saved_mission = 1
    selected_mission = 1
    Engine.set_meta("operation_shadow_session_mission", 1)
    owned_weapons.clear()
    owned_weapons.append("sniper")
    _save_progress()
    get_tree().reload_current_scene()

func _save_progress():
    var config = ConfigFile.new()
    config.set_value("progress", "save_schema", 126)
    config.set_value("progress", "unlocked_mission", saved_mission)
    config.set_value("progress", "selected_mission", selected_mission)
    config.set_value("progress", "owned_weapons", owned_weapons)
    config.set_value("settings", "player_color", player_color_index)
    config.set_value("settings", "sound_level", sound_level)
    config.set_value("settings", "brightness", brightness_level)
    config.save(SAVE_PATH)

func _load_progress():
    var config = ConfigFile.new()
    if config.load(SAVE_PATH) == OK:
        var previous_schema = int(config.get_value("progress", "save_schema", 0))
        var previous_unlocked = int(config.get_value("progress", "unlocked_mission", 1))
        var reached_six_before_stage_seven = previous_unlocked >= 6
        var reached_seven_before_stage_eight = previous_unlocked >= 7
        # V95 could store only up to stage 3. The current project follows the
        # user's completed port mission by migrating that old maximum to 4.
        if previous_schema < 96 and previous_unlocked >= 3:
            previous_unlocked = 4
        if previous_schema < 103 and previous_unlocked >= 4:
            previous_unlocked = 5
        if previous_schema < 106 and previous_unlocked >= 5:
            previous_unlocked = 6
        # V117 capped progress at stage 6 even after completing it. V118 also
        # wrote some stage-6 saves before the migration existed. Upgrade only
        # existing saves that had already reached 6, never earlier saves.
        if previous_schema < 119 and reached_six_before_stage_seven and previous_unlocked == 6:
            previous_unlocked = 7
            stage_seven_migrated = true
        # V119 capped saves at 7 even after the seventh mission was completed.
        if previous_schema < 120 and reached_seven_before_stage_eight and previous_unlocked == 7:
            previous_unlocked = 8
            stage_eight_migrated = true
        if previous_schema < 124 and previous_unlocked >= 8:
            previous_unlocked = 9
            stage_nine_migrated = true
        if previous_schema < 126 and previous_unlocked >= 9:
            previous_unlocked = 10
            stage_ten_migrated = true
        saved_mission = clamp(previous_unlocked, 1, 10)
        selected_mission = clamp(int(config.get_value("progress", "selected_mission", saved_mission)), 1, saved_mission)
        player_color_index = clamp(int(config.get_value("settings", "player_color", 0)), 0, 3)
        sound_level = clamp(int(config.get_value("settings", "sound_level", 3)), 0, 3)
        brightness_level = clamp(int(config.get_value("settings", "brightness", 1)), 0, 3)
        var stored_weapons = config.get_value("progress", "owned_weapons", ["sniper"])
        owned_weapons.clear()
        for stored_weapon in stored_weapons:
            owned_weapons.append(String(stored_weapon))
        if not owned_weapons.has("rifle"):
            owned_weapons.append("rifle")
        if not owned_weapons.has("sniper"):
            owned_weapons.append("sniper")
        if stage_ten_migrated:
            selected_mission = 10
            _save_progress()
        elif stage_nine_migrated:
            selected_mission = 9
            _save_progress()
        elif stage_eight_migrated:
            selected_mission = 8
            _save_progress()
        elif stage_seven_migrated:
            selected_mission = 7
            _save_progress()

func _update_health_color():
    if player_health <= 30:
        health_fill_style.bg_color = Color(0.90, 0.05, 0.04, 0.98)
    elif player_health <= 60:
        health_fill_style.bg_color = Color(0.95, 0.55, 0.02, 0.98)
    else:
        health_fill_style.bg_color = Color(0.08, 0.72, 0.20, 0.98)
    health_bar.queue_redraw()

func _cycle_stance():
    if not game_started or game_ended:
        return
    stance = (stance + 1) % 3
    var capsule = player_collision.shape as CapsuleShape3D
    if stance == 0:
        stance_button.text = "🧍"
        camera.position.y = 0.65
        capsule.height = 1.8
        player_collision.position.y = 0.0
        quiet_mode = false
    elif stance == 1:
        stance_button.text = "🧎"
        camera.position.y = 0.20
        capsule.height = 1.25
        player_collision.position.y = -0.25
        quiet_mode = true
    else:
        stance_button.text = "▬"
        camera.position.y = -0.18
        capsule.height = 0.90
        player_collision.position.y = -0.48
        quiet_mode = true

func _toggle_zoom():
    if not game_started or game_ended:
        return
    zoomed = not zoomed
    var target_fov = 5.0 if zoomed and current_weapon == "sniper" else (20.0 if zoomed else 75.0)
    var zoom_tween = create_tween()
    zoom_tween.set_trans(Tween.TRANS_QUAD)
    zoom_tween.set_ease(Tween.EASE_OUT)
    zoom_tween.tween_property(camera, "fov", target_fov, 0.18)
    zoom_button.text = "⊗" if zoomed else "◉"

func _cycle_movement_mode():
    if not game_started or game_ended:
        return
    movement_mode = (movement_mode + 1) % 3
    if movement_mode == 0:
        speed_button.text = "🚶"
        status_label.text = "وضع المشي الهادئ"
    elif movement_mode == 1:
        speed_button.text = "🏃"
        status_label.text = "وضع الجري"
    else:
        speed_button.text = "⚡"
        status_label.text = "الجري السريع - يصدر ضجيجاً أكبر"

func _make_btn(txt: String, pos: Vector2, sz: Vector2) -> Button:
    var b = Button.new()
    b.text = txt
    b.position = pos
    b.size = sz
    b.focus_mode = Control.FOCUS_NONE
    b.layout_direction = Control.LAYOUT_DIRECTION_LTR
    b.add_theme_font_size_override("font_size", 28)
    b.add_theme_color_override("font_color", Color(1, 1, 1, 0.96))
    b.add_theme_color_override("font_pressed_color", Color(1, 0.90, 0.30, 1))
    var radius = int(min(sz.x, sz.y) * 0.48)
    var normal_style = StyleBoxFlat.new()
    normal_style.bg_color = Color(0.04, 0.07, 0.09, 0.16)
    normal_style.border_color = Color(0.82, 0.90, 0.96, 0.52)
    normal_style.border_width_left = 2
    normal_style.border_width_top = 2
    normal_style.border_width_right = 2
    normal_style.border_width_bottom = 2
    normal_style.corner_radius_top_left = radius
    normal_style.corner_radius_top_right = radius
    normal_style.corner_radius_bottom_left = radius
    normal_style.corner_radius_bottom_right = radius
    var pressed_style = normal_style.duplicate()
    pressed_style.bg_color = Color(0.10, 0.42, 0.58, 0.38)
    var hover_style = normal_style.duplicate()
    hover_style.bg_color = Color(0.08, 0.20, 0.26, 0.25)
    b.add_theme_stylebox_override("normal", normal_style)
    b.add_theme_stylebox_override("pressed", pressed_style)
    b.add_theme_stylebox_override("hover", hover_style)
    b.add_theme_stylebox_override("focus", normal_style)
    b.modulate = Color(1, 1, 1, 0.88)
    return b

func _on_look_gui_input(event):
    if event is InputEventScreenTouch:
        # The whole free viewport controls aiming. Buttons are added above this
        # area and consume their own touches, so aiming never steals a button.
        if event.pressed and look_touch_id == -1:
            look_touch_id = event.index
        elif event.index == look_touch_id:
            look_touch_id = -1
    elif event is InputEventScreenDrag and event.index == look_touch_id:
        _apply_look_drag(event.relative)

func _apply_look_drag(relative: Vector2):
    var sensitivity = AIM_LOOK_SENS if zoomed else LOOK_SENS
    if _get_aim_assist_target() != null:
        # Slow the final few pixels over a visible enemy without stealing
        # control from the player or snapping through walls.
        sensitivity *= 0.58
    yaw -= relative.x * sensitivity
    pitch -= relative.y * sensitivity
    pitch = clamp(pitch, deg_to_rad(-75), deg_to_rad(75))
    player.rotation.y = yaw
    camera.rotation.x = pitch
