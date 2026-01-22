extends Control

var data: ItemData
var atlas_x: int = 60
var atlas_y: int = 0
var price = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$pic.texture = $pic.texture.duplicate()
	$pic.texture.region = Rect2(atlas_x, atlas_y, 20, 28)

	$TextureButton.texture_normal = $TextureButton.texture_normal.duplicate()
	$TextureButton.texture_normal.region = Rect2(0, atlas_y, 20, 28)

	$TextureButton.texture_hover = $TextureButton.texture_hover.duplicate()
	$TextureButton.texture_hover.region = Rect2(20, atlas_y, 20, 28)

	$TextureButton.texture_pressed = $TextureButton.texture_pressed.duplicate()
	$TextureButton.texture_pressed.region = Rect2(40, atlas_y, 20, 28)

	$price.text = str(price)

func _on_button_toggled(toggled_on:bool) -> void:
	if toggled_on:
		Utils.emit_signal("item_selected", data)
