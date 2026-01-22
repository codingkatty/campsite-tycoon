extends Control

var tent_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()

func refresh():
	$name.text = tent_data.name

	$pic.texture = $pic.texture.duplicate()
	$pic.texture.region = Rect2(tent_data.icon_atlas_x, 0, 20, 28)

	$price.get_node("text").text = "$" + str(tent_data.price)

	var is_occupied = tent_data.occupied
	$occupied.texture = $occupied.texture.duplicate()

	if is_occupied:
		$occupied.texture.region = Rect2(43, 0, 43, 10)
	else:
		$occupied.texture.region = Rect2(0, 0, 43, 10)
