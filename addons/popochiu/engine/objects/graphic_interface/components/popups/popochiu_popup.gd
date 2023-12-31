extends PanelContainer
class_name PopochiuPopup
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
# warning-ignore-all:return_value_discarded

@onready var lbl_title: Label = %Title
@onready var btn_ok: Button = %Ok
@onready var btn_cancel: Button = %Cancel
@onready var btn_close: TextureButton = %Close


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	# Connect to own signals
	gui_input.connect(_check_click)
	
	# Connect to child signals
	btn_ok.pressed.connect(on_ok_pressed)
	btn_cancel.pressed.connect(on_cancel_pressed)
	btn_close.pressed.connect(on_cancel_pressed)
	
	close()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
## Called when the popup is opened. At this point it is not visible yet.
func _open() -> void:
	pass


## Called when the popup is closed. The node hides after calling this method.
func _close() -> void:
	pass


## Called when OK is pressed.
func _on_ok() -> void:
	pass


## Called when CANCEL or X (top-right corner) are pressed.
func _on_cancel() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
## Shows the popup scaling it and blocking interactions with the graphic interface.
func open() -> void:
	_open()
	
	# TODO: I'm not sure we should do this...
	if E.settings.scale_gui:
		scale = Vector2.ONE * E.scale
	
	G.block()
	Cursor.set_cursor(Cursor.Type.USE, true)
	
	(E.gi as PopochiuGraphicInterface).popups_stack.append(self)
	
	show()


## Closes the popup unlocking interactions with the graphic interface.
func close() -> void:
	(E.gi as PopochiuGraphicInterface).popups_stack.erase(self)
	
	if (E.gi as PopochiuGraphicInterface).popups_stack.is_empty():
		G.done()
		Cursor.unlock()
	
	_close()
	
	hide()


## Called when the OK button is pressed. It closes the popup afterwards.
func on_ok_pressed() -> void:
	_on_ok()
	
	close()


## Called when the CANCEL button is pressed. It closes the popup afterwards.
func on_cancel_pressed() -> void:
	_on_cancel()
	
	close()


## Called when the X (top-right corner) button is pressed. It closes the popup
## afterwards.
func on_close_pressed() -> void:
	_on_cancel()
	
	close()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
## Checks if the overlay area of the popup was clicked in order to close it.
func _check_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed()\
	and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		_on_cancel()
		close()
