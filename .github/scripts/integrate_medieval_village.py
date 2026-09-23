#!/usr/bin/env python3
import json, shutil, sys, zipfile
from pathlib import Path
from PIL import Image

project = Path(sys.argv[1]).resolve()
asset_zip = Path(sys.argv[2]).resolve()
ASSETS = [
    "Wall_Plaster_Straight","Wall_Plaster_Window_Wide_Flat","Wall_Plaster_Door_Flat",
    "Wall_Plaster_WoodGrid","Wall_UnevenBrick_Straight","Wall_UnevenBrick_Window_Wide_Flat",
    "Wall_UnevenBrick_Door_Flat","Roof_RoundTiles_4x4","Roof_RoundTiles_6x6",
    "Door_1_Flat","Prop_Crate","Prop_Wagon","Prop_WoodenFence_Single",
    "Prop_WoodenFence_Extension1","Balcony_Simple_Straight"
]
if not (project / "project.godot").is_file():
    raise SystemExit(f"Godot project not found: {project}")
if not asset_zip.is_file():
    raise SystemExit(f"Asset zip not found: {asset_zip}")

asset_out = project / "assets" / "medieval_village"
if asset_out.exists():
    shutil.rmtree(asset_out)
asset_out.mkdir(parents=True)

with zipfile.ZipFile(asset_zip) as zf:
    names = zf.namelist()
    def member_for(basename):
        suffix = "/glTF/" + basename
        return next((n for n in names if n.endswith(suffix)), None)

    textures = set()
    for stem in ASSETS:
        gltf_name = member_for(stem + ".gltf")
        bin_name = member_for(stem + ".bin")
        if not gltf_name or not bin_name:
            raise RuntimeError(f"Missing glTF pair for {stem}")
        gltf_bytes = zf.read(gltf_name)
        (asset_out / f"{stem}.gltf").write_bytes(gltf_bytes)
        (asset_out / f"{stem}.bin").write_bytes(zf.read(bin_name))
        doc = json.loads(gltf_bytes.decode("utf-8"))
        for item in doc.get("images", []):
            uri = item.get("uri")
            if uri and not uri.startswith("data:"):
                textures.add(Path(uri).name)

    for texture in sorted(textures):
        member = member_for(texture)
        if not member:
            raise RuntimeError(f"Missing texture {texture}")
        target = asset_out / texture
        target.write_bytes(zf.read(member))
        with Image.open(target) as im:
            if max(im.size) > 1024:
                scale = 1024 / max(im.size)
                size = (max(1, int(im.size[0] * scale)), max(1, int(im.size[1] * scale)))
                im.resize(size, Image.Resampling.LANCZOS).save(target, compress_level=6)

    license_member = next((n for n in names if n.endswith("/License_Standard.txt")), None)
    if license_member:
        (asset_out / "LICENSE_Quaternius_CC0.txt").write_bytes(zf.read(license_member))

main_path = project / "main.gd"
text = main_path.read_text(encoding="utf-8")

if "var medieval_asset_cache := {}" not in text:
    marker = "var brightness_level := 1\n"
    if marker not in text:
        raise RuntimeError("Global insertion point not found")
    text = text.replace(marker, marker + "var medieval_asset_cache := {}\n", 1)

door_marker = "    door.add_child(door_mesh)\n\n    # Windows, stone bands and distinct roof silhouettes distinguish each building.\n"
if "_attach_medieval_door_visual(door, door_mesh, door_width)" not in text:
    repl = (
        "    door.add_child(door_mesh)\n"
        "    if mission_number == 1:\n"
        "        _attach_medieval_door_visual(door, door_mesh, door_width)\n\n"
        "    # Windows, stone bands and distinct roof silhouettes distinguish each building.\n"
    )
    if door_marker not in text:
        raise RuntimeError("Door insertion point not found")
    text = text.replace(door_marker, repl, 1)

building_end = "    _make_structure(center + Vector3(-1.10, -1.68, 1.82), Vector3(0.62, 0.78, 0.10), Color(0.20, 0.18, 0.15))\n\nfunc _make_vehicle"
if "_dress_medieval_building(center, building_size, lock_kind)" not in text:
    repl = (
        "    _make_structure(center + Vector3(-1.10, -1.68, 1.82), Vector3(0.62, 0.78, 0.10), Color(0.20, 0.18, 0.15))\n"
        "    if mission_number == 1:\n"
        "        _dress_medieval_building(center, building_size, lock_kind)\n\n"
        "func _make_vehicle"
    )
    if building_end not in text:
        raise RuntimeError("Building insertion point not found")
    text = text.replace(building_end, repl, 1)

