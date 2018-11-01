OriginalWeapons = {
    ["weapon_ttt_glock"] = { false, "" }, --does cw have a good auto-pistol?
    ["weapon_ttt_m16"] = { false, "cw_ar15" },
    --["weapon_ttt_smokegrenade"] = { false, "" }, --Grenade base is different from regular wep base - requires more work
    ["weapon_ttt_stungun"] = { false, "cw_ump45" },
    ["weapon_ttt_mac10"] = { false, "cw_mp5" },
    ["weapon_ttt_pistol"] = { false, "cw_m1911" },
    ["weapon_ttt_revolver"] = { false, "cw_deagle" },
    ["weapon_ttt_rifle"] = { false, "cw_l115" },
    ["weapon_ttt_shotgun"] = { false, "" }, --m3 super 90
    ["weapon_ttt_sledge"] = { false, "" } --m249
}

--Left side are the TTT values, right side are the CW2.0 equivalents
ImportantValues = {
    ["PrintName"] = "PrintName",
    ["Slot"] = "Slot",
    ["Icon"] = "", --Needs transfer, not copy
    ["Kind"] = "", --Needs transfer, not copy
    ["WeaponID"] = "", --Needs transfer, not copy
    ["Delay"] = "FireDelay",
    ["Recoil"] = "Recoil",
    ["Damage"] = "Damage",
    ["Cone"] = "Hipspread", --May also need to copy to Aimspread as well
    ["ClipSize"] = "Primary.ClipSize",
    ["ClipMax"] = "", --Needs transfer, not copy
    ["DefaultClip"] = "Primary.DefaultClip",
    ["AmmoEnt"] = "", --Needs transfer, not copy
    ["HeadshotMultiplier"] = "", --MAY need transfer/copy, CW2.0 includes no function of its own
    ["NumShots"] = "Shots" --For shotguns
}
--In this addon, we're replacing the TTT weapon data with weapons.GetStored for the weapons in the CW2.0 weapon pack
--My thinking: want to be able to load either: default CW2.0 weapon stats, or modified weapon stats that mirror the TTT weapons
--However, in some scenarios, players may have removed or modified the default TTT weapons, so include checks JIC
--Will have to include a modified CW2.0 base into this addon, and run valid-checks on it
hook.Add( "PostGamemodeLoaded", "CW20inTTT", function()
    if GAMEMODE != "terrotown" then return end

    function weapons.OnLoaded()
        --First, we're going to load the CW2.0 base up with the necessary functions from the TTT weapon base
        local cwwepbase = weapons.GetStored( "cw_base" )
        local tttwepbase = weapons.GetStored( "weapon_tttbase" )
        --To do: copy the necessary functions over
            --What functions? I think drop, ammo, dna, holster, and client info?

        --Next, check which base TTT weapons are still relatively unmodified (or extracting values might throw errors)
        for k, v in pairs( OriginalWeapons ) do
            if file.Exists( "gamemode/terrortown/entites/" .. k .. ".lua", "GAME" ) then --Check if someone's deleted the weapon file
                if weapons.Get( k ).Base == "weapon_tttbase" then --Check if someone's already modified the weapons beyond comprehension
                    v[1] = true
                end
            end
        end



        --Temporary Solution
        for k, v in pairs( OriginalWeapons ) do
            if v[1] == true then
                weapons.GetStored( k ) = weapons.GetStored( v[2] )
            end
        end
    end
end )

--[[
    Notes to self:
    - We're replacing the TTT weapon information with the respective (set so in the above table) CW2.0 weapon
    information
        - This means the CW2.0 weapon base will require a few functions from the TTT base
            - This can be added by the script first thing - will probably do this
            - Or we can include a custom CW2.0 weapon base in with the script
        - We want players to be able to choose between using the current weapon values (damage/recoil/etc.) from the
        TTT weapons, be able to run their own values for the CW2.0 stats, or use the default CW2.0 values
            - Since we're just extracting the weapon data tables form the CW2.0 weapons themselves
]]