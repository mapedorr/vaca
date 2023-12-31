@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PROutside := preload('res://popochiu/rooms/outside/room_outside.gd')
const PREnd := preload('res://popochiu/rooms/end/room_end.gd')
const PRInstacrem := preload('res://popochiu/rooms/instacrem/room_instacrem.gd')
const PRHouse := preload('res://popochiu/rooms/house/room_house.gd')
const PRAirport := preload('res://popochiu/rooms/airport/room_airport.gd')
# ---- classes

# nodes ----
var Outside: PROutside : get = get_Outside
var End: PREnd : get = get_End
var Instacrem: PRInstacrem : get = get_Instacrem
var House: PRHouse : get = get_House
var Airport: PRAirport : get = get_Airport
# ---- nodes

# functions ----
func get_Outside() -> PROutside: return super.get_runtime_room('Outside')
func get_End() -> PREnd: return super.get_runtime_room('End')
func get_Instacrem() -> PRInstacrem: return super.get_runtime_room('Instacrem')
func get_House() -> PRHouse: return super.get_runtime_room('House')
func get_Airport() -> PRAirport: return super.get_runtime_room('Airport')
# ---- functions

