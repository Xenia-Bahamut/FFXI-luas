-- Original: Motenten / Modified: Arislan
-- Modified from Arislan’s MNK lua and made into War

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
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad4 ]    Upheaval
--              [ CTRL+Numpad5 ]    Ukko’s Fury
--              [ CTRL+Numpad6 ]    Full Break

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

-- Setup vars that are user-independent.
function job_setup()

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    --include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 93

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Chango', 'MidAcc', 'HighAcc', 'STP', 'SubtleBlow')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponSet = M{['description']='Weapon Set', 'Naegling', 'Chango', 'LoxoticMace', 'ShiningOne'}
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

    send_command('bind !o gi ugs false; input /equip ring2 "Warp Ring"; input /echo Warping; wait 10; input /item "Warp Ring" <me>;')
    send_command('bind !p gi ugs false; input /equip ring2 "Dim. Ring (Holla)"; input /echo Warping Reisj; wait 10; input /item "Dim. Ring (Holla)" <me>;')


    --if player.sub_job == 'DRG' then
    --***Add in lines for DRG abilities later
        --send_command('bind ^numpad/ input /ja "Berserk" <me>')
        --send_command('bind ^numpad* input /ja "Warcry" <me>')
        --send_command('bind ^numpad- input /ja "Aggressor" <me>')
--    end

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    --send_command('bind ^numpad8 input /ws "Ascetic\'s Fury" <t>')
    send_command('bind ^numpad4 input /ws "Upheaval" <t>')
    send_command('bind ^numpad5 input /ws "Ukko\’s Fury" <t>')
    send_command('bind ^numpad2 input /ws "Full Break" <t>')

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind @c')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
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

    -- Precast sets to enhance JAs
    sets.precast.JA['Berserk'] = {back="Cichol's Mantle", body="Pummeler's Lorica +2", feet="Agoge Calligae +3"}
    sets.precast.JA['Warcry'] = {head="Agoge Mask +3"}
    sets.precast.JA['Defender'] = {hands="Agoge Mufflers +3"}
    sets.precast.JA['Aggressor'] = {head="Pummeler's Mask +3", body="Agoge Lorica +3"}
    sets.precast.JA['Mighty Strikes'] = {hands="Agoge Mufflers +3"}
    sets.precast.JA["Warrior's Charge"] = {legs="Agoge Cuisses +3"}
    sets.precast.JA['Tomahawk'] = {ammo="Thr. Tomahawk", feet="Agoge Calligae +3"}
    sets.precast.JA['Retaliation'] = {hands="Pummeler's Mufflers +3", feet="Boii Calligae +3"}
    sets.precast.JA['Restraint'] = {hands="Boii Mufflers +3"}
    sets.precast.JA['Blood Rage'] = {body="Boii Lorica +3"}
    sets.precast.JA['Brazen Rush'] = {}
    sets.precast.JA['Provoke'] = set_combine(sets.Enmity,{})

    sets.precast.JA['Jump'] = {
        --Not BiS but works with what I have
        ammo="Aurgelmir Orb",
        head="Flam. Zucchetto +2",
        body="Tatenashi Haramaki +1",
        --hands="Crusher Gauntlets",
        hands="Flam. Manopolas +2",
        legs="Tatenashi Haidate +1",
        --feet="Ostro Greaves",
        feet="Flam. Gambieras +2",
        neck="Vim Torque +1",
        waist="Reiki Yotai",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Flamma Ring",
        ring2="Crepuscular Ring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}},
}

    sets.precast.JA['High Jump'] = sets.precast.JA['Jump']
    sets.precast.JA['Super Jump'] = {}


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        --legs="Sakpata's Cuisses",
        legs="Dashing Subligar", 
        feet="Sakpata's Leggings",
        neck="Unmoving Collar +1",
        ear1="Tuisto Earring",
        ear2="Odnowa Earring +1",
        ring1="Niqmaddu Ring",
        ring2="Gelatinous Ring +1",
        back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},
        waist="Engraved Belt",
        }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    sets.precast.Step = {
        ammo="Seething Bomblet +1",
        head="Blistering Sallet +1",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Sanctity Necklace",
        ear1="Mache Earring +1",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Cacoethic Ring +1",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}},
        waist="Ioskeha Belt +1",
        }

    sets.precast.Flourish1 = {
        ammo="Pemphredo Tathlum",
        head="Blistering Sallet +1",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Sanctity Necklace",
        ear1="Dignitary's Earring",
        ear2="Crepuscular Earring",
        ring1="Stikini Ring +1",
        ring2="Metamorph Ring +1",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}},
        waist="Ioskeha Belt +1",
        }

    sets.Enmity = {
        --ammo="Sapience Orb", --2
        head="Pummeler's Mask +3", --12
        body="Souveran Curiass +1", --11
        hands="Pummeler's Mufflers +3", --15
        legs="Souveran Diechlings +1",
        feet="Souveran Schuhs +1", --7
        --neck="Moonlight Necklace", --10
        neck="Unmoving Collar +1", --10
        ear1="Cryptic Earring", --4
        ear2="Trux Earring", --5
        --ring1="Pernicious Ring", --5
        --ring2="Pernicious Ring", --5
        --ring1="Apeile Ring", --5~9
        --ring2="Apeile Ring +1", --5~9
        --back="Cichol’s Mantle", --+10 when the cape is made 
        --waist="Kasiri Belt", --3
        waist="Trance Belt", --4
        }

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Impatiens",
        head="Sakpata's Helm", --8
        body="Sacro Breastplate",
        hands="Leyline Gloves", --5
        neck="Orunmila's Torque", --5
        waist="Sailfi Belt +1",
        ear1="Loquacious Earring",
        ear2="Etiolation Earring",
        ring1="Prolix Ring",
        ring2="Lebeche Ring",
        --back=Cichols_FCIdle,
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        })



    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

