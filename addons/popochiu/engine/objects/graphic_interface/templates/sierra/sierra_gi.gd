extends PopochiuGraphicInterface


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	super()
	
	commands = load(
		"res://addons/popochiu/engine/objects/graphic_interface/templates/sierra/sierra_commands.gd"
	).new()
	
	Cursor.replace_frames($Cursor)
	
	$Cursor.hide()
	$Menu.hide()
	
	E.current_command = SierraCommands.Commands.WALK


func _input(event: InputEvent) -> void:
	if G.is_blocked: return
	
	if event is InputEventMouseMotion:
		if get_global_mouse_position().y < 16.0:
			if not I.active:
				Cursor.show_cursor("use")
			Cursor.block()
			
			$Menu.show()
		elif get_global_mouse_position().y > $Menu.size.y and $Menu.visible:
			Cursor.unlock()
			if not I.active:
				Cursor.show_cursor(G.get_command_description(E.current_command))
			
			$Menu.hide()
	elif event is InputEventMouseButton and event.is_pressed():
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:
				if not $Menu.visible and not E.hovered\
				 and E.current_command != SierraCommands.Commands.WALK:
					get_viewport().set_input_as_handled()
			MOUSE_BUTTON_RIGHT:
				get_viewport().set_input_as_handled()
				
				E.current_command = posmod(
					E.current_command + 1, SierraCommands.Commands.size()
				)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func _on_mouse_entered_clickable(clickable: PopochiuClickable) -> void:
	if G.is_blocked: return
	
	if not I.active:
		G.show_hover_text(clickable.description)
	else:
		G.show_hover_text(
			'Use %s with %s' % [I.active.description, clickable.description]
		)


func _on_mouse_exited_clickable(clickable: PopochiuClickable) -> void:
	if G.is_blocked: return
	
	G.show_hover_text()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _on_inventory_pressed() -> void:
	%SierraInventoryPopup.open()
	$Menu.hide()
