# Componentes do Sistema de Reciclagem

**Versão**: STK v0.10.1  
**Última Atualização**: 16 de Fevereiro de 2026  
**Status**: ✅ **100% IMPLEMENTADO**

---

## Componentes Básicos (v1.0 - Implementados)

### 1. Backpack Straps (Alças de Mochila)
**Fonte**: Desmontagem de mochilas  
**Uso**: Melhorar conforto (weight reduction)  
**Namespace**: `STK.BackpackStraps*`

| Qualidade | Obtido de | Weight Reduction | Tailoring Req | Recipe |
|-----------|-----------|------------------|---------------|--------|
| **Basic** | Schoolbag, FannyPack, Satchel | +5% | - | Disassemble |
| **Reinforced** | HikingBag, DuffelBag | +10% | - | Disassemble / Upgrade |
| **Tactical** | Crafting | +15% | - | Upgrade Recipe |

**Propriedades do Item**:
```lua
Type             = Normal
Weight           = 0.3
DisplayCategory  = Material
Icon             = BackpackStrapsBasic/Reinforced/Tactical
WorldStaticModel = BackpackStraps_Ground
```

**Valores Configuráveis (Sandbox)**:
- `STK.StrapsBasicBonus`: 5% (1-50%)
- `STK.StrapsReinforcedBonus`: 10% (1-50%)
- `STK.StrapsTacticalBonus`: 15% (1-50%)

---

### 2. Backpack Fabric (Tecido de Mochila)
**Fonte**: Desmontagem de mochilas  
**Uso**: Aumentar capacidade  
**Namespace**: `STK.BackpackFabric*`

| Qualidade | Obtido de | Capacity Bonus | Tailoring Req | Recipe |
|-----------|-----------|----------------|---------------|--------|
| **Basic** | Schoolbag, FannyPack, Satchel | +3 | - | Disassemble |
| **Reinforced** | HikingBag, DuffelBag | +5 | - | Disassemble / Upgrade |
| **Tactical** | Crafting | +8 | - | Upgrade Recipe |

**Propriedades do Item**:
```lua
Type             = Normal
Weight           = 0.5
DisplayCategory  = Material
Icon             = BackpackFabricBasic/Reinforced/Tactical
WorldStaticModel = BackpackFabric*_Ground
```

**Valores Configuráveis (Sandbox)**:
- `STK.FabricBasicBonus`: +3 (1-20)
- `STK.FabricReinforcedBonus`: +5 (1-20)
- `STK.FabricTacticalBonus`: +8 (1-20)

---

### 3. Belt Buckle Reinforced (Fivela de Cinto Reforçada)
**Fonte**: Crafting (componente auxiliar)  
**Uso**: Weight reduction bonus  
**Namespace**: `STK.BeltBuckleReinforced`

| Qualidade | Weight Reduction | Tailoring Req |
|-----------|------------------|---------------|
| **Reinforced** | +10% | - |

**Propriedades do Item**:
```lua
Type             = Normal
Weight           = 0.1
DisplayCategory  = Material
Icon             = BeltBuckleReinforced
WorldStaticModel = BeltBuckleReinforced_Ground
```

**Valores Configuráveis (Sandbox)**:
- `STK.BeltBuckleBonus`: 10% (1-50%)

---

## 📜 Receitas de Disassemble

### Tier 1 - Mochilas Básicas

| Container | Componentes | Quantidade Total | Tempo | XP Award |
|-----------|-------------|------------------|-------|----------|
| **Schoolbag** | Straps Basic + Fabric Basic | 2 + 1 = 3 | 100s | 2.0 Tailoring |
| **FannyPack** | Straps Basic + Fabric Basic | 1 + 1 = 2 | 80s | 2.0 Tailoring |
| **Satchel** | Straps Basic + Fabric Basic | 1 + 1 = 2 | 100s | 2.0 Tailoring |

### Tier 2 - Mochilas Médias/Grandes

| Container | Componentes | Quantidade Total | Tempo | XP Award |
|-----------|-------------|------------------|-------|----------|
| **HikingBag** | Straps Reinforced + Fabric Reinforced | 2 + 1 = 3 | 150s | 5.0 Tailoring |
| **BigHikingBag** | Straps Reinforced + Fabric Reinforced | 2 + 1 = 3 | 150s | 5.0 Tailoring |
| **DuffelBag** | Straps Reinforced + Fabric Reinforced | 2 + 1 = 3 | 150s | 5.0 Tailoring |

**Requisitos Comuns**:
- 1x Scissors (não consome, verifica sharpness)
- Tailoring 2+ (Tier 1) ou 5+ (Tier 2) recomendado

---

## 🔧 Receitas de Upgrade

### Upgrade de Tier (Reinforced → Tactical)

| Receita | Inputs | Output | Tempo | XP Award |
|---------|--------|--------|-------|----------|
| **Upgrade Straps** | 2x Straps Reinforced + 1x Needle + 1x Thread + 1x Leather Strips | 1x Straps Tactical | 200s | 8.0 Tailoring |
| **Upgrade Fabric** | 2x Fabric Reinforced + 1x Needle + 1x Thread + 1x Denim Strips | 1x Fabric Tactical | 200s | 8.0 Tailoring |

