extends CanvasLayer

@onready var shadow = $Control/Shadow
@onready var animation_player = $AnimationPlayer

func _ready():
	shadow.scale *= Vector2(DisplayServer.window_get_size() / GManager.DEFAULT_WINDOW_SIZE)

func fading() -> bool:
	return Fade.animation_player.is_playing()

func fade_in():
	shadow.visible = true
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	
func fade_out():
	animation_player.play_backwards("FadeIn")
	await animation_player.animation_finished
	shadow.visible = false
