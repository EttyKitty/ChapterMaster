try {
	screen_save("screen" + string(save_number) + ".png");

	alarm[3] = 1;
} catch (_exception) {
	handle_exception(_exception);
}
