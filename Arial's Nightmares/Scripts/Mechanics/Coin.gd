extends Area2D

@onready var coin_sound = preload("res://Assets/Music/mixkit-coins-sound-2003.wav")
@onready var audio_stream_player = $AudioStreamPlayer

@onready var sprite = $Pizza
@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var collected = false

var pickup_function
var movement_function
var velocity

func _ready():
	audio_stream_player.stream = coin_sound

func _physics_process(delta):
	if movement_function:
		global_position = movement_function.call(global_position, delta)

func _on_body_entered(_body):
	if not collected:
		collected = true
		
		audio_stream_player.play()
		animation_player.play_backwards("Spawn")
		await animation_player.animation_finished
		visible = false
		
		if pickup_function:
			await pickup_function.call()
			
		queue_free()
