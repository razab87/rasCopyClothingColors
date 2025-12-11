-- adds the new copy-paste options for clothing color during character customisation; modifies several function of the vanilla file lua/client/ISUI/ISColorPickerHSB.lua
--
--
-- by razab



local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

local NEW_HEIGHT = 0
local COPY_BTN_WIDTH = UI_BORDER_SPACING*2 + getTextManager():MeasureStringX(UIFont.Small, getText("UI_rasCopyColor_Copy"))
local PASTE_BTN_WIDTH = UI_BORDER_SPACING*2 + getTextManager():MeasureStringX(UIFont.Small, getText("UI_rasCopyColor_Paste"))

local PASTE_BTN = nil
local SAVED_COLOR = nil



local function onPasteColor(self)

     if SAVED_COLOR then -- when paste has been clicked, apply the saved color (stored in SAVED_COLOR)
         local h, s, b = ISColorPickerHSB:toHSB(SAVED_COLOR)
         self:setCurrentColor(h, s ,b)
     end
end


local function onCopyColor(self)
    SAVED_COLOR = self.currentColor -- when "copy" has been clicked, save the current color
end


local vanilla_render = ISColorPickerHSB.render
function ISColorPickerHSB:render(...)

    vanilla_render(self, ...)
   
    if PASTE_BTN then
       PASTE_BTN.enable = true
	   PASTE_BTN.tooltip = nil
	   if not SAVED_COLOR then -- if no color has been saved, disable the "Paste" button
	      PASTE_BTN.enable = false
	      PASTE_BTN.tooltip = getText("UI_rasCopyColor_NoColorSaved")
	   end
    end
end


local vanilla_createChildren = ISColorPickerHSB.createChildren
function ISColorPickerHSB:createChildren(...)

    vanilla_createChildren(self, ...)

    local y = nil
    local children = self:getChildren()
	for _,child in pairs(children) do
        if child.Type == "ISButton"  then -- change y position of the "Accept" button and save the y position
             y = child:getY() + UI_BORDER_SPACING + BUTTON_HGT
             child:setY(y) 
             break;
        end 
    end

    if y then -- introduce the "Copy" and "Paste" buttons
       local buttonPaste = ISButton:new(self.width - PASTE_BTN_WIDTH - UI_BORDER_SPACING, y, PASTE_BTN_WIDTH, BUTTON_HGT, getText("UI_rasCopyColor_Paste"), self, onPasteColor)
	   self:addChild(buttonPaste)
       PASTE_BTN = buttonPaste

       local buttonCopy = ISButton:new(self.width - COPY_BTN_WIDTH - UI_BORDER_SPACING - PASTE_BTN_WIDTH - UI_BORDER_SPACING, y, COPY_BTN_WIDTH, BUTTON_HGT, getText("UI_rasCopyColor_Copy"), self, onCopyColor)
	   self:addChild(buttonCopy)       
   end

end



local vanilla_new = ISColorPickerHSB.new
function ISColorPickerHSB:new(x, y, initial, ...)

   local o = vanilla_new(self, x, y, initial, ...) 
   o:setHeight(o:getHeight() + UI_BORDER_SPACING + BUTTON_HGT) -- enlarge the color menu (more space for the new buttons)
   return o   
end


