extends Control

func on_managed_updated():
	for c in get_node("main_body/tab_container").get_children():
		if c.get_node("scroll_container/task_box").get_children().size() > 1:
			c.get_node("scroll_container/task_box/label_no_tasks").visible = false
