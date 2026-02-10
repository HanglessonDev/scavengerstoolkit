# Receitas do Mod - Backpack Recycling

## Categoria 1: Desmontagem (Disassembly)

### R001 - Disassemble School Bag
```
Input: Bag_SchoolBag (condition > 30%)
Output: 
  - Basic Straps x1
  - Basic Fabric x1
Time: 30 min
Skill: Tailoring 2
Tools: Needle (not consumed)
Sound: ClothesRipping
```

### R002 - Disassemble Fanny Pack
```
Input: Fanny Pack
Output: Quick-Access Pouch x1
Time: 20 min
Skill: Tailoring 2
Tools: Needle
```

### R003 - Disassemble Tote Bag
```
Input: Tote Bag
Output: Basic Fabric x2
Time: 25 min
Skill: Tailoring 2
Tools: Needle
```

### R004 - Disassemble Satchel
```
Input: Bag_Satchel
Output:
  - Basic Straps x1
  - Basic Fabric x1
Time: 30 min
Skill: Tailoring 2
Tools: Needle
```

### R005 - Disassemble Normal Hiking Bag
```
Input: Bag_NormalHikingBag (condition > 40%)
Output:
  - Reinforced Straps x1
  - Durable Fabric x1
  - Buckles x2
Time: 45 min
Skill: Tailoring 4
Tools: Needle
```

### R006 - Disassemble Duffel Bag
```
Input: Bag_DuffelBag
Output:
  - Durable Fabric x2
  - Buckles x2
Time: 40 min
Skill: Tailoring 4
Tools: Needle
```

### R007 - Disassemble Big Hiking Bag
```
Input: Bag_BigHikingBag (condition > 50%)
Output:
  - Reinforced Straps x1
  - Durable Fabric x2
  - Buckles x3
Time: 60 min
Skill: Tailoring 5
Tools: Needle
```

### R008 - Disassemble ALICE Pack
```
Input: Bag_ALICEpack (condition > 50%)
Output:
  - Military Straps x1
  - Tactical Fabric x2
  - Heavy Buckles x4
Time: 90 min
Skill: Tailoring 6
Tools: Needle
```

### R009 - Disassemble Hydration Pack
```
Input: Hydration Pack
Output:
  - Hydration System x1
  - Basic Fabric x1
Time: 35 min
Skill: Tailoring 3
Tools: Needle
```

### R010 - Disassemble Cloth Gun Case
```
Input: Cloth Gun Case
Output: Basic Fabric x2
Time: 25 min
Skill: Tailoring 2
Tools: Needle
```

### R011 - Disassemble Shoulder Holster
```
Input: Holster_Shoulder
Output: Quick-Access Pouch x1
Time: 20 min
Skill: Tailoring 2
Tools: Needle
```

### R012 - Disassemble Bullets Bandolier
```
Input: Bullets Bandolier
Output: Quick-Access Pouch x1
Time: 20 min
Skill: Tailoring 2
Tools: Needle
```

---

## Categoria 2: Upgrades - Capacidade (Capacity Focus)

### R101 - Reinforce School Bag (Capacity)
```
Input:
  - Bag_SchoolBag
  - Basic Fabric x2
  - Thread x2
Output: Bag_SchoolBag_Reinforced
  (Capacity: 15 → 18, WeightRed: 70%)
Time: 60 min
Skill: Tailoring 3
Tools: Needle
OnGiveXP: Tailoring_15
```

### R102 - Expand Satchel
```
Input:
  - Bag_Satchel
  - Basic Fabric x1
  - Thread x1
Output: Bag_Satchel_Expanded
  (Capacity: 10 → 13, WeightRed: 60%)
Time: 50 min
Skill: Tailoring 3
Tools: Needle
OnGiveXP: Tailoring_12
```

### R103 - Enhance Hiking Bag (Capacity)
```
Input:
  - Bag_NormalHikingBag
  - Durable Fabric x2
  - Buckles x2
  - Thread x3
Output: Bag_HikingBag_Enhanced
  (Capacity: 20 → 24, WeightRed: 75%)
Time: 90 min
Skill: Tailoring 5
Tools: Needle
OnGiveXP: Tailoring_25
```

### R104 - Expand Purse
```
Input:
  - Purse
  - Basic Fabric x1
  - Quick-Access Pouch x1
  - Thread x2
Output: Purse_Expanded
  (Capacity: 6 → 9, WeightRed: 85%)
Time: 45 min
Skill: Tailoring 3
Tools: Needle
OnGiveXP: Tailoring_10
```

---

## Categoria 3: Upgrades - Conforto (Weight Reduction Focus)

### R201 - Reinforce School Bag (Comfort)
```
Input:
  - Bag_SchoolBag
  - Basic Straps x2
  - Thread x2
Output: Bag_SchoolBag_Comfortable
  (Capacity: 15, WeightRed: 70% → 78%)
Time: 60 min
Skill: Tailoring 3
Tools: Needle
OnGiveXP: Tailoring_15
```

### R202 - Upgrade Hiking Bag (Comfort)
```
Input:
  - Bag_NormalHikingBag
  - Reinforced Straps x1
  - Thread x2
Output: Bag_HikingBag_Comfortable
  (Capacity: 20, WeightRed: 75% → 83%)
Time: 75 min
Skill: Tailoring 4
Tools: Needle
OnGiveXP: Tailoring_20
```

