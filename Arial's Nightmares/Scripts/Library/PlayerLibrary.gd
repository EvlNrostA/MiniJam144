extends CharacterBody2D
class_name Player_library

@onready var footstep_sound = preload("res://Assets/Music/concrete-footsteps-6752.wav")
@onready var death_sound = preload("res://Assets/Music/8bit-lose-life-sound-wav-97245.wav")
@onready var audio_stream_player = $AudioStreamPlayer
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var collision_shape = $CollisionShape2D
@onready var shadow = $Shadow
@onready var sprite = $Sprite2D

@export var speed : float = 1
var vel := Vector2.ZERO


var JUMP_VELOCITY = -400
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func play_sound(sound):
	audio_stream_player.stream = sound
	audio_stream_player.play()

func death_animation():
	shadow.hide()
	play_sound(death_sound)
	animationPlayer.play("Fall")
	await animationPlayer.animation_finished

func run_animation(given_velocity):
	if given_velocity != Vector2.ZERO:
		animationPlayer.play("Run_Right")
	else:
		animationPlayer.play("Idle_Right")

func Move2D(delta) -> void:
	vel = Vector2(Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"))

	move_and_collide(vel * delta * speed * 100)
	
	run_animation(vel)
	if vel != Vector2.ZERO and not audio_stream_player.playing:
		play_sound(footstep_sound)
		
	if vel.x >= 0.1:
		sprite.flip_h = false
	elif vel.x <= -0.1:
		sprite.flip_h = true
	pass


func PlatformMove2D(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("Space") and is_on_floor():
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
	
func Move2DRight(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = (speed / 2) * delta

	if Input.is_action_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if is_on_floor():
		if Input.is_action_pressed("Right"):
			velocity.x = speed * delta
		else:
			velocity.x = -10000 * delta
			
	run_animation(velocity)
	
	move_and_slide()
