extends Control

var label_selection_text = "Selected Task: %s"

var selected_task : Control = null

var main_body
var input_body
var task_options

func _ready():
	
	TaskManager.task_manager = get_node("main_body/task_view/task_view_body/task_container/task_box")
	
	main_body = get_node("main_body")
	input_body = get_node("main_body/task_editing/v_managment_body/h_input_body")
	
	task_options = get_node("main_body/task_editing/v_managment_body/options_task_type")
	
	update_manager()
	pass

func update_manager():
	
	if selected_task == null:
		$main_body/label_current_selection.text = "No task has been selected"
	else:
		$main_body/label_current_selection.text = label_selection_text % [selected_task.task_name]

func is_task_selected():
	if selected_task == null:
		return false
	return true

func _on_button_confirm_button_up():
	if is_task_selected():
		print("task is selected")
	else:
		TaskManager.create_task(input_body.get_node("task_renaming").text, task_options.selected)
		
		task_options.selected = 0
		input_body.get_node("task_renaming").clear()
	pass

func _on_button_cancel_button_down():
	selected_task = null
	input_body.get_node("task_renaming").clear()
	task_options.selected = 0
	pass
