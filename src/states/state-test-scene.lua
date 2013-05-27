--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
--==============================================================

local mainMenu = {}
mainMenu.layerTable = nil
local mainLayer = nil

local playButton

textRect = { }
len = 1
----------------------------------------------------------------
----------------------------------------------------------------
mainMenu.onFocus = function ( self )
	MOAIGfxDevice.getFrameBuffer():setClearColor ( 0, 0, 0, 1 )
end	

----------------------------------------------------------------
mainMenu.onInput = function ( self )
	if inputmgr:up () then
		
		local x, y = mainLayer:wndToWorld ( inputmgr:getTouch ())
		
		--playButton:updateClick ( false, x, y )
    
		--MOAITextBox:getStringBounds does not return a proper value (at least, not before its been rendered once)
    len = len + 1 
    x1, y1, x2, y2 = tb:getStringBounds( len, 4 )
    textRect = { x1, y1, x2, y2-12 }
  
    mainLayer:wndToWorld ( inputmgr:getTouch ())
  
    print ( "TB" .. "," .. x1 .. "," .. y1  .. "," .. x2 .. "," .. y2)
    print ( "Width = " .. x2 - x1 .. " Height=" .. y2 - y1)
    print ( "Mouse Click: " .. x .. "," .. y );

	elseif inputmgr:down () then
		
		local x, y = mainLayer:wndToWorld ( inputmgr:getTouch ())
		
		--playButton:updateClick ( true, x, y )
	end

end

function drawShapes(i, x, y, xs, ys) 
    MOAIGfxDevice:setPenColor(1,0,1,1)
    MOAIDraw.fillCircle ( 100, 100, 64, 32 )
    MOAIGfxDevice:setPenColor(0,0,1,1)
    --MOAIDraw.drawRect(  unpack (textRect) )
    MOAIDraw.drawRect(  100, -100, 300, 0 )
end

function drawShapes2(i, x, y, xs, ys) 
    MOAIGfxDevice:setPenColor(0,0,1,1)
    MOAIDraw.drawRect(  unpack (textRect) )
    --MOAIDraw.drawRect(  -100, -100, 100, 100 )
end

----------------------------------------------------------------
mainMenu.onLoad = function ( self )
		
	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	mainMenu.layerTable [ 1 ] = { layer }
	
	local font =  MOAIFont.new ()
	font:loadFromTTF ( "arialbd.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?! ", 12, 163 )

	local textbox = {}
	textbox[1] = MOAITextBox.new ()
	textbox[1]:setFont ( font )
	textbox[1]:setAlignment ( MOAITextBox.LEFT_JUSTIFY )
	textbox[1]:setYFlip ( true )
	textbox[1]:setRect ( -200, -200, 200, 0 )
	textbox[1]:setString ( "Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo Logo " )
	--layer:insertProp ( textbox[1] )
	
  textcoords = { -380, -270, 380, 110 }
  
  textbg = MOAIGfxQuad2D.new()
  textbg:setTexture( "resources/background.png" )
  textbg:setRect( -390, 120, 390, -280 )
  bgProp = MOAIProp2D.new()
  bgProp:setDeck (textbg)
  --layer:insertProp( bgProp )

	textbox[2] = MOAITextBox.new ()
	textbox[2]:setFont ( font )
  --textbox[2]:setColor ( 0.2,0.2,0.2,1 )
	textbox[2]:setAlignment ( MOAITextBox.LEFT_JUSTIFY )
	textbox[2]:setYFlip ( true )
	textbox[2]:setRect ( unpack (textcoords) )
	textbox[2]:setString ( "Test mmm Test mmm Test mmm " )
	layer:insertProp ( textbox[2] )
  
  tb = textbox[2]
  
	scriptDeck = MOAIScriptDeck.new()
  scriptDeck:setRect(-400, -300, 400, 300)
  scriptDeck:setDrawCallback (drawShapes)
  prop = MOAIProp2D.new ()
  prop:setDeck ( scriptDeck )
  --layer:insertProp ( prop )
  
	local gameData = dofile( "gamedata/gamedata.lua" )	
  
  local scene = gameData.jail
 
 
  self.name = "My scene"
 
 -- Find the items in the scene:
  if scene.items then
      for i,v in pairs(scene.items) do
          print (i)
          if type (v.onUse) == "function" then
            print ("Using " .. i )
            v.onUse ( self )
          end
      end
  end
  
  -- Handle the scene entry
	if type (scene.onEntry) == "function" then
      scene:onEntry( context )
  elseif type (scene.onEntry) == "string" then
      textbox[2]:setString ( scene.onEntry )
  end
  
  textTest = MOAIScriptDeck.new()
  textTest:setRect( textbox[2]:getRect() )
  textTest:setDrawCallback (drawShapes2)
  textTestProp = MOAIProp2D.new ()
  textTestProp:setDeck ( textTest )
  textTestProp:setParent( textbox[2] )
  layer:insertProp ( textTestProp )
  
--	playButton = elements.makeTextButton ( font, "resources/button.png", 206, 150, 60 )
	
--	playButton:setCallback ( function ( self )
		
--		local thread = MOAIThread.new ()
--		thread:run ( mainMenu.StartGameCloud, mainMenu.newGame )
		
--	end )
	
--	if savefiles.get ( "user" ).fileexist then
--		playButton:setString ( "Continue" )
--		playButton.newGame = false
--	else
--		playButton:setString ( "New Game" )
--		playButton.newGame = true
--	end
	
--	layer:insertProp ( playButton.img )
--	layer:insertProp ( playButton.txt )
	
	mainLayer = layer
	
end

----------------------------------------------------------------
mainMenu.onUnload = function ( self )
	
	for i, layerSet in ipairs ( self.layerTable ) do
		
		for j, layer in ipairs ( layerSet ) do
		
			layer = nil
		end
	end
	
	self.layerTable = nil
	mainLayer = nil
end

----------------------------------------------------------------
mainMenu.onUpdate = function ( self )
	
end

return mainMenu