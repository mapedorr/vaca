@tool
extends "res://addons/popochiu/engine/interfaces/i_character.gd"

# classes ----
const PCGoddiu := preload('res://popochiu/characters/goddiu/character_goddiu.gd')
const PCPopochius := preload('res://popochiu/characters/popochius/character_popochius.gd')
const PCPopsy := preload('res://popochiu/characters/popsy/character_popsy.gd')
const PCChiquininin := preload('res://popochiu/characters/chiquininin/character_chiquininin.gd')
const PCGonorrein := preload('res://popochiu/characters/gonorrein/character_gonorrein.gd')
const PCCarenalga := preload('res://popochiu/characters/carenalga/character_carenalga.gd')
# ---- classes

# nodes ----
var Goddiu: PCGoddiu : get = get_Goddiu
var Popochius: PCPopochius : get = get_Popochius
var Popsy: PCPopsy : get = get_Popsy
var Chiquininin: PCChiquininin : get = get_Chiquininin
var Gonorrein: PCGonorrein : get = get_Gonorrein
var Carenalga: PCCarenalga : get = get_Carenalga
# ---- nodes

# functions ----
func get_Goddiu() -> PCGoddiu: return super.get_runtime_character('Goddiu')
func get_Popochius() -> PCPopochius: return super.get_runtime_character('Popochius')
func get_Popsy() -> PCPopsy: return super.get_runtime_character('Popsy')
func get_Chiquininin() -> PCChiquininin: return super.get_runtime_character('Chiquininin')
func get_Gonorrein() -> PCGonorrein: return super.get_runtime_character('Gonorrein')
func get_Carenalga() -> PCCarenalga: return super.get_runtime_character('Carenalga')
# ---- functions

