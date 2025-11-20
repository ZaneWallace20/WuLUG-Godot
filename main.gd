extends Node3D

@onready var player: CharacterBody3D = $Player
var block = load("res://block.tscn").instantiate()
@onready var spawn_timer: Timer = $SpawnTimer

@export var spawn_time := 1.0
var reset_spawn_timer := spawn_time

@export var spawn_block_x_offset := 5
@export var spawn_block_y_offset := 2
var player_spawn := Vector3.ZERO
@export var block_spawn := Vector3.ZERO

func reset():
	spawn_timer.wait_time = reset_spawn_timer
	player.position = player_spawn
	
func spawn():
	var other_block = block.duplicate()
	other_block.position = block_spawn
	other_block.position.x = randf_range(-spawn_block_x_offset,spawn_block_x_offset)
	other_block.position.y = randf_range(block_spawn.y, spawn_block_y_offset)
	
	spawn_timer.wait_time *= 0.95
	spawn_timer.wait_time = clamp(spawn_timer.wait_time,0.1,1)
	add_child(other_block)

func _on_spawn_timeout() -> void:
	spawn()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_spawn = player.position
	player_spawn.y += 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.y <= -5:
		reset()
	print(spawn_timer.time_left)
