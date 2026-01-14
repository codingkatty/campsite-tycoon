class_name ItemData extends Resource

@export var name: String = ""
@export_enum("tent", "terrain", "amenities") var item_type: String = "tent"
@export var price: int = 0
@export var size: String = "1t"
@export var atlas_x: int = 60
@export var item_tile: Vector2i = Vector2i(-1, -1)
@export var is_terrain: bool = false
@export var terrain_set: int = -1
@export var terrain: int = -1
