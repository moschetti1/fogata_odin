package sprites

import "core:fmt"
import rl "vendor:raylib"

/*
######################
##SPRITESHEET MODULE##
######################
*/


SpriteSheet :: struct {
	atlas:          rl.Texture2D,
	scale:          f32,
	frame_width:    int,
	frame_height:   int,
	frames_per_row: int,
}

get_rect :: proc(sprite: ^SpriteSheet, frame: int) -> rl.Rectangle {
	row := frame / sprite.frames_per_row
	col := frame % sprite.frames_per_row

	return rl.Rectangle {
		x = f32(col * sprite.frame_width),
		y = f32(row * sprite.frame_height),
		width = f32(sprite.frame_width),
		height = f32(sprite.frame_height),
	}
}

draw_sprite_frame_at :: proc(sprite: ^SpriteSheet, frame: int, position: rl.Vector2) {
	source := get_rect(sprite, frame)
	dest := rl.Rectangle {
		x      = position.x,
		y      = position.y,
		width  = f32(sprite.frame_width) * sprite.scale,
		height = f32(sprite.frame_height) * sprite.scale,
	}
	origin := rl.Vector2{dest.width / 2, dest.height / 2}
	dest.x += origin.x
	dest.y += origin.y

	rl.DrawTexturePro(sprite.atlas, source, dest, origin, 0, rl.WHITE)

	when ODIN_DEBUG {
		// Debug info
		text := fmt.ctprintf("Absolute Frame: %d", frame)
		rl.DrawText(text, i32(position.x - 50), i32(position.y - 80), 10, rl.LIME)

		// Draw bounds
		rl.DrawRectangleLinesEx(
			rl.Rectangle {
				position.x,
				position.y,
				position.x + f32(sprite.frame_width),
				position.y + f32(sprite.frame_height),
			},
			2,
			rl.LIME,
		)
	}
}

destroy_sprite :: proc(sprite: ^SpriteSheet) {
	rl.UnloadTexture(sprite.atlas)
}

