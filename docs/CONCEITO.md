# Scavenger's Toolkit
## Conceito Geral

**Nome Oficial**: Scavenger's Toolkit  
**Tagline**: *"Dismantle, salvage, and upgrade containers in the apocalypse. No bag left behind."*  
**Versão Atual**: v0.10.1 (Unreleased)  
**Última Atualização**: 16 de Fevereiro de 2026  
**Status**: ✅ **100% IMPLEMENTADO** - Production Ready

---

## 🎯 Visão Geral

Um mod realista para Project Zomboid que permite desmontar mochilas encontradas no mundo e usar suas peças para criar upgrades, melhorando outras mochilas através do sistema de costura.

### Filosofia de Design
- **Realismo**: Aproveitar cada recurso disponível no apocalipse
- **Simplicidade**: Sistema intuitivo baseado em crafting vanilla
- **Progressão**: Requer skill de Tailoring, upgrades melhores precisam mais habilidade
- **Escolhas**: Usar mochila como está OU desmontar para componentes
- **Qualidade**: Código modular, documentado e extensível via hooks

---

## 📦 Componentes do Mod

### Upgrades de Mochila

| Componente | Tier | Weight Reduction | Capacity | Recipe Source |
|------------|------|------------------|----------|---------------|
| **Backpack Straps** (Alças) | | | | |
| `STK.BackpackStrapsBasic` | Basic | +5% | - | Disassemble |
| `STK.BackpackStrapsReinforced` | Reinforced | +10% | - | Disassemble / Upgrade |
| `STK.BackpackStrapsTactical` | Tactical | +15% | - | Upgrade |
| **Backpack Fabric** (Tecido) | | | | |
| `STK.BackpackFabricBasic` | Basic | - | +3 | Disassemble |
| `STK.BackpackFabricReinforced` | Reinforced | - | +5 | Disassemble / Upgrade |
| `STK.BackpackFabricTactical` | Tactical | - | +8 | Upgrade |
| **Belt Buckle** (Fivela) | | | | |
| `STK.BeltBuckleReinforced` | Reinforced | +10% | - | Componente auxiliar |

**Pesos dos Componentes:**
- Straps: 0.3 kg cada
- Fabric: 0.5 kg cada
- Belt Buckle: 0.1 kg

---

## 🔧 Sistemas Implementados

### ✅ 1. Sistema Core de Upgrades
- Adicionar upgrades via menu de contexto (clique direito)
- Remover upgrades com validação de ferramentas
- Persistência via ModData (`LStraps`, `LFabric`, `LBuckle`)
- Validação progressiva (ferramentas → materiais → skill)
- Tooltips dinâmicos mostrando stats

### ✅ 2. Container Limits (v0.10.1 Otimizado)
Limites de upgrades por tipo de mochila:

| Mochila | Limite Padrão |
|---------|---------------|
| FannyPack | 1 upgrade |
| Satchel | 2 upgrades |
| Schoolbag | 3 upgrades |
| HikingBag | 2 upgrades |
| BigHikingBag | 2 upgrades |
| DuffelBag | 2 upgrades |
| MedicalBag | 2 upgrades |
| **Default** (não listado) | 3 upgrades |

**Otimização v0.10.1**: Sistema de tracking com weak table para evitar re-processamento e spam de logs.

### ✅ 3. Tailoring XP System (Regressivo)
- **XP Base**: 2.0 XP ao adicionar upgrade
- **Redução por Nível**: -0.2 XP por nível de Tailoring
- **XP Mínimo**: 0.2 XP (nível 10)
- **Fórmula**: `XP = max(0.2, 2.0 - (nível × 0.2))`
- **Feedback Visual**: HaloTextHelper com popup verde (+X.X Tailoring)

### ✅ 4. Removal Failure System
- **Chance Base de Falha**: 50% (nível 0)
- **Redução por Nível**: -5% por nível de Tailoring
- **Chance Nível 10**: 0% (sempre sucesso)
- **Falha**: Material destruído (não retorna item)
- **Sucesso**: Material recuperado normalmente
- **Feedback Visual**: HaloTextHelper com popup vermelho

### ✅ 5. Knife Alternative
- **9 tipos de facas** aceitas como alternativa à tesoura:
  - Kitchen Knife, Hunting Knife, Butter Knife, Multitool, Pocket Knife, Fillet Knife, Butterfly Knife, Utility Knife, Straight Razor
- **Desgaste** de ferramenta ao usar
- **Opcional**: Ativável/desativável via Sandbox (default: OFF)

### ✅ 6. Feedback System Humanizado (EXCLUSIVO)
- **17+ mensagens contextuais** em PT-BR + EN
- **Categorias**:
  - `AddSuccess` (4 variações)
  - `AddFailed` (3 variações)
  - `RemoveFailed` (6 variações)
  - `RemoveExpert` (3 variações)
- **Silencioso**: Zumbis não ouvem (`SilentSpeaker`)
- **Anti-spam**: Controle de frequência por categoria
- **Opcional**: Pode ser desativado sem quebrar outras features

