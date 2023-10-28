extends Node2D

@onready var bullet_refrance = preload("res://Levels/YAM/obstacle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	
	var newOB = bullet_refrance.instantiate()
	get_parent().add_child(newOB)
	newOB.emit_signal("SPAWN",Vector2.LEFT, Vector2(1350, 530))
	
	
	randomize()
	$Timer.wait_time = randf_range(1.6, 6.0)
	print($Timer.wait_time)
	$Timer.start()
	

