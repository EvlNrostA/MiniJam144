extends Player_library

@onready var manager = get_parent()
@onready var yam = $"../Yam"
@onready var hit = false

func _physics_process(delta):
	if not hit:
		Move2DRight(delta)
		if not audio_stream_player.playing:
			play_sound(footstep_sound)
	else:
		position = position.move_toward(yam.position, manager.settings.level_velocity * delta)
		animationPlayer.play("Fall")

func pushed():
	hit = true
	play_sound(death_sound)

func death():
	GManager.game_over()

