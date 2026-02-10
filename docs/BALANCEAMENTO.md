# Notas de Balanceamento e Design

## Filosofia de Balanceamento

### Princípios Core
1. **Upgrades são ESCOLHAS, não obrigações**
   - Vanilla deve permanecer viável
   - Mod adiciona opções, não poder creep

2. **Custo de Oportunidade**
   - Desmontar item = perder o item original
   - Decisão difícil: "Vale a pena sacrificar esta mochila?"

3. **Progressão Gradual**
   - Early game: upgrades modestos
   - Mid/late game: upgrades significativos
   - Nunca trivializar o jogo

4. **Realismo > Game Design (quando possível)**
   - Sistema faz sentido narrativo
   - Evitar números mágicos arbitrários

---

## Curva de Progressão

### Early Game (Dias 1-7)
**Skill disponível**: Tailoring 0-2

**Containers típicos**:
- Tote Bag (spawn alto)
- School Bag (spawn alto)
- Fanny Pack (spawn médio)

**Upgrades acessíveis**:
- School Bag Reinforced: +3 capacity (20% boost)
- School Bag Comfortable: +8% weight reduction (11% boost relativo)

**Impacto**: Modesto, ajuda mas não revoluciona

### Mid Game (Dias 8-21)
**Skill disponível**: Tailoring 3-5

**Containers típicos**:
- Normal Hiking Bag
- Duffel Bag
- Ocasionalmente Big Hiking Bag

**Upgrades acessíveis**:
- Hiking Bag Enhanced: +4 capacity (20% boost)
- Hiking Bag Comfortable: +8% weight reduction (10.6% boost)
- Upgrades híbridos começam a valer a pena

**Impacto**: Notável, recompensa investimento em Tailoring

### Late Game (Dias 22+)
**Skill disponível**: Tailoring 6+

**Containers típicos**:
- ALICE Pack (raro)
- Big Hiking Bag
- Items militares

**Upgrades acessíveis**:
- Advanced/Tactical variants
- Múltiplos upgrades simultâneos (desmontar vários items)
- Sistema de hidratação e especiais

**Impacto**: Significativo, mas gated por raridade de materiais

---

## Matemática de Balanceamento

### Capacidade (Capacity)

**Fórmula Base**: Upgrade = 15-25% do valor base
```
School Bag: 15 → 18 (+3, 20%)
Hiking Bag: 20 → 24 (+4, 20%)
Big Hiking: 30 → 36 (+6, 20%)
```

**Justificativa**:
- 20% é notável mas não game-breaking
- Equivale a "meio container extra" de espaço
- Comparável a diferença entre tiers vanilla

**Edge Cases**:
- Containers pequenos (<10): upgrade mínimo +2
- Containers grandes (>30): upgrade máximo +8

### Weight Reduction

**Fórmula Base**: Upgrade = +5-10% pontos percentuais
```
School Bag: 70% → 78% (+8pp, equivalente a +11.4% efetivo)
Hiking Bag: 75% → 83% (+8pp, equivalente a +10.6% efetivo)
ALICE Pack: 85% → 90% (+5pp, equivalente a +5.9% efetivo)
```

**Justificativa**:
- Retornos diminuem em valores altos (realismo)
- ALICE já é premium, pouco espaço para melhoria
- Diferença perceptível mas não absurda

**Limite Hard**: Nunca exceder 95% weight reduction
- Vanilla max é ALICE com 85%
- Nosso max é 90% (ALICE upgraded em v3.0 futuro)

### Upgrades Híbridos

**Fórmula**: 50-60% dos valores separados
```
School Bag Tactical:
  - Se fosse só capacity: +3
  - Se fosse só comfort: +8%
  - Híbrido: +2 capacity + 5% weight red
```

**Justificativa**:
- Versatilidade tem custo
- Evita "opção estritamente superior"
- Jogador escolhe: especializar ou balancear?

---

## Economia de Componentes

### Tabela de Valores Relativos

| Componente | Valor Relativo | Obtido de | Crafting Equivalente |
|------------|----------------|-----------|----------------------|
| Basic Fabric | 1.0 | Tote, School, Satchel | +2 capacity |
| Basic Straps | 1.2 | School, Satchel | +5% weight red |
| Durable Fabric | 2.0 | Hiking, Duffel | +4 capacity |
| Reinforced Straps | 2.5 | Hiking, Big Hiking | +8% weight red |
| Buckles | 0.5 | Hiking, Duffel | Auxiliary material |
| Tactical Fabric | 3.0 | ALICE, Military | +6 capacity |
| Military Straps | 3.5 | ALICE | +10% weight red |
| Heavy Buckles | 0.8 | ALICE, Military | Auxiliary material |
| Quick-Access Pouch | 1.5 | Fanny, Holster | +1 cap + 2% weight |
| Hydration System | 2.5 | Hydration Pack | +2 cap + 3% weight |