### R203 - Optimize Duffel Bag
```
Input:
  - Bag_DuffelBag
  - Reinforced Straps x2
  - Buckles x2
  - Thread x3
Output: Bag_DuffelBag_Optimized
  (Capacity: 22, WeightRed: 60% → 70%)
Time: 80 min
Skill: Tailoring 5
Tools: Needle
OnGiveXP: Tailoring_22
```

---

## Categoria 4: Upgrades Híbridos (Balanced)

### R301 - Tactical School Bag
```
Input:
  - Bag_SchoolBag
  - Basic Straps x1
  - Basic Fabric x1
  - Quick-Access Pouch x1
  - Thread x3
Output: Bag_SchoolBag_Tactical
  (Capacity: 15 → 17, WeightRed: 70% → 75%)
Time: 90 min
Skill: Tailoring 4
Tools: Needle
OnGiveXP: Tailoring_20
```

### R302 - Professional Satchel
```
Input:
  - Bag_Satchel
  - Basic Straps x1
  - Basic Fabric x1
  - Thread x2
Output: Bag_Satchel_Professional
  (Capacity: 10 → 12, WeightRed: 60% → 65%)
Time: 70 min
Skill: Tailoring 4
Tools: Needle
OnGiveXP: Tailoring_18
```

### R303 - Advanced Hiking Bag
```
Input:
  - Bag_NormalHikingBag
  - Reinforced Straps x1
  - Durable Fabric x1
  - Buckles x3
  - Thread x4
Output: Bag_HikingBag_Advanced
  (Capacity: 20 → 23, WeightRed: 75% → 80%)
Time: 120 min
Skill: Tailoring 6
Tools: Needle
OnGiveXP: Tailoring_30
```

### R304 - Hydration Hiking Bag
```
Input:
  - Bag_NormalHikingBag
  - Hydration System x1
  - Thread x3
Output: Bag_HikingBag_Hydration
  (Capacity: 20 → 22, WeightRed: 75% → 78%)
  Special: "Integrated water carrier"
Time: 100 min
Skill: Tailoring 5
Tools: Needle
OnGiveXP: Tailoring_25
```

---

## Regras de Implementação

### Nomenclatura de Items
- Base vanilla: `Bag_SchoolBag`
- Upgraded: `Bag_SchoolBag_Reinforced`, `Bag_SchoolBag_Comfortable`, etc.
- Sufixos: `_Reinforced`, `_Enhanced`, `_Comfortable`, `_Optimized`, `_Tactical`, `_Advanced`, `_Expanded`

### Sintaxe de Receita (Exemplo Real)
```lua
recipe Reinforce School Bag (Capacity)
{
    Bag_SchoolBag,
    BasicFabric=2,
    Thread=2,
    
    Result: Bag_SchoolBag_Reinforced,
    Time: 60.0,
    Category: Tailoring,
    
    NeedToBeLearn: true,
    CanBeDoneFromFloor: true,
    
    RequiredSkills: Tailoring:3,
    OnGiveXP: Tailoring:15,
    
    AnimNode: RipSheets,
    Sound: ClothesRipping,
}
```

### Consumo de Thread
- Upgrades básicos (Tier 1): 1-2 Thread
- Upgrades intermediários (Tier 2): 2-3 Thread
- Upgrades avançados (Tier 3): 3-4 Thread

### XP Gain
- Desmontagem: 5-15 XP (baseado em complexidade)
- Upgrades básicos: 10-15 XP
- Upgrades intermediários: 20-25 XP
- Upgrades avançados: 30+ XP

---

## Balanceamento - Comparações

### School Bag Vanilla vs Upgraded
| Versão | Capacity | Weight Red. | Custo para fazer |
|--------|----------|-------------|------------------|
| Vanilla | 15 | 70% | N/A |
| Reinforced (Cap) | 18 | 70% | 2 Fabric, 2 Thread, 60min, Lvl3 |
| Comfortable (WR) | 15 | 78% | 2 Straps, 2 Thread, 60min, Lvl3 |
| Tactical (Hybrid) | 17 | 75% | 1 Strap, 1 Fabric, 1 Pouch, 3 Thread, 90min, Lvl4 |

### Hiking Bag Vanilla vs Upgraded
| Versão | Capacity | Weight Red. | Custo para fazer |
|--------|----------|-------------|------------------|
| Vanilla | 20 | 75% | N/A |
| Enhanced (Cap) | 24 | 75% | 2 Fabric, 2 Buckles, 3 Thread, 90min, Lvl5 |
| Comfortable (WR) | 20 | 83% | 1 Straps, 2 Thread, 75min, Lvl4 |
| Advanced (Hybrid) | 23 | 80% | 1 Straps, 1 Fabric, 3 Buckles, 4 Thread, 120min, Lvl6 |
| Hydration | 22 | 78% | 1 Hydro System, 3 Thread, 100min, Lvl5 |

---

## Checklist de Implementação

### Fase 1 - Desmontagem (1 semana)
- [ ] R001: School Bag
- [ ] R002: Fanny Pack
- [ ] R003: Tote Bag
- [ ] R009: Hydration Pack
- [ ] Testar todos os componentes gerados

### Fase 2 - Upgrades Básicos (1 semana)
- [ ] R101: School Bag Capacity
- [ ] R201: School Bag Comfort
- [ ] R301: School Bag Tactical
- [ ] Testar balanceamento

### Fase 3 - Expansão (1-2 semanas)
- [ ] Resto das desmontagens (R004-R012)
- [ ] Resto dos upgrades (R102-R304)
- [ ] Polish e ajustes finais
