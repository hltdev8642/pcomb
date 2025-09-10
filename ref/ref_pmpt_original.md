create combined physics mod for teardown game.

combine the three mods and their features from:
- #file:ref/pdm
- #file:ref/ibsit 
- #file:ref/mbcs 

#websearch 
#extensions 

references to use:
- #fetch https://teardowngame.com/modding/api.html
- #fetch https://www.teardowngame.com/modding
- #file:ref/api.xml
- #file:ref/api.html
- #file:ref/api.md

- should include (2) options/settings menus (options.lua):
  - 1: via mod manager / main menu
  - 2: via pause menu)

-- DEV HINT (for Copilot): -- Try to prioritize using the functions listed in #file:ref/main_functions.lua 
-- Only Teardown API functions from #file:ref/api.html #file:ref/api.xml #file:ref/api.md
-- Avoid inventing new global functions. Prefer module return tables.
-- Utilize the list of built in functions/methods in #file:ref/function_list.lua


new mod should reside in root directory of workspace 