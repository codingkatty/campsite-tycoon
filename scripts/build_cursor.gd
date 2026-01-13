extends Node2D

@onready var tilemap = get_parent().get_node("map/TileMap")
@onready var pointer1 = get_node("1t")
@onready var pointer2_h = get_node("2t_horizontal")
@onready var pointer2_v = get_node("2t_vertical")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var tilepos = tilemap.local_to_map(mouse_position)
	pointer2_h.position = tilepos * 16

	if Input.is_action_just_pressed("build"):
		print("build")
		tilemap.set_cell(2, tilepos, 0, Vector2i(14, 5))
		#tilemap.set_cells_terrain_connect(2, [tilepos], 0, 1, false)
