extends Node

var map_node
var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_in_wave = 0

func _ready():
	map_node = get_node("Map1")
	
	for x in get_tree().get_nodes_in_group("build_buttons"):
		x.connect("pressed", Callable(self, "initiate_build_mode").bind(x.get_name()))

	start_new_wave()

func _process(delta):
	if build_mode:
		update_towe_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode:
		verify_and_build()
		cancel_build_mode()


##
## Wave functions
##
func start_new_wave():
	var wave_data = retrieve_wave_data()
	await(get_tree().create_timer(0.2).timeout)
	spawn_enemies(wave_data)


func retrieve_wave_data():
	var wave_data = [["blue_tank", 0.7], ["blue_tank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data


func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		map_node.get_node("Path").add_child(new_enemy, true)
		await(get_tree().create_timer(i[1]).timeout)


##
## Build Functions
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type.to_lower() + "_t_1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type)


func update_towe_preview():
	var mouse_position = get_node("UI/HUD").get_global_mouse_position()
	var tower_exclusion = map_node.get_node("TowerExclusion")
	var current_tile = tower_exclusion.local_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_local(current_tile)
	build_tile = current_tile
	
	if tower_exclusion.get_cell_tile_data(0, current_tile) == null:
		get_node("UI").update_tower_preview(tile_position, "80f472b4")
		build_valid = true
		build_location = tile_position
	else:
		get_node("UI").update_tower_preview(tile_position, "ff2d2db4")
		build_valid = false


func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()


func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 9, Vector2i(0,0))