### Custos de Receitas (em Valores Relativos)

**Tier 1 Upgrade**: 2.0-3.0 valor total
```
School Bag Reinforced:
  - 2x Basic Fabric (2.0)
  - 2x Thread (0.5)
  Total: 2.5
```

**Tier 2 Upgrade**: 4.0-6.0 valor total
```
Hiking Bag Enhanced:
  - 2x Durable Fabric (4.0)
  - 2x Buckles (1.0)
  - 3x Thread (0.75)
  Total: 5.75
```

**Tier 3 Upgrade**: 7.0-10.0 valor total
```
Advanced Hiking Bag:
  - 1x Reinforced Straps (2.5)
  - 1x Durable Fabric (2.0)
  - 3x Buckles (1.5)
  - 4x Thread (1.0)
  Total: 7.0
```

### Regra de "Valor Justo"

**Valor do Upgrade ≤ 70% valor do item base**

Exemplo: Desmontar 1 Hiking Bag dá ~6.0 valor
- Fazer upgrade em School Bag usa ~2.5 valor
- Sobra 3.5 valor para outros projetos
- Jogador não é "forçado" a usar tudo numa coisa só

---

## Tempo de Crafting

### Fórmula Base
```
Tempo = (30 + 15 * Tier) * Complexidade
```

**Tiers**:
- Tier 1 (School, Tote): multiplier 1
- Tier 2 (Hiking, Duffel): multiplier 1.5
- Tier 3 (ALICE, Military): multiplier 2

**Complexidade**:
- Desmontagem simples: 1.0
- Upgrade capacity: 1.2
- Upgrade comfort: 1.0
- Upgrade híbrido: 1.5

**Exemplos**:
```
Disassemble Tote Bag:
  30 * 1.0 = 30 min

Disassemble Hiking Bag:
  30 * 1.5 * 1.0 = 45 min

School Bag Reinforced:
  (30 + 15*1) * 1.2 = 54 min → arredonda 60 min

Advanced Hiking Bag:
  (30 + 15*2) * 1.5 = 90 min → arredonda 120 min
```

**Justificativa**:
- Tempo suficiente para ser "investimento"
- Não tão longo que seja tedioso
- Risco de zombie durante crafting

---

## Requisitos de Skill

### Tabela de Progressão

| Tailoring Level | Pode Fazer | Desbloqueios Notáveis |
|-----------------|------------|------------------------|
| 0-1 | Nada (deve treinar primeiro) | - |
| 2 | Desmontagem Tier 1 | School, Tote, Fanny |
| 3 | Upgrades Tier 1 | School Reinforced/Comfortable |
| 4 | Desmontagem Tier 2, Upgrades híbridos | Hiking, Duffel, Tactical |
| 5 | Desmontagem Tier 3 inicial | Big Hiking Bag |
| 6 | Upgrades Tier 3, ALICE | Advanced upgrades, ALICE Pack |
| 7+ | (Futuro v2.0) | Modificações múltiplas |

### Curva de Aprendizado

**Level 0 → 2**: ~2-3 dias (rasgando lençóis)
**Level 2 → 4**: ~5-7 dias (crafting regular + upgrades mod)
**Level 4 → 6**: ~10-14 dias (precisa fazer muitos upgrades)

**Design Goal**: Mod se torna viável no mid-game, não early game

---

## XP Rewards

### Fórmula
```
XP = Base * (1 + 0.2 * Tier) * Type_Multiplier
```

**Base**: 10 XP
**Type Multipliers**:
- Desmontagem: 0.5-1.0 (baixo, é "fácil")
- Upgrade capacity: 1.5 (requer precisão)
- Upgrade comfort: 1.2 (ergonomia)
- Upgrade híbrido: 2.0+ (complexo)

**Exemplos**:
```
Disassemble School Bag:
  10 * (1 + 0.2*1) * 0.5 = 6 XP → arredonda 5 XP

School Bag Reinforced:
  10 * (1 + 0.2*1) * 1.5 = 18 XP → arredonda 15 XP

Advanced Hiking Bag:
  10 * (1 + 0.2*2) * 2.0 = 28 XP → arredonda 30 XP
```

**Justificativa**: 
- Upgrades avançados acceleram treino de Tailoring
- Cria feedback loop positivo
- Recompensa experimentação

---

## Comparações com Vanilla

### Container Tiers (Referência)

