function TocCheckCompatibilityWithOlderVersions(mod_data)
    -- Gets the old status and turns it into the new.

    if mod_data.TOC.Limbs == nil then
        print("TOC: Limbs is nil, setting new mod_data")
        TocMapOldDataToNew(mod_data)
    end

    if mod_data.TOC.Limbs.Right_Hand.is_cut == nil then
        print("TOC: Something was wrongly initiliazed before. Resetting parameters")
        TocResetEverything()
    else
        print("TOC: Found compatible data, correcting models in case of errors")

        -- TODO check if models are correctly applied
        local player = getPlayer()
        local player_inv = player:getInventory()

        for _, side in ipairs(TOC_sides) do
            for _, limb in ipairs(TOC_limbs) do
                local part_name = side .. "_" .. limb

                if mod_data.TOC.Limbs[part_name].is_cut and mod_data.TOC.Limbs[part_name].is_amputation_shown then
                    local amputated_clothing_name = "TOC.Amputation_" .. part_name
                    if player_inv:FindAndReturn(amputated_clothing_name) == nil then
                        local amputation_clothing_item = player:getInventory():AddItem(TocFindAmputatedClothingFromPartName(part_name))
                        TocSetCorrectTextureForAmputation(amputation_clothing_item, player)
                        player:setWornItem(amputation_clothing_item:getBodyLocation(), amputation_clothing_item)


                    end

                end




            end
        end

        TocReapplyBodyLocation()



    end

end



---@param compat_og_mod boolean Changes how data is arranged since backup_old_data contains data from TOC Beta
local function TocSetModDataParams(mod_data, backup_old_data, new_names_table, old_names_table, compat_og_mod)



    if compat_og_mod == nil then
        print("TOC: Couldn't find any compatible data that could be retrieved")
        return  -- SOmething was wrong here, so return and do nothing
    end


    -- Key setup
    local is_cut_old_key = nil
    local is_infected_old_key = nil
    local is_operated_old_key = nil
    local is_cicatrized_old_key = nil
    local is_cauterized_old_key = nil
    local is_amputation_shown_old_key = nil
    local cicatrization_time_old_key = nil
    local is_other_bodypart_infected_old_key = nil

    if compat_og_mod then
        is_cut_old_key = "IsCut"
        is_infected_old_key = "IsInfected"
        is_operated_old_key = "IsOperated"
        is_cicatrized_old_key = "IsCicatrized"
        is_cauterized_old_key = "ISBurn"
        is_amputation_shown_old_key = "ToDisplay"
        cicatrization_time_old_key = "CicaTimeLeft"
        is_other_bodypart_infected_old_key = "OtherBody_IsInfected"
    else
        is_cut_old_key = "is_cut"
        is_infected_old_key = "is_infected"
        is_operated_old_key = "IsOperated"
        is_cicatrized_old_key = "is_cicatrized"
        is_cauterized_old_key = "is_cauterized"
        is_amputation_shown_old_key = "is_amputation_shown"
        cicatrization_time_old_key = "cicatrization_time"
        is_other_bodypart_infected_old_key = "is_other_bodypart_infected"
        
    end




    mod_data.TOC.is_other_bodypart_infected = backup_old_data[is_other_bodypart_infected_old_key]

    for i = 1, #new_names_table do

        local old_name = old_names_table[i]
        local new_name = new_names_table[i]
        print("TOC: is_cut: " .. old_name .. " " .. tostring(backup_old_data[old_name][is_cut_old_key]))
        print("TOC: is_operated: " .. old_name .. " " .. tostring(backup_old_data[old_name][is_operated_old_key]))
        print("TOC: is_cicatrized: " .. old_name .. " " .. tostring(backup_old_data[old_name][is_cicatrized_old_key]))
        print("TOC: is_amputation_shown: " .. old_name .. " " .. tostring(backup_old_data[old_name][is_amputation_shown_old_key]))
        print("TOC: cicatrization_time: " .. old_name .. " " .. tostring(backup_old_data[old_name][cicatrization_time_old_key]))

        
        mod_data.TOC.Limbs[new_name].is_cut = backup_old_data[old_name][is_cut_old_key]

        if mod_data.TOC.Limbs[new_name].is_cut then
            print("TOC: Found old cut limb, reapplying model")
            local cloth = getPlayer():getInventory():AddItem(TocFindAmputatedClothingFromPartName(new_name))
            getPlayer():setWornItem(cloth:getBodyLocation(), cloth)
        end


        mod_data.TOC.Limbs[new_name].is_infected = backup_old_data[old_name][is_infected_old_key]
        mod_data.TOC.Limbs[new_name].is_operated = backup_old_data[old_name][is_operated_old_key]
        mod_data.TOC.Limbs[new_name].is_cicatrized = backup_old_data[old_name][is_cicatrized_old_key]
        mod_data.TOC.Limbs[new_name].is_cauterized = backup_old_data[old_name][is_cauterized_old_key]
        mod_data.TOC.Limbs[new_name].is_amputation_shown = backup_old_data[old_name][is_amputation_shown_old_key]
        mod_data.TOC.Limbs[new_name].cicatrization_time = backup_old_data[old_name][cicatrization_time_old_key]
    end

