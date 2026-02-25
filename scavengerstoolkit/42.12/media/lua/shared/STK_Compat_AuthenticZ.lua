--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Compat_AuthenticZ.lua
--- @author Scavenger's Toolkit Team
--- @version 1.0.0
---
--- Módulo de compatibilidade STK ↔ AuthenticZ (Backpacks Plus).
---
--- Detecta se o AuthenticZ está ativo e registra todas as suas bags
--- tiered na tabela STK_Constants.BAGS, mapeando para as categorias
--- equivalentes vanilla. Isso permite que o player aplique upgrades
--- STK em qualquer bag upgradeada pelo AZ.
---
--- Fluxo esperado pelo player:
---   1. Remover upgrades STK existentes (se houver).
---   2. Fazer o upgrade AZ (Tier 1 → 2 → 3).
---   3. Aplicar upgrades STK na nova bag tiered.
--- Tentar pular o passo 1 resulta em perda dos upgrades STK — comportamento
--- intencional que evita stacking irrestrito de poder.
---

local STK_API = require("STK_API")
local STK_Logger = require("STK_Logger")

local log = STK_Logger.get("STK-Compat-AuthenticZ")

local Compat = {}

-- ---------------------------------------------------------------------------
-- Detecção
-- ---------------------------------------------------------------------------

--- Retorna true se o AuthenticZ (Backpacks Plus) estiver entre os mods ativos.
--- Usa iteração manual em vez de :contains() porque o caractere '+' no mod ID
--- pode ser tratado como regex por algumas implementações Java do método contains.
--- @return boolean
function Compat.isActive()
	local mods = getActivatedMods()
	for i = 0, mods:size() - 1 do
		if mods:get(i) == "\\AuthenticZBackpacks+" then
			return true
		end
	end
	return false
end

-- ---------------------------------------------------------------------------
-- Mapa de bags
--
-- Formato: { fullType, category }
-- category deve ser uma das chaves válidas do CATEGORY_MAP em STK_API.
--
-- Regra de mapeamento:
--   Schoolbag / Kids Backpack / NBH / CEDA / B4B* (school-sized) → schoolbag
--   Packsport / Spiffo / B4BWalker / B4BHolly (hiking-sized)     → hiking
--   DuffelBag / Medical / Military / Roadside / Festive Duffel    → duffel
--   ALICEpack / SurvivorBag / ARVN Rucksack / B4HARVN            → military
--   Bags de equipamento (webbing, utility belt)                   → ignoradas
--     └─ Capacity muito baixa (2-5), BodyLocation especial, não são mochilas.
-- ---------------------------------------------------------------------------

