# Quick Reference - Scavenger's Toolkit

**Nome Oficial**: Scavenger's Toolkit  
**Tagline**: *"No bag left behind"*

## 📁 Arquivos do Projeto

### Documentação de Design
- **CONCEITO.md** - Visão geral e filosofia do mod
- **ITEMS_DATABASE.md** - Todos os containers vanilla com stats
- **COMPONENTES.md** - Lista de componentes criados
- **RECEITAS.md** - Todas as receitas (desmontagem + upgrades)
- **BALANCEAMENTO.md** - Matemática e notas de design
- **ROADMAP.md** - Cronograma e fases de desenvolvimento
- **README.md** - Este arquivo (referência rápida)

---

## 🎯 Objetivos do Mod (v1.0)

1. ✅ Desmontar 10+ tipos de containers
2. ✅ Criar 5+ tipos de componentes
3. ✅ Implementar 15+ receitas de upgrade
4. ✅ Sistema baseado em Tailoring skill
5. ✅ Balanceamento realista e não OP

---

## 🔧 Stack Técnico

- **Engine**: Project Zomboid (Build 41+)
- **Language**: Lua + Scripts declarativos
- **Mod Type**: Crafting/Items
- **Abordagem**: Criar itens novos (não ModData em v1.0)

---

## 📊 Receitas Core (Resumo)

### Desmontagem (12 receitas)
- Tier 1: School Bag, Tote, Fanny, Satchel, Gun Case (5)
- Tier 2: Hiking Bag, Duffel, Hydration Pack (3)
- Tier 3: Big Hiking, ALICE Pack (2)
- Especiais: Holster, Bandolier (2)

### Upgrades (15+ receitas)
- **Capacity Focus**: +10-20% capacity
- **Comfort Focus**: +5-10% weight reduction
- **Hybrid**: Balanced boost em ambos

---

## 🎮 Progressão do Jogador

| Dias | Tailoring | Pode Fazer |
|------|-----------|------------|
| 1-3 | 0-1 | Treinar (rasgar lençóis) |
| 4-7 | 2-3 | Desmontagem básica, primeiros upgrades |
| 8-14 | 3-4 | Upgrades intermediários, híbridos |
| 15-21 | 4-5 | Desmontagem Tier 2, upgrades avançados |
| 22+ | 6+ | ALICE Pack, upgrades premium |

---

## 💡 Exemplos Práticos

### Cenário 1: Early Game
```
Encontrei: 2x School Bag, 3x Tote Bag
Ação:
  1. Desmontar 3 Tote → 6 Basic Fabric
  2. School Bag + 2 Fabric → School Bag Reinforced
  3. Guardar 4 Fabric para futuros upgrades
Resultado: School Bag melhorado (15→18 cap)
```

### Cenário 2: Mid Game
```
Encontrei: Hiking Bag, Big Hiking Bag, 2x Duffel
Ação:
  1. Usar Hiking Bag como main
  2. Desmontar 1 Duffel → componentes Tier 2
  3. Hiking + componentes → Hiking Enhanced
  4. Guardar Big Hiking para emergência
Resultado: Hiking Bag melhorado (20→24 cap)
```

### Cenário 3: Late Game
```
Encontrei: ALICE Pack (raro!)
Ação:
  1. USAR o ALICE (não desmontar!)
  2. Desmontar outras bags para componentes
  3. Fazer upgrades em backup bags
  4. ALICE fica como endgame item
Resultado: ALICE intocado + backups melhorados
```

---

## ⚖️ Regras de Balanceamento (Rápido)

### Stats
- ✅ Upgrade dá 15-25% boost
- ✅ Nunca supera próximo tier vanilla
- ✅ Weight reduction max: 90%
- ✅ Capacity boost max: +8 units

### Custos
- ✅ Tier 1: 2-3 componentes + thread
- ✅ Tier 2: 4-6 componentes + thread
- ✅ Tier 3: 7-10 componentes + thread

### Tempo
- ✅ Desmontagem: 20-90 min
- ✅ Upgrade básico: 45-75 min
- ✅ Upgrade avançado: 90-120 min

---

## 🚀 Roadmap (Super Resumido)

```
Semana 1: Proof of concept (3 receitas)
Semana 2-3: Core loop (Tier 1 completo)
Semana 4-5: Expansão (Tier 2 e 3)
Semana 6: Polish e release v1.0
```

---

## 🐛 Troubleshooting Rápido

### Mod não aparece no jogo
- [ ] Verificar mod.info está correto
- [ ] Verificar pasta em `/mods/NomeMod/`
- [ ] Reiniciar completamente o jogo

### Receita não aparece
- [ ] Skill suficiente?
- [ ] Ferramentas corretas (Needle)?
- [ ] Sintaxe Lua correta?
- [ ] Usar debug mode e checar console

### Item não tem stats corretos
- [ ] Verificar `scripts/items.txt`
- [ ] Comparar com item vanilla similar
- [ ] Reload scripts (Ctrl+R em debug)

---

## 📚 Links Úteis

### Engenharia Reversa
- Backpack Borders: ID `2996978365`
- Visible Backpack: ID `2335368829`
- Localização: `steamapps/workshop/content/108600/`

### Documentação
- PZ Wiki Modding: https://pzwiki.net/wiki/Modding
- Lua Reference: https://www.lua.org/manual/5.1/
- PZ Forums: https://theindiestone.com/forums/

### Comunidade
- Discord PZ: https://discord.gg/projectzomboid
- Subreddit: r/projectzomboid
- Steam Workshop: steamcommunity.com/app/108600/workshop/

---

## 🎯 Next Steps (Começar Hoje!)

1. [ ] Estudar mods de referência (engenharia reversa)
2. [ ] Criar estrutura de pastas do mod
3. [ ] Implementar primeiro componente (BasicFabric)
4. [ ] Testar primeira receita (Disassemble Tote Bag)
5. [ ] Documentar aprendizados em NOTES.md

---

## ⏱️ Tempo Estimado Total

**Completo v1.0**: 40-60 horas (6-7 semanas @ 8h/semana)

**Breakdown**:
- Setup/Aprendizado: 8-10h
- Proof of Concept: 12-15h
- Core Loop: 15-20h
- Expansão: 15-20h
- Polish: 8-12h

---

## 💭 Filosofia

> "Versão simples funcionando > Conceito complexo imaginado"

> "Perfeito é inimigo do feito"

> "Iterar, não revolucionar"

---

**Última atualização**: Início do projeto
**Versão planejada**: 1.0
**Status**: Fase de documentação ✅
