tool
extends Panel

export(Texture) var folder_icon

#Controls
onready var folder_tree = $MarginContainer/PanelContainer/HBoxContainer/FolderTree
onready var folder_ntxt = $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/FolderName
onready var git_text = $DialogGit/MarginContainer/GItextedit
onready var readme_text = $DialogReadme/MarginContainer/Readtextedit

#Buttons
onready var add_folder= $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/AddFolder
onready var del_folder= $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/DelFolder
onready var clear_tree = $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer/ClearTree
onready var create_struc = $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/Create
onready var edit_git = $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer2/EditGitBtn
onready var edit_readme = $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer2/EditReadBtn
onready var add_git = $MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer2/Addgit
onready var add_readme =$MarginContainer/PanelContainer/HBoxContainer/Controls/VBoxContainer/HBoxContainer2/Addreadme


var sel_item = null
var root = null

func _ready():
	self.set_focus_mode(Control.FOCUS_ALL)
	root = folder_tree.create_item()
	root.set_text(0,"root")
	#print(root.get_children())
	#print(folder_tree.get_selected())
	
	add_folder.connect("button_down",self,"_on_add_folder_down")
	del_folder.connect("button_down",self,"_on_del_folder_down")
	create_struc.connect("button_down",self,"_on_create_struc_down")
	edit_git.connect("button_down",self,"_on_editgit_button_down")
	edit_readme.connect("button_down",self,"_on_editreadme_button_down")
	clear_tree.connect("button_down",self,"_on_cleartree_button_down")
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
	newfolder.set_disable_folding(false)
	newfolder.set_editable(0,true)
	newfolder.set_icon(0,folder_icon)
	
func _on_del_folder_down():
	var selitem_parent = null
	if folder_tree.get_selected() != null and folder_tree.get_selected() != folder_tree.get_root():
		selitem_parent = folder_tree.get_selected().get_parent()
		selitem_parent.remove_child(folder_tree.get_selected())
		sel_item = null
		selitem_parent.select(0)
		
func _on_create_struc_down():
	var dir = Directory.new()
	dir.open('res://')
	var dir_dic = get_names(folder_tree.get_root())
	create_direc(dir_dic, dir)
	
	if add_git.is_pressed():
		var gitfile = File.new()
		gitfile.open('res//.gitignore',gitfile.WRITE)
		gitfile.store_string(git_text.text)
		gitfile.close()
	
	if add_readme.is_pressed():
		var readmefile = File.new()
		readmefile.open('res://README.md',readmefile.WRITE)
		readmefile.store_string(readme_text.text)
		readmefile.close()

	
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
			dict[child.get_text(0)] = get_names(child)
			# put code here
			child = child.get_next()
	return dict

func create_direc(dir_dict, dir):
	var strdir = dir.get_current_dir()
	if !dir_dict.empty():
		for key in dir_dict.keys():
			if !dir.dir_exists(key): dir.make_dir(key)
			
			if !dir_dict[key].empty():
				dir.change_dir(key)
				create_direc(dir_dict[key],dir)
			dir.change_dir(strdir)
	else:
		return
	
func _on_editgit_button_down():
	$DialogGit.set_exclusive(true)
	$DialogGit.popup_centered()


func _on_editreadme_button_down():
	$DialogReadme.set_exclusive(true)
	$DialogReadme.popup_centered()
	
func _on_cleartree_button_down():
	folder_tree.clear()
	root = folder_tree.create_item()
	root.set_text(0,"root")

