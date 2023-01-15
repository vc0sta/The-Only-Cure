function GetBodyParts()
    local bodyparts = { "RightHand", "RightForearm", "RightArm", "LeftHand", "LeftForearm", "LeftArm"}
    return bodyparts
end

function GetLimbsBodyPartTypes()

    return {BodyPartType.Hand_R, BodyPartType.ForeArm_R, BodyPartType.UpperArm_R,
            BodyPartType.Hand_L, BodyPartType.ForeArm_L, BodyPartType.UpperArm_L}

end

function GetOtherBodyPartTypes()

    return {BodyPartType.Torso_Upper, BodyPartType.Torso_Lower, BodyPartType.Head, BodyPartType.Neck, 
            BodyPartType.Groin, BodyPartType.UpperLeg_L, BodyPartType.UpperLeg_R, BodyPartType.LowerLeg_L, 
            BodyPartType.LowerLeg_R, BodyPartType.Foot_L, BodyPartType.Foot_R, BodyPartType.Back}

end


function GetAcceptingProsthesisBodyParts()


    return {BodyPartType.Hand_R, BodyPartType.ForeArm_R,
            BodyPartType.Hand_L, BodyPartType.ForeArm_L}


end



local function PartNameToBodyLocation(name)
    if name == "RightHand"      then return "ArmRight_Prot" end
    if name == "RightForearm"   then return "ArmRight_Prot" end
    if name == "RightArm"       then return "ArmRight_Prot" end
    if name == "LeftHand"       then return "ArmLeft_Prot" end
    if name == "LeftForearm"    then return "ArmLeft_Prot" end
    if name == "LeftArm"        then return "ArmLeft_Prot" end
end


-- TODO find a better name, this doesnt check for amputation only for prosthetics
function FindTocItemWorn(part_name, patient)
    local worn_items = patient:getWornItems()

    for i=1,worn_items:size()-1 do -- Maybe wornItems:size()-1
        local item = worn_items:get(i):getItem();
        if item:getBodyLocation() == PartNameToBodyLocation(part_name) then
            return item;
        end
    end

end












-- TODO ew
function find_clothName_TOC(bodyPart)
    if bodyPart:getType()       == BodyPartType.Hand_R      then return "TOC.ArmRight_noHand"
    elseif bodyPart:getType()   == BodyPartType.ForeArm_R   then return "TOC.ArmRight_noForearm"
    elseif bodyPart:getType()   == BodyPartType.UpperArm_R  then return "TOC.ArmRight_noArm"
    elseif bodyPart:getType()   == BodyPartType.Hand_L      then return "TOC.ArmLeft_noHand"
    elseif bodyPart:getType()   == BodyPartType.ForeArm_L   then return "TOC.ArmLeft_noForearm"
    elseif bodyPart:getType()   == BodyPartType.UpperArm_L  then return "TOC.ArmLeft_noArm"
    else return nil
    end
end

function TocGetDisplayText(part_name)
    if part_name == "RightHand"      then return getText("UI_ContextMenu_RightHand") end
    if part_name == "RightForearm"   then return getText("UI_ContextMenu_RightForearm") end
    if part_name == "RightArm"       then return getText("UI_ContextMenu_RightArm") end
    if part_name == "LeftHand"       then return getText("UI_ContextMenu_LeftHand") end
    if part_name == "LeftForearm"    then return getText("UI_ContextMenu_LeftForearm") end
    if part_name == "LeftArm"        then return getText("UI_ContextMenu_LeftArm") end
end


function TocGetBodyPartTypeFromBodyPart(part_name)
    if part_name == "RightHand"      then return BodyPartType.Hand_R end
    if part_name == "RightForearm"   then return BodyPartType.ForeArm_R end
    if part_name == "RightArm"       then return BodyPartType.UpperArm_R end
    if part_name == "LeftHand"       then return BodyPartType.Hand_L end
    if part_name == "LeftForearm"    then return BodyPartType.ForeArm_L end
    if part_name == "LeftArm"        then return BodyPartType.UpperArm_L end
end


function TocFindAmputatedClothingFromPartName(part_name)
    if part_name == "RightHand"      then return "TOC.ArmRight_noHand" end
    if part_name == "RightForearm"   then return "TOC.ArmRight_noForearm" end
    if part_name == "RightArm"       then return "TOC.ArmRight_noArm" end
    if part_name == "LeftHand"       then return "TOC.ArmLeft_noHand" end
    if part_name == "LeftForearm"    then return "TOC.ArmLeft_noForearm" end
    if part_name == "LeftArm"        then return "TOC.ArmLeft_noArm" end

end


function find_protheseID_TOC(item)
    local itemType = item:getType()
    if     string.find(itemType, "WoodenHook")  then return 1
    elseif string.find(itemType, "MetalHook")   then return 2
    elseif string.find(itemType, "MetalHand")   then return 3
    else return 0
    end
end

function find_protheseFact_TOC(item)
    local itemType = item:getType()
    if     string.find(itemType, "WoodenHook") and string.find(itemType, "noHand")    then return 1.5
    elseif string.find(itemType, "WoodenHook") and string.find(itemType, "noForearm") then return 1.65
    elseif string.find(itemType, "MetalHook")  and string.find(itemType, "noHand")    then return 1.3
    elseif string.find(itemType, "MetalHook")  and string.find(itemType, "noForearm") then return 1.45
    elseif string.find(itemType, "MetalHand")  and string.find(itemType, "noHand")    then return 1.1
    elseif string.find(itemType, "MetalHand")  and string.find(itemType, "noForearm") then return 1.25
    end
end