end



function TocMapOldDataToNew(mod_data)

    local old_names_table = { "RightHand", "RightForearm", "RightArm", "LeftHand", "LeftForearm", "LeftArm" }
    local new_names_table = { "Right_Hand", "Right_LowerArm", "Right_UpperArm", "Left_Hand", "Left_LowerArm", "Left_UpperArm" }

    print("TOC: Trying to backup old data")
    local backup_old_data = mod_data.TOC

    TocResetEverything()

    -- Another check just in case the user is using Mr Bounty og version. I really don't wanna map that out so let's just reset everything directly

    local og_mod_check = nil
    -- Player has the og version of the mod
    if backup_old_data.RightHand.IsCut ~= nil then
        print("TOC: Found TOC Beta data")
        og_mod_check = true
    elseif backup_old_data.RightHand.is_cut ~= nil then
        print("TOC: Found TOCBB data")
        og_mod_check = false
    end


    TocSetModDataParams(mod_data, backup_old_data, new_names_table, old_names_table, og_mod_check)




end


------------------------------------------------------------------------------------------

-- Modified functions for compat reason, used only in one instance
--------------------
local function TocPartNameToOldBodyLocationProsthesis(name)
    if name == "Right_Hand" then return "ArmRight_Prot" end
    if name == "Right_LowerArm" then return "ArmRight_Prot" end
    if name == "Right_UpperArm" then return "ArmRight_Prot" end
    if name == "Left_Hand" then return "ArmLeft_Prot" end
    if name == "Left_LowerArm" then return "ArmLeft_Prot" end
    if name == "Left_UpperArm" then return "ArmLeft_Prot" end
end

local function TocPartNameToOldBodyLocationAmputation(name)
    if name == "Right_Hand" then return "ArmRight" end
    if name == "Right_LowerArm" then return "ArmRight" end
    if name == "Right_UpperArm" then return "ArmRight" end
    if name == "Left_Hand" then return "ArmLeft" end
    if name == "Left_LowerArm" then return "ArmLeft" end
    if name == "Left_UpperArm" then return "ArmLeft" end
end



function TocFindAmputationInInventory(player, side, limb)
    local player_inventory = player:getInventory()
    local item_name = "TOC.Amputation_" .. side .. "_" .. limb
    local found_item = player_inventory:FindAndReturn(item_name)
    if found_item then
        return found_item:getFullType()

    end

end

function TocFindEquippedProsthesisInInventory(player, side, limb)
    local player_inventory = player:getInventory()
    for _, prost in ipairs(GetProsthesisList()) do
        local item_name = "TOC.Prost_" .. side .. "_" .. limb .. "_" .. prost
        local found_item = player_inventory:FindAndReturn(item_name)

        if found_item then
            return found_item:getFullType()

        end

    end

end


function TocOldFindAmputationOrProsthesisName(part_name, player, choice)

    local player_inventory = player:getInventory()
    
    for _, side in ipairs(TOC_sides) do
        for _, limb in ipairs(TOC_limbs) do
            local item_name
            local found_item
            if choice == "Amputation" then
                item_name = "TOC.Amputation_" .. side .. "_" .. limb
            end

            if choice == "Prosthesis" then
                item_name = "TOC.Prost" .. side .. "_" .. limb .. "_MetalHook"      -- TODO finish this

                
            end
            

            found_item = player_inventory:FindAndReturn(item_name)

            if found_item then
                return found_item:getFullType()

            end
 

        end
    end


end