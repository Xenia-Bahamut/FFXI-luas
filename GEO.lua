-- Original: Motenten / Modified: Arislan
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
--              [ WIN+O ]           Cycle VR Ring Mode
--
--  Abilities:  [ CTRL+` ]          Full Circle
--              [ CTRL+B ]          Blaze of Glory
--              [ CTRL+A ]          Ecliptic Attrition
--              [ CTRL+D ]          Dematerialize
--              [ CTRL+L ]          Life Cycle
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

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    geo_timer = ''
    indi_timer = ''
    indi_duration = 308
    entrust_timer = ''
    entrust_duration = 344
    entrust = 0
    newLuopan = 0

    state.Buff['Blaze of Glory'] = buffactive['Blaze of Glory'] or false

    -- state.CP = M(false, "Capacity Points Mode")

    state.Auto = M(true, 'Auto Nuke')
    state.Element = M{['description']='Element','Fire','Blizzard','Aero','Stone','Thunder','Water'}

    state.BarElement = M{['description']='BarElement', 'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesia', 'Barvirus', 'Barparalyze', 'Barsilence', 'Barpetrify', 'Barpoison', 'Barblind', 'Barsleep'}

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
        }

    lockstyleset = 87

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.VRRing = M(false, 'VRRing')


    -- Additional local binds
    --include('Global-Binds.lua')

    send_command('bind ^` input /ja "Full Circle" <me>')
    send_command('bind ^b input /ja "Blaze of Glory" <me>')
    --send_command('bind ^a input /ja "Ecliptic Attrition" <me>')
    send_command('bind ^d input /ja "Dematerialize" <me>')
    --send_command('bind ^c input /ja "Life Cycle" <me>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^insert gs c cycleback Element')
    send_command('bind ^delete gs c cycle Element')
    send_command('bind !w input /ma "Aspir III" <t>')
    send_command('bind !p input /ja "Entrust" <me>')
    send_command('bind ^, input /ma Sneak <stpc>')
    send_command('bind ^. input /ma Invisible <stpc>')
    -- send_command('bind @c gs c toggle CP')
    send_command('bind @o gs c toggle VRRing')
    send_command('bind @w gs c toggle WeaponLock')

    send_command('bind ^numpad7 input /ws "Black Halo" <t>')
    send_command('bind ^numpad8 input /ws "Hexa Strike" <t>')
    send_command('bind ^numpad9 input /ws "Realmrazer" <t>')
    send_command('bind ^numpad6 input /ws "Exudation" <t>')
    send_command('bind ^numpad1 input /ws "Flash Nova" <t>')

    send_command('bind #- input /follow <t>')

	send_command('bind !o gi ugs false; input /equip ring2 "Warp Ring"; input /echo Warping; wait 10; input /item "Warp Ring" <me>;')
	send_command('bind !p gi ugs false; input /equip ring2 "Dim. Ring (Holla)"; input /echo Warping Reisj; wait 10; input /item "Dim. Ring (Holla)" <me>;')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind ^b')
    send_command('unbind ^a')
    send_command('unbind ^d')
    send_command('unbind ^c')
    send_command('unbind !`')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind !w')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind !.')
    -- send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad1')
    send_command('unbind !numpad7')
    send_command('unbind !numpad8')
    send_command('unbind !numpad9')
    send_command('unbind !numpad4')
    send_command('unbind !numpad5')
    send_command('unbind !numpad6')
    send_command('unbind !numpad1')
    send_command('unbind !numpad+')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Precast Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +3"}
    sets.precast.JA['Life Cycle'] = {
        head="Bagua Galero +3",
        body="Geomancy Tunic +2",
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10',}}, --***Could add -pdt with ambu resin
        }


    -- Fast cast sets for spells

    sets.precast.FC = {
        -- max 80. /RDM gives 15
        -- Gives 87 FC
        ranged="Dunna", --3
        main="Sucellus", --5
        --sub="Chanter's Shield", --3
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+12',}}, --14
        body="Zendik Robe", --13
        hands="Agwu's Gages", --6
        legs="Geomancy Pants +1", --11
        feet="Amalric Nails +1", --6
        neck="Orunmila's Torque", --5
        ear1="Malignance Earring", --4
        ear2="Loquacious Earring", --2
        ring1="Kishar Ring", --4
        ring2="Lebeche Ring", --QM2
        back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}}, --10
        waist="Shinjutsu-no-Obi +1", --5
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        back="Perimede Cape",
        waist="Siegel Sash",
        })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        hands="Bagua Mitaines +3",
        ear2="Barkarole Earring",
        })

    sets.precast.FC.Geomancy = set_combine(sets.precast.FC, {
        --in case of packet loss
        main="Idris",
        sub="Genmei Shield",
        range="Dunna",
        })


    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        hands="Vanya Cuffs", --7
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --QM+2
        back="Perimede Cape", --QM+4
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Brutal Earring",
        ring1="Epaminondas's Ring",
        ring2="Petrov Ring",
        waist="Fotia Belt",
        }

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, { 
        --Modifiers: MND: 70% STR: 30%
        ammo="Ghastly Tathlum +1",
        ear2="Regal Earring",
        ring1="Epaminondas's Ring",
        ring2="Metamorph Ring +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Exudiation'] = set_combine(sets.precast.WS, { 
        --Modifiers: MND: 50% INT: 50%
        ammo="Ghastly Tathlum +1", 
        neck="Sibyl Scarf",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Epaminondas's Ring",
        ring2="Metamorph Ring +1",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        })

    sets.precast.WS['Hexastrike'] = set_combine(sets.precast.WS, {
        --***Needs input
        --Modifiers: STR: 30% MND: 30%
        neck="Caro Necklace",
        --waist="Prosilio Belt +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Flash Nova'] = {
        head="Bagua Galero +3",
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        legs="Amalric Slops +1",
        feet="Amalric Nails +1",
        neck="Saevus Pendant +1",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Refoccilation Stone",
        }

    sets.precast.WS['Cataclysm'] = {
        --***Need input
        --Modifiers: STR: 30% INT: 30%
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        }

    ------------------------------------------------------------------------
    ----------------------------- Midcast Sets -----------------------------
    ------------------------------------------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        main="Sucellus",
        sub="Chanter's Shield",
        head="Amalric Coif +1",
        hands=gear.Merl_FC_hands,
        legs="Geomancy Pants +1",
        ear1="Malignance Earring",
        ear2="Etiolation Earring",
        ring1="Kishar Ring",
        ring2="Weather. Ring +1",
        back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
        waist="Shinjutsu-no-Obi +1",
        } -- Haste

   sets.midcast.Geomancy = {
        --Geomancy and handbell gives 373 at 99, 409 at mastered.
        --Geomancy and handbell skill combine for max skill of 900
        --Geomancy Potency items do not stack. Only the highest value will apply (Idris > Bagua charm +2) 
        --Geomancy does not affect entrusted spells
        -- XX/XX = geomancy skill / handbell skill
        main="Idris",
        sub="Ammurapi Shield",
        ranged="Dunna", --0/18
        head="Azimuth Hood +3", --20/0
        --head="Bagua Galero +3", --Luopan HP +600
        body="Bagua Tunic +1", --12/0
        hands="Geomancy Mitaines +3", --19/0
        legs="Bagua Pants +3",
        feet="Azimuth Gaiters +3", --indi +20
        ear1="Calamitous Earring", --conserve mp
        ear2="Etiolation Earring", --TEMP +mp
        neck="Bagua Charm +2", --gives potency but no +skill
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"}, --8/8
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"}, --8/8
        back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +20','Pet: Damage taken -2%','Damage taken-3%',}},
        waist="Shinjutsu-no-Obi +1", --conserve mp 
        }

    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        --Max 5:46 w/ full indi spell duration job points
        main={ name="Gada", augments={'Indi. eff. dur. +10','AGI+4','Mag. Acc.+18','"Mag.Atk.Bns."+11','DMG:+10',}}, --11 indi duration aug
        ranged="Dunna",
        legs="Bagua Pants +3", --21 duration
        feet="Azimuth Gaiters +3", --35 duration
        back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +20','Pet: Damage taken -2%','Damage taken-3%',}},
        })

    sets.midcast.Cure = {
        main="Daybreak", --30
        sub="Sors Shield", --3/(-5)
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}, --10  Path B
        body="Vanya Robe", --7/(-6)  Path B 
        hands="Vanya Cuffs", -- Path B 
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet="Vanya Clogs", --5  Path B 
        neck="Incanter's Torque",
        ear1="Mendi. Earring", --5
        ear2="Meili Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}}, --***could optimize w/dedicated ambu cape
        back="Tempered Cape +1",
        waist="Luminary Sash",
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        neck="Nuna Gorget +1",
        ring2="Metamorph Ring +1",
        waist="Luminary Sash",
        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        main="Gada",
        sub="Ammurapi Shield",
        hands="Vanya Cuffs",
        neck="Malison Medallion",
        ring1="Haoma's Ring",
        ring2="Menelaus's Ring",
        back="Oretan. Cape +1",
        })

    sets.midcast.Raise = sets.midcast.FastRecast
    sets.midcast.Erase = sets.midcast.FastRecast

    sets.midcast['Enhancing Magic'] = {
        --Need only 500 skill
        --Geo has no native enhancing skill. Gets it from the subjob.
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','VIT+6','Mag. Acc.+6','DMG:+9',}}, --6 enh duration aug
        sub="Ammurapi Shield",
        head="Befouled Crown", --*** Need input
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        ear1="Mimir Earring", --10
        ear2="Andoaa Earring", --5
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back="Fi Follet Cape +1", --9
        waist="Olympus Sash", --5
        }

    sets.midcast.EnhancingDuration = {
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','VIT+6','Mag. Acc.+6','DMG:+9',}}, --6 enh duration aug
        sub="Ammurapi Shield", --10
        head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        waist="Embla Sash",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1",
        })

    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
        back="Grapevine Cape",
        })

    sets.RefreshReceived= {
        feet="Inspirited Boots",
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        }

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
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
        ear2="Magnetic Earring",
        ring1="Evanescence Ring", --5
        waist="Emphatikos Rope", --12
        })

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
        head="Befouled Crown",
        legs="Shedir Seraweels",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast.MndEnfeebles = {
        -- MND/Magic accuracy
        main="Idris",
        sub="Ammurapi Shield",
        --head="Geomancy Galero +3",
        --body="Geomancy Tunic +3",
        head=empty,
        body="Cohort Cloak +1",
        hands="Regal Cuffs",
        --legs="Geomancy Pants +3",
        legs="Azimuth Tights +3",
        --feet="Geomancy Sandals +3",
        feet="Azimuth Gaiters +3",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Kishar Ring",
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back="Aurist's Cape +1",
        waist="Luminary Sash",
        }

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        -- INT/Magic accuracy
        main="Maxentius",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        waist="Acuity Belt +1",
        }) 

    sets.midcast.LockedEnfeebles = {body="Geomancy Tunic +3"}

    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})

    sets.midcast['Dark Magic'] = {
        main="Rubicundity",
        sub="Ammurapi Shield",
        head="Geomancy Galero +1",
        body="Geomancy Tunic +2",
        hands="Geomancy Mitaines +3",
        legs="Azimuth Tights +3",
        feet="Agwu's Pigaches",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2="Metamorph Ring +1",
        back="Aurist's Cape +1",
        waist="Acuity Belt +1",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Bagua Galero +3",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        ear1="Hirudinea Earring",
        ear2="Mani Earring",
        waist="Fucho-no-Obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        })

    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Azimuth Hood +3",
        body="Azimuth Coat +3",
        hands="Azimuth Gloves +3",
        legs="Azimuth Tights +3",
        feet="Azimuth Gaiters +3",

        neck="Baetyl Pendant",
        ear1="Malignance Earring",
        --ear2="Azimuth Earring +2",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamor. Ring +1",
        waist="Sacro Cord",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        }

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        main="Idris",
        sub="Ammurapi Shield",
        hands="Bagua Mitaines +3",
        legs=gear.Merl_MAB_legs,
        feet=gear.Merl_MAB_feet,
        neck="Sanctity Necklace",
        ear2="Digni. Earring",
        waist="Acuity Belt +1",
        })

    sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'].Resistant, {
        body="Seidr Cotehardie",
        })

    sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ Idle Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        --*** Needs input. Put in Nyame as filler
        main="Bolelabunga",
        sub="Genmei Shield",
        head="Nyame Helm",
        body="Azimuth Coat +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Geomancy Sandals +2",
        neck="Bathy Choker +1",
        ear1="Lugalbanda Earring",
        ear2="Etiolation Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10',}}, --***Could add -pdt with ambu resin
        --waist="Slipor Sash",
        waist="Carrier's Sash", --ele resist
        }

    sets.resting = set_combine(sets.idle, {
        main="Contemplator +1",
        sub="Khonsu",
        waist="Shinjutsu-no-Obi +1",
        })

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        head="Nyame Helm", --7/7
        body="Nyame Mail", --9/9
        hands="Nyame Gauntlets", --7/7
        legs="Nyame Flanchard",  --8/8
        feet="Nyame Sollerets", --7/7
        neck="Warder's Charm +1", --ele resist
        ear1="Lugalbanda Earring",
        ear2="Etiolation Earring",
        ring2="Defending Ring", --10/10
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10',}}, --***Could add -pdt with ambu resin --5/5
        waist="Carrier's Sash", --ele resist
        })

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, {
        -- 0/0/0: Player DT, Pet DT, Pet Regen
        -- Pet: -DT (37.5% to cap) / Pet: Regen
        main="Idris", --0/25/0
        sub="Genmei Shield", --10 pdt
        head="Azimuth Hood +3", --12/0/5
        --body="Telchine Chas.", --0/0/3 ***Pet Regen aug
        body="Shamash Robe",
        hands="Geomancy Mitaines +3", --3 pdt 0/13/0
        legs={ name="Telchine Braconi", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -4%',}}, --0/0/3
        feet="Bagua Sandals +3", --0/0/5
        neck="Bagua Charm +2",
        ear1="Lugalbanda Earring",
        ear2="Etiolation Earring",
        --ear2="Odnowa Earring +1", --3/3/0/0
        ring1="Gelatinous Ring +1", --7/(-1)/0/0
        ring2="Defending Ring", --10/0/0
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10','Pet: "Regen"+5',}}, --0/0/0/15
        waist="Isa Belt" --0/0/3/1
        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
        sub="Malignance Pole",
        sub="Khonsu",
        body="Mallquis Saio +2", --8/8
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10',}}, --***Could add -pdt with ambu resin --5/5
        })

    sets.PetHP = {head="Bagua Galero +3"}

    -- .Indi sets are for when an Indi-spell is active.
    --sets.idle.Indi = set_combine(sets.idle, {})
    --sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {})
    --sets.idle.DT.Indi = set_combine(sets.idle.DT, {})
    --sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {})

    sets.idle.Town = set_combine(sets.idle, {
        main="Idris",
        sub="Ammurapi Shield",
        head="Bagua Galero +3",
        body="Geomancy Tunic +2",
        legs="Bagua Pants +3",
        feet="Geomancy Sandals +2",
        neck="Bagua Charm +2",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
        waist="Acuity Belt +1",
        })

    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Geomancy Sandals +2"}

    sets.latent_refresh = {waist="Fucho-no-obi"}
    --for idle refresh when below 85% MP
    --sets.latent_refresh85 = {
        --head={ name="Merlinic Hood", augments={'DEX+7','Pet: "Store TP"+3','"Refresh"+2','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        --hands="Bagua Mitaines +3",
        --legs={ name="Merlinic Shalwar", augments={'Attack+24','"Cure" potency +1%','"Refresh"+2','Accuracy+13 Attack+13','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        --}
    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        main="Idris",
        sub="Genmei Shield",
        sub="Daybreak",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        ear1="Telos Earring",
        ear2="Crepuscular Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe1"},
        ring2={name="Chirich Ring +1", bag="wardrobe3"},
        back=gear.GEO_TP_Cape, --*** Alternative? 
        waist="Cetl Belt", --*** Needs input. Grunfeld rope? Shetal Stone?
        }


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.magic_burst = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Azimuth Hood +3",
        body="Azimuth Coat +3",
        hands="Azimuth Gloves +3",
        legs="Azimuth Tights +3",
        feet="Azimuth Gaiters +3",

        --head="Ea Hat +1", --7/(7)
        --body="Ea Houppe. +1", --9/(9)
        --hands="Ea Cuffs +1", --6/(6)
        --legs="Ea Slops +1", --8/(8)
        --feet="Bagua Sandals +3",

        neck="Mizu. Kubikazari", --10
        ear1="Malignance Earring",
        --ear2="Azimuth Earring +2",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Mujin Band", --(5)
        waist="Sacro Cord",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Saida Ring", bag="wardrobe3"},
        ring2={name="Saida Ring", bag="wardrobe4"},
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
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

function job_pretarget(spell, spellMap, eventArgs)
    if spell.type == 'Geomancy' then
        if spell.name:startswith('Indi') and buffactive.Entrust and spell.target.type == 'SELF' then
            add_to_chat(002, 'Entrust active - Select a party member!')
            cancel_spell()
        end
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    elseif state.Auto.value == true then
        if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and spellMap ~= 'GeoNuke' then
            refine_various_spells(spell, action, spellMap, eventArgs)
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        -- Target distance under 8 yalms. ***this may break the lua
        elseif spell.target.distance < (18+ spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        end
    elseif spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    elseif spell.skill == 'Enfeebling Magic' and newLuopan == 1 then
        -- prevent Cohort Cloak from unequipping head when relic head is locked
        equip(sets.midcast.LockedEnfeebles)
    elseif spell.skill == 'Geomancy' then
        if buffactive.Entrust and spell.english:startswith('Indi-') then
            equip({main={ name="Gada", augments={'Indi. eff. dur. +10','AGI+4','Mag. Acc.+18','"Mag.Atk.Bns."+11','DMG:+10',}}}) --*** input gada with indi duration aug
                entrust = 1
        end
    end
        if spell.skill == 'Elemental Magic' and state.VRRing.value == true then
        equip(sets.VRRing)
        end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        --[[if spell.english:startswith('Geo') then
            geo_timer = spell.english
            send_command('@timers c "'..geo_timer..'" 600 down spells/00136.png')
        elseif spell.english:startswith('Indi') then
            if entrust == 1 then
                entrust_timer = spell.english
                send_command('@timers c "'..entrust_timer..' ['..spell.target.name..']" '..entrust_duration..' down spells/00136.png')
                entrust = 0
            else
                send_command('@timers d "'..indi_timer..'"')
                indi_timer = spell.english
                send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
            end
        end ]]
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english:startswith('Geo-') or spell.english == "Life Cycle" then
            newLuopan = 1
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

    if buff == "Bolster" then
        if gain then
            send_command('@timers c "Bolster" 210 up')
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

-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    if gain == false then
        send_command('@timers d "'..geo_timer..'"')
        enable('head')
        newLuopan = 0
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    classes.CustomIdleGroups:clear()
end

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' then
            if spellMap == 'GeoElem' then
                return 'GeoElem'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    --for idle refresh when below 85% MP but it messes with idle.DT.Pet
    --if player.mpp < 86 then
        --idleSet = set_combine(idleSet, sets.latent_refresh85)
    --end
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if pet.isvalid then
        if pet.hpp > 73 then
            if newLuopan == 1 then
                equip(sets.PetHP)
                disable('head')
            end
        elseif pet.hpp <= 73 then
            enable('head')
            newLuopan = 0
        end
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local o_msg = state.VRRingMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Auto.value then
        msg = ' Auto: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

function refine_various_spells(spell, action, spellMap, eventArgs)

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.skill == 'Elemental Magic' and spellMap ~= 'GeoElem' then
            spell_index = table.find(degrade_array[spell.element],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array[spell.element][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        elseif spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end



-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'nuke' and not midaction() then
        send_command('@input /ma "' .. state.Element.current .. ' V" <t>')
    end
    gearinfo(cmdParams, eventArgs)
end

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
    set_macro_page(6, 14)  --*** (Page#, Book#)
end

function set_lockstyle()
    send_command('wait 4; input /lockstyleset ' .. lockstyleset)
end
