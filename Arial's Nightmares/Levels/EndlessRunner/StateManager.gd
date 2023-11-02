extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 4000,
		"level_timer": 20,
		"level_velocity": 300,
		"obstacle_wait_range": [2, 3]
	},
	"normal": {
		"speed": 2000,
		"level_timer": 30,
		"level_velocity": 700,
		"obstacle_wait_range": [1, 2]
	},
	"hard": {
		"speed": 100,
		"level_timer": 30,
		"level_velocity": 1200,
		"obstacle_wait_range": [1, 2]
	}
}

const COIN_WAIT_RANGE = [5, 7]
const ITEMS_START_POS = Vector2(1230, 530)
const COIN_POINTS = 5

@onready var obstacle_scene = preload("res://Levels/EndlessRunner/Obstacle.tscn")
@onready var coin_scene = preload("res://Nodes/Mechanics/Coin.tscn")

@onready var player = $Player
@onready var tile_timer = $TileTimer
@onready var coin_timer = $CoinTimer

@onready var coins = []

var settings

func _ready():
	randomize()
	
	if GManager.difficulty == null:
		GManager.restart_levels()
		GManager.difficulty = "easy"
	
	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed
	player.shadow.visible = false
	
	var clouds = get_tree().get_nodes_in_group("Clouds")
	for cloud in clouds:
		cloud.start()
	
	LVLTimer.start_timer(settings.level_timer, _on_level_timer_timeout)
	start_coin_timer()
	start_tiles()

func start_tiles():
	tile_timer.start(GManager.randf_list_range(settings.obstacle_wait_range))

func _on_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	obstacle.emit_signal("SPAWN", Vector2.LEFT, settings.level_velocity, ITEMS_START_POS)
	
	start_tiles()
	
func _on_level_timer_timeout():
	GManager.next_level()

func start_coin_timer():
	coin_timer.start(GManager.randf_list_range(COIN_WAIT_RANGE))

func _on_coin_timer_timeout():
	var coin = coin_scene.instantiate()
	add_child(coin)
	coins.append(coin)

	coin.z_index = 5
	coin.movement_function = "endless_runner_movement"
	coin.velocity = settings.level_velocity
	coin.points = COIN_POINTS
	coin.global_position = ITEMS_START_POS
	
	start_coin_timer()
