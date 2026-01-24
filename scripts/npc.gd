extends CharacterBody2D

@onready var agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
var SPEED =  20
var targ: Vector2
var place_in_queue = 0
var moving_to_first = false

var char_name: String
var desc: String
var desc_info = ["job", "origin", "story"]

var price: int
var texture: Texture2D

func _ready():
	char_name = Utils.random_name()
	desc_info = Utils.generate_story()
	desc = char_name + " is a " + desc_info[0] + " that came from " + desc_info[1] + ". " + desc_info[2] + "."
	price = randi() % 8 + 2
	change_spritesheet(texture)
	sprite.play("idle")

func _process(delta):
	if position.distance_to(Vector2(59, -2)) < 0.5:
		play_anim("idle")
		position = Vector2(59, -2)
		moving_to_first = false

	if moving_to_first:
		play_anim("side_walk")
		sprite.flip_h = true
		position = position.move_toward(Vector2(59, -2), delta * SPEED)
		return
	
	if position.distance_to(targ) > 0.5 and not moving_to_first:
		var curLoc = global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVel = (nextLoc - curLoc).normalized() * SPEED
		velocity = newVel
		move_and_slide()
		var next_pos = agent.get_next_path_position()
		var direction = (next_pos - position).normalized()
		
		if direction.x < 0:
			play_anim("side_walk")
			sprite.flip_h = true
		elif direction.x > 0:
			play_anim("side_walk")
			sprite.flip_h = false
		elif direction.y < 0:
			play_anim("back_walk")
		elif direction.y > 0:
			play_anim("front_walk")
	else:
		if timer.is_stopped():
			timer.start(1)
		play_anim("back_idle")
		sprite.flip_h = false

func updateTargetPosition(target):
	targ = target
	agent.set_target_position(target)

func play_anim(anim):
	if sprite.animation != anim:
		sprite.play(anim)

func _on_timer_timeout() -> void:
	visible = false
	$CollisionShape2D.disabled = true

func change_spritesheet(new_sheet: Texture2D):
	sprite.sprite_frames = sprite.sprite_frames.duplicate()

	for anim in sprite.sprite_frames.get_animation_names():
		for i in range(sprite.sprite_frames.get_frame_count(anim)):
			var frame_tex = sprite.sprite_frames.get_frame_texture(anim, i)
			var new_atlas = AtlasTexture.new()
			new_atlas.atlas = new_sheet
			new_atlas.region = frame_tex.region
			sprite.sprite_frames.set_frame(anim, i, new_atlas)
