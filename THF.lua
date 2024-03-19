-- Original: Motenten / Modified: Arislan
-- https://github.com/ArislanShiva/luas/blob/master/Arislan-THF.lua
-- Modified by Xenia of Bahamut
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad8 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    --include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.AttackMode = M{['description']='Attack', 'Capped', 'Uncapped'}
    -- state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 85
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'LowBuff')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    state.WeaponSet = M{['description']='Weapon Set', 'TauretGleti', 'AeneasGleti', 'NaeglingGleti', 'AeneasMalevolence'}
    --later include sets with the Twashtar and Centovente (TP dagger)
    state.WeaponLock = M(false, 'Weapon Lock')
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    --include('Global-Binds.lua') -- OK to remove this line
    --include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @e gs c cycleback WeaponSet')
    send_command('bind @r gs c cycle WeaponSet')
    -- send_command('bind @c gs c toggle CP')
    send_command('bind !` input /ja "Flee" <me>')

    send_command('bind ^numlock input /ja "Assassin\'s Charge" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end

    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad8 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
    send_command('bind ^numpad2 input /ws "Wasp Sting" <t>')
    send_command('bind ^numpad3 input /ws "Gust Slash" <t>')

    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @a')
    -- send_command('unbind @c')
    send_command('unbind @r')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.TreasureHunter = {
        head="Volte Cap",
        hands={ name="Herculean Gloves", augments={'STR+9','Pet: Mag. Acc.+2','"Treasure Hunter"+2','Accuracy+17 Attack+17','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
        legs="Volte Hose",
        waist="Chaac Belt",
        feet="Skulker's Poulaines +2",
        }

    sets.TH = sets.TreasureHunter

    sets.phalanx = {
        head={ name="Herculean Helm", augments={'Mag. Acc.+22','AGI+2','Phalanx +4','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
        body={ name="Taeon Tabard", augments={'Potency of "Cure" effect received+7%','Phalanx +3',}},
        hands={ name="Taeon Gloves", augments={'Potency of "Cure" effect received+7%','Phalanx +3',}},
        legs={ name="Taeon Tights", augments={'Potency of "Cure" effect received+7%','Phalanx +3',}},
        feet={ name="Taeon Boots", augments={'Potency of "Cure" effect received+7%','Phalanx +3',}},
        }

    sets.Phalanx = sets.phalanx

    sets.ProtectShellReceived = {
        ring1="Sheltered Ring",
        }

    sets.buff['Sneak Attack'] = {
        ammo="Yetshila +1",
        head="Adhemar Bonnet +1",
        neck="Assassin's Gorget +2",
        body="Meghanada Cuirie +2",
        hands="Malignance Gloves",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        --waist="Chaac Belt",
        --back=Toutatis.WSD,  ****Fix
        legs="Pillager's Culottes +3",
        feet="Mummu Gamashes +2"
    }

    sets.buff['Trick Attack'] = {
        --ammo="Tengu-no-hane",
        head="Adhemar Bonnet +1",
        neck="Assassin's Gorget +2",
        ear1="Sherida Earring",
        body="Mummu Jacket +2",
        hands="Pillager's Armlets +1",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        --back="Canny Cape",
        waist="Chaac Belt",
        legs="Mummu Kecks +2",
        feet="Mummu Gamashes +2"
    }

    -- Actions we want to use to tag TH.
        sets.precast.Step = {
        head="Adhemar Bonnet +1",
        neck="Assassin's Gorget +2",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        --back=Toutatis.WSD,  ****Fix
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Chaac Belt",
        legs="Pillager's Culottes +3",
        feet="Skulker's Poulaines +2"
    }

    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +3"}
    sets.precast.JA['Aura Steal'] = {head="Plunderer's Bonnet +1"}
    sets.precast.JA['Collaborator'] = set_combine(sets.TreasureHunter, {head="Skulker's Bonnet +3"})
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +3"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = set_combine(sets.TreasureHunter, {body="Skulker's Vest +3"})

    sets.precast.JA['Steal'] = {
        ammo="Barathrum", --3
        --head="Asn. Bonnet +2",
        hands="Pillager's Armlets +1",
        feet="Pillager's Poulaines +3",
        neck="Pentalagus Charm",
        }

    sets.precast.JA['Despoil'] = {ammo="Barathrum", legs="Skulker's Culottes +1", feet="Skulker's Poulaines +2"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +3"}
    sets.precast.JA['Feint'] = {legs="Plunderer's Culottes +3"}
    --sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    --sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    sets.precast.Waltz = {
        ammo="Yamarang",
        head="Mummu Bonnet +2", --rec’d +9
        body="Passion Jacket",
        legs="Dashing Subligar",
        feet="Rawhide Boots",
        ring1="Valseur's Ring",
        ring2="Asklepian Ring", -- rec’d +3
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        --Max 80% Fast Cast ****
        ammo="Sapience Orb", --2
        head={ name="Herculean Helm", augments={'"Cure" potency +10%','"Fast Cast"+6','"Refresh"+1','Accuracy+12 Attack+12','Mag. Acc.+5 "Mag.Atk.Bns."+5',}}, --6
        body="Taeon Tabard", --4, +5 with augments
        hands="Leyline Gloves", --8
        legs={ name="Herculean Trousers", augments={'Mag. Acc.+5','"Fast Cast"+6','"Mag.Atk.Bns."+1',}}, --6
        feet=gear.Herc_MAB_feet, --2
        neck="Orunmila's Torque", --5
        ear1="Loquac. Earring", --2
        ear2="Etiolation Earring", --1
        --ear2="Enchntr. Earring +1", --2
        ring1="Prolix Ring", --2
        ring2="Lebeche Ring", --QM+2
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        ring1="Lebeche Ring",
        })

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        --ammo="Aurgelmir Orb",
        ammo="Seething Bomblet +1",
        head="Nyame Helm",
        body="Nyame Mail",
        --hands="Meg. Gloves +2", --***
        hands="Nyame Gauntlets",
        --legs="Plunderer's Culottes +3",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Regal Ring",
        ring2="Epaminondas's Ring",
        back=gear.THF_WS1_Cape,
        waist="Fotia Belt",
        } -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Voluspa Tathlum",
        ear2="Telos Earring",
        })

    sets.precast.WS.Critical = {
        --for use of SA on a ws
        ammo="Yetshila +1",
        head="Pillager's Bonnet +3",
        body="Gleti's Cuirass", --Is this correct? ***
        }

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        --head="Adhemar Bonnet +1",
        head="Skulker's Bonnet +3",
        body="Adhemar Jacket +1",
        legs="Meg. Chausses +2",
        feet="Malignance Boots",
        ear1="Sherida Earring",
        ear2="Skulker's Earring +2",
        ring2="Ilabrat Ring",
        })

    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
        })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        --Modifier: 50% Dex
        --Benefits more from fTP and Multi-attack
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
        body="Plunderer's Vest +3",
        hands="Adhemar Wristbands +1",
        --legs="Skulker's Culottes +3",
        legs="Gleti's Breeches",
        --feet="Adhemar Gamashes +1",
        feet="Mummu Gamashes +2",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Odr Earring",
        ring1="Regal Ring",
        ring2="Begrudging Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},
        waist="Fotia Belt",
        })

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        ammo="Voluspa Tathlum",
        --legs="Pillager's Culottes +3",
        ring1="Regal Ring",
        })

    sets.precast.WS['Evisceration'].HighBuff = set_combine(sets. precast.WS['Evisceration'], {
        head="Skulker's Bonnet +3",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        --feet="Gleti's Boots",
        ear1="Mache Earring +1",
        ring2="Gere Ring",
        })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        --Modifier: 80% DEX
        --does not benefit as much with fTP and Multi-attack gear
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Skulker's Vest +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Assassin's Gorget +2",
        ear1="Sherida Earring",
        ear2="Odr Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        back=gear.THF_WS1_Cape,
        waist="Kentarch Belt +1",
        })

    sets.precast.WS['Rudra\'s Storm'].HighBuff = set_combine(sets. precast.WS['Rudra\'s Storm'], {
        --ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +3",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        ear1="Moonshade Earring",
        ring2="Epaminondas's Ring",
        })

    sets.precast.WS['Rudra\'s Storm'].Stacked = set_combine(sets. precast.WS['Rudra\'s Storm'], {
        --For Sneak Attack w/ Rudra when attack capped
        ammo="Yetshila +1",
        --head="Pillager’s Bonnet +3",
        head="Nyame Helm",
        hands="Nyame Gauntlets",
        legs="Plunderer's Culottes +3",
        feet="Nyame Sollerets",
        ear1="Moonshade Earring",
        })

    sets.precast.WS['Rudra\'s Storm'].StackedHighBuff = set_combine(sets. precast.WS['Rudra\'s Storm'].Stacked, {
        --For Sneak Attack w/ Rudra when attack capped
        --head="Skulker's Bonnet +3",
        head="Nyame Helm",
        ring2="Epaminondas's Ring",
        })

    sets.precast.WS['Rudra\'s Storm'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'], {
        ammo="Voluspa Tathlum",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]
    sets.precast.WS['Mandalic Stab'].Acc = sets.precast.WS["Rudra's Storm"].Acc

    sets.precast.WS['Cyclone'] = set_combine(sets.TH, {
        })

    --sets.precast.WS['Aeolian Edge'] = set_combine(sets.TH, {
        --})

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        --Modifier: 40% DEX, 40% INT and MAB
        ammo="Ghastly Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        ear1="Hecate's Earring",
        ear2="Friomisi Earring",
        ring1="Dingir Ring",
        ring2="Epaminondas's Ring",
        back="Argocham. Mantle",
        --waist="Orpheus's Sash",
        waist="Eschan Stone",
        })

    --sets.precast.WS[Savage Blade'] = (sets.precast.WS)
        --Modifier: 50% STR, 50% MND
        --*** Needs fixing?



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        legs="Carmine Cuisses +1", --20
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        ring2="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast.Trust = sets.precast.FC


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Jute Boots +1", --movement speed +18 but ilvl
        neck=" Assassin's Gorget +2", --For dyna
        --neck="Bathy Choker +1",
        ear1="Eabani Earring",
        --ear2="Sanare Earring",
        ear2="Infused Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back="Moonlight Cape",
        --waist="Kasiri Belt",
        waist="Engraved Belt",
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Malignance Gloves", --5/5
        --hands="Nyame Gauntlets", --7/7
        legs="Malignance Tights", --7/7
        --legs="Nyame Flanchard", --8/8
        feet="Malignance Boots", --4/4
        neck="Warder's Charm +1",
        ear1="Eabani Earring",
        ear2="Sanare Earring",
        ring1="Purity Ring", --0/4
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Carrier's Sash", --ele resist
        })

   sets.idle.Refresh = set_combine(sets.idle, {
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        })


    sets.idle.Town = set_combine(sets.idle, {
        ammo="Aurgelmir Orb",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        waist="Windbuffet Belt +1",
        })

    sets.idle.Regen = set_combine(sets.idle, {
        head="Meghanada Visor +2",
        body="Meg. Cuirie +2",
        hands="Meg. Gloves +2",
        legs="Meg. Chausses +2",
        feet="Meg. Jam. +2",
        })

    sets.regen = sets.idle.Regen

    sets.idle.Regain = set_combine(sets.idle, {
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        ring1="Karieyh Ring +1",
        })

    sets.regain = sets.idle.Regain

    sets.idle.Weak = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Pillager's Poulaines +3"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo="Aurgelmir Orb",
        --ammo="Yamarang",
        --head="Plunderer's Bonnet +3",
        --head="Adhemar Bonnet +1",
        head="Skulker's Bonnet +3",
        body="Adhemar Jacket +1",
        hands="Adhemar Wristbands +1",
        legs="Gleti's Breeches",
        feet="Plunderer's Poulaines +3",

        --body="Nyame Mail",
        --hands="Nyame Gauntlets",
        --legs="Nyame Flanchard",
        --feet="Nyame Sollerets",

        neck="Assassin's Gorget +2", 
        --ear1="Sherida Earring",
        --ear2="Telos Earring",
        ear1="Dedition Earring",
        ear2="Skulker's Earring +2",
        ring1="Gere Ring",
        ring2="Hetairoi Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        --waist="Windbuffet Belt +1",
        waist="Sailfi Belt +1", ---
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Skulker's Bonnet +3",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ear2="Telos Earring",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ammo="Yamarang",
        body="Pillager's Vest +3",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        ammo="C. Palug Stone",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        --hands="Nyame Gauntlets",
        hands="Gazu Bracelets +1",
        --legs="Pillager's Culottes +3",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        ear2="Mache Earring +1",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        --waist="Olseni Belt",
        waist="Eschan Stone",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        head=gear.Herc_STP_head,
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", -- 6
        --hands=gear.Adhemar_A_hands,
        hands="Adhemar Wristbands +1",
        legs="Gleti's Breeches",
        feet=gear.Taeon_DW_feet, --9
        neck="Assassin's Gorget +2",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Gere Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 41%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        head="Skulker's Bonnet +3",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        ammo="Yamarang",
        body="Pillager's Vest +3",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelets +1",
        legs="Pillager's Culottes +3",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        head=gear.Herc_STP_head,
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
        ammo="Aurgelmir Orb",
        --ammo="Yamarang",
        --head="Adhemar Bonnet +1",
        head="Skulker's Bonnet +3",
        body="Adhemar Jacket +1", -- 6
        --hands=gear.Adhemar_A_hands,
        hands="Adhemar Wristbands +1",
        legs="Gleti's Breeches",
        feet=gear.Taeon_DW_feet, --9
        neck="Assassin's Gorget +2",
        ear1="Cessance Earring",
        ear2="Suppanomimi", --5
        ring1="Gere Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 37%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head="Skulker's Bonnet +3",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        ammo="Yamarang",
        body="Pillager's Vest +3",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelets +1",
        legs="Pillager's Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head=gear.Herc_STP_head,
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        ammo="Aurgelmir Orb",
        --ammo="Yamarang",
        --head="Adhemar Bonnet +1",
        head="Skulker's Bonnet +3",
        body="Pillager's Vest +3",
        --hands=gear.Adhemar_A_hands,
        hands="Adhemar Wristbands +1",
        legs="Gleti's Breeches",
        feet="Plunderer's Poulaines +3",
        neck="Assassin's Gorget +2",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Gere Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 26%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Skulker's Bonnet +3",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        ammo="Yamarang",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelets +1",
        legs="Pillager's Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head=gear.Herc_STP_head,
        body="Tu. Harness +1",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        ammo="Aurgelmir Orb",
        --ammo="Yamarang",
        head="Adhemar Bonnet +1",
        body="Pillager's Vest +3",
        --hands=gear.Adhemar_A_hands,
        hands="Adhemar Wristbands +1",
        legs="Gleti's Breeches",
        feet="Plunderer's Poulaines +3",
        neck="Assassin's Gorget +2",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Gere Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 22%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Skulker's Bonnet +3",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        ammo="Yamarang",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelets +1",
        legs="Pillager's Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head=gear.Herc_STP_head,
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Pillager's Vest +3",
        --hands=gear.Adhemar_A_hands,
        hands="Adhemar Wristbands +1",
        legs="Gleti's Breeches",
        feet="Plunderer's Poulaines +3",
        neck="Assassin's Gorget +2",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Gere Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        waist="Windbuffet Belt +1",
        } -- 5%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Skulker's Bonnet +3",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        ammo="Yamarang",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelets +1",
        legs="Pillager's Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head=gear.Herc_STP_head,
        body="Tu. Harness +1",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Kentarch Belt +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Malignance Gloves", --5/5
        legs="Malignance Tights", --7/7
        feet="Malignance Boots", --4/4
        ring2="Defending Ring", --10/10
        }



    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    --sets.Reive = {neck="Ygnas's Resolve +1"}
    -- sets.CP = {back="Mecisto. Mantle"}

    sets.TauretGleti = {main="Tauret", sub="Gleti's Knife"}
    sets.AeneasGleti = {main="Aeneas", sub="Gleti's Knife"}
    sets.NaeglingGleti = {main="Naegling", sub="Gleti's Knife"}
    sets.AeneasMalevolencee = {main="Aeneas", sub="Malevolence"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
    if spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Aeolian Edge' then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    check_weaponset()
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end

--function job_update(cmdParams, eventArgs)
    --handle_equipping_gear(player.status)
    --th_update(cmdParams, eventArgs)
--end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    --if state.Buff['Sneak Attack'] then
    --    wsmode = 'SA'
    --end
    --if state.Buff['Trick Attack'] then
    --    wsmode = (wsmode or '') .. 'TA'
    --end

    return wsmode
end

function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    --if state.TreasureMode.value == 'Fulltime' then
        --meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    --end

    return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
        end
    end
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

function check_weaponset()
    equip(sets[state.WeaponSet.current])
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'WAR' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 1)
    else
        set_macro_page(1, 1)
    end
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 6)
end

