-- PARALLAX - by Hazel Quantock
-- scroll layers by different amounts
-- controls to nudge all layers in a direction - so can easily position a series of frames


local help = Dialog("Help")
		:label{text="PARALLAX           by Hazel Quantock @TekF"}
		:separator()
		:label{text="By default each layer moves twice as fast as"}
		:newrow()
		:label{text="the one below. To control speed manually, add"}
		:newrow()
		:label{text="\"s=<speed>\" to the layer's name."}
		:newrow()
		:label{text="Example:"}
		:newrow()
		:label{text="  Layer 2 s=7"}
		:newrow()
		:label{text="  Layer 1 s=3"}

-- keep our own copy of the position, so we can handle sub-pixel movements (cel positions are stored as ints)
local positions = {}

function Scroll( x, y )

	local sprite = app.activeSprite

	local deb = nil
	--deb = Dialog("Debug")   -- alternatively, maybe I can use app.command.DeveloperConsole

	for i,layer in ipairs(sprite.layers) do
		if layer ~= nil then
			-- read speed value from layer name
			local speed = tonumber(string.match( layer.name, "s=([0-9%.%-]+)" ))
			if deb then deb:label{ label="speed", text=tostring(speed) } end
			
			if speed == nil then
				-- default speed: each layer moves twice as fast as the one below
				speed = 2^(i-1)
			end
		
			-- read wrap value from layer name
			local wrapX,wrapY = string.match( layer.name, "w=(x?)(y?)" )
			if deb then deb:label{ label="wrap", text=tostring(wrapX)..tostring(wrapY) } end

			-- convert them to bools
			if wrapX=="x" then wrapX = true else wrapX = false end
			if wrapY=="y" then wrapY = true else wrapY = false end
			
			local cel = layer:cel(app.activeFrame)

			if cel ~= nil and speed ~= 0 then

				-- get position from array, if not there or != stored one (as int), set from the int
				local pos = positions[layer.name]
				if pos == nil or math.floor(pos[1]) ~= cel.position.x or math.floor(pos[2]) ~= cel.position.y then
					-- note that these values will go wrong if a layer changes wrap
					-- but I haven't handled that case because wrap flags are in the layer's name,
					-- so the code thinks it's a different layer and won't get confused!
					pos = { cel.position.x, cel.position.y }
					if wrapX then pos[1] = 0.0 end
					if wrapY then pos[2] = 0.0 end
				end
				
				pos[1] = pos[1] + x*speed
				pos[2] = pos[2] + y*speed

				if wrapX or wrapY then
					local ipos = { math.floor(pos[1]), math.floor(pos[2]) }
					
					-- select the area to wrap
					-- if layer is bigger than the sprite, select that (otherwise assume they don't want weird wrapping within a small area)
					local bounds = sprite.bounds:union(Rectangle(cel.bounds))
					sprite.selection = Selection(bounds)
					
					-- set the layer it's working on (don't seem to be able to specify this, so set the app's current layer
					app.activeLayer = layer -- it doesn't say I can do this, but it doesn't seem to mind

					-- these ifs are SILLY! Just give me a 2D input!
					if wrapX and ipos[1] ~= 0 then
						if ipos[1] > 0 then
							app.command.MoveMask{ target="content", direction="right", units="pixel", quantity=ipos[1], wrap=true }
						else
							app.command.MoveMask{ target="content", direction="left", units="pixel", quantity=-ipos[1], wrap=true }
						end
						pos[1] = pos[1]-ipos[1]
					end
					if wrapY and ipos[2] ~= 0 then
						if ipos[2] > 0 then
							app.command.MoveMask{ target="content", direction="down", units="pixel", quantity=ipos[2], wrap=true }
						else
							app.command.MoveMask{ target="content", direction="up", units="pixel", quantity=-ipos[2], wrap=true }
						end
						pos[2] = pos[2]-ipos[2]
					end
					app.command.DeselectMask()
				end
				
				if not wrapX and not wrapY then
					cel.position = Point( pos[1], pos[2] )
				else if not wrapX then
					cel.position = Point( pos[1], cel.position.y )
				else if not wrapY then
					cel.position = Point( cel.position.x, pos[2] )
				end end end
				
				positions[layer.name] = pos
			end
		end
	end

	if deb then deb:show{wait=false} end
	
	-- AAARGH! need to refresh!
	app.refresh()
end


local dlg = Dialog("Parallax")
dlg
	:button{text=utf8.char(0x2196),onclick=function() Scroll( 1, 1 ) end}
	:button{text="↑",onclick=function() Scroll( 0, 1 ) end}
	:button{text=utf8.char(0x2197),onclick=function() Scroll( -1, 1 ) end}
	:newrow()
	:button{text="←",onclick=function() Scroll( 1, 0 ) end}
	:button{text="?", onclick=function() help:show{} end}
	:button{text="→",onclick=function() Scroll( -1, 0 ) end}
	:newrow()
	:button{text=utf8.char(0x2199),onclick=function() Scroll( 1, -1 ) end}
	:button{text="↓",onclick=function() Scroll( 0, -1 ) end}
	:button{text=utf8.char(0x2198),onclick=function() Scroll( -1, -1 ) end}
	:show{wait=false}
--dlg.bounds = Rectangle( 250, 500, dlg.bounds.width, dlg.bounds.height );