--- Lista completa de bags AZ tiered com suas categorias STK equivalentes.
--- Cada entrada é { fullType: string, category: string }.
--- @type table<integer, { fullType: string, category: string }>
local AZ_BAGS = {

	-- -------------------------------------------------------------------------
	-- SCHOOLBAG — school-sized backpacks (Capacity ~15-18, WeightReduction ~60-70)
	-- -------------------------------------------------------------------------

	-- Schoolbag vanilla upgradeada
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Tier_3", category = "schoolbag" },

	-- Kids Backpack (Small Backpack)
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Kids_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Kids_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Kids_Tier_3", category = "schoolbag" },

	-- NBH Hazmat Pack
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagNBH_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagNBH_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagNBH_Tier_3", category = "schoolbag" },

	-- CEDA Hazmat Pack (verde)
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDA_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDA_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDA_Tier_3", category = "schoolbag" },

	-- CEDA Hazmat Pack (preto)
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDABlack_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDABlack_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDABlack_Tier_3", category = "schoolbag" },

	-- CEDA Hazmat Pack (vermelho)
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDARed_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDARed_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDARed_Tier_3", category = "schoolbag" },

	-- Back 4 Blood — Mom (school-sized, SoundParameter SchoolBag)
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BMom_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BMom_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BMom_Tier_3", category = "schoolbag" },

	-- Packsport Plain
	{ fullType = "AuthenticZBackpacksPlus.Bag_Packsport_Plain_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Packsport_Plain_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Packsport_Plain_Tier_3", category = "schoolbag" },

	-- Packsport Rim (versão clássica)
	{ fullType = "AuthenticZBackpacksPlus.Bag_Packsport_Rim_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Packsport_Rim_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Packsport_Rim_Tier_3", category = "schoolbag" },

	-- Schoolbag Spiffo 2 (variante Spiffo com alças extras)
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Spiffo2_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Spiffo2_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Schoolbag_Spiffo2_Tier_3", category = "schoolbag" },

	-- CEDA Hazmat Pack (azul)
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDABlue_Tier_1", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDABlue_Tier_2", category = "schoolbag" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SchoolBagCEDABlue_Tier_3", category = "schoolbag" },

	-- -------------------------------------------------------------------------
	-- HIKING — mochilas de trilha (Capacity ~20-25, WeightReduction ~70-80)
	-- -------------------------------------------------------------------------

	-- Hiking Bag vanilla upgradeada
	{ fullType = "AuthenticZBackpacksPlus.Bag_NormalHikingBag_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_NormalHikingBag_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_NormalHikingBag_Tier_3", category = "hiking" },

	-- Big Hiking Bag vanilla upgradeada
	{ fullType = "AuthenticZBackpacksPlus.Bag_BigHikingBag_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_BigHikingBag_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_BigHikingBag_Tier_3", category = "hiking" },

	-- Back 4 Blood — Evangelo (hiking-sized, SoundParameter HikingBag)
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BEvangelo_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BEvangelo_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BEvangelo_Tier_3", category = "hiking" },

	-- Back 4 Blood — Hoffman
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BHoffman_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BHoffman_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BHoffman_Tier_3", category = "hiking" },

	-- Back 4 Blood — Holly (hiking-sized)
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BHolly_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BHolly_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BHolly_Tier_3", category = "hiking" },

	-- Back 4 Blood — Walker
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BWalker_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BWalker_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_B4BWalker_Tier_3", category = "hiking" },

	-- Spiffo Backpack AZ
	{ fullType = "AuthenticZBackpacksPlus.Bag_SpiffoBackpackAZ_Tier_1", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SpiffoBackpackAZ_Tier_2", category = "hiking" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_SpiffoBackpackAZ_Tier_3", category = "hiking" },

	-- -------------------------------------------------------------------------
	-- DUFFEL — sacolas e bolsas (Capacity ~11-21, WeightReduction ~50-65)
	-- -------------------------------------------------------------------------

	-- Duffel Bag vanilla upgradeada (multicolor)
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBag_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBag_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBag_Tier_3", category = "duffel" },

	-- Duffel TINT (branco/claro)
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBagTINT_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBagTINT_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBagTINT_Tier_3", category = "duffel" },

	-- Duffel Grey
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBagGrey_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBagGrey_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBagGrey_Tier_3", category = "duffel" },

	-- Medical Bag (trauma/médica, mesmo porte de duffel)
	{ fullType = "AuthenticZBackpacksPlus.Bag_MedicalBag_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_MedicalBag_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_MedicalBag_Tier_3", category = "duffel" },

	-- Military Duffel (não confundir com ALICEpack — é uma bolsa, não mochila)
	{ fullType = "AuthenticZBackpacksPlus.Bag_Military_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Military_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_Military_Tier_3", category = "duffel" },

	-- Festive Duffel
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBag_Festive_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBag_Festive_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_DuffelBag_Festive_Tier_3", category = "duffel" },

	-- Roadside Duffel (menor, 50% WR)
	{ fullType = "AuthenticZBackpacksPlus.Bag_RoadsideDuffel_Tier_1", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_RoadsideDuffel_Tier_2", category = "duffel" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_RoadsideDuffel_Tier_3", category = "duffel" },

	-- -------------------------------------------------------------------------
	-- MILITARY — mochilas táticas pesadas (Capacity ~28-38, WeightReduction ~85-90)
	-- -------------------------------------------------------------------------

	-- ALICEpack vanilla upgradeada
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Tier_1", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Tier_2", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Tier_3", category = "military" },

	-- ALICEpack Army
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Army_Tier_1", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Army_Tier_2", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Army_Tier_3", category = "military" },

	-- ALICEpack Urban Camo (AZ-exclusive skin)
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_UrbanCamo_Tier_1", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_UrbanCamo_Tier_2", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_UrbanCamo_Tier_3", category = "military" },

	-- ALICEpack Desert Camo
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_DesertCamo_Tier_1", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_DesertCamo_Tier_2", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_DesertCamo_Tier_3", category = "military" },

	-- ALICEpack Festive
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Festive_Tier_1", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Festive_Tier_2", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ALICEpack_Festive_Tier_3", category = "military" },

	-- ARVN Rucksack (integração com Brita's Weapon Pack)
	{ fullType = "AuthenticZBackpacksPlus.Bag_ARVN_Rucksack_Tier_1", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ARVN_Rucksack_Tier_2", category = "military" },
	{ fullType = "AuthenticZBackpacksPlus.Bag_ARVN_Rucksack_Tier_3", category = "military" },

	-- -------------------------------------------------------------------------
	-- IGNORADAS (não registradas)
	-- -------------------------------------------------------------------------
	-- Bag_MilitaryWebbing_AZ / Bag_MilitaryWebbingTightened_AZ
	--   → BodyLocation = webbing, Capacity = 5 — não é mochila, não faz sentido
	--     aceitar upgrades STK de straps/fabric.
	--
	-- Bag_UtilityBeltFront / Bag_UtilityBeltDesert e variantes Loose
	--   → BodyLocation = AZ:TorsoRigPlus2, Capacity = 2 — acessório tático,
	--     não uma bag de carregamento principal.
	--
	-- Bag_ProtonPack_Back
	--   → Prop cosmético, WeightReduction 35% muito baixo, RunSpeedModifier 0.80.
	--     Não é uma mochila de sobrevivência; registrá-la seria estranho.
	--
	-- Bags sem Tier (Bag_ALICEpack_Festive, Bag_ALICEpack_UrbanCamo, etc.)
	--   → São as versões base que o AZ usa como ponto de partida. Já estão
	--     registradas no STK pela tabela principal de bags vanilla AZ-skinned,
	--     ou serão registradas pelo módulo de bags vanilla se relevante.
}

-- ---------------------------------------------------------------------------
-- Aplicação
-- ---------------------------------------------------------------------------

--- Registra todas as bags AZ tiered no STK via STK_API.
--- Chamado pelo CompatManager somente quando isActive() retorna true.
function Compat.apply()
	if not Compat.isActive() then
		return
	end

	local registered = 0
	local skipped = 0

	for _, entry in ipairs(AZ_BAGS) do
		local ok = STK_API.registerBag(entry.fullType, { category = entry.category })
		if ok then
			registered = registered + 1
		else
			-- registerBag já loga warning se o fullType já existia.
			skipped = skipped + 1
		end
	end

	log.info(
		"AuthenticZ compat aplicado: "
			.. registered
			.. " bags registradas"
			.. (skipped > 0 and (", " .. skipped .. " ignoradas (já existiam)") or "")
	)
end

-- ---------------------------------------------------------------------------
-- Boot
-- ---------------------------------------------------------------------------

-- Auto-apply on load. If AuthenticZ is not active, log and do nothing.
if Compat.isActive() then
	Compat.apply()
else
	log.info("AuthenticZ nao detectado — modulo de compat inativo.")
end

return Compat
