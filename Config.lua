--[[
███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ██████╗░░█████╗░██╗░░░██╗███████╗██╗░░░░░████████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔══██╗██╔══██╗██║░░░██║██╔════╝██║░░░░░╚══██╔══╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  ██████╔╝██║░░██║╚██╗░██╔╝█████╗░░██║░░░░░░░░██║░░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══██╗██║░░██║░╚████╔╝░██╔══╝░░██║░░░░░░░░██║░░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░██║╚█████╔╝░░╚██╔╝░░███████╗███████╗░░░██║░░░
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚══════╝╚══════╝░░░╚═╝░░░
--]]
local ROVELT = exports["RO_Lib"]:GetData()
Config = {}
Config.Framework = "QB" -- Options (ESX, QB) | This is just your framework
Config.PrefixCore = "qb-core" -- options (qb-core, es_extended or your own)
Config.InteractKey = "E"

--######################################
--###########    SETTINGS    ###########
--######################################

Config.ViewDistance = 1.5 -- How close you have to be, to see the lab.
Config.Progressbar = "QB" -- Options (ESX, QB, OX, none)
Config.Notify = "QB" -- Options (ESX, QB, OX, RO_Notify)
Config.Target = "qb-target" -- options (ox_target, qb-target, none)
Config.Locks = false
Config.GangOrJob = "gang" -- Options (none, gang, job) If set to none, everyone who knows the code can change it.

