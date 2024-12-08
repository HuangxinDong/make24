extends Node

var save_path = "user://player_data.save"

# Player's data
var player = {
	"make24_score": 0,
	"limited_time_score": 0,
	"limited_time_best": 0,
}


# 保存玩家数据到文件
func save_data():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(player)
	save_file.close()

# 加载玩家数据
func load_data():
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		player = save_file.get_var()
		save_file.close()
	else:
		print("No data saved")
