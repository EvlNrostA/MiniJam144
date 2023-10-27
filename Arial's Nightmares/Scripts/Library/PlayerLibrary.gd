extends CharacterBody2D
class_name Player_library


@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")


@export var speed : float = 1
var vel := Vector2.ZERO

func _process(delta):
	Move2D(delta)
	pass

func Move2D(delta) -> void:
	vel = Vector2(Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"))
	move_and_collide(vel * delta * speed * 100)
	pass

func MovePlatform(delta) -> void:
	pass
