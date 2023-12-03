extends Area2D

@onready var manager = get_parent()

func _process(delta: float) -> void:
	if manager.settings:
		position = position.move_toward(manager.player.position, manager.settings.nir_speed * delta)

func _on_arielush_entered(col):
	manager.player.death()
