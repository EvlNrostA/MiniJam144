extends Area2D

@onready var collision = $CollisionShape2D
@onready var collected = false

var points
var movement_function
var velocity

func endless_runner_movement(delta):
	global_position += Vector2.LEFT * velocity * delta * 100

func _process(delta):
	if movement_function and velocity:
		call(movement_function, delta)

func _on_body_entered(body):
	if not collected:
		collected = true
		visible = false
		
		await Points.add(points)
		queue_free()
