extends CharacterBody2D
class_name Player_library


@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

@export var speed : float = 1
var vel := Vector2.ZERO


var JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	Move2D(delta)
	pass

func Move2D(delta) -> void:
	vel = Vector2(Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"))
	move_and_collide(vel * delta * speed * 100)
	if vel != Vector2.ZERO:
		animationPlayer.play("Run_Right")
	else:
		animationPlayer.play("Idle_Right")
		
	if vel.x >= 1:
		$Player_Sprite.flip_h = false
	elif vel.x <= -1:
		$Player_Sprite.flip_h = true
	pass


func PlatformMove2D(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed * 100
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 100)

	move_and_slide()
	pass
