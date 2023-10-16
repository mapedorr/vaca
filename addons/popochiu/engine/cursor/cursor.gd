extends CanvasLayer

enum Type {
	NONE,
	ACTIVE,
	DOWN,
	IDLE,
	LEFT,
	LOOK,
	RIGHT,
	SEARCH,
	TALK,
	UP,
	USE,
	WAIT,
}

var is_blocked := false


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor()


func _process(delta):
	var texture_size := ($AnimatedSprite2D.sprite_frames.get_frame_texture(
		$AnimatedSprite2D.animation,
		$AnimatedSprite2D.frame
	) as Texture2D).get_size()
	
	$AnimatedSprite2D.position = $AnimatedSprite2D.get_global_mouse_position()
	$Sprite2D.position = $AnimatedSprite2D.get_global_mouse_position()
	
	if $AnimatedSprite2D.position.x < 1.0:
		$AnimatedSprite2D.position.x = 1.0
	elif $AnimatedSprite2D.position.x > 268.0:
		$AnimatedSprite2D.position.x = 268.0
	
	if $AnimatedSprite2D.position.y < 1.0:
		$AnimatedSprite2D.position.y = 1.0
	elif $AnimatedSprite2D.position.y > 268.0:
		$AnimatedSprite2D.position.y = 268.0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func set_cursor(type := Type.IDLE, ignore_block := false) -> void:
	if not ignore_block and is_blocked: return
	
	# TODO: Temporary fix for mouse cursor change. This need improvements.
	#if E.current_command > -1:
		#show_cursor(G.get_command_description(E.current_command))
		#return
	
	if not Type.values().has(type):
		prints("[Popochiu] Cursor has no type: %s" % type)
		return
	
	var anim_name = Type.keys()[type]
	
	if not $AnimatedSprite2D.sprite_frames.has_animation(anim_name.to_lower()):
		prints("[Popochiu] Cursor has no animation: %s" % anim_name)
		return
	
	$AnimatedSprite2D.play(anim_name.to_lower())


func set_cursor_texture(texture: Texture2D, ignore_block := false) -> void:
	if not ignore_block and is_blocked: return
	
	$AnimatedSprite2D.hide()
	$Sprite2D.texture = texture
	$Sprite2D.show()


func remove_cursor_texture() -> void:
	$Sprite2D.texture = null
	$Sprite2D.hide()
	$AnimatedSprite2D.show()


func toggle_visibility(is_visible: bool) -> void:
	$AnimatedSprite2D.visible = is_visible
	$Sprite2D.visible = is_visible


func block() -> void:
	is_blocked = true


func unlock() -> void:
	is_blocked = false


func scale_cursor(factor: Vector2) -> void:
	$Sprite2D.scale = Vector2.ONE * factor
	$AnimatedSprite2D.scale = Vector2.ONE * factor


func get_position() -> Vector2:
	return $Sprite2D.position


func replace_frames(new_node: AnimatedSprite2D) -> void:
	$AnimatedSprite2D.sprite_frames = new_node.sprite_frames
	$AnimatedSprite2D.offset = new_node.offset


func show_cursor(anim_name: String, ignore_block := false) -> void:
	if not ignore_block and is_blocked: return
	
	if not $AnimatedSprite2D.sprite_frames.has_animation(anim_name):
		prints("[Popochiu] Cursor has no animation: %s" % anim_name)
		return
	
	$AnimatedSprite2D.play(anim_name)
	$AnimatedSprite2D.show()
	$Sprite2D.hide()
