extends Sprite2D

@onready var tilemap = get_parent().get_node("map/TileMap")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var tilepos = tilemap.local_to_map(mouse_position)
	position = tilepos * 16

	if Input.is_action_pressed("build"):
		tilemap.set_cell(2, tilepos, -1, Vector2i(1, 6))
		tilemap.set_cells_terrain_connect(2, [tilepos], 0, 1, false)
