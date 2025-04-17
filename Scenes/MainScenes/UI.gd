extends CanvasLayer

@onready var hp_bar = get_node("HUD/ColorRect/MarginContainer/H/HP")


func set_tower_preview(tower_type):
	var mouse_position = get_node("HUD").get_global_mouse_position()
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("80f472b4")
	
	var range_texture = Sprite2D.new()
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.texture = load("res://Assets/UI/range_overlay.png")
	range_texture.scale = Vector2(scaling, scaling)
	range_texture.modulate = Color("80f472b4")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)


func update_tower_preview(new_position, color):
	get_node("TowerPreview").position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)

##
## Game Controls
##
func _on_pause_play_pressed():
	var game_scene = get_parent()
	
	if game_scene.build_mode:
		game_scene.cancel_build_mode()
	
	if game_scene.current_wave == 0:
		game_scene.current_wave += 1
		game_scene.start_new_wave()
	else:
		get_tree().paused = !get_tree().paused


func _on_speed_up_pressed():
	if Engine.get_time_scale() == 1.0:
		Engine.set_time_scale(2.0)
	else:
		Engine.set_time_scale(1.0)

func update_health_bar(health):
	var tween = create_tween()
	tween.tween_property(hp_bar, "value", health, 0.3)
	if health < 30:
		hp_bar.set_tint_progress("ff0602")
	elif health < 60:
		hp_bar.set_tint_progress("ffff02")	
	else:
		hp_bar.set_tint_progress("1aff02")
	
	
