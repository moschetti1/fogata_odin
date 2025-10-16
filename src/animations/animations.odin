package animations

import "core:fmt"
import rl "vendor:raylib"

/*
#####################
##ANIMATIONS MODULE##
#####################

A modularized version of an animation player that can be added to any entity.
*/

Animation :: struct {
	start_frame: int,
	frame_count: int,
	fps:         f32,
	loop:        bool,
}

AnimationPlayer :: struct {
	current_frame: int,
	frame_timer:   f32,
	finished:      bool,
	animation:     Animation,
}

play_animation :: proc(player: ^AnimationPlayer, animation: Animation) {
	player.animation = animation
	player.frame_timer = 0
	player.current_frame = 0
	player.finished = false
}

update_animation_player :: proc(player: ^AnimationPlayer, dt: f32) {
	if player.animation.frame_count == 0 do return
	animation := player.animation

	player.frame_timer += dt

	frame_duration := 1.0 / animation.fps
	if player.frame_timer >= frame_duration {
		player.frame_timer -= frame_duration
		player.current_frame += 1
		if player.current_frame >= animation.frame_count {
			if animation.loop {
				player.current_frame = 0
			} else {
				player.current_frame = animation.frame_count - 1
				player.finished = true
			}
		}
	}
}

get_absolute_frame :: proc(player: ^AnimationPlayer) -> int {
	return player.current_frame + player.animation.start_frame
}

