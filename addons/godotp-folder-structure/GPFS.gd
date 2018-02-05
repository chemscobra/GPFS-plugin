extends Panel

#Controls
onready var folder_tree = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/FolderTree
onready var folder_ntxt = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/FolderName
#Buttons
onready var add_folder= $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/AddFolder
onready var del_folder= $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/DelFolder
onready var create_struc = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/Create

var sel_item = null
var root = null

func _ready():
	root = folder_tree.create_item()
	root.set_text(0,"root")
	
	add_folder.connect("button_down",self,"_on_add_folder_down")
	del_folder.connect("button_down",self,"_on_del_folder_down")
	create_struc.connect("button_down",self,"_on_create_struc_down")

#Button Functions

func _on_add_folder_down():
	if folder_ntxt.text != "" and sel_item == null:
		var newfolder = folder_tree.create_item()
		newfolder.set_text(0,folder_ntxt.text)
		newfolder.set_selectable(0,true)
	else:
		var newfolder = folder_tree.create_item(sel_item)
		newfolder.set_text(0,folder_ntxt.text)
		newfolder.set_selectable(0,true)
	pass
	
func _on_del_folder_down():
	if sel_item != null and root.:
		root.remove_child(sel_item)

func _on_create_struc_down():
	pass


func _on_FolderTree_item_selected():
	sel_item = folder_tree.get_selected()
	print(sel_item.get_text(0))


func _on_FolderTree_nothing_selected():
	if sel_item != null:
		sel_item.deselect(0)
		sel_item = null
	print(sel_item)
