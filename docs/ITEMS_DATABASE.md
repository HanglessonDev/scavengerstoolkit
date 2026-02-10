# Database de Containers Vanilla - Project Zomboid

Fonte: https://pzwiki.net/wiki/Container

## Containers Prioritários para v1.0

### Tier 1 - Básicos (Comuns, Stats Baixos)
| Item | Capacity | Weight Red. | Spawn Rate | Notas |
|------|----------|-------------|------------|-------|
| Bag_SchoolBag | 15 | 70% | Muito Alto | Mochila escolar pequena |
| Bag_Satchel | 10 | 60% | Alto | Bolsa lateral |
| Fanny Pack | 4 | 90% | Médio | Pochete, muito comum |
| Tote Bag | 10 | 50% | Alto | Sacola de pano |

### Tier 2 - Intermediários
| Item | Capacity | Weight Red. | Spawn Rate | Notas |
|------|----------|-------------|------------|-------|
| Bag_NormalHikingBag | 20 | 75% | Médio | Mochila caminhada normal |
| Bag_DuffelBag | 22 | 60% | Médio | Mala esportiva |
| Purse | 6 | 85% | Alto | Bolsa feminina pequena |

### Tier 3 - Avançados (Raros, Stats Altos)
| Item | Capacity | Weight Red. | Spawn Rate | Notas |
|------|----------|-------------|------------|-------|
| Bag_BigHikingBag | 30 | 80% | Baixo | Mochila grande |
| Bag_ALICEpack | 35 | 85% | Muito Baixo | Militar, melhor do jogo |
| First Aid Kit | 8 | 95% | Baixo | Pequeno mas excelente redução |

---

## Containers Especializados (Candidatos para Componentes Especiais)

### Hidratação
| Item | Capacity | Weight Red. | Notas |
|------|----------|-------------|-------|
| Hydration Pack | 6 | 90% | Recipiente de água embutido - componentizável! |

### Armas/Munição
| Item | Capacity | Weight Red. | Notas |
|------|----------|-------------|-------|
| Holster_Shoulder | 4 | 95% | Sistema de coldre - pode virar componente |
| Bullets Bandolier | 4 | 95% | Bandoleira munição - pode virar componente |
| Cloth Gun Case | 6 | 80% | Descartável, bom para reciclar |

### Vestuário com Storage
| Item | Capacity | Weight Red. | Notas |
|------|----------|-------------|-------|
| Vest_BulletCivilian | 8 | 95% | Colete, possui bolsos |
| Vest_BulletPolice | 10 | 95% | Versão policial |

---

## Análise para Desmontagem

### Containers BONS para Desmontar (v1.0)
✅ **Bag_SchoolBag** - comum, todos tem extras
✅ **Fanny Pack** - muito comum, stats OK
✅ **Tote Bag** - comum demais, descartável
✅ **Satchel** - comum, stats medianos
✅ **Cloth Gun Case** - baixa utilidade sozinho

### Containers que GERAM Componentes Valiosos
💎 **Bag_BigHikingBag** - alças reforçadas, estrutura resistente
💎 **Bag_ALICEpack** - frame militar, melhor qualidade
💎 **Hydration Pack** - sistema de hidratação único
💎 **Holster_Shoulder** - sistema de fixação rápida

### Containers BASE para Upgrade (v1.0)
🎯 **Bag_SchoolBag** → School Bag Reinforced
🎯 **Bag_NormalHikingBag** → Hiking Bag Enhanced  
🎯 **Bag_DuffelBag** → Duffel Bag Reinforced
🎯 **Purse** → Purse Expanded

---

## Regras de Balanceamento

### Componentes por Tier
- **Tier 1**: 1-2 componentes básicos
- **Tier 2**: 2-3 componentes + chance de componente especial
- **Tier 3**: 3-4 componentes + componente especial garantido

### Progressão de Tailoring
- **Lvl 2**: Desmontar Tier 1, Upgrade básicos
- **Lvl 4**: Desmontar Tier 2, Upgrades intermediários
- **Lvl 6**: Desmontar Tier 3, Upgrades avançados

### Limites de Upgrade
- Cada container só pode ser melhorado **1 vez** na v1.0
- Melhorias não stackam (não pode fazer Reinforced → Super Reinforced)
- Upgrades dão +10-25% stats dependendo do tier base

---

## Notas de Implementação
- Nomes internos seguem padrão `Base.Bag_NomeDoItem`
- Weight reduction é percentual (0-100)
- Capacity é em unidades de peso (1 unit = ~0.1kg aprox)
- Stats finais precisam respeitar lógica do jogo
