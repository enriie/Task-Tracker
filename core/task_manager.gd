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

var label_wrapper : Control
var label_selected : Label
var label_filter  : Label

var wrap_label

func _ready():
	selected_task = null
	filter = Ref.MANAGER_FILTERS.ALL
	
	label_selected = $main_body/task_editor/h_box_label/label_wrapper/label_current_selection
	label_wrapper = $main_body/task_editor/h_box_label/label_wrapper
	label_filter = $main_body/task_view_body/buttons_filter/label_current_filter
	
	input_body = $main_body/task_editor/h_input_body
	task_options = $main_body/task_editor/options_task_type
	
	wrap_label = false
	
	TaskManager.task_box = $main_body/task_view_body/task_container/task_box
	TaskManager.task_manager = self
	
	DataManager.load_data()
	update_manager()
	filter_tasks()

func _process(delta):
	if !wrap_label:
		return
	
	label_selected.rect_position[0] -= 1
	if label_selected.rect_position[0] <  -label_selected.rect_size[0] - 4:
		label_selected.rect_position[0] = label_wrapper.rect_position[0] + (label_wrapper.rect_position[0] * 1.25)

func update_manager():
	if selected_task == null:
		label_selected.text = "None"
	else:
		label_selected.text = selected_task.task_name

func filter_tasks():
	match filter:
		Ref.MANAGER_FILTERS.ALL:
			label_filter.text = label_filter_text % "All"
		Ref.MANAGER_FILTERS.DAILY:
			label_filter.text = label_filter_text % "D"
		Ref.MANAGER_FILTERS.WEEKLY:
			label_filter.text = label_filter_text % "W"
		Ref.MANAGER_FILTERS.MONTHLY:
			label_filter.text = label_filter_text % "M"
		Ref.MANAGER_FILTERS.ONE_TIME:
			label_filter.text = label_filter_text % "O"
		_: printerr("Incorrect filter was selected! Filter:[%s]" % filter)
	
	for t in TaskManager.task_box.get_children():
		t.visible = true
		if filter != Ref.MANAGER_FILTERS.ALL:
			if t.type != filter - 1:
				t.visible = false

func select_task(mt):
	if selected_task == mt:
		return
	
	wrap_label = false
	selected_task = mt
	
	label_selected.rect_position[0] = 0
	
	input_body.get_node("task_name_input").text = mt.task_name
	task_options.selected = mt.type
	label_selected._set_size(Vector2(0, 0))
	label_selected.text = selected_task.task_name
	
	update_manager()

func _on_button_confirm_button_up():
	if input_body.get_node("task_name_input").text.replace(" ", "").length() > 0:
		if selected_task != null:
			TaskManager.edit_task(selected_task, input_body.get_node("task_name_input").text, task_options.selected)
			
			input_body.get_node("task_name_input").clear()
			selected_task = null
		else:
			TaskManager.create_task(input_body.get_node("task_name_input").text, task_options.selected, false, {})
			input_body.get_node("task_name_input").clear()
			
		wrap_label = false
		update_manager()
		filter_tasks()

func _on_button_cancel_button_down():
	wrap_label = false
	selected_task = null
	input_body.get_node("task_name_input").clear()
	
	update_manager()

func _on_button_all_pressed():
	filter = Ref.MANAGER_FILTERS.ALL
	filter_tasks()

func _on_button_daily_pressed():
	filter = Ref.MANAGER_FILTERS.DAILY
	filter_tasks()

func _on_button_weekly_pressed():
	filter = Ref.MANAGER_FILTERS.WEEKLY
	filter_tasks()

func _on_button_monthly_pressed():
	filter = Ref.MANAGER_FILTERS.MONTHLY
	filter_tasks()

func _on_button_one_time_pressed():
	filter = Ref.MANAGER_FILTERS.ONE_TIME
	filter_tasks()


func _on_label_current_selection_resized():
	wrap_label = false
	if $main_body/task_editor/h_box_label/label_wrapper/label_current_selection.rect_size[0] > label_wrapper.rect_size[0] - 32:
		wrap_label = true
