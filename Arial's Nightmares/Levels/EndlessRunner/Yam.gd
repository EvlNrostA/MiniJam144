extends Area2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta):
	$"../Line2D".points[1] = make_canvas_position_local($"../Player_Tamplate".position)
	pass


func _on_arielush_entered(body):
	if body.is_in_group("player_group"):
		body.death()