# Allows to handle an Area2D that reacts to click events, and mouse entering,
# and exiting.
@tool
extends Area2D
class_name PopochiuClickable

const CURSOR := preload('res://addons/popochiu/engine/cursor/cursor.gd')

@export var script_name := ''
@export var description := ''
@export var clickable := true
@export var baseline := 0 : set = set_baseline
@export var walk_to_point := Vector2.ZERO : set = set_walk_to_point
@export var cursor: CURSOR.Type = CURSOR.Type.NONE
@export var always_on_top := false

var room: Node2D = null : set = set_room # It is a PopochiuRoom
var times_clicked := 0
var times_right_clicked := 0
var times_middle_clicked := 0

@onready var _description_code := description


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	add_to_group('PopochiuClickable')
	
	if Engine.is_editor_hint():
		hide_helpers()
		return
	else:
		$BaselineHelper.free()
		$WalkToHelper.free()
	
	visibility_changed.connect(_toggle_input)

	if clickable:
		# Connect to own signals
		mouse_entered.connect(_toggle_description.bind(true))
		mouse_exited.connect(_toggle_description.bind(false))
		
		# Connect to singleton signals
		E.language_changed.connect(_translate)
	
	set_process_unhandled_input(false)
	_translate()


func _unhandled_input(event: InputEvent):
	var mouse_event := event as InputEventMouseButton
	if mouse_event and mouse_event.pressed:
		if not E.hovered or E.hovered != self: return
		
		E.clicked = self
		get_viewport().set_input_as_handled()
		
		match mouse_event.button_index:
			MOUSE_BUTTON_LEFT:
				if I.active:
					_on_item_used(I.active)
				else:
					on_command(mouse_event.button_index)
					
					times_clicked += 1
			MOUSE_BUTTON_RIGHT:
				if not I.active:
					on_command(mouse_event.button_index)
					
					times_right_clicked += 1
			MOUSE_BUTTON_MIDDLE:
				if not I.active:
					on_command(mouse_event.button_index)
					
					times_middle_clicked += 1


func _process(delta):
	if Engine.is_editor_hint():
		if walk_to_point != get_node('WalkToHelper').position:
			walk_to_point = get_node('WalkToHelper').position

			notify_property_list_changed()
		elif baseline != get_node('BaselineHelper').position.y:
			baseline = get_node('BaselineHelper').position.y

			notify_property_list_changed()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
## When the room this node belongs to has been added to the tree
func _on_room_set() -> void:
	pass


## When the node is clicked
func _on_click() -> void:
	pass


## When the node is right clicked
func _on_right_click() -> void:
	pass


## When the node is middle clicked
func _on_middle_click() -> void:
	pass


## When the node is clicked and there is an inventory item selected
func _on_item_used(item: PopochiuInventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func hide_helpers() -> void:
	$BaselineHelper.hide()
	$WalkToHelper.hide()


func show_helpers() -> void:
	$BaselineHelper.show()
	$WalkToHelper.show()


func disable() -> Callable:
	return func (): await disable_now()


# Hides the Node and disables its interaction
func disable_now() -> void:
	self.visible = false
	
	await get_tree().process_frame


func enable() -> Callable:
	return func (): await enable_now()


# Makes the Node visible and enables its interaction
func enable_now() -> void:
	self.visible = true
	
	await get_tree().process_frame


func get_description() -> String:
	if Engine.is_editor_hint():
		if description.is_empty():
			description = name
		return description
	return E.get_text(description)


func on_click() -> void:
	await G.show_system_text("Can't INTERACT with it")


func on_right_click() -> void:
	await G.show_system_text("Can't EXAMINE it")


func on_item_used(item: PopochiuInventoryItem) -> void:
	await G.show_system_text("Can't USE %s here" % item.description)


func on_command(button_idx: int) -> void:
	var command := G.get_command(E.current_command).to_snake_case()
	var target_method := "_on_%s"
	var suffix := "click"
	
	match button_idx:
		MOUSE_BUTTON_RIGHT:
			suffix = "right_" + suffix
		MOUSE_BUTTON_MIDDLE:
			suffix = "middle_" + suffix
	
	var use_fallback := false
	
	if not command.is_empty():
		var command_method := suffix.replace("click", command)
		
		if has_method(target_method % command_method):
			suffix = command_method
		elif has_method(target_method % command):
			# Check if the default LEFT CLICK command method exists
			suffix = command
		else:
			use_fallback = true
	
	E.add_history({
		action = suffix if command.is_empty() else G.get_command(E.current_command),
		target = description
	})
	
	if use_fallback:
		E.command_fallback()
	else:
		call(target_method % suffix)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _toggle_description(display: bool) -> void:
	set_process_unhandled_input(display)
	
	if display:
		if E.hovered and is_instance_valid(E.hovered) and (
			E.hovered.get_parent() == self or get_index() < E.hovered.get_index()
		):
			E.add_hovered(self, true)
			return
		
		E.add_hovered(self)
		
		G.mouse_entered_clickable.emit(self)
	else:
		if E.remove_hovered(self):
			G.mouse_exited_clickable.emit(self)


func _toggle_input() -> void:
	if clickable:
		input_pickable = visible
		set_process_unhandled_input(false)


func _translate() -> void:
	if Engine.is_editor_hint() or not is_inside_tree()\
	or not E.settings.use_translations: return
	
	description = E.get_text(
		'%s-%s' % [get_tree().current_scene.name, _description_code]
	)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ SET & GET ░░░░
func set_baseline(value: int) -> void:
	baseline = value
	
	if Engine.is_editor_hint() and get_node_or_null('BaselineHelper'):
		get_node('BaselineHelper').position = Vector2.DOWN * value


func set_walk_to_point(value: Vector2) -> void:
	walk_to_point = value
	
	if Engine.is_editor_hint() and get_node_or_null('WalkToHelper'):
		get_node('WalkToHelper').position = value


func get_walk_to_point() -> Vector2:
	if Engine.is_editor_hint():
		return walk_to_point
	elif is_inside_tree():
		return to_global(walk_to_point)
	return walk_to_point


func set_room(value: Node2D) -> void:
	room = value
	
	_on_room_set()
