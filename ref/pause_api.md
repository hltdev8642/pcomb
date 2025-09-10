PauseMenuButton
clicked = PauseMenuButton(title, [location])
Arguments
title (string) - Text on button
location (string, optional) - Button location. If "bottom_bar" - bottom bar, if "main_bottom" - below "Main menu" button, if "main_top" - above "Main menu" button. Default "bottom_bar".

Return value
clicked (boolean) - True if clicked, false otherwise

Calling this function will add a button on the bottom bar or in the main pause menu (center of the screen) when the game is paused. Identified by 'location' parameter, it can be below "Main menu" button (by passing "main_bottom" value)or above (by passing "main_top"). A primary button will be placed in the main pause menu if this function is called from a playable mod. There can be only one primary button. Use this as a way to bring up mod settings or other user interfaces while the game is running. Call this function every frame from the tick function for as long as the pause menu button should still be visible. Only one button per script is allowed. Consecutive calls replace button added in previous calls.

```
function tick()

    -- Primary button which will be placed in the main pause menu below "Main menu" button
	if PauseMenuButton("Back to Hub", "main_bottom") then
		StartLevel("hub", "level/hub.xml")
	end

	-- Primary button which will be placed in the main pause menu above "Main menu" button
	if PauseMenuButton("Back to Hub", "main_top") then
		StartLevel("hub", "level/hub.xml")
	end
	
	-- Button will be placed in the bottom bar of the pause menu
	if PauseMenuButton("MyMod Settings") then
		visible = true
	end
end

function draw()
	if visible then
		UiMakeInteractive()
	end
end

```