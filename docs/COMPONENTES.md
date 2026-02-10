# Componentes do Sistema de Reciclagem

## Componentes Básicos (v1.0)

### 1. Backpack Straps (Alças de Mochila)
**Fonte**: Qualquer mochila desmontada
**Uso**: Melhorar conforto (weight reduction)

| Qualidade | Obtido de | Weight Red. Bonus | Tailoring Req |
|-----------|-----------|-------------------|---------------|
| Basic Straps | School Bag, Tote Bag, Fanny Pack | +5% | Lvl 2 |
| Reinforced Straps | Hiking Bag, Duffel Bag | +8% | Lvl 4 |
| Military Straps | ALICE Pack, Military Bags | +10% | Lvl 6 |

**Propriedades do Item**:
```
Type = Normal
Weight = 0.3
DisplayCategory = Crafting
Icon = (reutilizar sprite de Belt ou similar)
```

---

### 2. Pocket Fabric (Tecido de Compartimento)
**Fonte**: Qualquer container desmontado
**Uso**: Aumentar capacidade

| Qualidade | Obtido de | Capacity Bonus | Tailoring Req |
|-----------|-----------|----------------|---------------|
| Basic Fabric | School Bag, Purse, Satchel | +2 units | Lvl 2 |
| Durable Fabric | Hiking Bag, Duffel Bag | +4 units | Lvl 4 |
| Tactical Fabric | ALICE Pack, Military items | +6 units | Lvl 6 |

**Propriedades do Item**:
```
Type = Normal
Weight = 0.2
DisplayCategory = Crafting
Icon = (reutilizar sprite de RippedSheets ou Fabric)
```

---

### 3. Buckles and Fasteners (Fivelas e Fixadores)
**Fonte**: Mochilas de qualidade
**Uso**: Crafting material auxiliar

| Qualidade | Obtido de | Uso | Quantidade |
|-----------|-----------|-----|------------|
| Standard Buckles | Hiking Bags, Duffels | Upgrades Tier 2 | 2-3 por desmontagem |
| Heavy Duty Buckles | ALICE, Military | Upgrades Tier 3 | 3-4 por desmontagem |

**Propriedades do Item**:
```
Type = Normal
Weight = 0.1
DisplayCategory = Crafting
Icon = (reutilizar sprite de Screw ou Metal)
```

---

## Componentes Especiais (v1.0 - Limitados)

### 4. Hydration System (Sistema de Hidratação)
**Fonte**: Hydration Pack (único)
**Uso**: Adicionar slot dedicado de água (futuro)

**⚠️ Nota v1.0**: Por enquanto, apenas dá bonus híbrido ao invés de slot especial

| Efeito | Bonus |
|--------|-------|
| Capacity | +2 units |
| Weight Reduction | +3% |
| Flavor Text | "Sistema de hidratação integrado" |

**Propriedades do Item**:
```
Type = Normal
Weight = 0.4
DisplayCategory = Crafting
Icon = (sprite de WaterBottle ou Canteen modificado)
```

---

### 5. Quick-Access Pouch (Bolso de Acesso Rápido)
**Fonte**: Fanny Pack, Holster, Bandolier
**Uso**: Bonus híbrido pequeno

| Efeito | Bonus |
|--------|-------|
| Capacity | +1 unit |
| Weight Reduction | +2% |
| Flavor Text | "Bolso externo de acesso rápido" |

**Propriedades do Item**:
```
Type = Normal
Weight = 0.15
DisplayCategory = Crafting
Icon = (sprite de Bag_FannyPack reduzido)
```

---

## Tabela de Desmontagem (Referência Rápida)

| Container | Componentes Gerados | Quantidade | Tailoring |
|-----------|---------------------|------------|-----------|
| School Bag | Basic Straps + Basic Fabric | 1 + 1 | 2 |
| Fanny Pack | Quick-Access Pouch | 1 | 2 |
| Tote Bag | Basic Fabric | 2 | 2 |
| Satchel | Basic Straps + Basic Fabric | 1 + 1 | 2 |
| Hiking Bag (Normal) | Reinforced Straps + Durable Fabric + Buckles | 1 + 1 + 2 | 4 |
| Duffel Bag | Durable Fabric + Buckles | 2 + 2 | 4 |
| Big Hiking Bag | Reinforced Straps + Durable Fabric + Buckles | 1 + 2 + 3 | 5 |
| ALICE Pack | Military Straps + Tactical Fabric + Heavy Buckles | 1 + 2 + 4 | 6 |
| Hydration Pack | Hydration System + Basic Fabric | 1 + 1 | 3 |
| Cloth Gun Case | Basic Fabric | 2 | 2 |
| Holster/Bandolier | Quick-Access Pouch | 1 | 2 |

---

## Regras de Design

### Qualidade de Componentes
- **Condição do item afeta rendimento**:
  - 80-100%: Componentes completos
  - 50-79%: -1 componente
  - 30-49%: Só componentes básicos
  - <30%: Falha na desmontagem (gasta item, nada retorna)

### Balanceamento
- Componentes devem valer MENOS que o item original
- Incentivo: 1 item ruim + componentes = 1 item bom
- Nunca deve ser melhor desmontar tudo e remontar
- Escolha difícil: "Uso essa segunda hiking bag ou desmonto?"

### Peso dos Componentes
- Soma dos componentes < peso do item original
- Exemplo: School Bag (1.5kg) → Straps (0.3kg) + Fabric (0.2kg) = 0.5kg total
- Perda de material = realismo da desmontagem

---

## Expansões Futuras (Post v1.0)

### Componentes Avançados (v2.0)
- **Frame/Estrutura**: Para mochilas grandes, +durabilidade
- **Padding/Acolchoamento**: Redução de fadiga ao carregar peso
- **Waterproof Liner**: Proteção contra chuva para itens dentro
- **Modular Attachment Points**: Base para sistema de slots customizados

### Componentes de Vestuário (v3.0?)
- Desmontar coletes, jaquetas com bolsos
- Transferir proteção de um item para outro
- Sistema mais complexo (fora do escopo atual)
