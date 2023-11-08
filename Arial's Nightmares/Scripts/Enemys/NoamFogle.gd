extends Area2D

@onready var explosion_sound = preload("res://Assets/Music/missile-explosion-168600.wav")
@onready var audio_stream_player = $AudioStreamPlayer

@onready var hide_timer = $HideTimer
@onready var reveal_timer = $RevealTimer
@onready var sprite = $NoamFogle
@onready var animation_player = $AnimationPlayer

@onready var hiding = true
@onready var hit = false

func reset_sprite():
	sprite.hide()
	sprite.modulate.a = 255

func _ready():
	reset_sprite()
	audio_stream_player.stream = explosion_sound

func reveal(reveal_delay) -> void:
	sprite.show()
	animation_player.play("Jumping")
	await animation_player.animation_finished
	
	reveal_timer.start(reveal_delay)
	await reveal_timer.timeout
	
	animation_player.play_backwards("Jumping")
	await animation_player.animation_finished
	sprite.hide()
	
func hide_and_reveal(reveal_delay, hide_delay) -> void:
	if hiding and not hit:
		hiding = false
		hide_timer.start(hide_delay)
		await hide_timer.timeout
		
		await reveal(reveal_delay)
		hiding = true

func _on_body_entered(body):
	if not hit and not hiding and sprite.visible:
		hit = true
		
		reveal_timer.stop()
		hide_timer.stop()
	
		audio_stream_player.play()
		animation_player.play("Death")
		await animation_player.animation_finished
		reset_sprite()
		
		body.killed_noam_fogle()
		
		hiding = true
		hit = false
