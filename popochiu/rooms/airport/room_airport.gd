@tool
extends PopochiuRoom

const Data := preload('room_airport_state.gd')

var state: Data = load('res://popochiu/rooms/airport/room_airport.tres')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
# TODO: Overwrite Godot's methods


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
# What happens when Popochiu loads the room. At this point the room is in the
# tree but it is not visible
func _on_room_entered() -> void:
	Cursor.hide()
	A.mx_coffee.play()
	C.Gonorrein.face_left()
#	C.Popsy.play_animation("stand")
	C.Chiquininin.face_left()
	C.Goddiu.face_left()


# What happens when the room changing transition finishes. At this point the room
# is visible.
func _on_room_transition_finished() -> void:
	await E.queue([
		"Chiquininin: Rápido rápido, que no se nos haga tarde.",
		"Gonorrein(angry): Pero si el viaje será en 2 semanas.",
		"Popsy: Sí, ¿Pero y si nos quedamos dormidius?",
		"Goddiu: Más vale prevenir que lamentar.",
		"Gonorrein: ...",
	])
	
	C.Goddiu.walk_to_marker("Entrance", Vector2(32.0, 0.0))
	E.queue([
		C.Popsy.queue_walk_to_marker("Entrance"),
		C.Popsy.queue_play_animation("stand"),
	])
	C.Chiquininin.walk_to_marker("Entrance", Vector2(48.0, 0.0))
	C.Gonorrein.walk_to_marker("Entrance", Vector2(64.0, 0.0))


# What happens before Popochiu unloads the room.
# At this point, the screen is black, processing is disabled and all characters
# have been removed from the $Characters node.
func _on_room_exited() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
# You could put public functions here


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
# You could put private functions here
