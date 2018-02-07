tool
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
	self.set_focus_mode(Control.FOCUS_ALL)
	root = folder_tree.create_item()
	root.set_text(0,"root")
	print(root.get_children())
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
	var root = folder_tree.get_root()
	
	if folder_ntxt.text != "" and folder_tree.get_selected() == null:
		
		if name_exists(root, folder_ntxt.text):
			$AlertFolderName.set_exclusive(true)
			$AlertFolderName.popup_centered()
			return
			#var counter = count_tree_items(newfolder.get_parent())
			#newfolder.set_text(0,folder_ntxt.text +str(counter))
		else:
			newfolder = folder_tree.create_item(folder_tree.get_root())
			newfolder.set_text(0,folder_ntxt.text)
		#print(folder_tree.get_root().get_button_count(0))
	elif folder_ntxt.text != "" and folder_tree.get_selected() != null:
		
		if name_exists(folder_tree.get_selected(), folder_ntxt.text):
			$AlertFolderName.set_exclusive(true)
			$AlertFolderName.popup_centered()
			return
			#var counter = count_tree_items(newfolder.get_parent())
			#newfolder.set_text(0,folder_ntxt.text +str(counter))
		else:
			newfolder = folder_tree.create_item(folder_tree.get_selected())
			newfolder.set_text(0,folder_ntxt.text)
	else:
		return
	newfolder.set_selectable(0,true)
	newfolder.set_disable_folding(true)
	newfolder.set_editable(0,true)
	
func _on_del_folder_down():
	var selitem_parent = null
	if folder_tree.get_selected() != null and folder_tree.get_selected() != folder_tree.get_root():
		selitem_parent = folder_tree.get_selected().get_parent()
		selitem_parent.remove_child(folder_tree.get_selected())
		sel_item = null
		selitem_parent.select(0)
		
func _on_create_struc_down():
	var root = folder_tree.get_root()
	print(typeof(get_names(root)))
	print(str(get_names(root)))

func _on_FolderTree_item_selected():
	sel_item = folder_tree.get_selected()
	print(sel_item.get_text(0))

func _on_FolderTree_nothing_selected():
	if folder_tree.get_selected() != null:
		folder_tree.get_selected().deselect(0)
	print("Nothing Selected!")
	
func count_tree_items(treeitem):
	var child_count = 0
	if treeitem != null:
		var child = treeitem.get_children()
		while child != null:
			# put code here
			print(child.get_text(0))
			++child_count
			child = child.get_next()
	return child_count

func name_exists(treeitem, foldername):
	if treeitem != null:
		var child = treeitem.get_children()
		while child != null:
			# put code here
			if child.get_text(0) == foldername:
				return true
			else:
				child = child.get_next()
	return false

func get_names(treeitem):
	var dict = {}
	if treeitem != null:
		var child = treeitem.get_children()
		while child != null:
			if not dict.has(child.get_text(0)):
				dict[child.get_text(0)] = get_names(child)
			# put code here
			child = child.get_next()
	return dict
	