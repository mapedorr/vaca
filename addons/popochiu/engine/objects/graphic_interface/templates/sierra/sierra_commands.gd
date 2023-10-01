extends Resource
class_name SierraCommands

enum Commands {
	WALK, LOOK, INTERACT, TALK
}

var commands_dic := {
	Commands.WALK : "Walk",
	Commands.LOOK : "Look",
	Commands.INTERACT : "Interact",
	Commands.TALK : "Talk",
}


func fallback() -> void:
	walk()


func walk() -> void:
#	E.get_node("/root/C").walk_to_clicked()
	C.walk_to_clicked()


func look() -> void:
	G.show_system_text("Nothing to say about this item")
