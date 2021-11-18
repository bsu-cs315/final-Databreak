extends Node2D


const SPAWN_POSITION := Vector2(496,460)

var enemy_position := Vector2(2578,662)
var usb_position := Vector2(-47, -1777)
var floppy_position := Vector2(2705, 1198)
var player : KinematicBody2D
var enemy : KinematicBody2D
var usb : Area2D
var floppy : Area2D
var floppy_collected := 0
var usb_collected := 0


func _ready() -> void:
	_make_player()
	_make_enemy()
	enemy_position = Vector2(3743,-1130)
	_make_enemy()
	enemy_position = Vector2(7186,665)
	_make_enemy()
	enemy_position = Vector2(875,-1129)
	_make_enemy()
	_make_USB()
	_make_Floppy_Disk()
	floppy_position = Vector2(6019, 689)
	_make_Floppy_Disk()
	floppy_position = Vector2(2241, -1105)
	_make_Floppy_Disk()


func _process(_delta) -> void:
	# Exit Conditions
	if floppy_collected == 3 and usb_collected == 1:
		# You win
		var _game_over := get_tree().change_scene("res://ScreenEnd/ScreenWin.tscn")


# When called creates an instance of a player at whatever the spawn position is set to for the level
func _make_player() -> void:
	player = load("res://Player/Player.tscn").instance()
	player.position = SPAWN_POSITION
	call_deferred("add_child", player)


# When called creates an instance of an enemy at a specified position
func _make_enemy() -> void:
	enemy = load("res://Enemy/Enemy.tscn").instance()
	var _connection = enemy.connect("player_hit", self, "_register_hit")
	enemy.position = enemy_position
	call_deferred("add_child", enemy)


# When called creates an instance of an USB collectable at a specified position
func _make_USB() -> void:
	usb = load("res://Collectables/Data/USB.tscn").instance()
	var _connection := usb.connect("body_entered", self, "_on_USB_Entered", [usb])
	usb.position = usb_position
	call_deferred("add_child", usb)


# When called creates an instance of an Floppy Disk collectable at a specified position
func _make_Floppy_Disk() -> void:
	floppy = load("res://Collectables/Data/FloppyDisk.tscn").instance()
	var _connection := floppy.connect("body_entered", self, "_on_Floppy_Entered", [floppy])
	floppy.position = floppy_position
	call_deferred("add_child", floppy)


func _register_hit(body) -> void:
	if body == player:
		var _game_over := get_tree().change_scene("res://ScreenEnd/ScreenEnd.tscn")


func _on_USB_Entered(body, _usb) -> void:
	if body == player:
		# Make note that data was collected
		usb_collected += 1
		$HUD/USB.visible = false
		_usb.queue_free()


func _on_Floppy_Entered(body, _floppy) -> void:
	if body == player:
		# Make note that data was collected
		floppy_collected += 1
		if floppy_collected == 1:
			$HUD/Floppy.visible = false
		elif floppy_collected == 2:
			$HUD/Floppy2.visible = false
		elif floppy_collected == 3:
			$HUD/Floppy3.visible = false
		_floppy.queue_free()