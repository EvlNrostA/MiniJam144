extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var collected = false

var points
var movement_function
var velocity

func endless_runner_movement(delta):
	global_position += Vector2.LEFT * velocity * delta

func _physics_process(delta):
	if movement_function and velocity:
		call(movement_function, delta)

func _on_body_entered(body):
	if not collected:
		collected = true
		
		animation_player.play_backwards("Spawn")
		await animation_player.animation_finished
		
		visible = false
		
		await UI.points_add(points)
		queue_free()