--***Remove this line later. Change “SomeAcc” to “MidAcc” and “FullhAcc” to “HighAcc”. Case sensitive
--*** Change Coiste Bodhar to Aurgelmir Orb\
--*** seething bomblet is used for ws I won’t use much.
--*** update the capes with what I have made so far. Put ***beside capes I have but need stats (like -PDT) on


    sets.precast.WS = {
        ammo="Knobkierrie",
        head="Agoge Mask +3",
        --body="Pummeler's Lorica +3",
        body="Nyame Mail",
        --hands="Boii Mufflers +3",
        hands="Nyame Gauntlets",
        --legs="Sakpata's Cuisses", --After some RP put into it
        --legs="Nyame Flanchard",
        legs="Boii Cuisses +3",
        feet="Nyame Sollerets",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Epaminondas's Ring",
        ring2="Niqmaddu Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Sailfi Belt +1",
        }

    --Sword weaponskill sets

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    --Modifiers: STR: 50% MND: 50%
    --does not benefit as much with fTP and Multi-attack gear
        ammo="Knobkierrie",
        head="Agoge Mask +3",
        --body="Sakpata's Plate", --After some RP put into it
        body="Nyame Mail",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Nyame Sollerets",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Epaminondas's Ring",
        ring2="Sroda Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Sailfi Belt +1",
        })

    sets.precast.WS['Savage Blade'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Savage Blade'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})
    sets.precast.WS['Savage Blade'].SubtleBlow = set_combine(sets. precast.WS['Savage Blade'], {})


    sets.precast.WS['Sanguine Blade'] = {
        ammo="Knobkierrie",
        head="Pixie Hairpin +1",
        body="Sacro Breastplate",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Sulevia's Leggings +2",
        neck="Baetyl Pendant",
        waist="Eschan Stone",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Archon Ring",
        ring2="Epaminondas's Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        }

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        head="Flam. Zucchetto +2",
        body="Sakpata's Plate",
        hands="Boii Mufflers +3",
        legs="Tatenashi Haidate +1",
        feet="Flam. Gambieras +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Lugra Earring +1",
        ear2="Schere Earring",
        ring1="Niqmaddu Ring",
        ring2="Flamma Ring",
        --back=Cichols_STRDA,
        })
    sets.precast.WS['Requiescat'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Requiescat'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

    -- Hand-to-Hand weaponskill sets
    --Input later. Put in Raging Fists, Tornado Kick, 


    --Axe weaponskill sets

    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
        body="Hjarrandi Breastplate",
        hands="Flamma Manopolas +2",
        legs="Zoar Subligar +1",
        feet="Boii Calligae +3",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Moonshade Earring",
        ear2="Schere Earring",
        ring1="Niqmaddu Ring",
        ring2="Hetairoi Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},
        })
    sets.precast.WS['Rampage'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Rampage'].HighAcc = set_combine(sets.precast.WS.HighAcc, {
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Moonshade Earring",
        ear2="Schere Earring",
        ring1="Niqmaddu Ring",
        ring2="Hetairoi Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},
        })

    sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Calamity'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Calamity'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Calamity'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Mistral Axe'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Mistral Axe'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Mistral Axe'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        head="Flam. Zucchetto +2",
        body="Sakpata's Plate",
        hands="Boii Mufflers +3",
        legs="Tatenashi Haidate +1",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Lugra Earring +1",
        ear2="Schere Earring",
        ring1="Niqmaddu Ring",
        ring2="Flamma Ring",
        --back=Cichols_STRDA,
        })
    sets.precast.WS['Decimation'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Decimation'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Decimation'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

    sets.precast.WS['Cloudsplitter'] = {
        ammo="Knobkierrie",
        head="Agoge Mask +3",
        body="Sacro Breastplate",
        hands="Nyame Gauntlets",
        legs="Boii Cuisses +3",
        feet="Sulevia's Leggings +2",
        neck="Baetyl Pendant",
        waist="Eschan Stone",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Niqmaddu Ring",
        ring2="Epaminondas's Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        }


    --Club weaponskill sets

    sets.precast.WS['Hexa Strike'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
        body="Hjarrandi Breastplate",
        hands="Boii Mufflers +3",
        legs="Zoar Subligar +1",
        feet="Boii Calligae +3",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Moonshade Earring",
        ear2="Schere Earring",
        ring1="Niqmaddu Ring",
        ring2="Hetairoi Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},
        })
    sets.precast.WS['Hexa Strike'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Hexa Strike'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Hexa Strike'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Black Halo'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Black Halo'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Black Halo'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Black Halo'], {
        ammo="Knobkierrie",
        head="Agoge Mask +3",
        --body="Sakpata's Plate", --After some RP put into it
        body="Nyame Mail",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Nyame Sollerets",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Epaminondas's Ring",
        ring2="Niqmaddu Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Sailfi Belt +1",
})


    --Great Sword weaponskill sets

   sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Ground Strike'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Ground Strike'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ground Strike'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        head="Flam. Zucchetto +2",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Sakpata's Leggings",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Moonshade Earring",
        ear2="Schere Earring",
        ring1="Niqmaddu Ring",
        ring2="Regal Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        })
    sets.precast.WS['Resolution'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Resolution'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})


	-- Great Axe weaponskill sets

	sets.precast.WS['Shield Break'] = {
        ammo="Pemphredo Tathlum",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Sakpata's Leggings",
        neck="Sanctity Necklace",
        ear1="Dignitary's Earring",
        ear2="Crepuscular Earring",
        ring1="Stikini Ring +1",
        ring2="Metamorph Ring +1",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Eschan Stone",
        }
	sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS['Shield Break'], {})
	sets.precast.WS['Weapon Break'] = set_combine(sets.precast.WS['Shield Break'], {})
	sets.precast.WS['Full Break'] = set_combine(sets.precast.WS['Shield Break'], {})

    sets.precast.WS['Raging Rush'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
        body="Hjarrandi Breastplate",
        hands="Flamma Manopolas +2",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="Fotia Gorget",
        waist="Sailfi Belt +1",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Niqmaddu Ring",
        ring2="Epaminondas's Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        })
    sets.precast.WS['Raging Rush'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Raging Rush'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Raging Rush'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	sets.precast.WS["Steel Cyclone"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Steel Cyclone"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["Steel Cyclone"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Steel Cyclone"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	sets.precast.WS["Fell Cleave"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Fell Cleave"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["Fell Cleave"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Fell Cleave"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})
	sets.precast.WS["King's Justice"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["King's Justice"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["King's Justice"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["King's Justice"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	sets.precast.WS["Ukko's Fury"] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Boii Mask +3",
        --body="Sakpata's Plate", --After some RP put into it
        body="Nyame Mail",
        --hands="Sakpata's Gauntlets", --After some RP put into it
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Boii Earring +1",
        ring1="Niqmaddu Ring",
        ring2="Sroda Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},
        waist="Sailfi Belt +1",
        })
    sets.precast.WS["Ukko's Fury"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["Ukko's Fury"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Ukko's Fury"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        --head="Sakpata's Helm", --After some RP put into it
        head="Agoge Mask +3",
        --body="Sakpata's Plate", --After some RP put into it
        body="Nyame Mail", 
        --hands="Sakpata's Gauntlets", --After some RP put into it
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Nyame Sollerets",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Niqmaddu Ring",
        ring2="Sroda Ring",
        back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},
        waist="Sailfi Belt +1",
        })
    sets.precast.WS['Upheaval'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Upheaval'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})


	-- Polearm weaponskill sets

	sets.precast.WS["Impulse Drive"] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
        body="Sakpata's Plate",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Boii Earring +1",
        ring1="Niqmaddu Ring",
        ring2="Sroda Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Sailfi Belt +1",
})

    sets.precast.WS["Impulse Drive"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["Impulse Drive"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Impulse Drive"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Boii Mask +3",
        body="Sakpata's Plate",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1="Moonshade Earring",
        ear2="Boii Earring +1",
        ring1="Niqmaddu Ring",
        --ring2="Flamma Ring",
        ring2="Sroda Ring", --For high buffs
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},
        })

	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Stardiver'].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Stardiver'].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	-- Scythe weaponskill sets

	sets.precast.WS["Spiral Hell"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Spiral Hell"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["Spiral Hell"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Spiral Hell"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})

	-- Cl weaponskill sets

	sets.precast.WS["Judgement"] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Agoge Mask +3",
        --body="Sakpata's Plate", --After some RP put into it
        body="Nyame Mail",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Nyame Sollerets",
        neck="War. Beads +2",
        ear1="Moonshade Earring",
        ear2="Thrud Earring",
        ring1="Epaminondas's Ring",
        ring2="Sroda Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Sailfi Belt +1",
        })

    sets.precast.WS["Judgement"].MidAcc = set_combine(sets.precast.WS.MidAcc, {})
    sets.precast.WS["Judgement"].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS["Judgement"].HighAcc = set_combine(sets.precast.WS.HighAcc, {})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        ring2="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast.Trust = sets.precast.FC


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Bathy Choker +1",
        ear1="Eabani Earring",
        --ear2="Sanare Earring",
        ear2="Odnowa Earring +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back="Moonlight Cape",
        waist="Engraved Belt",
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1",
        --head="Hjarrandi Helm",
        head="Nyame Helm", --7/7
        body="Nyame Mail", --9/9
        hands="Nyame Gauntlets",--7/7
        legs="Nyame Flanchard", --8/8
        feet="Nyame Sollerets",--7/7
        --neck="Warder's Charm +1", --5% chance to absorb damage
        neck="Loricate Torque +1",
        ear1="Odnowa Earring +1",
        ear2="Infused Earring",
        back="Moonlight Cape", --6/6
        waist="Carrier's Sash", --ele resist
        })


    sets.idle.Town = sets.idle

    sets.idle.Regen = set_combine(sets.idle, {
        ear1="Infused Earring",
        })

    sets.regen = sets.idle.Regen

    sets.idle.Regain = set_combine(sets.idle, {
        head="Valorous Mask",
        neck="Vim Torque +1",
        ring1="Karieyh Ring +1",
        })

    sets.regain = sets.idle.Regain


    sets.idle.Weak = sets.idle.DT


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT
    sets.latent_regen = {ring1="Apeile ring +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- 33% Double Attack rate @ 1900 job points & 5/5 merits (67% DA gear to reach 100%)
	--Total so far: DA+73, TA+2, QA+4
	sets.engaged = {
        ammo="Coiste Bodhar", --3/3
        head="Boii Mask +3", --7/0
        body="Hjarrandi Breastplate", --0/10
        hands="Sakpata's Gauntlets", --6/5 (7 @R25, 8 @R30)
        legs="Pumm. Cuisses +3", --11/0
        feet="Pumm. Calligae +3", --9/4
        neck="War. Beads +2", --7/0
        ear1=empty,
        ear1="Schere Earring", --6/5 (5 stp when R30)
        ear2="Boii Earring +1", --8/0
        ring1="Niqmaddu Ring", --QA+4
        ring2="Petrov Ring", --1/5
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}}, --10/0
        waist="Sailfi Belt +1", --5/0, TA+2
        }

    sets.engaged.MidAcc = set_combine(sets.engaged, {})
    sets.engaged.Acc = set_combine(sets.engaged.MidAcc, {})
    sets.engaged.HighAcc = set_combine(sets.engaged.Acc, {
        ear1="Mache Earring +1",
        ear2="Telos Earring",
        ring1="Flamma Ring",
        ring2="Cacoethic Ring +1",
        waist="Kentarch Belt +1",
        })

    sets.engaged.sTP = {
        --ammo="Coiste Bodhar",
        ammo="Aurgelmir Orb",
        head="Flamma Zucchetto +2",
        body="Hjarrandi Breastplate", --R15 Tatenashi Haramaki
        hands="Tatenashi Gote +1",
        legs="Tatenashi Haidate +1",
        feet="Tatenashi Sune-Ate +1",
        neck="Vim Torque +1",
        ear1="Telos Earring",
        ear2="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}},
        waist="Sailfi Belt +1",
        }

    sets.engaged.SubtleBlow= set_combine(sets.engaged, {
        --Cap of 50 for Subtle Blow. Total cap of 75
        --Current Total: 42 + 15 = 57
        --Deep-fried shrimp gives +8. NQ gives +9. Acc/Racc
        --Pukatrice Egg gives +8. NQ gives +9. Att/RAtt
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Dagon Breast.", --0/10
        hands="Sakpata's Gauntlets", --8/0
        legs="Pumm. Cuisses +3",
        feet="Sakpata's Leggings", --10/0
        neck="Bathy Choker +1", --11/0
        waist="Sailfi Belt +1",
        ear1="Telos Earring",
        ear2="Schere Earring", --3/0
        ring1="Niqmaddu Ring", --0/5
        ring2={name="Chirich Ring +1", bag="wardrobe1"}, --10/0
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        })

    sets.engaged.Tatenashi= set_combine(sets.engaged, {
        --Total so far: DA+32, TA+22, QA+3
        --X/X = Stp/TA 
        body="Tatenashi Haramaki +1", --5~9/5
        hands="Tatenashi Gote +1", --4~8/4
        legs="Tatenashi Haidate +1", --4~8/3
        feet="Tatenashi Sune-Ate +1", --4~8/3
        })



    sets.engaged.MidAcc.sTP = set_combine(sets.engaged.sTP, {})
    sets.engaged.Acc.sTP = set_combine(sets.engaged.MidAcc.sTP, {})
    sets.engaged.HighAcc.sTP = set_combine(sets.engaged.Acc.sTP, {})

	-- Dual wield melee sets
	sets.engaged.DW = { --3 DA @ offhand HQ Sangarius
        --ammo="Coiste Bodhar",
        ammo="Aurgelmir Orb",
        head="Flamma Zucchetto +2",
        body="Emicho Haubert +1", 
        hands="Emicho Gauntlets +1", -- 9 DA @ 2/5 Emicho +1 set bonus 
        legs="Pumm. Cuisses +3", --11
        feet="Pumm. Calligae +3", --9
        neck="War. Beads +2", --7
        ear1="Suppanomimi",
        ear2="Schere Earring", --6
        ring1="Niqmaddu Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}}, --10
        waist="Ioskeha Belt +1", --9
        }
	sets.engaged.DW.MidAcc = set_combine(sets.engaged, {})
    sets.engaged.DW.Acc = set_combine(sets.engaged.DW.MidAcc, {})
    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.Acc, {})
	
	sets.engaged.DW.sTP = {
        --ammo="Coiste Bodhar",
        ammo="Aurgelmir Orb",
        head="Flamma Zucchetto +2",
        body="Hjarrandi Breastplate", --R15 Tatenashi Haramaki
        hands="Emicho Gauntlets +1",
        legs="Tatenashi Haidate +1",
        feet="Tatenashi Sune-Ate +1",
        neck="Vim Torque +1",
        ear1="Suppanomimi",
        ear2="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}},
        waist="Ioskeha Belt +1",
        }
	sets.engaged.DW.sTP.MidAcc = set_combine(sets.engaged.DW.sTP, {})
    sets.engaged.DW.sTP.Acc = set_combine(sets.engaged.DW.sTP.MidAcc, {})
    sets.engaged.DW.sTP.HighAcc = set_combine(sets.engaged.DW.sTP.Acc, {})


	-- weapon specific melee sets
	sets.engaged.Chango = {
        --mostly for /SAM
        -- 33% Double Attack rate @ 1900 job points & 5/5 merits (67% DA gear to reach 100%)
        --DA/Stp. Total: 70/48(+5) and -DT 32, -15 PDT
        ammo="Coiste Bodhar", --3/3
        head="Boii Mask +3", --7/0
        body="Boii Lorica +3", --0/11
        hands="Sakpata's Gauntlets", --6/5 (8 stp when R30)
        legs="Pumm. Cuisses +3", --11/0
        feet="Pumm. Calligae +3", --9/4
        neck="War. Beads +2", --7/0
        ear1=empty,
        ear1="Schere Earring", --6/3 (5 stp when R30)
        ear2="Boii Earring +1", --8/0
        ring1="Niqmaddu Ring", --QA+4
        ring2="Petrov Ring", --1/5
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}}, --10/0
        waist="Sailfi Belt +1", --5/0
        }

    sets.engaged.Chango.MidAcc = set_combine(sets.engaged.Chango, {})
    sets.engaged.Chango.Acc = set_combine(sets.engaged.Chango.MidAcc, {})
    sets.engaged.Chango.HighAcc = set_combine(sets.engaged.Chango.Acc, {})
	
	sets.engaged.Chango.sTP = {
        --ammo="Coiste Bodhar",
        ammo="Aurgelmir Orb",
        head="Flamma Zucchetto +2",
        body="Hjarrandi Breastplate", --R15 Tatenashi Haramaki
        hands="Tatenashi Gote +1",
        legs="Tatenashi Haidate +1",
        feet="Tatenashi Sune-Ate +1",
        neck="Vim Torque +1",
        ear1="Telos Earring",
        ear2="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','”Dbl.Atk.”+10','Phys. dmg. taken-10%',}},
        waist="Sailfi Belt +1",
        }
    sets.engaged.Chango.MidAcc.sTP = set_combine(sets.engaged.Chango.sTP, {})
    sets.engaged.Chango.Acc.sTP = set_combine(sets.engaged.Chango.MidAcc.sTP, {})
    sets.engaged.Chango.HighAcc.sTP = set_combine(sets.engaged.Chango.Acc.sTP, {})









    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.buff.MightyStrikes = {
        feet="Boii Calligae +3",
        }

    sets.CP = {back="Mecisto. Mantle"}

    sets.TreasureHunter = {
        head="Volte Cap",
        legs="Volte Hose",
        feet="Volte Boots",
        waist="Chaac Belt",
        }

    sets.TH = sets.TreasureHunter

    sets.phalanx = {
        head={ name="Valorous Mask", augments={'Pet: AGI+4','Accuracy+18 Attack+18','Phalanx +4',}},
        body={ name="Valorous Mail", augments={'Blood Pact Dmg.+1','"Fast Cast"+3','Phalanx +4',}},
        hands={ name="Valorous Mitts", augments={'Attack+16','INT+13','Phalanx +5',}},
        legs={ name="Valorous Hose", augments={'INT+7','Mag. Acc.+11','Phalanx +5','Accuracy+14 Attack+14',}},
        feet={ name="Valorous Greaves", augments={'MND+1','INT+10','Phalanx +4','Accuracy+16 Attack+16',}},
        }

    sets.Phalanx = sets.phalanx

    sets.ProtectShellReceived = {
        ring1="Sheltered Ring",
        }

    --sets.Reive = {neck="Ygnas's Resolve +1"}

    sets.Naegling = {main="Naegling", sub="Blurred Shield +1"}
    sets.Chango = {main="Chango", sub="Utu Grip"}
    sets.LoxoticMace = {main="Loxotic Mace +1", sub="Blurred Shield +1"}
    sets.ShiningOne = {main="Shining One", sub="Utu Grip"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.

    if buff == "Mighty Strikes" then
        if gain then
            equip(sets.buff.MightyStrikes)
            disable('feet')
        else
            enable('feet')
            handle_equipping_gear(player.status)
        end
    end

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

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end
    if state.OffenseMode.value == 'SubtleBlow' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'SubtleBlow'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if player.hpp < 71 then
        idleSet = set_combine(idleSet, sets.latent_regen)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
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
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    --th_update(cmdParams, eventArgs)
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if player.equipment.main == "Chango" then
        meleeSet = sets.engaged.Chango
    end
    --if state.TreasureMode.value == 'Fulltime' then
        --meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    --end

    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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
--What is the correct book/page?
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'SAM' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'DRG' then
        set_macro_page(1, 1)
    else
        set_macro_page(1, 1)
    end
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end

