--=============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
--==============================================================

local splash = {}
splash.layerTable = nil

----------------------------------------------------------------
splash.onFocus = function ( self )	 

	MOAIGfxDevice.getFrameBuffer():setClearColor ( 0, 0, 0, 1 )
	
	splash.waitSeconds = 2
	splash.startTime = MOAISim.getDeviceTime ()
	
end

----------------------------------------------------------------
splash.onInput = function ( self )

end

----------------------------------------------------------------
splash.onLoad = function ( self )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	layer:setClearColor ( 0, 0, 0, 1 )
	splash.layerTable [ 1 ] = { layer }
	
	local gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( "resources/logob.png" )
	gfxQuad:setRect ( -128, -128, 128, 128 )
	
	local moaiLogo = MOAIProp.new ()
	moaiLogo:setDeck ( gfxQuad )
	layer:insertProp ( moaiLogo )

end

----------------------------------------------------------------
splash.onLoseFocus = function ( self )
end

----------------------------------------------------------------
splash.onUnload = function ( self )
	
	for i, layerSet in ipairs ( self.layerTable ) do
		
		for j, layer in ipairs ( layerSet ) do
		
			layer:clear ()
			layer = nil
		end
	end
	
	self.layerTable = nil
end

----------------------------------------------------------------
splash.onUpdate = function ( self )

	if self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

		statemgr.push ( "states/state-test-scene.lua" )
	end
end

return splash