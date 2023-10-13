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
	Cursor.hide()
	C.Goddiu.face_left()
#	A.mx_coffee.play()


# What happens when the room changing transition finishes. At this point the room
# is visible.
func _on_room_transition_finished() -> void:
	await C.Goddiu.walk_to_marker("Talk")
	await E.queue([
		"Goddiu: Oñiiiiiii.",
#		A.vo_popsy_01.queue_play(),
#		A.vo_chiquininin_01.queue_play(),
#		A.vo_gonorrein_01.queue_play(),
#		"Popochius: [shake]Oñiiiiiiiiiiiiiiii[/shake].",
		"Goddiu(happy): Les tengo una [color=a9ff9f]buena[/color] y una [color=c46c71]mala[/color] noticia.",
		"Popsy: ¿Qué pasí?",
		"Goddiu: La [color=a9ff9f]buena noticia[/color] es que Papiu Mateiu hablará de nosotros en un lugarciu muy boniu.",
		E.queue_camera_shake_bg(.5, 1.5),
		A.vo_popsy_02.queue_play(),
		A.vo_chiquininin_02.queue_play(),
		A.vo_gonorrein_02.queue_play(),
		"Popochius: [shake][rainbow]Tííííííííííííííííí[/rainbow][/shake]",
		"Goddiu(sad): La mala es que [color=c46c71]NO TIENE EL DINERO SUFICIENTE[/color] para salir del platanal.",
#		"Chiquininin(sad): Ayyyy [wave]doooooooooooooo[/wave]",
#		"Popsy(sad): Pobreciu.",
#		"Gonorrein(angry): [shake]¡Qué bobiu es Papiu Mateiu![/shake]",
#		"Carenalga: Sííííí mis popochius.",
		"Carenalga(sad): No tengo cómo pagarme el viaje a Munich, Alemania.",
#		"Carenalga(sad): Lo siento muchíu...",
		"Goddiu(happy): ¡¡¡TENEMOS QUE CONSEGUIR EL DINERIU!!!",
		"Chiquininin: ¿Qué tal si le pedimos ayuda [color=a9ff9f]¡¡¡A QUIENES NOS ESTÁN VIENDO!!![/color]?",
#		"Gonorrein: ¿A quienes?",
#		A.vo_popsy_03.queue_play(),
#		A.vo_chiquininin_03.queue_play(),
#		A.vo_gonorrein_03.queue_play(),
#		E.queue_camera_shake_bg(.5, 1.5),
#		"Popochius: [shake][rainbow]Tííííííííííííííííí[/rainbow][/shake]",
#		"Chiquininin: [color=75cec8]¡¡¡A QUIENES NOS ESTÁN VIENDO!!![/color]",
		"Goddiu(happy): ¡Qué buena idea!",
		"Popsy: ¿Nos ayudarías para que Papiu Mateiu pueda hablar de nosotros en Mamemania?",
#		"Gonorrein(angry): ¡Es Alemania, [shake]BOBIU[/shake]!",
#		"Chiquininin(happy): [wave]¡AYÚDANOS POFAVÍ![/wave]",
	])
	
	E.goto_room("End")


# What happens before Popochiu unloads the room.
# At this point, the screen is black, processing is disabled and all characters
# have been removed from the $Characters node.
func _on_room_exited() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
# You could put public functions here


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
# You could put private functions here
