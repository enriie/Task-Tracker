extends Control

var label_selection_text = "Selected Task: %s"
var label_filter_text = "Current Filter: %s"
var selected_task : Control = null

var main_body
var input_body
var task_options
var task_view_body

var filter
var filter_updated : bool

signal manager_updated

func _ready():
	selected_task = null
	filter = Ref.MANAGER_FILTERS.ALL
	
	TaskManager.daily_tasks = get_node("../main/main_body/tab_container/Daily/scroll_container/task_box")
	TaskManager.weekly_tasks = get_node("../main/main_body/tab_container/Weekly/scroll_container/task_box")
	TaskManager.monthly_tasks = get_node("../main/main_body/tab_container/Monthly/scroll_container/task_box")
	TaskManager.one_time_tasks = get_node("../main/main_body/tab_container/One Time/scroll_container/task_box")
	
	TaskManager.task_box = get_node("main_body/task_view/task_view_body/task_container/task_box")
	TaskManager.task_manager = self

	main_body = get_node("main_body")
	input_body = get_node("main_body/task_editing/v_managment_body/h_input_body")
	
	task_view_body = get_node("main_body/task_view/task_view_body")
	
	task_options = get_node("main_body/task_editing/v_managment_body/options_task_type")
	
	var err = connect("manager_updated", get_node("../main"), "on_managed_updated")
	if err != 0:
		print_debug("Error occured when trying to connect Task Manager View to Main View.")
	else:
		print_debug("Task Manager View successfully connected to Main View.")
	
	DataManager.load_data()
	update_manager()

func update_manager():
	if selected_task == null:
		$main_body/label_current_selection.text = "No task has been selected"
	else:
		$main_body/label_current_selection.text = label_selection_text % [selected_task.task_name]
	
	match filter:
		Ref.MANAGER_FILTERS.ALL:
			$main_body/task_view/task_view_body/buttons_filter/label_current_filter.text = label_filter_text % "All"
		Ref.MANAGER_FILTERS.DAILY:
			$main_body/task_view/task_view_body/buttons_filter/label_current_filter.text = label_filter_text % "D"
		Ref.MANAGER_FILTERS.WEEKLY:
			$main_body/task_view/task_view_body/buttons_filter/label_current_filter.text = label_filter_text % "W"
		Ref.MANAGER_FILTERS.MONTHLY:
			$main_body/task_view/task_view_body/buttons_filter/label_current_filter.text = label_filter_text % "M"
		Ref.MANAGER_FILTERS.ONE_TIME:
			$main_body/task_view/task_view_body/buttons_filter/label_current_filter.text = label_filter_text % "O"
		_: printerr("Incorrect filter was selected! Filter:[%s]" % filter)
	
	for t in TaskManager.task_box.get_children():
		t.visible = true
		if filter != Ref.MANAGER_FILTERS.ALL:
			if t.type != filter - 1:
				t.visible = false
	emit_signal("manager_updated")

func is_task_selected():
	if selected_task == null:
		return false
	return true

func select_task(mt):
	selected_task = mt
	
	input_body.get_node("task_renaming").text = mt.task_name
	task_options.selected = mt.type
	update_manager()

func _on_button_confirm_button_up():
	if get_node("main_body/task_editing/v_managment_body/h_input_body/task_renaming").text.replace(" ", "").length() > 0:
		if is_task_selected():
			TaskManager.edit_task(selected_task, input_body.get_node("task_renaming").text, task_options.selected)
			
			task_options.selected = 0
			input_body.get_node("task_renaming").clear()
			
			selected_task = null
			update_manager()
		else:
			TaskManager.create_task(input_body.get_node("task_renaming").text, task_options.selected, false, {})
			
			task_options.selected = 0
			input_body.get_node("task_renaming").clear()
			update_manager()

func _on_button_cancel_button_down():
	selected_task = null
	
	input_body.get_node("task_renaming").clear()
	task_options.selected = 0
	update_manager()

func _on_button_all_pressed():
	filter = Ref.MANAGER_FILTERS.ALL
	update_manager()

func _on_button_daily_pressed():
	filter = Ref.MANAGER_FILTERS.DAILY
	update_manager()

func _on_button_weekly_pressed():
	filter = Ref.MANAGER_FILTERS.WEEKLY
	update_manager()

func _on_button_monthly_pressed():
	filter = Ref.MANAGER_FILTERS.MONTHLY
	update_manager()

func _on_button_one_time_pressed():
	filter = Ref.MANAGER_FILTERS.ONE_TIME
	update_manager()