Config.Process = {
    weedlab = {
        Targets = {
            ["DRUG1"] = {
                location = vector3(1038.35, -3205.92, -38.24),
                Key = {[1] = "E", [2] = "G"},
                Event = function(id, Targetname, Targetlocation)
                    if Config.Target == "qb-target" or Config.Target == "ox_target" then
                        exports['qb-target']:AddCircleZone(Targetname, Targetlocation, 1.0, 
                        {
                            name="lab-target",
                            debugPoly=false,
                            useZ=true,
                        },{ 
                            options = {
                                { 
                                    action = function()
                                        DoEmote(nil, "weedlab", "DRUG1", 1) 
                                        local progressbar = ROVELT.Functions.progressbar("DRYING WEED", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true)
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "weedlab", 1, "DRUG1")
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-cannabis", 
                                    label = "Dry weed"
                                },
                                { 
                                    action = function()
                                        DoEmote(nil, "weedlab", "DRUG2", 1) 
                                        local progressbar = ROVELT.Functions.progressbar("GRINDING WEED", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true)
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "weedlab", 2, "DRUG1")
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-mortar-pestle", 
                                    label = "Grind weed"
                                }
                            },
                            distance = 2
                        })
                    else
                        if id == 1 then
                            ProgessHeader = "DRYING WEED"
                        elseif id == 2 then
                            ProgessHeader = "GRINDING WEED"
                        end
                        DoEmote(nil, "weedlab", "DRUG1", id) 
                        local progressbar = ROVELT.Functions.progressbar(ProgessHeader, 2500, Config.Progressbar)
                        if progressbar == true then
                            DoEmote(true) 
                            TriggerServerEvent("Rovelt_FreeLab_finish", "weedlab", id, "DRUG1")
                        end
                    end
                end, 
                items = {[1] = {"weed"}, [2] = {"dried_weed"}, [3] = {"weed_baggy"}},
                amount = {[1] = {15, 1, 3}, [2] = {1}, [3] = {2}}, 
                Emotes = {
                    [1] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "bkr_prop_weed_bud_02b", pedbone = 26, xyzPos = {0.10889027484041, 0.0093449200936445, 0.01315924509763}, xyzRot = {3.7627050433705, 45.429811112215, 3.0901459510806}},
                    [2] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "bkr_prop_weed_bud_pruned_01a", pedbone = 26, xyzPos = {0.14608455551081, 0.018633116356107, 0.018676177601705}, xyzRot = {0, 0, 0}}
                },
                TextHeader3D = {{header = "Press [~g~E~w~] to ~g~DRY WEED", Key = "E", ID = 1}, {header = "Press [~g~G~w~] to ~g~GRIND WEED", Key = "G", ID = 2}},
            },
            ["DRUG2"] = {
                location = vector3(1033.77, -3206.18, -38.28),
                Key = {[1] = "E"},
                Event = function(id, Targetname, Targetlocation)
                    if Config.Target == "qb-target" or Config.Target == "ox_target" then
                        exports['qb-target']:AddCircleZone(Targetname, Targetlocation, 1.0, 
                        {
                            name="lab-target",
                            debugPoly=false,
                            useZ=true,
                        },{ 
                            options = {
                                { 
                                    action = function()
                                        DoEmote(nil, "weedlab", "DRUG2", 1) 
                                        local progressbar = ROVELT.Functions.progressbar("ROLLING JOINT", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true) 
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "weedlab", 1)
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-joint", 
                                    label = "Roll joint"
                                }
                            },
                            distance = 2
                        })
                    else
                        if id == 1 then
                            ProgessHeader = "ROLLING JOINT"
                        end
                        DoEmote(nil, "weedlab", "DRUG2", 1) 
                        local progressbar = ROVELT.Functions.progressbar(ProgessHeader, 2500, Config.Progressbar)
                        if progressbar == true then
                            DoEmote(true) 
                            TriggerServerEvent("Rovelt_FreeLab_finish", "weedlab", id, "DRUG2")
                        else
                            DoEmote(true)
                        end
                    end
                end, 
                items = {[1] = {"weed_baggy", "rolling_paper"}, [2] = {"joint"}},
                amount = {[1] = {2, 1}, [2] = {1}}, 
                Emotes = {
                    [1] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "p_amb_joint_01", pedbone = 26, xyzPos = {0.12669119259556, 0.006077651177726, 0.024049449711787},xyzRot = {-9.8081250410206, -61.905959211242, 150.6503048216}}
                },
                TextHeader3D = {{header = "Press [~g~E~w~] to ~g~ROLL JOINT", Key = "E", ID = 1}},
            },
        },
        locations = {
            entry = vector3(1066.35, -3183.58, -39.16),
        }
    },
    cokelab = {
        Targets = {
            ["DRUG1"] = {
                location = vector3(1090.87, -3195.69, -39.2),
                Key = {[1] = "E", [2] = "G"},
                Event = function(id, Targetname, Targetlocation)
                    if Config.Target == "qb-target" or Config.Target == "ox_target" then
                        exports['qb-target']:AddCircleZone(Targetname, Targetlocation, 1.0, 
                        {
                            name="lab-target",
                            debugPoly=false,
                            useZ=true,
                        },{ 
                            options = {
                                { 
                                    action = function()
                                        DoEmote(nil, "cokelab", "DRUG1", 1) 
                                        local progressbar = ROVELT.Functions.progressbar("DRYING LEAVES", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true)
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "cokelab", 1, "DRUG1")
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-pills", 
                                    label = "Dry coca leaves"
                                },
                                { 
                                    action = function()
                                        DoEmote(nil, "cokelab", "DRUG1", 2) 
                                        local progressbar = ROVELT.Functions.progressbar("MIXING CHEMICALS", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true)
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "cokelab", 2, "DRUG1")
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-scissors", 
                                    label = "Mix chemicals"
                                }
                            },
                            distance = 2
                        })
                    else
                        if id == 1 then
                            ProgessHeader = "DRYING LEAVES"
                        elseif id == 2 then
                            ProgessHeader = "MIXING CHEMICALS"
                        end
                        DoEmote(nil, "cokelab", "DRUG1", id) 
                        local progressbar = ROVELT.Functions.progressbar(ProgessHeader, 2500, Config.Progressbar)
                        if progressbar == true then
                            DoEmote(true) 
                            TriggerServerEvent("Rovelt_FreeLab_finish", "cokelab", id, "DRUG1")
                        else
                            DoEmote(true)
                        end
                    end
                end, 
                items = {[1] = {"cocaleaves"}, [2] = {"cocapaste"}, [3] = {"dried_coke"}},
                amount = {[1] = {2}, [2] = {1}, [3] = {1}}, 
                Emotes = {
                    [1] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "bkr_prop_weed_leaf_01a", pedbone = 26, xyzPos = {0.13751806835205, -0.0019809994775792, 0.017777999339682}, xyzRot = {-58.868058490983, 70.044610684278, 64.7999373689}},
                    [2] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "xm3_prop_xm3_bottle_pills_01a", pedbone = 26, xyzPos = {0.097189825594, 0.02609522337513, 0.0024089502503523}, xyzRot = {49.009014646742, 72.462537620957, -60.334924056195}}
                },
                TextHeader3D = {{header = "Press [~g~E~w~] to ~g~DRY COCA LEAVES", Key = "E", ID = 1}, {header = "Press [~g~G~w~] to ~g~MIX CHEMICALS", Key = "G", ID = 2}},
            },
            ["DRUG2"] = {
                location = vector3(1100.57, -3199.42, -39.19),
                Key = {[1] = "E"},
                Event = function(id, Targetname, Targetlocation)
                    if Config.Target == "qb-target" or Config.Target == "ox_target" then
                        exports['qb-target']:AddCircleZone(Targetname, Targetlocation, 1.0, 
                        {
                            name="lab-target",
                            debugPoly=false,
                            useZ=true,
                        },{ 
                            options = {
                                { 
                                    action = function()
                                        DoEmote(nil, "cokelab", "DRUG2", 1) 
                                        local progressbar = ROVELT.Functions.progressbar("PACKING COKE", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true) 
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "cokelab", 1, "DRUG2")
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-boxes-packing", 
                                    label = "Pack coke"
                                }
                            },
                            distance = 2
                        })
                    else
                        if id == 1 then
                            ProgessHeader = "PACKING COKE"
                        end
                        DoEmote(nil, "cokelab", "DRUG2", 1) 
                        local progressbar = ROVELT.Functions.progressbar(ProgessHeader, 2500, Config.Progressbar)
                        if progressbar == true then
                            DoEmote(true) 
                            TriggerServerEvent("Rovelt_FreeLab_finish", "cokelab", id, "DRUG2")
                        else
                            DoEmote(true)
                        end
                    end
                end, 
                items = {[1] = {"dried_coke",}, [2] = {"coke"}},
                amount = {[1] = {1}, [2] = {10}}, 
                Emotes = {
                    [1] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "p_meth_bag_01_s", pedbone = 26, xyzPos = {0.13582229233282, -0.022461251888973, 0.068103997538365}, xyzRot = {0, 0, 68.50727370921}}
                },
                TextHeader3D = {{header = "Press [~g~E~w~] to ~g~PACK COKE", Key = "E", ID = 1}},
            },
        },
        locations = {
            entry = vector3(1088.59, -3187.56, -38.99),
        }
    },
    methlab = {
        Targets = {
            ["DRUG1"] = {
                location = vector3(1005.73, -3200.4, -38.52),
                Key = {[1] = "E"},
                Event = function(id, Targetname, Targetlocation)
                    if Config.Target == "qb-target" or Config.Target == "ox_target" then
                        exports['qb-target']:AddCircleZone(Targetname, Targetlocation, 1.0, 
                        {
                            name="lab-target",
                            debugPoly=false,
                            useZ=true,
                        },{ 
                            options = {
                                { 
                                    action = function()
                                        DoEmote(nil, "methlab", "DRUG1", id) 
                                        local progressbar = ROVELT.Functions.progressbar("MIXING CHEMICALS", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true) 
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "methlab", 1, "DRUG1")
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-flask", 
                                    label = "Mix Chemicals"
                                },
                            },
                            distance = 2
                        })
                    else
                        DoEmote(nil, "methlab", "DRUG1", id) 
                        local progressbar = ROVELT.Functions.progressbar("MIXING CHEMICALS", 2500, Config.Progressbar)
                        if progressbar == true then
                            DoEmote(true) 
                            TriggerServerEvent("Rovelt_FreeLab_finish", "methlab", id, "DRUG1")
                        else
                            DoEmote(true)
                        end
                    end
                end, 
                items = {[1] = {"pseudoephedrine", "drain_cleaner"}, [2] = {"methcrystal"}},
                amount = {[1] = {10, 10}, [2] = {1}}, 
                Emotes = {
                    [1] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "xm3_prop_xm3_bottle_pills_01a", pedbone = 26, xyzPos = {0.097189825594, 0.02609522337513, 0.0024089502503523}, xyzRot = {49.009014646742, 72.462537620957, -60.334924056195}}
                },
                TextHeader3D = {{header = "Press [~g~E~w~] to ~g~MIX CHEMICALS", Key = "E", ID = 1}},
            },
            ["DRUG2"] = {
                location = vector3(1011.93, -3194.27, -39.19),
                Key = {[1] = "E", [2] = "G"},
                Event = function(id, Targetname, Targetlocation)
                    if Config.Target == "qb-target" or Config.Target == "ox_target" then
                        exports['qb-target']:AddCircleZone(Targetname, Targetlocation, 1.0, 
                        {
                            name="lab-target",
                            debugPoly=false,
                            useZ=true,
                        },{ 
                            options = {
                                { 
                                    action = function()
                                        DoEmote(nil, "methlab", "DRUG2", 1) 
                                        local progressbar = ROVELT.Functions.progressbar("CRACKING METH TRAY", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true) 
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "methlab", 1)
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-hammer", 
                                    label = "Crack methtray"
                                },
                                { 
                                    action = function()
                                        DoEmote(nil, "methlab", "DRUG2", 2) 
                                        local progressbar = ROVELT.Functions.progressbar("PACKING METH", 5000, Config.Progressbar)
                                        if progressbar == true then
                                            DoEmote(true) 
                                            TriggerServerEvent("Rovelt_FreeLab_finish", "methlab", 2)
                                        else
                                            DoEmote(true)
                                        end
                                    end, 
                                    icon = "fa-solid fa-box-open", 
                                    label = "Pack meth"
                                }
                            },
                            distance = 2
                        })
                    else
                        if id == 1 then
                            ProgessHeader = "CRACKING METHTRAY"
                        elseif id == 2 then
                            ProgessHeader = "PACKING METH"
                        end
                        DoEmote(nil, "methlab", "DRUG2", id) 
                        local progressbar = ROVELT.Functions.progressbar(ProgessHeader, 2500, Config.Progressbar)
                        if progressbar == true then
                            DoEmote(true) 
                            TriggerServerEvent("Rovelt_FreeLab_finish", "methlab", id, "DRUG2")
                        else
                            DoEmote(true)
                        end
                    end
                end, 
                items = {[1] = {"methcrystal",}, [2] = {"cracked_meth"}, [3] = {"meth"}},
                amount = {[1] = {1}, [2] = {1}, [3] = {1}}, 
                Emotes = {
                    [1] = {EmoteDict = nil, EmoteName = "WORLD_HUMAN_HAMMERING", prop = "p_amb_joint_01", pedbone = 26, xyzPos = {0.12669119259556, 0.006077651177726, 0.024049449711787},xyzRot = {-9.8081250410206, -61.905959211242, 150.6503048216}},
                    [2] = {EmoteDict = "missheistdockssetup1clipboard@base", EmoteName = "base", prop = "p_meth_bag_01_s", pedbone = 26, xyzPos = {0.13582229233282, -0.022461251888973, 0.068103997538365}, xyzRot = {0, 0, 68.50727370921}}
                },
                TextHeader3D = {{header = "Press [~g~E~w~] to ~g~CRACK METHTRAY", Key = "E", ID = 1},{header = "Press [~g~G~w~] to ~g~PACK METH", Key = "G", ID = 2}},
            },
        },
        locations = {
            entry = vector3(996.88, -3200.79, -36.39),
        }
    },
}

