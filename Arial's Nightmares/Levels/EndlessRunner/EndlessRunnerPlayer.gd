extends Player_library

@onready var manager = get_parent()
@onready var yam = $"../Yam"
@onready var hit = false

func _ready():
	audio_stream_player.stream = footstep_sound

func _physics_process(delta):
	if not hit:
		Move2DRight(delta)
		if not audio_stream_player.playing:
			audio_stream_player.play()
			print("play")
	else:
		position = position.move_toward(yam.position, manager.settings.level_velocity * delta)
		animationPlayer.play("Fall")

func pushed():
	hit = true
	play_sound(death_sound)
	velocity += Vector2(-300, -300)

func death():
	GManager.game_over()

