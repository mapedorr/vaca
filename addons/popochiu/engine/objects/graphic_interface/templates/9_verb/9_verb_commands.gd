extends RefCounted
class_name NineVerbCommands

enum Commands {
	WALK_TO, OPEN, PICK_UP, PUSH, CLOSE, LOOK_AT, PULL, GIVE, TALK_TO, USE
}

var commands_dic := {
	Commands.WALK_TO : "Walk to",
	Commands.OPEN : "Open",
	Commands.PICK_UP : "Pick up",
	Commands.PUSH : "Push",
	Commands.CLOSE : "Close",
	Commands.LOOK_AT : "Look at",
	Commands.PULL : "Pull",
	Commands.GIVE : "Give",
	Commands.TALK_TO : "Talk to",
	Commands.USE : "Use",
}


func fallback() -> void:
	walk_to()


func walk_to() -> void:
#	E.get_node("/root/C").walk_to_clicked()
	C.player.walk_to_clicked()
	
	await C.player.move_ended
	E.current_command = E.clicked.suggested_command
	E.clicked.on_command(MOUSE_BUTTON_LEFT)


func open() -> void:
	C.player.say("Can't open that")


func pick_up() -> void:
	C.player.say("Not picking that up")


func push() -> void:
	C.player.say("I don't want to do that")


func close() -> void:
	C.player.say("Can't close that")


func look_at() -> void:
	if E.clicked:
		await C.player.face_clicked()
	
	await C.player.say("I have nothing to say about that")


func pull() -> void:
	C.player.say("I don't want to do that")


func give() -> void:
	C.player.say("What?")


func talk_to() -> void:
	C.player.say("Emmmm...")


func use() -> void:
	C.player.say("What?")