**Requisitos**:
- 1x Needle (não consome)
- 1x Thread (consome)
- 1x Material especial (Leather/Denim Strips)
- Tailoring 8+ recomendado

---

## ⚙️ Sistema de Limites por Container

Cada tipo de mochila tem um limite máximo de upgrades que pode receber:

| Tipo de Mochila | Limite de Upgrades |
|-----------------|-------------------|
| FannyPack | 1 |
| Satchel | 2 |
| Schoolbag | 3 |
| HikingBag | 2 |
| BigHikingBag | 2 |
| DuffelBag | 2 |
| MedicalBag | 2 |
| **Default** (não listado) | 3 |

**Configurável via Sandbox**:
- `STK.FannyPackLimit` (0-5)
- `STK.SatchelLimit` (0-5)
- `STK.SchoolbagLimit` (0-6)

**Otimização v0.10.1**: Sistema de tracking com weak table evita re-processamento e spam de logs.

---

## 📊 Tabela de Rendimento Completo

### Desmontagem → Componentes → Upgrades

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO DE RECICLAGEM                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Mochila Velha                                                  │
│     │                                                           │
│     ▼ (Disassemble)                                             │
│                                                                 │
│  ┌─────────────────┐  ┌─────────────────┐                       │
│  │ Straps Basic    │  │ Fabric Basic    │                       │
│  │ (+5% weight)    │  │ (+3 capacity)   │                       │
│  └─────────────────┘  └─────────────────┘                       │
│         │                      │                                 │
│         │ (Upgrade Recipe)       │ (Upgrade Recipe)              │
│         ▼                      ▼                                 │
│  ┌─────────────────┐  ┌─────────────────┐                       │
│  │ Straps Tactical │  │ Fabric Tactical │                       │
│  │ (+15% weight)   │  │ (+8 capacity)   │                       │
│  └─────────────────┘  └─────────────────┘                       │
│         │                      │                                 │
│         └──────────┬───────────┘                                 │
│                    ▼                                              │
│           Mochila Melhorada                                      │
│           (Capacity + Weight Reduction)                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Exemplo Prático

**Cenário**: 2x Schoolbag encontradas

```
Opção A: Usar como está
  → 1x Schoolbag (25 capacity, 0% reduction)

Opção B: Desmontar + Upgrade
  → Desmonta 1x Schoolbag
  → 2x Straps Basic + 1x Fabric Basic
  → Aplica na outra Schoolbag
  → Schoolbag (25+3+3+3 = 34 capacity, 5+5+5 = 15% weight reduction)
```

---

## 🎯 Regras de Design (Implementadas)

### Condição do Item
- **Requisito**: Item precisa estar em condição razoável (>30%)
- **Verificação**: `item:getCondition() > item:getConditionMax() * 0.3`

### Ferramentas Necessárias
- **Tesoura**: Requerida para disassemble
  - Não consome, mas verifica `Sharpness` e `IsNotDull`
  - Alternativa: 9 tipos de facas (opcional via Sandbox)
- **Agulha + Linha**: Requeridas para upgrade
  - Agulha não consome
  - Linha consome 1 unidade

### Balanceamento
- **Componentes valem MENOS** que item original
- **Incentivo**: 1 item ruim + componentes = 1 item melhorado
- **Escolha difícil**: "Uso essa segunda hiking bag ou desmonto?"

### Peso dos Componentes
```
School Bag (1.5kg)
  → Straps Basic (0.3kg) + Fabric Basic (0.5kg) = 0.8kg total
  → Perda de 0.7kg = realismo da desmontagem
```

---

## 📦 Expansões Futuras (Post v1.0)

### Componentes Avançados (v2.0 - Planejado)
- **Frame/Estrutura**: Para mochilas grandes, +durabilidade
- **Padding/Acolchoamento**: Redução de fadiga ao carregar peso
- **Waterproof Liner**: Proteção contra chuva para itens dentro
- **Modular Attachment Points**: Base para sistema de slots customizados

### Componentes de Vestuário (v3.0? - Conceito)
- Desmontar coletes, jaquetas com bolsos
- Transferir proteção de um item para outro
- Sistema mais complexo (fora do escopo atual)

---

## 🔗 Referências Rápidas

### Arquivos de Definição
- **Itens**: `scavengerstoolkit/42.12/media/scripts/items/STK_Items.txt`
- **Receitas**: `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`
- **Sandbox**: `scavengerstoolkit/42.12/media/sandbox-options.txt`

### Texturas
- `Item_BackpackStrapsBasic.png`
- `Item_BackpackStrapsReinforced.png`
- `Item_BackpackStrapsTactical.png`
- `Item_BackpackFabricBasic.png`
- `Item_BackpackFabricReinforced.png`
- `Item_BackpackFabricTactical.png`
- `Item_BeltBuckleReinforced.png`

### World Models
- `BackpackStraps_Ground`
- `BackpackFabricBasic_Ground`
- `BackpackFabricReinforced_Ground`
- `BackpackFabricTactical_Ground`
- `BeltBuckleReinforced_Ground`

---

*Documento atualizado em 16 de Fevereiro de 2026 - STK v0.10.1*
