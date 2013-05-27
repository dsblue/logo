SCREEN_WIDTH 	= 800
SCREEN_HEIGHT	= 600
SCREEN_UNITS_X	= SCREEN_WIDTH
SCREEN_UNITS_Y	= SCREEN_HEIGHT

require "elements"
require "modules/state-manager"	
require "modules/input-manager"	

-- DEBUG MODE
DEBUG = false

if(DEBUG) then
  MOAIDebugLines.setStyle ( MOAIDebugLines.PARTITION_CELLS, 2, 0, 0, 1, 1 )
  MOAIDebugLines.setStyle ( MOAIDebugLines.PARTITION_PADDED_CELLS, 1, 0, 1, 0, 1 )
  MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 1, 0, 0, 1 )
  MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 0, 1 )
  MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 2, 1, 0, 1, 1 )
  --MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 2, 1, 1, 0, 1 )
  --MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 2, 1, 1, 0, 1 )
  --MOAIDebugLines.setStyle ( MOAIDebugLines.TOTAL_STYLES, 2, 1, 1, 0, 1 )
end

MOAISim.openWindow ( "Logo", SCREEN_WIDTH, SCREEN_HEIGHT )

viewport = MOAIViewport.new ()
viewport:setSize ( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )
viewport:setScale ( SCREEN_UNITS_X, SCREEN_UNITS_Y )

-- Create a viewport that uses window coordinates, 0,0 in upper left corner
windowViewport = MOAIViewport.new ()
windowViewport:setSize ( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )
windowViewport:setScale ( SCREEN_UNITS_X, -SCREEN_UNITS_Y )
windowViewport:setOffset ( -1, 1 )

--MOAISim.enterFullscreenMode()

-- seed random numbers
math.randomseed ( os.time ())

--statemgr.push ( "states/state-splash.lua" )	
--statemgr.push ( "states/state-test-scene.lua" )	
statemgr.push ( "states/state-load-scene.lua" )	

-- Start the game!
statemgr.begin ()

