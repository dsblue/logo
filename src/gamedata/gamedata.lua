
D = {
	jail = {
    locationName = "Jail Cell",
    onEntry = "The cell reeks of urine and sweat. $father sits alone in the corner. $bars separate you from the guards desk across the room.  Inside the cell is two beds and a sink.",
		items = {
			key = {
        displayName = "key",
				onPickup = true,
				onLook = "This is a key",
				onUse = function ( c ) print ("Use in scene " .. c.name ) end
			},
			bars = {
        displayName = "Steel bars",
				onPickup = "inv..",
				onLook = "This is a key",
				onUse = function ( c ) if (c["key"] == nil) then print ("Opening bars") end end
			}
		},
		actors = {
			father = {
        displayName = "Your father",
				dialog = {
					["What is your name?"] = "Dad",
					["What is your quest?"] = "To catch them all..."
				}
			},
			cop = {
        displayName = "A cop",
				dialog = {
					["What is your name?"] = "Cop",
					["What is your quest?"] = "To win."
				}
			}
		},
    exits = {
      ["Front door"] = {
        tryExit = function ( c ) end
      }
    }
	}
}

return D
