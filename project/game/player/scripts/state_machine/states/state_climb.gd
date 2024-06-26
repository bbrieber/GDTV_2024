class_name State_Climb extends StateMovementBase


@export var wallRaycast: WallRaycast
var climb_acceleration : float 


func enter(_msg :Dictionary= {}) -> void:
	state_started.emit()
	climb_acceleration  = player.player_movement_config.climb_velocity / player.player_movement_config.climb_time_to_peak

	player.player_skin.play_animation(PlayerSkin.ANIMATION_STATE.CLIMB)
	player.player_state.start_climb( )
	
func exit() -> void:	
	state_exit.emit()
	player.player_state.stop_climb( )

#	if player.velocity.y>0:
#		player.player_state.coyote_timer.start()


func update_energy()->void:	
	AlEnergySystem.reduce_energy(player.player_movement_config.climb_energy_per_second)

func physics_update(_ownerBody: CharacterBody2D,delta: float) -> void:
	var vertical_dir:float = player.input_processor.vertical_dir
	
		
	player.velocity.x = wallRaycast.get_wall_dir()
			#player.velocity.x =  _get_stop_velocity(direction,delta)#
		
	player.velocity.y = _get_climb_velocity(vertical_dir,delta)
	
	player.move_and_slide()
	



func _get_climb_velocity(direction: float,delta:float) ->float:
	var out:float = player.velocity.y
	var target_dir_sign : int = 1 if direction > 0 else -1
	target_velocity.y = direction  * player.player_movement_config.climb_velocity

	var accelerate : bool = true if ( 
		(target_dir_sign > 0 and target_velocity.y >= player.velocity.y) or
		(target_dir_sign < 0 and target_velocity.y <= player.velocity.y) 
		or
		(target_dir_sign > 0 and target_velocity.y < 0) or
		(target_dir_sign < 0 and target_velocity.y > 0)
		 ) else false
		
	if accelerate:
		out += climb_acceleration * delta *target_dir_sign

	#else:
	#	out += run_deceleration * delta *target_dir_sign
	
	if target_dir_sign > 0:
		out = max(out,target_velocity.y)
	else:
		out = min(out,target_velocity.y)
		

	return out