compound_end = "    _make_structure(Vector3(70, 2.0, 0), Vector3(0.8, 4, 140), Color(0.20, 0.22, 0.24))\n\nfunc _build_missile_depot():"
if "_spawn_medieval_village_props()" not in text:
    repl = (
        "    _make_structure(Vector3(70, 2.0, 0), Vector3(0.8, 4, 140), Color(0.20, 0.22, 0.24))\n"
        "    _spawn_medieval_village_props()\n\n"
        "func _build_missile_depot():"
    )
    if compound_end not in text:
        raise RuntimeError("Compound insertion point not found")
    text = text.replace(compound_end, repl, 1)

helpers = r'''
func _get_medieval_asset(asset_name: String):
    if medieval_asset_cache.has(asset_name):
        return medieval_asset_cache[asset_name]
    var path = "res://assets/medieval_village/" + asset_name + ".gltf"
    if not ResourceLoader.exists(path):
        medieval_asset_cache[asset_name] = null
        return null
    var resource = load(path)
    if resource is PackedScene:
        medieval_asset_cache[asset_name] = resource
        return resource
    medieval_asset_cache[asset_name] = null
    return null

func _spawn_medieval_asset(asset_name: String, pos: Vector3, rot: Vector3 = Vector3.ZERO, asset_scale: Vector3 = Vector3.ONE, parent: Node3D = null):
    var packed = _get_medieval_asset(asset_name)
    if packed == null:
        return null
    var instance = packed.instantiate()
    if not (instance is Node3D):
        instance.queue_free()
        return null
    var parent_node: Node3D = self if parent == null else parent
    parent_node.add_child(instance)
    instance.position = pos
    instance.rotation_degrees = rot
    instance.scale = asset_scale
    instance.set_meta("medieval_visual", true)
    return instance

func _attach_medieval_door_visual(door: AnimatableBody3D, fallback_mesh: MeshInstance3D, door_width: float):
    var visual = _spawn_medieval_asset(
        "Door_1_Flat",
        Vector3(-door_width * 0.50 + 0.07, -1.15, -0.10),
        Vector3.ZERO,
        Vector3(door_width / 1.118, 2.30 / 2.10, 1.0),
        door
    )
    if visual != null:
        fallback_mesh.visible = false

func _dress_medieval_building(center: Vector3, building_size: Vector3, lock_kind: String):
    var seed_value = int(abs(center.x * 3.0 + center.z * 5.0))
    var prefix = "Wall_UnevenBrick" if seed_value % 3 == 0 else "Wall_Plaster"
    if lock_kind in ["building1", "building2"]:
        prefix = "Wall_Plaster"
    var straight_asset = prefix + "_Straight"
    var door_asset = prefix + "_Door_Flat"
    var window_asset = prefix + "_Window_Wide_Flat"
    var wall_y_scale = max(0.72, building_size.y / 3.123)
    var visual_offset = 0.13

    var door_module_width = min(2.20, building_size.x * 0.30)
    var front_side_width = max(0.90, (building_size.x - door_module_width) * 0.50)
    var front_side_offset = door_module_width * 0.50 + front_side_width * 0.50
    var front_z = center.z + building_size.z * 0.50 + visual_offset
    _spawn_medieval_asset(straight_asset, Vector3(center.x - front_side_offset, 0.0, front_z), Vector3(0, 180, 0), Vector3(front_side_width / 2.0, wall_y_scale, 1.0))
    _spawn_medieval_asset(door_asset, Vector3(center.x, 0.0, front_z), Vector3(0, 180, 0), Vector3(door_module_width / 2.0, wall_y_scale, 1.0))
    _spawn_medieval_asset(straight_asset, Vector3(center.x + front_side_offset, 0.0, front_z), Vector3(0, 180, 0), Vector3(front_side_width / 2.0, wall_y_scale, 1.0))

    var rear_window_width = min(2.80, building_size.x * 0.34)
    var rear_side_width = max(0.90, (building_size.x - rear_window_width) * 0.50)
    var rear_side_offset = rear_window_width * 0.50 + rear_side_width * 0.50
    var rear_z = center.z - building_size.z * 0.50 - visual_offset
    _spawn_medieval_asset(straight_asset, Vector3(center.x - rear_side_offset, 0.0, rear_z), Vector3.ZERO, Vector3(rear_side_width / 2.0, wall_y_scale, 1.0))
    _spawn_medieval_asset(window_asset, Vector3(center.x, 0.0, rear_z), Vector3.ZERO, Vector3(rear_window_width / 2.0, wall_y_scale, 1.0))
    _spawn_medieval_asset(straight_asset, Vector3(center.x + rear_side_offset, 0.0, rear_z), Vector3.ZERO, Vector3(rear_side_width / 2.0, wall_y_scale, 1.0))

    var side_scale = max(1.0, building_size.z / 2.0)
    var left_x = center.x - building_size.x * 0.50 - visual_offset
    var right_x = center.x + building_size.x * 0.50 + visual_offset
    _spawn_medieval_asset(straight_asset, Vector3(left_x, 0.0, center.z), Vector3(0, -90, 0), Vector3(side_scale, wall_y_scale, 1.0))
    _spawn_medieval_asset(straight_asset, Vector3(right_x, 0.0, center.z), Vector3(0, 90, 0), Vector3(side_scale, wall_y_scale, 1.0))

    var use_large_roof = max(building_size.x, building_size.z) > 12.0
    var roof_asset = "Roof_RoundTiles_6x6" if use_large_roof else "Roof_RoundTiles_4x4"
    var roof_source_x = 8.25 if use_large_roof else 5.513
    var roof_source_z = 8.032 if use_large_roof else 5.561
    var roof_x_scale = (building_size.x + 0.80) / roof_source_x
    var roof_z_scale = (building_size.z + 0.80) / roof_source_z
    var roof_y_scale = 0.34 if building_size.y >= 4.0 else 0.28
    _spawn_medieval_asset(roof_asset, Vector3(center.x, building_size.y + 0.12, center.z), Vector3.ZERO, Vector3(roof_x_scale, roof_y_scale, roof_z_scale))

    if building_size.y >= 4.0 and seed_value % 2 == 0:
        _spawn_medieval_asset(
            "Balcony_Simple_Straight",
            Vector3(center.x, min(building_size.y - 1.10, 2.70), front_z + 0.04),
            Vector3(0, 180, 0),
            Vector3(min(2.1, building_size.x / 4.0), 1.0, 1.0)
        )

func _spawn_medieval_village_props():
    var prop_specs = [
        ["Prop_Crate", Vector3(-29.2, 0.0, -9.2), Vector3(0, 18, 0), Vector3(0.95, 0.95, 0.95)],
        ["Prop_Crate", Vector3(-27.9, 0.0, -9.6), Vector3(0, -12, 0), Vector3(0.78, 0.78, 0.78)],
        ["Prop_Crate", Vector3(30.2, 0.0, -25.3), Vector3(0, 31, 0), Vector3(0.90, 0.90, 0.90)],
        ["Prop_Wagon", Vector3(31.2, 0.0, 27.8), Vector3(0, -34, 0), Vector3(1.0, 1.0, 1.0)],
        ["Prop_WoodenFence_Single", Vector3(-54.5, 0.0, 13.0), Vector3(0, 90, 0), Vector3(1.1, 1.1, 1.1)],
        ["Prop_WoodenFence_Extension1", Vector3(-54.5, 0.0, 9.2), Vector3(0, 90, 0), Vector3(1.1, 1.1, 1.1)],
        ["Prop_WoodenFence_Single", Vector3(54.5, 0.0, 14.0), Vector3(0, -90, 0), Vector3(1.1, 1.1, 1.1)]
    ]
    for spec in prop_specs:
        _spawn_medieval_asset(spec[0], spec[1], spec[2], spec[3])

'''
if "func _get_medieval_asset(asset_name: String):" not in text:
    insertion = "\nfunc _make_vehicle(pos: Vector3, color: Color, truck: bool):\n"
    if insertion not in text:
        raise RuntimeError("Helper insertion point not found")
    text = text.replace(insertion, "\n" + helpers + "func _make_vehicle(pos: Vector3, color: Color, truck: bool):\n", 1)

main_path.write_text(text, encoding="utf-8")

cfg_path = project / "export_presets.cfg"
cfg = cfg_path.read_text(encoding="utf-8")
cfg = cfg.replace("IGImax-V127-debug.apk", "IGImax-V128-debug.apk")
cfg = cfg.replace("version/code=127", "version/code=128")
cfg = cfg.replace('version/name="1.27"', 'version/name="1.28"')
cfg_path.write_text(cfg, encoding="utf-8")

(project / "V128_MEDIEVAL_VILLAGE_AR.txt").write_text(
    "IGImax V128 - تطوير القرية\n\n"
    "- دمج عناصر مختارة من Medieval Village MegaKit Standard بصيغة glTF.\n"
    "- الحفاظ على تصادمات ومهام V127 دون تغيير.\n"
    "- إضافة واجهات وجدران ونوافذ وأبواب وأسقف وديكورات للمرحلة الأولى.\n"
    "- ضغط خامات الحزمة إلى 1024 بكسل لتحسين الأداء على Android.\n"
    "- ترخيص عناصر Quaternius: CC0 1.0.\n",
    encoding="utf-8"
)
print(f"Integrated {len(ASSETS)} medieval models and {len(textures)} shared textures")
