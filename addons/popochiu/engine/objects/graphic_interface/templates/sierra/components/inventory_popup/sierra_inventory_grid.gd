extends HBoxContainer

var _items_in_grid := {}

#@onready var scroll_up: TextureButton = $ScrollButtonsContainer/ScrollUp
#@onready var scroll_down: TextureButton = $ScrollButtonsContainer/ScrollDown


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	# Connect to singletons signals
	#I.item_added.connect(_on_item_added)
	#I.item_removed.connect(_on_item_removed)
	
	#scroll_up.disabled = I.items.is_empty() or I.items.size() <= 15
	#scroll_down.disabled = I.items.is_empty() or I.items.size() <= 15
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _on_item_added(item: PopochiuInventoryItem, _animate := true) -> void:
	$GridContainer.get_child(I.items.size() - 1).add_child(item)
	_items_in_grid[item.script_name] = item
	
	# TODO: This should be handled by the item itself or by the class from where
	# inventory panels will inherit from
	item.selected.connect(_change_cursor)
	
	# Common call to all inventories. Should be in the class from where inventory
	# panels will inherit from
	await get_tree().process_frame
	
	I.item_add_done.emit(item)


func _on_item_removed(item: PopochiuInventoryItem, _animate := true) -> void:
	# TODO: This should be handled by the item itself or by the class from where
	# inventory panels will inherit from
	item.selected.disconnect(_change_cursor)
	
	(_items_in_grid[item.script_name] as PopochiuInventoryItem).queue_free()
	# TODO: Move the items to their new position in the grid?
	
	# Common call to all inventories. Should be in the class from where inventory
	# panels will inherit from
	await get_tree().process_frame
	
	I.item_remove_done.emit(item)


# TODO: This should be in the PopochiuInventoryItem class or in the class from
# where inventory panels will inherit from
func _change_cursor(item: PopochiuInventoryItem) -> void:
	I.set_active_item(item, true)
