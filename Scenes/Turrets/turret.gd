extends Node2D
class_name Turret

var enemy_array = []
var built = false
var enemy = null


func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[self.get_name()]["range"]


func _physics_process(delta):
	if enemy_array.size() > 0 and built:
		select_enemy()
		turn()


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


func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	print(enemy_array)

