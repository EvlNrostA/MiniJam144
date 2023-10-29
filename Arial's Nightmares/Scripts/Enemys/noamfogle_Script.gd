extends Area2D

@onready var hide_timer = $HideTimer
@onready var reveal_timer = $RevealTimer
@onready var sprite = $NoamFogle
@onready var animation_player = $AnimationPlayer
@onready var hiding = true

func _ready():
	sprite.visible = false

func reveal(reveal_delay) -> void:
	sprite.visible = true
	animation_player.play("Jumping")
	await animation_player.animation_finished
	
	reveal_timer.start(reveal_delay)
	await reveal_timer.timeout
	
	animation_player.play_backwards("Jumping")
	await animation_player.animation_finished
	sprite.visible = false
	
func hide_and_reveal(reveal_delay, hide_delay) -> void:
	if hiding:
		hiding = false
		hide_timer.start(hide_delay)
		await hide_timer.timeout
		
		await reveal(reveal_delay)
		hiding = true

func _on_body_entered(body):
	if sprite.visible:
		reveal_timer.stop()
		hide_timer.stop()
	
		animation_player.play("Death")
		await animation_player.animation_finished
		sprite.visible = false
		hiding = true
		
		body.killed_noam_fogle(self)
