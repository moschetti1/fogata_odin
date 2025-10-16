package main
import "core:fmt"
import rl "vendor:raylib"

SoundManager :: struct {
	campfire_music:      rl.Music,
	campfire_volume:     f32,
	crickets_music:      rl.Music,
	crickets_volume:     f32,
	fire_start_sfx:      rl.Sound,
	fire_extinguish_sfx: rl.Sound,
}

toggle_crickets :: proc(manager: ^SoundManager) {
	if rl.IsMusicStreamPlaying(manager.crickets_music) {
		rl.StopMusicStream(manager.crickets_music)
	} else {
		rl.PlayMusicStream(manager.crickets_music)
		rl.SetMusicVolume(manager.crickets_music, manager.crickets_volume)
	}
}

toggle_campfire :: proc(manager: ^SoundManager) {
	if rl.IsMusicStreamPlaying(manager.campfire_music) {
		// rl.PlaySound(manager.fire_extinguish_sfx)
		rl.StopMusicStream(manager.campfire_music)
	} else {
		fmt.println("play music")
		// rl.PlaySound(manager.fire_start_sfx)
		rl.PlayMusicStream(manager.campfire_music)
		rl.SetMusicVolume(manager.campfire_music, manager.campfire_volume)
	}
}

update_campfire_volume :: proc(manager: ^SoundManager, vol: f32) {
	manager.campfire_volume = vol
	if rl.IsMusicStreamPlaying(manager.campfire_music) {
		rl.SetMusicVolume(manager.campfire_music, manager.campfire_volume)
	}
}

update_crickets_volume :: proc(manager: ^SoundManager, vol: f32) {
	manager.crickets_volume = vol
	if rl.IsMusicStreamPlaying(manager.crickets_music) {
		rl.SetMusicVolume(manager.crickets_music, manager.crickets_volume)
	}
}

