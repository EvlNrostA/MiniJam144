extends Sprite2D

const MIN_WAIT = 4
const MAX_WAIT = 13

@onready var roar_sound = preload("res://Assets/Music/dragon-roar-38093.wav")
@onready var audio_stream_player = $AudioStreamPlayer

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var animation

func start(animation):
	rotation = 0
	self.animation = animation
	audio_stream_player.stream = roar_sound
	start_timer()
	
func start_timer():
	timer.start(randf_range(MIN_WAIT, MAX_WAIT))

func _on_timer_timeout():
	if not audio_stream_player.playing:
		audio_stream_player.play()
		
	animation_player.play(animation)
	start_timer()
