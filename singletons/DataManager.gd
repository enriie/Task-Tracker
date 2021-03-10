extends Node

const DATA_KEY_POINTS = "points"

var daily_save = "user://daily.json"
var weekly_save = "user://weekly.json"
var monthly_save = "user://monthly.json"
var one_time_save = "user://one_time.json"
var points_save = "user://points_data.json"

var data : Dictionary

var file : File
var dir : Directory

func _ready():
	dir = Directory.new()
	data = {}
	
	file = File.new()

func load_data():
	file = File.new()
	var path
	for t in Ref.TASK_TYPE.values():
		match t:
			Ref.TASK_TYPE.DAILY: path = daily_save
			Ref.TASK_TYPE.WEEKLY: path = weekly_save
			Ref.TASK_TYPE.MONTHLY: path = monthly_save
			Ref.TASK_TYPE.ONE_TIME: path = one_time_save
			
		var err = file.open(path, File.READ)
		if err == 0:
			data[t] = parse_json(file.get_as_text())
		file.close()
	
	path = points_save
	var err = file.open(path, File.READ)
	data[DATA_KEY_POINTS] = {}
	if err == 0:
		data[DATA_KEY_POINTS] = parse_json(file.get_as_text())
	file.close()
	
	print(data.keys())
	
	for i in Ref.TASK_TYPE.size():
			if data[i] != null:
				for ts in data[i].keys():
					TaskManager.create_task(data[i][ts][Ref.KEY_TASK_NAME], i, data[i][ts][Ref.KEY_TASK_CHECKED], data[i][ts][Ref.KEY_TASK_CHECKED_DATE], ts, true)
	PointsManager.load_data(data[DATA_KEY_POINTS])
	
	TimeManager.update_datetime()
	TaskManager.wrappable_labels = get_tree().get_nodes_in_group("wrapping_text")

func save_data():
	file = File.new()
	
	var nodes = get_tree().get_nodes_in_group("has_data")
	
	data.clear()
	for type in Ref.TASK_TYPE.values():
		data[type] = {}
	
	for node in nodes:
		data[node.type][node.id] = node.get_data()
	
	data[DATA_KEY_POINTS] = PointsManager.get_data()
	
	print(data.keys())
	
	var path
	for k in data.keys():
		match k:
			Ref.TASK_TYPE.DAILY: path = daily_save
			Ref.TASK_TYPE.WEEKLY: path = weekly_save
			Ref.TASK_TYPE.MONTHLY: path = monthly_save
			Ref.TASK_TYPE.ONE_TIME: path = one_time_save
			DATA_KEY_POINTS: path = points_save
		
		if data[k] != null and !data.empty():
			var err = file.open(path, File.WRITE)
			if err == 0:
				file.store_line(to_json(data[k]))
	file.close()
