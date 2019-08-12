tool
extends EditorPlugin

var gpfs_window = null

func _enter_tree():
	assert(Engine.get_version_info().major >= 3)
	gpfs_window = preload('GPFS.tscn').instance()
	get_editor_interface().get_base_control().add_child(gpfs_window)
	add_menu_item(tr('Create Folder Structure'), '_on_show_gpfs_pressed')
#	add_control_to_bottom_panel(gpfs,"Folder Structure")

func _exit_tree():
	if gpfs_window:
		gpfs_window.queue_free()
		remove_menu_item(tr('Create Folder Structure'))
	
func _on_show_gpfs_pressed(_data):
	gpfs_window.display()

func add_menu_item(p_name, p_callback):
	var minor_version = Engine.get_version_info().minor
	if minor_version >= 1:
		add_tool_menu_item(p_name, self, p_callback)

func remove_menu_item(p_name):
	var minor_version = Engine.get_version_info().minor
	if minor_version >= 1:
		remove_tool_menu_item(p_name)