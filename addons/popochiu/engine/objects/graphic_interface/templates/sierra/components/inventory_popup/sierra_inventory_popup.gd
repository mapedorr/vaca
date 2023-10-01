extends PopochiuPopup


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func _open() -> void:
	E.current_command = SierraCommands.Commands.INTERACT


func _close() -> void:
	if I.active:
		Cursor.set_cursor_texture(I.active.texture)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _on_look_pressed() -> void:
	if is_instance_valid(I.active):
		I.active = null
	
	E.current_command = SierraCommands.Commands.LOOK
	
	# Force changing the cursor
	Cursor.show_cursor(
		G.get_command(E.current_command).to_snake_case(),
		true
	)


func _on_select_pressed() -> void:
	if is_instance_valid(I.active):
		I.active = null
	
	E.current_command = SierraCommands.Commands.INTERACT
	
	Cursor.show_cursor("use", true)
