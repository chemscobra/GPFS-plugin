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
	print(typeof(root.get_children()))
	print(folder_tree.get_selected())
	
	add_folder.connect("button_down",self,"_on_add_folder_down")
	del_folder.connect("button_down",self,"_on_del_folder_down")
	create_struc.connect("button_down",self,"_on_create_struc_down")

func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_DELETE):
		 _on_del_folder_down()
		
	
#Button Functions
func _on_add_folder_down():
	var newfolder = null
	if folder_ntxt.text != "" and folder_tree.get_selected() == null:
		newfolder = folder_tree.create_item(folder_tree.get_root())
		if newfolder.get_prev() != null and newfolder.get_prev().get_text(0) == folder_ntxt.text:
			newfolder.set_text(0,folder_ntxt.text +str(1))
			newfolder.set_selectable(0,true)
		else:
			newfolder.set_text(0,folder_ntxt.text)
			newfolder.set_selectable(0,true)
		print("Added Item")
		
	elif folder_ntxt.text != "" and folder_tree.get_selected() != null:
		newfolder = folder_tree.create_item(folder_tree.get_selected())
		newfolder.set_text(0,folder_ntxt.text)
		newfolder.set_selectable(0,true)
	else:
		pass
		
	print(typeof(newfolder))
	
func _on_del_folder_down():
	var selitem_parent = null
	if folder_tree.get_selected() != null:
		selitem_parent = folder_tree.get_selected().get_parent()
		selitem_parent.remove_child(folder_tree.get_selected())
		sel_item = null
		selitem_parent.select(0)
		
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
