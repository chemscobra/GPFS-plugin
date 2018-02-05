tool
extends EditorPlugin

var gpfs = null

func _enter_tree():
	gpfs = load("res://addons/godotp-folder-structure/GPFS.tscn").instance()
	add_control_to_bottom_panel(gpfs,"Folder Structure")

func _exit_tree():
	remove_control_from_bottom_panel(gpfs)
	gpfs.free()