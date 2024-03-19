-- Original: Motenten / Modified: Arislan
-- Modified by Yoana of Bahamut. Received March 2022
-- Modified by Xenia of Bahamut


-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--              [ WIN+H ]           Cycle Helix Mode
--              [ WIN+R ]           Cycle Regen Mode
--              [ WIN+O ]           Cycle VR Ring Mode
--              [ WIN+P ]           Cycle Phalanx Mode
--              [ WIN+S ]           Toggle Storm Surge
--
--  Abilities:  [ CTRL+` ]          Immanence
--              [ CTRL+- ]          Light Arts/Addendum: White
--              [ CTRL+= ]          Dark Arts/Addendum: Black
--              [ CTRL+[ ]          Rapture/Ebullience
--              [ CTRL+] ]          Altruism/Focalization
--              [ CTRL+; ]          Celerity/Alacrity
--              [ ALT+[ ]           Accesion/Manifestation
--              [ ALT+] ]           Perpetuance
--              [ ALT+; ]           Penury/Parsimony
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad0 ]    Myrkr
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                    Dark Arts
--                                          ----------                  ---------
--                gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar power          Rapture                     Ebullience
--              gs c scholar duration       Perpetuance
--              gs c scholar accuracy       Altruism                    Focalization
--              gs c scholar enmity         Tranquility                 Equanimity
--              gs c scholar skillchain                                 Immanence
--              gs c scholar addendum       Addendum: White             Addendum: Black


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
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    state.HelixMode = M{['description']='Helix Mode', 'Potency', 'Duration'}
    state.RegenMode = M{['description']='Regen Mode', 'Duration', 'Potency'}
    state.PhalanxMode = M{['description']='Phalanx Mode', 'Duration', 'Potency'}


    -- state.CP = M(false, "Capacity Points Mode")

    update_active_strategems()

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Endorsement Ring"}
    degrade_array = {
        ['Aspirs'] = {'Aspir','Aspir II'}
        }

    lockstyleset = 92

end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT', 'Vagary')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.StormSurge = M(false, 'Stormsurge')
    state.VRRing = M(false, 'VRRing')


    -- Additional local binds
    --include('Global-Binds.lua') -- OK to remove this line
    --include('Global-GEO-Binds.lua') -- OK to remove this line

    --loads Partybuffs lua for seeing party buffs
    send_command('lua l partybuffs')
    send_command('lua l dparty')

	send_command('bind !o gi ugs false; input /equip ring2 "Warp Ring"; input /echo Warping; wait 10; input /item "Warp Ring" <me>;')
	--send_command('bind !p gi ugs false; input /equip ring2 "Dim. Ring (Holla)"; input /echo Warping Reisj; wait 10; input /item "Dim. Ring (Holla)" <me>;')


	
	--send_command('lua l gearinfo')

    send_command('bind ^` input /ja Immanence <me>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^- gs c scholar light')
    send_command('bind ^= gs c scholar dark')
    send_command('bind ^[ gs c scholar power')
    send_command('bind ^] gs c scholar accuracy')
    send_command('bind ^; gs c scholar speed')
    send_command('bind !w input /ma "Aspir II" <t>')
    send_command('bind !o input /ma "Regen V" <stpc>')
    send_command('bind ![ gs c scholar aoe')
    send_command('bind !] gs c scholar duration')
    send_command('bind !; gs c scholar cost')
    -- send_command('bind @c gs c toggle CP')
    send_command('bind @h gs c cycle HelixMode')
    send_command('bind @r gs c cycle RegenMode')
    send_command('bind @o gs c toggle VRRing')
    send_command('bind @p gs c cycle PhalanxMode')
    send_command('bind @s gs c toggle StormSurge')
    send_command('bind @w gs c toggle WeaponLock')

    send_command('bind ^numpad0 input /Myrkr')

    --include('Global-Binds.lua')

	select_default_macro_book(9, 1)
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ^;')
    send_command('unbind !w')
    send_command('unbind !o')
    send_command('unbind ![')
    send_command('unbind !]')
    send_command('unbind !;')
    send_command('unbind ^,')
    send_command('unbind !.')
    -- send_command('unbind @c')
    send_command('unbind @h')
    send_command('unbind @g')
    send_command('unbind @s')
    send_command('unbind @w')
    send_command('unbind ^numpad0')

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

    --send_command('lua u gearinfo')
    send_command('lua u partybuffs')
    send_command('lua u dparty')
end

-- Define sets and vars used by this job file.
function init_gear_sets()


    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	Gada_EnhDur = { name="Gada", augments={'Enh. Mag. eff. dur. +6','Mag. Acc.+14',}}
	Grioavolr_FC = { name="Grioavolr", augments={'"Fast Cast"+7','INT+6','Mag. Acc.+10','"Mag.Atk.Bns."+6','Magic Damage +1',}}
	
    Chironic_LegsMNDMacc = { name="Chironic Hose", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','"Resist Silence"+5','MND+15','Mag. Acc.+14','"Mag.Atk.Bns."+13',}}
	
    --Telchine_HeadEnhDur = { name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
    --Telchine_BodyEnhDur = { name="Telchine Chas.", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
    --Telchine_HandsEnhDur = { name="Telchine Gloves", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
    --Telchine_LegsEnhDur = { name="Telchine Braconi", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
    --Telchine_FeetEnhDur = { name="Telchine Pigaches", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
	
	Vanya_HeadFC = { name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}}
	
	Vanya_HeadConserveMP = { name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}}
	Vanya_LegsConserveMP = { name="Vanya Slops", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}}
	
	VanyaHood_curepotency = { name="Vanya Hood", augments={'MP+50','"Cure" potency +7%','Enmity-6',}}
	VanyaClogs_curepotency = { name="Vanya Clogs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}}

	Vanya_HeadMagicSkill = { name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}
    Vanya_BodyMagicSkill = { name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}
    Vanya_HandsMagicSkill = { name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}
    Vanya_LegsMagicSkill = { name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}
    Vanya_FeetMagicSkill = { name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}
	
	--Lughs_MNDIdle = { name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Mag. Evasion+15',}}
	--Lughs_INTMAB = { name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Mag. Evasion+15',}}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Tabula Rasa'] = {legs="Pedagogy Pants +3"}
    sets.precast.JA['Enlightenment'] = {body="Pedagogy Gown +3"}
    sets.precast.JA['Sublimation'] = {
        main="Siriti",
        --head="Academic's Mortarboard +3",
        body="Pedagogy Gown +3",
        ear1="Savant's Earring",
        waist="Embla Sash",
        }



    -- Fast cast sets for spells
    sets.precast.FC = {
        --Max 80%
        --Total: 76 + 15 if /RDM
        main="Musa", --10
        sub="Enki Strap",
        ammo="Sapience Orb", --2
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+12',}}, --14
        body="Zendik Robe", --13
        hands="Agwu's Gages", --6
        legs="Psycloth Lappas", --7
        feet="Pedagogy Loafers +3", --8
        neck="Orunmila's Torque", --5
        ear1="Malignance Earring", --4
        ear2="Loquacious Earring", --2
        ring1="Lebeche Ring", --4
        ring2="Kishar Ring", --4
        back={ name="Lugh's Cape", augments={'Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Mag. Evasion+15',}},--***will update after another aug
        --waist="Witful Belt", --3, QM+3
        waist="Embla Sash", --5
        }

    sets.precast.FC.Grimoire = {
        head="Pedagogy Mortarboard +3", --13
        feet="Acad. Loafers +3", --12
        }
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        hands="Vanya Cuffs", --7
        ear2="Mendicant's Earring", --5
        ring1="Lebeche Ring", --QM+2
        back="Perimede Cape", --QM+4
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
    sets.precast.Storm = set_combine(sets.precast.FC)


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        --***Setup ws later
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Epaminondas's Ring",
        ring2="Karieyh Ring +1",
        waist="Fotia Belt",
        }

    sets.precast.WS['Omniscience'] = set_combine(sets.precast.WS, {
        --***Setup ws later
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        body="Pedagogy Gown +3",
        legs="Pedagogy Pants +3",
        feet="Merlinic Crackows",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring2="Archon Ring",
        --back=Lughs_INTMAB,
        waist="Sacro Cord",
        })

    sets. precast.WS['Shattersoul'] = set_combine(sets.precast.WS, {
        ammo="Ghastly Tathlum +1",
        neck="Argute Stole +2",
        ear1="Halasz Earring",
        ear2="Etiolation Earring",
        ring1="Mephitas's Ring +1",
        ring2="Metamorph Ring +1",
        back="Fi Follet Cape +1",
        waist="Shinjutsu-no-Obi +1",
        })


    sets.precast.WS['Myrkr'] = {
        -- Aim for Max MP
        ammo="Psilomene",
        head="Pedagogy Mortarboard +3",
        body="Academic's Gown +3",
        hands="Nyame Gauntlets",
        legs="Amalric Slops +1",
        feet="Arbatel Loafers +3",
        neck="Sanctity Necklace",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Fotia Belt",
        }

    sets.precast.WS['Aeolian Edge'] = {
        ammo="Ghastly Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Argute Stole +2",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        waist="Fotia Belt",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}}, --***Replace with 30 INT, 20 MACC/MDMG, 10% WSD,
        }



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        ring2="Evanescence Ring", --5
        waist="Rumination Sash", --10
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}},
        }

    sets.midcast.Cure = {
        --Aim for Cure Potency, Healing Skill, MND
        --1 Healing Skill = 2 MND = 4 VIT
        --Cure Potency cap for equipment = 50
        --*** DT set for Ongo
        main="Chatoyant Staff",
        sub="Khonsu",
        ammo="Staunch Tathlum +1",
        --head="Kaykaus Mitra +1",
        head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}}, --Cure Pot +10
        body="Arbatel Gown +3",
        hands="Nyame Gauntlets",
        legs="Academic's Pants +3",
        feet="Kaykaus Boots +1", --11(+2)/(-12)
        neck="Loricate Torque +1",
        --ear1="Beatific Earring",
        ear1="Mendicant's Earring",
        ear2="Calamitous Earring",
        ring1="Defending Ring",
        ring2="Mephitas's Ring +1", --R15 gives Conserve MP+15
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}},
        waist="Shinjutsu-no-Obi +1",
        }

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main="Chatoyant Staff",
        sub="Khonsu",
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        })

    sets.midcast.StatusRemoval = {
        main="Gada",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        ammo="Hydrocera",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        --body="Vanya Robe",
        body="Pedagogy Gown +3",
        --hands="Pedagogy Bracers +3",
        hands={ name="Telchine Gloves", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        legs="Academic's Pants +3",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        ear1="Mendicant's Earring",
        ear2="Meili Earring",
        ring1="Mephitas's Ring +1",
        ring2="Menelaus's Ring",
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}},
        waist="Bishop's Sash",
        }

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        main="Gada",
        sub="Ammurapi Shield",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        body="Pedagogy Gown +3",
        --hands="Hieros Mittens",
        hands="Vanya Cuffs",
        legs="Academic's Pants +3",
        feet="Gende. Galosh. +1",
        feet="Vanya Clogs",
        --neck="Debilis Medallion",
        neck="Incanter's Torque",
        ear1="Mendicant's Earring",
        ear2="Meili Earring",
        --ring1="Haoma's Ring",
        ring1="Mephitas's Ring +1",
        ring2="Menelaus's Ring",
        --back="Fi Follet Cape +1",
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}},
        waist="Bishop's Sash",
        })

    sets.midcast.Raise = sets.midcast.FastRecast
    sets.midcast.Erase = sets.midcast.FastRecast

    sets.midcast['Enhancing Magic'] = {
        --Need only 500 skill
        --@99 w/ Light Arts = 404
        --Mastered w/ Light Arts = 444
        main="Gada", --18
        sub="Ammurapi Shield",
        ammo="Savant's Treatise", --4
        head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        body="Pedagogy Gown +3", --17
        hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+22','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},        neck="Incanter's Torque", --10
        ear1="Mimir Earring", --10
        ear2="Andoaa Earring", --5
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"}, --8
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"}, --8
        back="Fi Follet Cape +1", --9
        waist="Olympus Sash", --5
        }

    sets.midcast.EnhancingDuration = {
        ammo="Staunch Tathlum +1", ---***for ongo
        main="Musa",
        sub="Enki Strap",
        head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        body="Pedagogy Gown +3",
        hands="Arbatel Bracers +3",
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+22','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        --neck="Incanter's Torque",
        neck="Loricate Torque +1", ---***for ongo
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        --ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring1="Defending Ring", ---***for ongo
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back="Fi Follet Cape +1",
        waist="Embla Sash",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        --Max: 175/tic, 189/tic w/ Tabula Rasa
        main="Musa",
        sub="Giuoco Grip",
        head="Arbatel Bonnet +3",
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        hands="Arbatel Bracers +3",
        neck="Reti Pendant", --conserve MP
        ear2="Calamitous Earring", --conserve MP
        back="Bookworm's Cape",
         })

    sets.midcast.RegenDuration = set_combine(sets.midcast.EnhancingDuration, {
        --Max: 175/tic, 189/tic w/ Tabula Rasa
        ammo="Pemphredo Tathlum",
        main="Musa",
        sub="Giuoco Grip", --Conserve MP+4
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        neck="Reti Pendant", --conserve MP
        ear2="Calamitous Earring", --conserve MP
        ring1="Mephitas's Ring +1", --R15 gives Conserve MP+15
        back={ name="Lugh's Cape", augments={'Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Mag. Evasion+15',}},--***will update after another aug
        })

    sets.midcast.RegenPotency = set_combine(sets.midcast.EnhancingDuration, {
        --Max: 175/tic, 189/tic w/ Tabula Rasa
        ammo="Pemphredo Tathlum",
        main="Musa",
        sub="Giuoco Grip", --Conserve MP+4
        head="Arbatel Bonnet +3",
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        hands={ name="Telchine Gloves", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        legs={ name="Telchine Braconi", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        neck="Reti Pendant", --conserve MP
        ear2="Calamitous Earring", --conserve MP
        ring1="Mephitas's Ring +1", --R15 gives Conserve MP+15
        back="Bookworm's Cape",
        })

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
        --Only need 500 Enhancing skill
        head="Befouled Crown",
        legs="Shedir Seraweels",
        })

    sets.midcast.Haste = sets.midcast.EnhancingDuration

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1",
        back="Grapevine Cape",
        })

    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
        back="Grapevine Cape",
        })

    sets.RefreshReceived= {
        feet="Inspirited Boots",
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        }

    sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
        --Max Enh skill: 500, set gives 455***
        feet={ name="Chironic Slippers", augments={'Pet: AGI+3','Pet: Mag. Acc.+15','Phalanx +4','Accuracy+20 Attack+20',}},
        neck="Incanter's torque",
        ear1="Andoaa Earring",
        ear2="Mimir Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        })

    sets.midcast.PhalanxPotency = set_combine(sets.midcast.EnhancingDuration, {
        ammo="Pemphredo Tathlum", --***To test for swaps 
        feet={ name="Chironic Slippers", augments={'Pet: AGI+3','Pet: Mag. Acc.+15','Phalanx +4','Accuracy+20 Attack+20',}}, --4
        })

    sets.phalanx = sets.PhalanxPotency
    sets.Phalanx = sets.PhalanxPotency

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        body="Pedagogy Gown +3",
        legs="Shedir Seraweels",
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        main="Vadose Rod",
        sub="Ammurapi Shield",
        ammo="Impatiens", --10
        head="Amalric Coif +1",
        hands="Regal Cuffs",
        legs="Shedir Seraweels",
        waist="Emphatikos Rope",
        ear1="Halasz Earring",
        ring1="Evanescence Ring", --5
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}},
        waist="Emphatikos Rope", --12
        })

    sets.midcast.Storm = sets.midcast.EnhancingDuration

    sets.midcast.Stormsurge = set_combine(sets.midcast.Storm,
       {feet="Pedagogy Loafers +3"
       })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
       ear1="Brachyura Earring",
       ring2="Sheltered Ring",
       })

    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head=empty,
        body="Cohort Cloak +1",
        --hands="Regal Cuffs", --*** Is it better than Kaykaus?
        hands="Kaykaus Cuffs +1",
        legs="Arbatel Pants +3",
        feet="Acad. Loafers +3",
        neck="Argute Stole +2",
        ear1="Vor Earring",
        ear2="Regal Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back="Aurist's Cape +1",
        waist="Obstinate Sash",
        }

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        --head="Academic's Mortarboard +3",
        head="Arbatel Bonnet +3",
        body="Acad. Gown +3",
        })

    sets.midcast.ElementalEnfeeble = sets.midcast.Enfeebles
    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield", waist="Shinjutsu-no-Obi +1"})

    sets.midcast['Dark Magic'] = {
        main="Musa",
        sub="Khonsu",
        ammo="Pemphredo Tathlum",
        head="Amalric Coif +1",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Arbatel Pants +3",
        feet="Agwu's Pigaches",
        neck="Argute Stole +2",
        ear1="Malignance Earring",
        ear2="Crepuscular Earring",
        ring1="Kishar Ring",
        ring2="Metamorph Ring +1",
        back={ name="Lugh's Cape", augments={'Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Mag. Evasion+15',}},--***will update after another aug
        waist="Acuity Belt +1",
        }

    sets.midcast.Kaustra = {
        --*** Used during 1 hour. Fix later
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Agwu's Robe",
        hands="Amalric Gages +1",
        legs="Amalric Slops +1",
        feet="Agwu's Pigaches",
        neck="Argute Stole +2",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Archon Ring",
        back="Aurist's Cape +1",
        waist="Acuity Belt +1",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        ammo="Staunch Tathlum +1",
        main="Rubicundity",
        sub="Ammurapi Shield",
        head="Pixie Hairpin +1",
        --body="Merlinic Jubbah", --*** with drain/aspir augs
        body="Academic's Gown +3",
        hands={ name="Merlinic Dastanas", augments={'"Drain" and "Aspir" potency +11','MND+1',}},
        legs="Pedagogy Pants +3",
        feet="Agwu's Pigaches",
        --ear1="Hirudinea Earring",
        --ear2="Mani Earring",
        ring1="Archon Ring",
        ring2="Evanescence Ring",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {
        })

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        --*** Needs work. Combo of AF/Relic +3
        main="Musa",
        sub="Khonsu",
        back="Aurist's Cape +1",
        waist="Luminary Sash",
        })

    -- Elemental Magic
    sets.midcast['Elemental Magic'] = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Pedagogy Mortarboard +3",
        body="Arbatel Gown +3",
        hands="Arbatel Bracers +3",
        legs="Arbatel Pants +3",
        feet="Arbatel Loafers +3",
        neck="Argute Stole +2",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        waist="Sacro Cord",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        }

    sets.magic_burst = {
        --MB DMG cap for equipment = 40
        --MB DMG / MB DMG II (26/20): Total ???
        ammo="Ghastly Tathlum +1",
        main="Bunzi's Rod", --10/0
        sub="Ammurapi Shield",

        --head="Pedagogy Mortarboard +3", --0/4
        --body="Arbatel Gown +3",
        --hands="Amalric Gages +1", --0/6
        --legs="Amalric Slops +1",
        --feet="Arbatel Loafers +3", --0/5

        head="Agwu's Cap",
        body="Arbatel Gown +3",
        hands="Agwu's Gages", --6
        legs="Agwu's Slops", --9/0
        feet="Arbatel Loafers +3", --0/5

        neck="Argute Stole +2", --7/0
        ear1="Malignance Earring",
        ear2="Regal Earring",
        --ring1="Metamorph Ring +1",
        ring1="Freke Ring",
        ring2="Mujin Band", --0/5
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        }

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        body="Seidr Cotehardie",
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        sub="Khonsu",
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        waist="Sacro Cord",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        main="Contemplator +1",
        sub="Khonsu",
        neck="Erra Pendant",
        head=empty,
        body="Twilight Cloak",
        legs="Arbatel Pants +3",
        ring1="Archon Ring",
        back="Aurist's Cape +1",
        waist="Acuity Belt +1",
        })

    sets.midcast.Helix = {
        --Want “Magic Damage +XX” and MAB
        ammo="Ghastly Tathlum +1",
        main="Bunzi's Rod",
        sub="Culminus",
        ammo="Ghastly Tathlum +1",
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Amalric Gages +1",
        legs="Agwu's Slops",
        feet="Amalric Nails +1",
        neck="Argute Stole +2",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Mallquis Ring",
        --waist="Skrymir Cord +1",
        waist="Acuity Belt +1",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        }

    sets.midcast.DarkHelix = set_combine(sets.midcast.Helix, {
        head="Pixie Hairpin +1",
        ring2="Archon Ring",
        })

    sets.midcast.LightHelix = set_combine(sets.midcast.Helix, {
        })

    sets.midcast.HelixBurst = set_combine(sets.midcast.Helix, {
        --MB DMG cap for equipment = 40
        --MB DMG / MB DMG II (0/0): Total 43/11
        ammo="Ghastly Tathlum +1",
        main="Bunzi's Rod", --10/0
        sub="Ammurapi Shield",
        --head="Agwu's Cap", --7/0
        head="Pedagogy Mortarboard +3",
        body="Agwu's Robe", --10/0
        hands="Agwu's Gages", --6
        --legs="Arbatel Pants +3",
        legs="Agwu's Slops", --9/0
        feet="Arbatel Loafers +3", --0/5
        neck="Argute Stole +2", --7/0
        ear1="Malignance Earring",
        ear2="Arbatel Earring +1",
        --ring1="Freke Ring",
        ring1="Medada's Ring", --for ongo
        ring2="Mujin Band", --0/5
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        --waist="Skrymir Cord +1",
        waist="Acuity Belt +1",
        })


    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Bolelabunga",
        sub="Genmei Shield",
        ammo="Homiliary",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        --feet="Herald's Gaiters", --*** not for ongo
        feet="Nyame Sollerets",
        neck="Loricate Torque +1",
        ear1="Etiolation Earring",
        ear2="Infused Earring",
        ring1="Defending Ring",
        ring2="Stikini Ring +1",
        back="Moonlight Cape",
        waist="Carrier's Sash",
        }

    sets.idle.DT = set_combine(sets.idle, {
        --*** Fill in later
        ammo="Staunch Tathlum +1", --3/3
        head="Nyame Helm", --7/7
        body="Nyame Mail", --9/9
        hands="Nyame Gauntlets", --7/7
        legs="Nyame Flanchard", --8/8
        feet="Nyame Sollerets", --7/7
        neck="Warder's Charm +1", --ele resist
        ear1="Lugalbanda Earring",
        ear2="Etiolation Earring",
        ring1="Defending Ring", --10/10
        ring2="Gelatinous Ring +1", --10/10
        back="Moonlight Cape",
        waist="Carrier's Sash", --ele resist
        })

    sets.idle.Vagary = sets.midcast['Elemental Magic']

    sets.idle.Town = set_combine(sets.idle, {
        main="Daybreak",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Pedagogy Mortarboard +3",
        body="Pedagogy Gown +3",
        --hands="Pedagogy Bracers +3",
        legs="Pedagogy Pants +3",
        feet="Herald's Gaiters",
        neck="Loricate Torque +1",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back="Moonlight Cape",
        waist="Acuity Belt +1",
        })

    sets.resting = set_combine(sets.idle, {
        main="Contemplator +1",
        sub="Khonsu",
        waist="Shinjutsu-no-Obi +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT
    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
    --sets.latent_refresh85 = {
    --*** Turn off for Ongo
        --head={ name="Merlinic Hood", augments={'DEX+7','Pet: "Store TP"+3','"Refresh"+2','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        --hands={ name="Merlinic Dastanas", augments={'Pet: STR+4','AGI+1','"Refresh"+2','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
        --legs={ name="Merlinic Shalwar", augments={'Attack+24','"Cure" potency +1%','"Refresh"+2','Accuracy+13 Attack+13','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        --}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
        main="Maxentius", --***Change to something or bunzi
        sub="Ammurapi Shield",
        --main="Malignance Pole", 
        --sub="Khonsu",
        ammo="Amar Cluster",
        head="Blistering Sallet +1",
        body="Nyame Mail",
        --hands="Gazu Bracelets +1",
        hands="Nyame Gauntlets",
        --legs="Pedagogy Pants +3",
        legs="Nyame Flanchard",
        --feet="Pedagogy Loafers +3",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        ear1="Crepuscular Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Petrov Ring",
        waist="Grunfeld Rope",
        }

	sets.engaged.Acc = set_combine(sets.engaged, {
        neck="Combatant's Torque",
        ear1="Mache Earring +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.buff['Ebullience'] = {head="Arbatel Bonnet +3"}
    sets.buff['Rapture'] = {head="Arbatel Bonnet +3"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +3"}
    sets.buff['Immanence'] = {
        hands="Arbatel Bracers +3",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
}
    sets.buff['Penury'] = {legs="Arbatel Pants +3"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +3"}
    sets.buff['Celerity'] = {feet="Pedagogy Loafers +3"}
    sets.buff['Alacrity'] = {feet="Pedagogy Loafers +3"}
    sets.buff['Klimaform'] = {feet="Arbatel Loafers +3"}

    sets.buff.FullSublimation = {
       body="Pedagogy Gown +3",
       waist="Embla Sash", --5
       }

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.LightArts = {feet="Acad. Loafers +3"}
    sets.DarkArts = {
        body="Acad. Gown +3",
        feet="Acad. Loafers +3",
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.Bookworm = {back="Bookworm's Cape"}
    sets.VRRing = {ring1="Medada's Ring"}
    -- sets.CP = {back="Mecisto. Mantle"}

    sets.TreasureHunter = {
        head="Volte Cap",
        legs="Volte Hose",
        feet="Volte Boots",
        waist="Chaac Belt",
        }
    sets.TH = sets.TreasureHunter
    sets.th = sets.TreasureHunter


end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if (spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"])) or
        (spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"])) then
        equip(sets.precast.FC.Grimoire)
    elseif spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Run after the general midcast() is done.

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if spellMap == "Helix" then
            equip(sets.midcast['Elemental Magic'])
            if spell.english:startswith('Lumino') then
                equip(sets.midcast.LightHelix)
            elseif spell.english:startswith('Nocto') then
                equip(sets.midcast.DarkHelix)
            else
                equip(sets.midcast.Helix)
            end
            if state.HelixMode.value == 'Duration' then
                equip(sets.Bookworm)
            end
        end
        if buffactive['Klimaform'] and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if spell.english == "Phalanx" and buffactive.Accession then
        equip(sets.midcast.EnhancingDuration)
        send_command('@input /echo **Cast Phalanx for yourself**')
    end

    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
    if spell.skill == 'Enfeebling Magic' then
        if spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"]) then
            equip(sets.LightArts)
        elseif spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"]) then
            equip(sets.DarkArts)
        end
    end
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
        if spell.english == "Impact" then
            equip(sets.midcast.Impact)
        end
    end
    if spell.skill == 'Elemental Magic' and state.VRRing.value == true then
        equip(sets.VRRing)
        end



    if spell.skill == 'Elemental Magic' or spell.english == "Kaustra" then
        if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        end
    end

    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
            end
        end
        if spellMap == "Regen" and state.RegenMode.value == 'Duration' then
            equip(sets.midcast.RegenDuration)
        end
        if spellMap == "Regen" and state.RegenMode.value == 'Potency' then
            equip(sets.midcast.RegenPotency)
        end
        if spellMap == "Phalanx" and state.PhalanxMode.value == 'Duration' then
            equip(sets.midcast.EnhancingDuration)
            send_command('@input /echo **Phalanx Duration**')
        end
        if spellMap == "Phalanx" and state.PhalanxMode.value == 'Potency' then
            equip(sets.midcast.PhalanxPotency)
            send_command('@input /echo *** Did this set equip the Pemphredo Tathlum for testing purposes? ***')
            send_command('@input /echo **Phalanx Potency**')
        end
        if state.Buff.Perpetuance then
            equip(sets.buff['Perpetuance'])
        end
        if spellMap == "Storm" and state.StormSurge.value then
            equip (sets.midcast.Stormsurge)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end

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

    if buff == "Tabula Rasa" then
        if gain then
            send_command('@timers c "Tabula Rasa" 210 up')
        end
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_rings()
    check_moving()
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    update_active_strategems()
    update_sublimation()
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        idleSet = set_combine(idleSet, sets.buff.FullSublimation)
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if player.mpp < 86 then
        idleSet = set_combine(idleSet, sets.latent_refresh85)
    end

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

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local h_msg = state.HelixMode.value

    local r_msg = state.RegenMode.value

    local o_msg = state.VRRingMode.value

    local p_msg = state.PhalanxMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Helix: ' ..string.char(31,001)..h_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Regen: ' ..string.char(31,001)..r_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
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

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
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

function check_rings()
    rings = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    if rings:contains(player.equipment.left_ring) then
        disable("left_ring")
    else
        enable("left_ring")
    end

    if rings:contains(player.equipment.right_ring) then
        disable("right_ring")
    else
        enable("right_ring")
    end
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
        if no_swap_gear:contains(player.equipment.waist) then
            enable("waist")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(6, 13)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end