### ✅ 7. Hook System v0.10.1 (EXCLUSIVO)
- **9 hooks disponíveis** com prioridades configuráveis
- **Prioridades**: VERY_HIGH (25), HIGH (40), NORMAL (50), LOW (75)
- **Hooks**:
  - `beforeInitBag`, `afterInitBag`
  - `beforeAdd`, `afterAdd`, `onAddFailed`
  - `beforeRemove`, `afterRemove`, `onRemoveFailed`
  - `checkRemoveTools`
- **Features desacopladas**: Fácil adicionar/remover sem modificar core

---

## 📜 Receitas Implementadas

### Disassemble Recipes (Reciclagem)

| Receita | Input | Output | Tempo | XP |
|---------|-------|--------|-------|-----|
| **Disassemble Schoolbag** | 1x Schoolbag + Tesoura | 2x Straps Basic + 1x Fabric Basic | 100s | 2.0 |
| **Disassemble FannyPack** | 1x FannyPack + Tesoura | 1x Straps Basic + 1x Fabric Basic | 80s | 2.0 |
| **Disassemble Satchel** | 1x Satchel + Tesoura | 1x Straps Basic + 1x Fabric Basic | 100s | 2.0 |
| **Disassemble HikingBag** | 1x HikingBag + Tesoura | 2x Straps Reinforced + 1x Fabric Reinforced | 150s | 5.0 |
| **Disassemble DuffelBag** | 1x DuffelBag + Tesoura | 2x Straps Reinforced + 1x Fabric Reinforced | 150s | 5.0 |

### Upgrade Recipes (Crafting)

| Receita | Input | Output | Tempo | XP |
|---------|-------|--------|-------|-----|
| **Upgrade Straps → Tactical** | 2x Straps Reinforced + 1x Needle + 1x Thread + 1x Leather Strips | 1x Straps Tactical | 200s | 8.0 |
| **Upgrade Fabric → Tactical** | 2x Fabric Reinforced + 1x Needle + 1x Thread + 1x Denim Strips | 1x Fabric Tactical | 200s | 8.0 |

---

## ⚙️ Opções de Sandbox (12 Opções)

### Container Limits
- `STK.FannyPackLimit` (default: 1, range: 0-5)
- `STK.SatchelLimit` (default: 2, range: 0-5)
- `STK.SchoolbagLimit` (default: 3, range: 0-6)

### Upgrade Values
- `STK.StrapsBasicBonus` (default: 5%, range: 1-50%)
- `STK.StrapsReinforcedBonus` (default: 10%, range: 1-50%)
- `STK.StrapsTacticalBonus` (default: 15%, range: 1-50%)
- `STK.FabricBasicBonus` (default: +3, range: 1-20)
- `STK.FabricReinforcedBonus` (default: +5, range: 1-20)
- `STK.FabricTacticalBonus` (default: +8, range: 1-20)
- `STK.BeltBuckleBonus` (default: 10%, range: 1-50%)

### Tailoring System
- `STK.TailoringEnabled` (default: ON)
- `STK.TailoringModifier` (default: 10, range: 0-20)

### Knife Alternative
- `STK.KnifeAlternative` (default: OFF)

### Crafting Time
- `STK.AddUpgradeTime` (default: 100s, range: 10-500)
- `STK.RemoveUpgradeTime` (default: 80s, range: 10-500)

### XP System
- `STK.TailoringXPEnabled` (default: ON)
- `STK.AddUpgradeXP` (default: 2.0, range: 0-10)
- `STK.XPReductionPerLevel` (default: 20%, range: 0-100%)
- `STK.MinimumXP` (default: 20%, range: 0-200%)

### Failure System
- `STK.RemovalFailureEnabled` (default: ON)
- `STK.BaseFailureChance` (default: 50%, range: 0-100%)
- `STK.FailureReductionPerLevel` (default: 5%, range: 0-10%)

---

## 🏗️ Arquitetura Técnica

### Estrutura de Arquivos
```
42.12/media/
├── sandbox-options.txt (12 opções configuráveis)
├── lua/
│   ├── client/
│   │   ├── OnInventoryContextMenu_STK.lua    # Menu de contexto
│   │   └── ToolTipInvOverride_STK.lua        # Tooltips dinâmicos
│   ├── shared/
│   │   ├── STKBagUpgrade.lua                 # Core + Hook System
│   │   ├── STK_ContainerLimits.lua           # Limites por bag (v2.0)
│   │   ├── STK_TailoringXP.lua               # XP regressivo + falha
│   │   ├── STK_KnifeAlternative.lua          # Facas alternativas
│   │   ├── STK_FeedbackSystem.lua            # Feedback humanizado
│   │   ├── STK_SilentSpeaker.lua             # Falas silenciosas
│   │   └── TimedActions/
│   │       └── ISSTKBagUpgradeAction.lua     # Ações de crafting
│   └── server/
├── scripts/
│   ├── items/
│   │   └── STK_Items.txt                     # Definição dos itens
│   └── recipes/
│       └── STK_Recipes.txt                   # 7 receitas
└── textures/
    ├── Item_BackpackStraps*.png
    ├── Item_BackpackFabric*.png
    └── Item_BeltBuckleReinforced.png
```
*Documento atualizado em 16 de Fevereiro de 2026 - STK v0.10.1*
