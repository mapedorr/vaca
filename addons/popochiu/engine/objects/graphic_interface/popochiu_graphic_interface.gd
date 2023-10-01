extends Control
class_name PopochiuGraphicInterface
## Handles the in-game Graphic Interface.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
# warning-ignore-all:return_value_discarded

var popups_stack := []
var commands: RefCounted = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	# Connect to singleton signals
	G.blocked.connect(_on_gi_blocked)
	G.freed.connect(_on_gi_freed)
	G.interface_hidden.connect(_hide_panels)
	G.interface_shown.connect(_show_panels)
	G.mouse_entered_clickable.connect(_on_mouse_entered_clickable)
	G.mouse_exited_clickable.connect(_on_mouse_exited_clickable)
	G.mouse_entered_inventory_item.connect(_on_mouse_entered_inventory_item)
	G.mouse_exited_inventory_item.connect(_on_mouse_exited_inventory_item)
	
#	if E.settings.scale_gui:
#		$MainContainer.scale = E.scale


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func _on_gi_blocked(props := { blocking = true }) -> void:
	pass


func _on_gi_freed() -> void:
	pass


func _hide_panels() -> void:
	pass


func _show_panels() -> void:
	pass


func _on_mouse_entered_clickable(clickable: PopochiuClickable) -> void:
	pass


func _on_mouse_exited_clickable(clickable: PopochiuClickable) -> void:
	pass


func _on_mouse_entered_inventory_item(inventory_item: PopochiuInventoryItem) -> void:
	pass


func _on_mouse_exited_inventory_item(inventory_item: PopochiuInventoryItem) -> void:
	pass
