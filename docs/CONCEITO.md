# Scavenger's Toolkit
## Conceito Geral

**Nome Oficial**: Scavenger's Toolkit  
**Tagline**: *"Dismantle, salvage, and upgrade containers in the apocalypse. No bag left behind."*

### Visão
Um mod realista para Project Zomboid que permite desmontar containers encontrados no mundo e usar suas peças para melhorar outros containers através do sistema de costura.

### Filosofia de Design
- **Realismo**: Aproveitar cada recurso disponível no apocalipse
- **Simplicidade**: Sistema intuitivo baseado em crafting vanilla
- **Progressão**: Requer skill de Tailoring, melhores items precisam mais habilidade
- **Escolhas**: Usar item como está OU desmontar para componentes

### Escopo v1.0 (MVP)
- Sistema de desmontagem de 5-8 containers comuns
- 3-4 tipos de componentes básicos
- 5-10 receitas de upgrade (1 upgrade por item)
- Baseado em criar itens novos (Backpack → Backpack_Reinforced)

### Fora do Escopo v1.0
❌ Modificações múltiplas por item (futuro v2.0)
❌ Slots especiais customizados (complexo demais)
❌ Interface visual customizada
❌ Containers além de mochilas/bags

---

## Mecânica Core

### Fluxo Básico
1. Jogador encontra 2+ containers similares
2. Desmonta um deles (Tailoring lvl 2+) → gera componentes
3. Usa componentes + container base + materiais → container melhorado
4. Container melhorado tem stats superiores (capacidade OU redução peso)

### Requisitos
- **Skill**: Tailoring 2-6 (dependendo da complexidade)
- **Ferramentas**: Needle (não consome), Thread (consome)
- **Tempo**: 30-120 minutos in-game
- **Condição**: Item precisa estar em condição razoável (>30%)

### Tipos de Melhoria
- **Tipo A - Capacidade**: +10-20% capacity
- **Tipo B - Conforto**: +5-10% weight reduction
- **Tipo C - Híbrido**: +5% capacity + 3% weight reduction (raro, high level)

---

## Componentes do Mod
- **Backpack Straps (Alças de Mochila)**: Melhora redução de peso
  - Basic Backpack Straps, Reinforced Backpack Straps, Tactical Backpack Straps
- **Backpack Fabric (Tecido de Mochila)**: Aumenta capacidade
  - Basic Backpack Fabric, Reinforced Backpack Fabric, Tactical Backpack Fabric
- **Belt Buckle (Fivela de Cinto)**: Componente auxiliar para upgrades
  - Standard Buckles, Reinforced Belt Buckle

---

## Referências
- Inspiração: [Backpack Borders](https://steamcommunity.com/sharedfiles/filedetails/?id=2996978365)
- Abordagem: Criar itens novos (não ModData) para v1.0
- Documentação: https://pzwiki.net/wiki/Modding

---

## Notas Técnicas
- Usar estrutura de receitas vanilla
- Items novos seguem nomenclatura: `Base.NomeOriginal_Upgraded`
- Componentes do mod usam namespace `STK`: `STK.BackpackStrapsBasic`, `STK.BackpackFabricReinforced`, etc.
- Componentes são items consumíveis no crafting
- Texturas podem reutilizar sprites vanilla inicialmente
