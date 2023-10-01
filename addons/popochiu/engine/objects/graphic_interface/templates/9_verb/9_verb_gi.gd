extends PopochiuGraphicInterface

@onready var commands_container: GridContainer = %CommandsContainer
@onready var settings_popup: PopochiuPopup = $"Popups/9VerbSettingsPopup"
@onready var quit_popup: PanelContainer = %"9VerbQuitPopup"


#region Godot
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	super()
	
	commands = load(
		"res://addons/popochiu/engine/objects/graphic_interface/templates/9_verb/9_verb_commands.gd"
	).new()
	
	Cursor.replace_frames($Cursor)
	Cursor.show_cursor('normal')
	
	$Cursor.hide()
	%HoverTextCentered.hide()
	
	# Connect to childs signals
	$BtnSettings.pressed.connect(_on_settings_pressed)
	settings_popup.classic_sentence_toggled.connect(_on_classic_sentence_toggled)
	settings_popup.quit_pressed.connect(_on_quit_pressed)
	
	# Connect to singletons signals
	E.redied.connect(_on_popochiu_ready)


func _unhandled_input(event: InputEvent) -> void:
	# Make the PC move to the clicked point on RIGHT CLICK
	if (event is InputEventMouseButton and event.is_pressed()
	and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT):
		C.player.walk(R.current.get_local_mouse_position())


#endregion
#region Virtual
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func _on_gi_blocked(props := { blocking = true }) -> void:
	E.current_command = -1
	G.show_hover_text()


func _on_gi_freed() -> void:
	E.current_command = NineVerbCommands.Commands.WALK_TO
	G.show_hover_text()
	
	
	# Make all commands to look as no pressed
	commands_container.unpress_commands()


func _on_mouse_entered_clickable(clickable: PopochiuClickable) -> void:
	if G.is_blocked: return
	
	if clickable.get("suggested_command"):
		commands_container.highlight_command(clickable.suggested_command)
	Cursor.show_cursor('active')
	
	if I.active:
		G.show_hover_text(
			'%s %s %s %s' % [
				G.get_command(E.current_command),
				I.active.description,
				"to" if E.current_command == NineVerbCommands.Commands.GIVE else "in",
				clickable.description
			]
		)
	else:
		G.show_hover_text(clickable.description)


func _on_mouse_exited_clickable(clickable: PopochiuClickable) -> void:
	if G.is_blocked: return
	
	if clickable.get("suggested_command"):
		commands_container.highlight_command(clickable.suggested_command, false)
	Cursor.show_cursor('normal')
	
	if I.active: return
	G.show_hover_text()


func _on_mouse_entered_inventory_item(inventory_item: PopochiuInventoryItem) -> void:
	if E.current_command == NineVerbCommands.Commands.WALK_TO:
		E.current_command = NineVerbCommands.Commands.LOOK_AT
	
	commands_container.highlight_command(NineVerbCommands.Commands.LOOK_AT)
	Cursor.show_cursor('active')
	
	if I.active:
		if (
			E.current_command == NineVerbCommands.Commands.USE
			and I.active != inventory_item
		):
			G.show_hover_text(
				'%s %s in %s' % [
					G.get_command(E.current_command),
					I.active.description,
					inventory_item.description
				]
			)
	else:
		G.show_hover_text(inventory_item.description)


func _on_mouse_exited_inventory_item(inventory_item: PopochiuInventoryItem) -> void:
	if E.current_command == NineVerbCommands.Commands.LOOK_AT:
		E.current_command = NineVerbCommands.Commands.WALK_TO
	
	commands_container.highlight_command(NineVerbCommands.Commands.LOOK_AT, false)
	Cursor.show_cursor('normal')
	
	if I.active:
		G.show_hover_text("Use %s in" % I.active.description)
		return
	
	G.show_hover_text()


#endregion
#region Private
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _on_settings_pressed() -> void:
	settings_popup.open()


func _on_popochiu_ready() -> void:
	if is_instance_valid(C.player):
		C.player.started_walk_to.connect(_on_player_started_walk)


func _on_player_started_walk(
	_character: PopochiuCharacter, _start_position: Vector2, _end_position: Vector2
) -> void:
	_on_gi_freed()


func _on_classic_sentence_toggled(button_pressed: bool) -> void:
	%HoverTextCursor.visible = not button_pressed
	%HoverTextCentered.visible = button_pressed


func _on_quit_pressed() -> void:
	quit_popup.open()


#endregion
