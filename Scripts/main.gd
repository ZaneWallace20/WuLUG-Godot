'''
This is the main script of the game. it controls spawning of the blocks,
player death, reset of game and so on
'''
extends Node3D

# grab tree vars, 'onready' lets us ues these when the node is in game
@onready var player: CharacterBody3D = $Player
@onready var spawn_timer: Timer = $SpawnTimer

# grab the block scene for use later
var block = load("res://Scenes/block.tscn").instantiate()

# 'export' lets us edit this var from the editor

# default spawn time of 1 second, save this time for later
@export var spawn_time := 1.0
var reset_spawn_timer := spawn_time

# rate in which the timer decreases
@export var decay_rate := 0.95
@export var min_spawn_rate := 0.1

# offsets for the random spawning
@export var spawn_block_x_offset := 5
@export var spawn_block_y_offset := 2

# initial spawn spots 
var player_spawn := Vector3.ZERO
@export var block_spawn := Vector3.ZERO


# player dies
func reset():
	spawn_timer.wait_time = reset_spawn_timer
	player.position = player_spawn
	
func spawn():
	
	# grab the block we instantiated
	var other_block = block.duplicate()
	
	# place it at the default spot
	other_block.position = block_spawn
	
	# adjust x/y 
	other_block.position.x = randf_range(-spawn_block_x_offset,spawn_block_x_offset)
	other_block.position.y = randf_range(block_spawn.y, spawn_block_y_offset)
	
	# make blocks spawn faster
	spawn_timer.wait_time *= decay_rate
	
	# prevent the timer from going too low
	spawn_timer.wait_time = clamp(spawn_timer.wait_time,min_spawn_rate,reset_spawn_timer)
	
	# place the block in the scene
	add_child(other_block)

# when timer stops
func _on_spawn_timeout() -> void:
	spawn()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# remove mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# grab current player position and use that for spawn
	player_spawn = player.position
	
	# I add double block y to player y to prevent clipping when respawn
	player_spawn.y += spawn_block_y_offset * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# check if the player "dies"
	if player.position.y <= -5:
		reset()
