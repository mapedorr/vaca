@icon('res://addons/popochiu/icons/inventory_item.png')
extends TextureRect
class_name PopochiuInventoryItem
## An inventory item.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

const CURSOR := preload('res://addons/popochiu/engine/cursor/cursor.gd')

signal selected(item)

@export var description := '' : get = get_description
@export var stack := false
@export var script_name := ''
@export var cursor: CURSOR.Type = CURSOR.Type.USE

var amount := 1
var in_inventory := false : set = set_in_inventory


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	mouse_entered.connect(_toggle_description.bind(true))
	mouse_exited.connect(_toggle_description.bind(false))
	gui_input.connect(_on_gui_input)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
## When the item is clicked in the Inventory
func _on_click() -> void:
	pass


## When the item is right clicked in the Inventory
func _on_right_click() -> void:
	pass


## When the item is middle clicked in the Inventory
func _on_middle_click() -> void:
	pass


## When the item is clicked and there is another inventory item selected
func _on_item_used(item: PopochiuInventoryItem) -> void:
	pass


## Actions to excecute after the item is added to the Inventory
func _on_added_to_inventory() -> void:
	pass


## Actions to excecute when the item is discarded from the Inventory
func _on_discard() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func queue_add(animate := true) -> Callable:
	return func (): await add(animate)


func add(animate := true) -> void:
	if I.is_full():
		printerr(
			"[Popochiu] Couldn't add %s. Inventory is full." %\
			script_name
		)
		
		await get_tree().process_frame
		return
	
	if not in_inventory:
		G.block()

		I.items.append(script_name)
		
		I.item_added.emit(self, animate)
		in_inventory = true
		
		await I.item_add_done

		G.done(true)

		return
	
	await get_tree().process_frame


func queue_add_as_active(animate := true) -> Callable:
	return func (): await add_as_active(animate)


func add_as_active(animate := true) -> void:
	await add(animate)
	
	I.set_active_item(self)


func queue_remove(animate := false) -> Callable:
	return func (): await remove(animate)


func remove(animate := false) -> void:
	in_inventory = false
	
	I.items.erase(script_name)
	I.set_active_item(null)
	# TODO: Maybe this signal should be triggered once the await has finished
	I.item_removed.emit(self, animate)
	
	await I.item_remove_done
	
	G.done()


func replace(new_item: PopochiuInventoryItem) -> void:
	in_inventory = false
	
	I.items.erase(script_name)
	I.set_active_item(null)
	I.items.append(new_item.script_name)
	new_item.in_inventory = true
	
	I.item_replaced.emit(self, new_item)
	
	await I.item_replace_done
	
	G.done()


func queue_discard(animate := false) -> Callable:
	return func (): await discard(animate)


func discard(animate := false) -> void:
	_on_discard()
	
	I.items.erase(script_name)
	I.item_discarded.emit(self)
	
	await remove(animate)


func set_active(ignore_block := false) -> void:
	I.set_active_item(self, ignore_block)


## When the item is clicked in the Inventory
func on_click() -> void:
	selected.emit(self)


## When the item is right clicked in the Inventory
func on_right_click() -> void:
	await G.show_system_text('Nothing to see in this item')


## When the item is clicked and there is another inventory item selected
func on_item_used(item: PopochiuInventoryItem) -> void:
	await G.show_system_text(
		'Nothing happens when using %s in this item' % item.description
	)


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


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ SET & GET ░░░░
func set_in_inventory(value: bool) -> void:
	in_inventory = value
	
	if in_inventory: _on_added_to_inventory()


func get_description() -> String:
	if Engine.is_editor_hint():
		if description.is_empty():
			description = name
		return description
	return E.get_text(description)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _toggle_description(is_hover: bool) -> void:
	if is_hover:
		G.mouse_entered_inventory_item.emit(self)
	else:
		G.mouse_exited_inventory_item.emit(self)
	
	# NOTE: Not sure this should go here
	#Cursor.set_cursor(cursor if is_hover else CURSOR.Type.IDLE)
	#G.show_hover_text(self.description if is_hover else '')


func _on_gui_input(event: InputEvent) -> void: 
	var mouse_event := event as InputEventMouseButton 
	if mouse_event and mouse_event.pressed:
		match mouse_event.button_index:
			MOUSE_BUTTON_LEFT:
				if I.active:
					_on_item_used(I.active)
				else:
					on_command(mouse_event.button_index)
			MOUSE_BUTTON_RIGHT:
				if not I.active:
					on_command(mouse_event.button_index)
			MOUSE_BUTTON_MIDDLE:
				if not I.active:
					on_command(mouse_event.button_index)