| Tier | Exemplo | Capacity | Weight Red. | Rarity |
|------|---------|----------|-------------|--------|
| Garbage | Plastic Bag | 6 | 50% | Muito Alto |
| Low | Tote Bag | 10 | 50% | Alto |
| Basic | School Bag | 15 | 70% | Alto |
| Mid | Hiking Bag | 20 | 75% | Médio |
| High | Big Hiking | 30 | 80% | Baixo |
| Premium | ALICE Pack | 35 | 85% | Muito Baixo |

### Nossos Upgrades vs "Próximo Tier"

**School Bag Reinforced (18 cap, 70% WR)**
- vs Hiking Bag (20 cap, 75% WR)
- Ainda inferior, mas "quase lá"
- Tradeoff: Hiking é mais raro

**Hiking Bag Enhanced (24 cap, 75% WR)**
- vs Big Hiking (30 cap, 80% WR)
- ~80% do valor, muito mais fácil de obter
- Excelente para mid-game

**Advanced Hiking (23 cap, 80% WR)**
- Entre Hiking e Big Hiking
- Equivalente a "Big Hiking piorado"
- Mas pode fazer com items comuns

**Regra**: Upgrade nunca supera próximo tier vanilla completo

---

## Edge Cases e Problemas

### Problema 1: "ALICE Pack Hoarding"
**Cenário**: Jogador acha 3 ALICE Packs, desmonta 2

**Componentes gerados**:
- 2x Military Straps (7.0 valor)
- 4x Tactical Fabric (12.0 valor)
- 8x Heavy Buckles (6.4 valor)
- Total: 25.4 valor relativo

**Potencial abuse**: Fazer vários upgrades premium

**Solução**:
- ALICE exige Tailoring 6 para desmontar (gated)
- ALICE é raríssimo (problema auto-limitado)
- Componentes militares só úteis em receitas high-tier

### Problema 2: "Infinite Loop"
**Cenário**: Upgraded item pode ser desmontado?

**Decisão**: **NÃO**
- Items upgraded não aparecem em receitas de desmontagem
- Evita exploits e complexidade
- Faz sentido narrativo (costura permanente)

### Problema 3: "Thread Economy"
**Cenário**: Thread muito escasso no early game

**Solução**:
- Receitas Tier 1 usam 1-2 Thread (razoável)
- Tailoring permite craftar Thread de Sheets
- Mod não quebra economia vanilla

### Problema 4: "Condição do Item"
**Cenário**: Mochila 10% condição ainda funciona?

**Decisão v1.0**: Ignorar condição (simplicidade)
**Decisão v2.0**: Exigir condição mínima (30%+)

---

## Testes de Sanidade

### Checklist de Balanceamento

Antes de release, verificar:

- [ ] Nenhum upgrade dá >30% boost em stat individual
- [ ] Nenhum upgraded item supera vanilla tier superior
- [ ] Desmontar + upgrades requer 3+ dias in-game para completar
- [ ] Jogador precisa escolher (não pode fazer todos upgrades)
- [ ] Thread consumption respeita economia vanilla
- [ ] XP gains não permitem powerleveling absurdo
- [ ] Tempos de crafting são "custosos mas não tediosos"

### Playtest Scenarios

**Scenario A - Casual Player**:
- Tailoring casual (não foca nisso)
- Chega em lvl 4 no dia 14
- Deve conseguir fazer ~3-4 upgrades básicos

**Scenario B - Tailoring Focus**:
- Jogador treina Tailoring ativamente
- Chega em lvl 6 no dia 10
- Deve conseguir fazer upgrades avançados mas limitado por materiais

**Scenario C - Lucky RNG**:
- Encontra muitos containers bons cedo
- Tem componentes mas falta skill
- Deve ser forçado a escolher o que upgradar

---

## Notas para Futuras Versões

### v2.0 - ModData System
- Múltiplos upgrades por item
- Máximo 3 modificações
- Sistema de "slot points" (cada mod consome points)
- Complexidade aumenta muito

### v3.0 - Slots Customizados
- Hydration System dá slot real de garrafa
- Ammo Bandolier dá slots de munição
- Requer modificar UI (muito avançado)

### v4.0 - Compatibilidade com Outros Mods
- Brita's Armor Pack
- ORGM (armas)
- Authentic Z (survival)
- Cada um pode ter containers únicos

---

## Conclusão

**Filosofia Final**: 
> "O mod deve fazer o jogador pensar 'isso é legal e faz sentido', não 'isso é OP e quebra o jogo'."

Se em dúvida sobre balanceamento: **NERF**. 
É mais fácil buffar depois baseado em feedback do que nerfar e decepcionar players.
