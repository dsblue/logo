--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
--==============================================================

local mainMenu = {}
mainMenu.layerTable = nil
local mainLayer = nil

local invButton

function CheckCollision(x, y, x1,y1,x2,y2)
  return x > x1 and x < x2 and y > y1 and y < y2
end

----------------------------------------------------------------
----------------------------------------------------------------
mainMenu.onFocus = function ( self )
	MOAIGfxDevice.getFrameBuffer():setClearColor ( 0, 0, 0, 1 )
end	

----------------------------------------------------------------
mainMenu.onInput = function ( self )
	if inputmgr:up () then
		
		local x, y = mainLayer:wndToWorld ( inputmgr:getTouch ())
		
		invButton:updateClick ( false, x, y )
    
		--MOAITextBox:getStringBounds does not return a proper value (at least, not before its been rendered once)
    for i,v in pairs( keywords ) do
      if CheckCollision(x,y, unpack(v.boundingBox)) then
        print ("Hit: " .. v.displayName )
      end
    end
    
    --print ( "TB" .. "," .. x1 .. "," .. y1  .. "," .. x2 .. "," .. y2)
    --print ( "Width = " .. x2 - x1 .. " Height=" .. y2 - y1)
    --print ( "Mouse Click: " .. x .. "," .. y );

	elseif inputmgr:down () then
		
		local x, y = mainLayer:wndToWorld ( inputmgr:getTouch ())
		
		invButton:updateClick ( true, x, y )
	end

end

function drawShapes(i, x, y, xs, ys) 
    MOAIGfxDevice:setPenColor(0,0,1,1)
    --MOAIDraw.drawRect(  unpack (textRect) )
    --MOAIDraw.drawRect(  -100, -100, 100, 100 )
    for i,v in pairs( keywords ) do
        MOAIDraw.drawRect( unpack(v.boundingBox) )
    end
      
end

----------------------------------------------------------------
mainMenu.onLoad = function ( self )
		
	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( windowViewport )
	mainMenu.layerTable [ 1 ] = { layer }
	
	local font =  MOAIFont.new ()
	font:loadFromTTF ( "arialbd.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?! ", 12, 163 )

  -- Build the textboxes that will hold the data from the game data.
	local textbox = {}
	textbox[1] = MOAITextBox.new ()
	textbox[1]:setFont ( font )
	textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
	textbox[1]:setRect ( 10, 10, 790, 50 )
	layer:insertProp ( textbox[1] )
    
	-- Build the main text box that displays the description of the area
  -- The actual text for the box is loaded from the game data
  textbg = MOAIGfxQuad2D.new()
  textbg:setTexture( "resources/background.png" ) -- Move this to the game data for different backgrounds
  textbg:setRect( 10, 200, 790, 590 )
  bgProp = MOAIProp2D.new()
  bgProp:setDeck (textbg)
  layer:insertProp( bgProp )

	textbox[2] = MOAITextBox.new ()
	textbox[2]:setFont ( font )
  --textbox[2]:setColor ( 0.2,0.2,0.2,1 )
	textbox[2]:setAlignment ( MOAITextBox.LEFT_JUSTIFY )
	textbox[2]:setRect ( 30,220,770, 570 )
	layer:insertProp ( textbox[2] )
  
  -- Make a global refrence to the textbox so we can draw on it
  tb = textbox[2]
    
	local gameData = dofile( "gamedata/gamedata.lua" )	
  
  local scene = gameData.jail
 
  -- Build bounding boxes for key words
 
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
  
	textbox[1]:setString ( scene.locationName )
  
  keywords = {}
  if type (scene.onEntry) == "function" then
      scene:onEntry( context )
  elseif type (scene.onEntry) == "string" then
      local descriptionText = ""
      local i = 1
      for id in scene.onEntry:gmatch("%S+") do
          --print ( id:sub(1,1) )
          if id:sub(1,1) == '$' then
            local var = id:sub(2)
            if scene.items[var] ~= nil then
                keywords[var] = scene.items[var]
            elseif scene.actors[var] ~= nil then  
                keywords[var] = scene.actors[var]              
            end
            
            if ( keywords[var] ~= nil ) then
              keywords[var].bounds = { i, keywords[var].displayName:len() } 
              i = i + keywords[var].displayName:len() + 1   -- Include space             
              descriptionText = descriptionText .. keywords[var].displayName  .. " "
            end
          else
            i = i + id:len() + 1 -- Include space
            descriptionText = descriptionText .. id .. " "
          end
      end
      textbox[2]:setString ( descriptionText )
      
      -- Now get the bounding boxes for each of the keywords
      for i,v in pairs( keywords ) do
        x1, y1, x2, y2 = tb:getStringBounds( unpack(v.bounds) )
        v.boundingBox = { x1, y1, x2, y2-16 }
      end
  end
  
  -- Debug boxes around keywords
  textTest = MOAIScriptDeck.new()
  textTest:setRect( textbox[2]:getRect() )
  textTest:setDrawCallback (drawShapes)
  textTestProp = MOAIProp2D.new ()
  textTestProp:setDeck ( textTest )
  textTestProp:setParent( textbox[2] )
  --layer:insertProp ( textTestProp )
  
  
  invButton = elements.makeButton ( "resources/inventory.png", 64, 64 )
  invButton:setCallback ( function ( self )
		
      print ( "Hit: Inventory" )
		
  end )
  
  invButton.img:setLoc ( 700, 50 )
  layer:insertProp ( invButton.img )
	
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