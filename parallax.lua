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


function Scroll( x, y )

	local sprite = app.activeSprite

	--local deb = Dialog("Debug")   -- alternatively, maybe I can use app.command.DeveloperConsole

	for i,layer in ipairs(sprite.layers) do
		if layer ~= nil then
			-- read speed value from layer name
			local speed = tonumber(string.match( layer.name, "s=(%d+)" ))
			--deb:label{ label="speed", text=speed }

			if speed == nil then
				-- default speed: each layer moves twice as fast as the one below
				speed = 2^(i-1)
			end
		
			local cel = layer:cel(app.activeFrame);
			if cel ~= nil and speed ~= 0 then
				cel.position = Point( cel.position.x + x*speed, cel.position.y + y*speed )
			end
		end
	end

	--deb:show{wait=false}
	
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

