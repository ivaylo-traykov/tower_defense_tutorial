extends PathFollow2D

signal base_damage(damage)

var speed = 150
var hp = 60
var projectile_imapct = preload("res://Scenes/SupportScenes/projectile_impact.tscn")
var damage = 21

@onready var health_bar = $HealthBar
@onready var impact_area = $Impact



func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)

func _physics_process(delta):
	if get_progress_ratio() == 1.0:
		base_damage.emit(damage)
		queue_free()
	move(delta)


func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = position + Vector2(-30, -30)


func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()


func impact():
	randomize()
	var x_pos =randi() % 31
	randomize()
	var y_pos =randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_imapct.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)



func on_destroy():
	get_node("RigidBody2D").queue_free()
	await(get_tree().create_timer(0.2).timeout)
	queue_free()
