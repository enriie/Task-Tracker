extends Node

var daily_save = "user://daily.json"
var weekly_save = "user://weekly.json"
var monthly_save = "user://monthly.json"
var one_time_save = "user://one_time.json"

var data : Dictionary

var file : File
var dir : Directory

func _ready():
	dir = Directory.new()
	data = {}
	
	file = File.new()
	
	pass

func load_data():
	file = File.new()
	var path
	for t in Ref.TASK_TYPE.values():
		match t:
			Ref.TASK_TYPE.DAILY: path = daily_save
			Ref.TASK_TYPE.WEEKLY: path = weekly_save
			Ref.TASK_TYPE.MONTHLY: path = monthly_save
			Ref.TASK_TYPE.ONE_TIME: path = one_time_save
		
		file.open(path, File.READ)
		data[t] = parse_json(file.get_as_text())
		file.close()
	
	for t in data.keys():
			if data[t] != null:
				for ts in data[t].keys():
					print(data[t][ts][Ref.KEY_TASK_NAME])
					TaskManager.create_task(data[t][ts][Ref.KEY_TASK_NAME], t, data[t][ts][Ref.KEY_TASK_CHECKED], data[t][ts][Ref.KEY_TASK_CHECKED_DATE], ts, true)
	
	pass

func save_data():
	file = File.new()
	
	var save_dict = {}
	var nodes = get_tree().get_nodes_in_group("has_data")
	
	for type in Ref.TASK_TYPE.values():
		data[type] = {}
	
	for node in nodes:
		data[node.type][node.id] = node.get_data()
	
	var path
	for t in Ref.TASK_TYPE.values():
		match t:
			Ref.TASK_TYPE.DAILY: path = daily_save
			Ref.TASK_TYPE.WEEKLY: path = weekly_save
			Ref.TASK_TYPE.MONTHLY: path = monthly_save
			Ref.TASK_TYPE.ONE_TIME: path = one_time_save
		
		if data[t] != null and !data.empty():
			file.open(path, File.WRITE)
			file.store_line(to_json(data[t]))
			file.close()
	pass

func delete_data():
	pass
