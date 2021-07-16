
require("data.const")
require("data.functions")
require("data.actions")
require("data.variables")
require("data.templates")

require("levels.1")

require("rooms.menu")
require("rooms.inGame")


-- TIC
function TIC()
   switchRoom(rooms.menu);
end


