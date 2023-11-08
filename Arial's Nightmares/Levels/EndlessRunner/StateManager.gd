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

const COIN_WAIT_RANGE = [3, 5]
const ITEMS_START_OFFSET = Vector2i(50, -180)
const COIN_POINTS = 5

@onready var obstacle_scene = preload("res://Levels/EndlessRunner/Obstacle.tscn")
@onready var coin_scene = preload("res://Nodes/Mechanics/Coin.tscn")

@onready var player = $Player
@onready var tile_timer = $TileTimer
@onready var coin_timer = $CoinTimer
@onready var buttons = $Buttons

var items_start_position
var settings

func _ready():
	if not GManager.is_mobile:
		buttons.visible = false
	
	if GManager.difficulty == null:
		GManager.start_level("easy")
	
	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed
	player.shadow.visible = false

	items_start_position = DisplayServer.window_get_size() + ITEMS_START_OFFSET
	
	var clouds = get_tree().get_nodes_in_group("Clouds")
	for cloud in clouds:
		cloud.start()
	
	UI.start_timer(settings.level_timer, _on_level_timer_timeout)
	start_coin_timer()
	start_tiles()

func start_tiles():
	tile_timer.start(GManager.randf_list_range(settings.obstacle_wait_range))

func _on_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	
	obstacle.area_entered.connect(Callable(item_delete).bind(obstacle))
	obstacle.emit_signal("SPAWN", Vector2.LEFT, settings.level_velocity, items_start_position)
	
	start_tiles()
	
func _on_level_timer_timeout():
	if not player.hit:
		GManager.next_level()

func start_coin_timer():
	coin_timer.start(GManager.randf_list_range(COIN_WAIT_RANGE))

func _on_coin_timer_timeout():
	var coin = coin_scene.instantiate()
	
	coin.scale.y = 0.5
	coin.scale *= 1.5
	
	coin.z_index = 0
	coin.movement_function = "endless_runner_movement"
	coin.velocity = settings.level_velocity
	coin.points = COIN_POINTS
	
	add_child(coin)
	
	coin.global_position = items_start_position
	coin.global_position.y += coin.sprite.get_rect().size.y / 8
	coin.area_entered.connect(Callable(item_delete).bind(coin))
	
	start_coin_timer()

func item_delete(col, item) -> void:
	if col.name == "ItemCollision":
		item.queue_free()
