extends Node2D
class_name Turret

var enemy_array = []
var built = false
var enemy = null
var ready_to_fire = true
var type
var category


func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]


func _physics_process(delta):
	if enemy_array.size() > 0 and built:
		select_enemy()
		if not get_node("AnimationPlayer").is_playing():
			turn()
		if ready_to_fire:
			fire()
		


func select_enemy():
	if enemy_array.size() == 0:
		enemy = null
		return
	var enemy_progress_aray = []
	for i in enemy_array:
		enemy_progress_aray.append(i.progress)
	var max_offset = enemy_progress_aray.max()
	var enemy_index = enemy_progress_aray.find(max_offset)
	enemy = enemy_array[enemy_index]


func turn():
	get_node("Turret").look_at(enemy.position)


func fire():
	ready_to_fire = false
	if category == "Projectile":
		fire_gun()
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	ready_to_fire = true


func fire_gun():
	get_node("AnimationPlayer").play("Fire")


func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	print(enemy_array)

