@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PROutside := preload('res://popochiu/rooms/outside/room_outside.gd')
const PREnd := preload('res://popochiu/rooms/end/room_end.gd')
const PRInstacrem := preload('res://popochiu/rooms/instacrem/room_instacrem.gd')
# ---- classes

# nodes ----
var Outside: PROutside : get = get_Outside
var End: PREnd : get = get_End
var Instacrem: PRInstacrem : get = get_Instacrem
# ---- nodes

# functions ----
func get_Outside() -> PROutside: return super.get_runtime_room('Outside')
func get_End() -> PREnd: return super.get_runtime_room('End')
func get_Instacrem() -> PRInstacrem: return super.get_runtime_room('Instacrem')
# ---- functions

