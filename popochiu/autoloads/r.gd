@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PROutside := preload('res://popochiu/rooms/outside/room_outside.gd')
# ---- classes

# nodes ----
var Outside: PROutside : get = get_Outside
# ---- nodes

# functions ----
func get_Outside() -> PROutside: return super.get_runtime_room('Outside')
# ---- functions