Config.Labs = {
    [1] = {
        pos = vector3(-701.12, -2241.25, 4.9), 
        Code = 1234, 
        Lab = "weedlab", 
        GangOrJob = "families"
    },
    [2] = {
        pos = vector3(-712.93, -2235.48, 5.94), 
        Code = 1234, 
        Lab = "cokelab", 
        GangOrJob = "ballas"
    },
    [3] = {
        pos = vector3(-724.59, -2235.48, 5.94), 
        Code = 1234, 
        Lab = "methlab", 
        GangOrJob = "police"
    },
}

--######################################
--###########    KEYBINDS    ###########
--######################################
Keybinds = {
    ["ESC"]       = 322,  ["F1"]        = 288,  ["F2"]        = 289,  ["F3"]        = 170,  ["F5"]  = 166,  ["F6"]  = 167,  ["F7"]  = 168,  ["F8"]  = 169,  ["F9"]  = 56,   ["F10"]   = 57, 
    ["~"]         = 243,  ["1"]         = 157,  ["2"]         = 158,  ["3"]         = 160,  ["4"]   = 164,  ["5"]   = 165,  ["6"]   = 159,  ["7"]   = 161,  ["8"]   = 162,  ["9"]     = 163,  ["-"]   = 84,   ["="]     = 83,   ["BACKSPACE"]   = 177, 
    ["TAB"]       = 37,   ["Q"]         = 44,   ["W"]         = 32,   ["E"]         = 38,   ["R"]   = 45,   ["T"]   = 245,  ["Y"]   = 246,  ["U"]   = 303,  ["P"]   = 199,  ["["]     = 116,  ["]"]   = 40,   ["ENTER"]   = 18,
    ["CAPS"]      = 137,  ["A"]         = 34,   ["S"]         = 8,    ["D"]         = 9,    ["F"]   = 23,   ["G"]   = 47,   ["H"]   = 74,   ["K"]   = 311,  ["L"]   = 182,
    ["LEFTSHIFT"] = 21,   ["Z"]         = 20,   ["X"]         = 73,   ["C"]         = 26,   ["V"]   = 0,    ["B"]   = 29,   ["N"]   = 249,  ["M"]   = 244,  [","]   = 82,   ["."]     = 81,
    ["LEFTCTRL"]  = 36,   ["LEFTALT"]   = 19,   ["SPACE"]     = 22,   ["RIGHTCTRL"] = 70, 
    ["HOME"]      = 213,  ["PAGEUP"]    = 10,   ["PAGEDOWN"]  = 11,   ["DELETE"]    = 178,
    ["LEFT"]      = 174,  ["RIGHT"]     = 175,  ["UP"]        = 27,   ["DOWN"]      = 173,
    ["NENTER"]    = 201,  ["N4"]        = 108,  ["N5"]        = 60,   ["N6"]        = 107,  ["N+"]  = 96,   ["N-"]  = 97,   ["N7"]  = 117,  ["N8"]  = 61,   ["N9"]  = 118
}
