@tool
extends PopochiuRoom

const Data := preload('room_outside_state.gd')

var state: Data = load('res://popochiu/rooms/outside/room_outside.tres')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
# TODO: Overwrite Godot's methods


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
# What happens when Popochiu loads the room. At this point the room is in the
# tree but it is not visible
func _on_room_entered() -> void:
	pass


# What happens when the room changing transition finishes. At this point the room
# is visible.
func _on_room_transition_finished() -> void:
	await C.Goddiu.walk_to_marker("Talk")
	await E.queue([
		"Goddiu: Oñiiiiiii.",
		"Popochius: [wave]Oñiiiiiiiiiiiiiiii[/wave].",
		"Goddiu(happy): Les tengo una [color=a9ff9f]buena[/color] y una [color=c46c71]mala[/color] noticia.",
		"Popsy: ¿Qué pasí?",
		"Goddiu: La [color=a9ff9f]buena noticia[/color] es que Papiu Mateiu hablará de nosotros en un lugarciu muy boniu.",
		"Popochius: [wave][rainbow]Tííííííííííííííííííííííííííííííííí[/rainbow][/wave]",
		"Goddiu(sad): La mala es que NO TIENE NI UN peso para salir del platanal.",
		C.Popsy.queue_play_animation("sad"),
		"Popsy(sad): Pobreciu.",
#		"Gonorrein(angry): [shake]¡Qué bobiu es Papiu Mateiu![/shake]",
		"Chiquininin(sad): Ayyyy [wave]doooooooooooooo[/wave]",
#		"",
#		"",
	])


# What happens before Popochiu unloads the room.
# At this point, the screen is black, processing is disabled and all characters
# have been removed from the $Characters node.
func _on_room_exited() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
# You could put public functions here


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
# You could put private functions here
