@tool
extends PopochiuRoom

const Data := preload('room_house_state.gd')

var state: Data = load('res://popochiu/rooms/house/room_house.tres')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
# TODO: Overwrite Godot's methods


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
# What happens when Popochiu loads the room. At this point the room is in the
# tree but it is not visible
func _on_room_entered() -> void:
	Cursor.hide()
	A.mx_coffee.play()
	C.Gonorrein.play_animation("idle_ul")


# What happens when the room changing transition finishes. At this point the room
# is visible.
func _on_room_transition_finished() -> void:
	await C.Goddiu.walk_to_marker("Right")
	await C.Goddiu.face_left()
	await E.queue([
		"Goddiu: Les tengo una MUY BUENA NOTICIA.",
		C.Popsy.queue_face_right(),
		"Gonorrein: ¿Qué pasó?",
		"Goddiu: Gracias a la ayuda de la comunidad.",
		"Goddiu(happy): Papiu Mateiu pudo comprar los pasajes pa' llevarnos a la GodotCon 2023.",
		"Popsy(happy): [shake]¿¡¡¡Qué!!!?[/shake]",
		"Popsy(happy): ¿Tan Rápido Tolima?",
		"Chiquininin(happy): [wave]Síííííííííí[/wave]",
		"Chiquininin(happy): NOS VAMOS PA' MAMEMANIA",
		"Gonorrein: ¿Y el alojamiento?",
		"Gonorrein(angry): ¿Y la comida?",
	])
	
	E.goto_room("Airport")


# What happens before Popochiu unloads the room.
# At this point, the screen is black, processing is disabled and all characters
# have been removed from the $Characters node.
func _on_room_exited() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
# You could put public functions here


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
# You could put private functions here
