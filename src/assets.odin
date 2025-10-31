package main

import "core:bytes"
import rl "vendor:raylib"

ATLAS_PATH :: "../assets/atlas.png"
WORK_SOUND :: "../assets/campfire.wav"
CRICKET_SOUND :: "../assets/criclet_sound.ogg"
KEYSTROKE_SFX :: "../assets/campfire.wav"

Assets :: struct {
	atlas:           rl.Texture2D,
	work_sound:      rl.Music,
	cricket_sound:   rl.Music,
	keystroke_sound: rl.Sound,
}

load_assets :: proc() -> Assets {
	assets: Assets

	when ODIN_DEBUG {
		assets.atlas = rl.LoadTexture(ATLAS_PATH)
		assets.work_sound = rl.LoadMusicStream(WORK_SOUND)
		// assets.cricket_sound = rl.LoadMusicStream(CRICKET_SOUND)
		assets.keystroke_sound = rl.LoadSound(KEYSTROKE_SFX)
	} else {
		atlas_png := #load(ATLAS_PATH)
		img := rl.LoadImageFromMemory(".png", raw_data(atlas_png), i32(len(atlas_png)))
		assets.atlas = rl.LoadTextureFromImage(img)
		rl.UnloadImage(img)
		work_sound_data := #load(WORK_SOUND)
		// 	cricket_sound_data := #load(CRICKET_SOUND)
		// 	keystroke_sound_data := #load(KEYSTROKE_SFX)
		assets.work_sound = rl.LoadMusicStreamFromMemory(
			".wav",
			raw_data(work_sound_data),
			i32(len(work_sound_data)),
		)
		// 	assets.cricket_sound = rl.LoadMusicStreamFromMemory(
		// 		".ogg",
		// 		raw_data(cricket_sound_data),
		// 		i32(len(cricket_sound_data)),
		// 	)
		// 	keystroke_sound := rl.LoadWaveFromMemory(
		// 		".wav",
		// 		raw_data(keystroke_sound_data),
		// 		i32(len(keystroke_sound_data)),
		// 	)
		// 	assets.keystroke_sound = rl.LoadSoundFromWave(keystroke_sound)
		// 	rl.UnloadWave(keystroke_sound)
	}
	return assets
}

unload_assets :: proc(assets: ^Assets) {
	rl.UnloadTexture(assets.atlas)
	rl.UnloadMusicStream(assets.work_sound)
	// rl.UnloadMusicStream(assets.cricket_sound)
	// rl.UnloadSound(assets.keystroke_sound)
}

