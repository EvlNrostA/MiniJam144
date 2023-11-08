extends Area2D

@onready var coin_sound = preload("res://Assets/Music/mixkit-coins-sound-2003.wav")
@onready var audio_stream_player = $AudioStreamPlayer

@onready var sprite = $Pizza
@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var collected = false

var points
var movement_function
var velocity

func _ready():
	audio_stream_player.stream = coin_sound

func endless_runner_movement(delta):
	global_position += Vector2.LEFT * velocity * delta

func _physics_process(delta):
	if movement_function and velocity:
		call(movement_function, delta)

func _on_body_entered(_body):
	if not collected:
		collected = true
		
		audio_stream_player.play()
		animation_player.play_backwards("Spawn")
		await animation_player.animation_finished
		
		visible = false
		
		await UI.points_add(points)
		queue_free()
