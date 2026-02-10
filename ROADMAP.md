# Roadmap de Desenvolvimento - Backpack Recycling Mod

## Filosofia de Desenvolvimento
- **Iterativo**: Sempre ter algo funcionando
- **Testável**: Cada fase gera build jogável
- **Incremental**: Não pular etapas
- **Realista**: 5-10h/semana de trabalho

---

## FASE 0: Preparação (3-5 dias)

### Semana 0 - Setup Inicial
**Tempo estimado: 5-8 horas**

- [ ] **Dia 1-2: Ambiente de Dev**
  - [ ] Instalar ferramentas (VS Code, Notepad++)
  - [ ] Localizar pasta de mods do PZ
  - [ ] Criar estrutura básica de pastas do mod
  - [ ] Configurar mod.info inicial

- [ ] **Dia 3-4: Engenharia Reversa**
  - [ ] Localizar e extrair Backpack Borders (ID: 2996978365)
  - [ ] Localizar e extrair Visible Backpack (ID: 2335368829)
  - [ ] Estudar estrutura de ambos os mods
  - [ ] Documentar aprendizados em NOTES.md

- [ ] **Dia 5: Primeiro Teste**
  - [ ] Criar "Hello World" mod (apenas aparece no menu de mods)
  - [ ] Testar que o jogo reconhece o mod
  - [ ] Familiarizar com reload de scripts (Ctrl+R em debug)

**Entregável**: Mod vazio que carrega sem erros

---

## FASE 1: Proof of Concept (Semana 1)

### Sprint 1.1 - Primeiro Componente
**Tempo estimado: 4-6 horas**

- [ ] Criar item: `BasicFabric` (componente mais simples)
- [ ] Definir propriedades (peso, icon, categoria)
- [ ] Testar spawn do item via debug
- [ ] Verificar que aparece no inventário corretamente

**Critério de Sucesso**: Item aparece no jogo e é utilizável

### Sprint 1.2 - Primeira Receita de Desmontagem
**Tempo estimado: 4-6 horas**

- [ ] Implementar receita R003 (Disassemble Tote Bag)
  - Mais simples: 1 input → 2 outputs iguais
- [ ] Configurar tempo, skill, ferramentas
- [ ] Testar in-game
- [ ] Ajustar balanceamento inicial

**Critério de Sucesso**: Consegue desmontar Tote Bag e receber 2x BasicFabric

### Sprint 1.3 - Primeira Receita de Upgrade
**Tempo estimado: 5-8 horas**

- [ ] Criar item upgraded: `Bag_SchoolBag_Reinforced`
- [ ] Copiar stats do vanilla e modificar capacity
- [ ] Implementar receita R101 (School Bag + 2 Fabric)
- [ ] Testar ciclo completo: desmontar → craftar upgrade
- [ ] Verificar stats finais do item

**Critério de Sucesso**: Pode pegar 2 Tote Bags, desmontar, melhorar School Bag

**Entregável Fase 1**: Mod funcional com 1 componente, 2 receitas, testável

---

## FASE 2: Core Loop (Semana 2-3)

### Sprint 2.1 - Todos os Componentes Básicos
**Tempo estimado: 6-8 horas**

- [ ] Implementar BasicStraps
- [ ] Implementar Buckles
- [ ] Implementar QuickAccessPouch
- [ ] Testar todos spawnando corretamente
- [ ] Criar icons (ou reaproveitar vanilla)

### Sprint 2.2 - Desmontagem Tier 1
**Tempo estimado: 6-8 horas**

- [ ] R001: School Bag → Straps + Fabric
- [ ] R002: Fanny Pack → Pouch
- [ ] R004: Satchel → Straps + Fabric
- [ ] R010: Cloth Gun Case → Fabric
- [ ] Testar todas as receitas
- [ ] Balancear tempos e requisitos

### Sprint 2.3 - Upgrades Básicos (Capacity + Comfort)
**Tempo estimado: 8-10 horas**

- [ ] Criar items: SchoolBag_Reinforced, SchoolBag_Comfortable
- [ ] Implementar R101 (Capacity upgrade)
- [ ] Implementar R201 (Comfort upgrade)
- [ ] Testar que stats realmente mudam
- [ ] Comparar com vanilla para balanceamento

### Sprint 2.4 - Primeiro Playtest
**Tempo estimado: 3-5 horas**

- [ ] Jogar 2-3 horas com o mod ativo
- [ ] Documentar bugs encontrados
- [ ] Anotar problemas de balanceamento
- [ ] Fazer ajustes com base no teste

**Entregável Fase 2**: Core loop completo e jogável (desmontar → craftar)

---

## FASE 3: Expansão de Conteúdo (Semana 4-5)

### Sprint 3.1 - Componentes Avançados
**Tempo estimado: 4-6 horas**

- [ ] DurableFabric (Tier 2)
- [ ] ReinforcedStraps (Tier 2)
- [ ] TacticalFabric (Tier 3)
- [ ] MilitaryStraps (Tier 3)
- [ ] HeavyBuckles (Tier 3)

### Sprint 3.2 - Desmontagem Tier 2 e 3
**Tempo estimado: 8-10 horas**

- [ ] R005: Hiking Bag → componentes Tier 2
- [ ] R006: Duffel Bag → componentes Tier 2
- [ ] R007: Big Hiking Bag → componentes Tier 2/3
- [ ] R008: ALICE Pack → componentes Tier 3
- [ ] Balancear raridade vs recompensa

### Sprint 3.3 - Upgrades Intermediários
**Tempo estimado: 8-10 horas**

- [ ] Items: Satchel_Expanded, HikingBag_Enhanced, etc.
- [ ] R102, R103: Upgrades de capacidade Tier 2
- [ ] R202, R203: Upgrades de conforto Tier 2
- [ ] Testar progressão completa (Tier 1 → 2 → 3)

### Sprint 3.4 - Componentes Especiais
**Tempo estimado: 5-7 horas**

- [ ] HydrationSystem (do Hydration Pack)
- [ ] R009: Desmontar Hydration Pack
- [ ] R304: Hiking Bag com sistema de hidratação
- [ ] Testar que bonus híbrido funciona

**Entregável Fase 3**: Mod completo com todas as receitas planejadas

---

## FASE 4: Polish & Release (Semana 6)

### Sprint 4.1 - Balanceamento Final
**Tempo estimado: 4-6 horas**

- [ ] Playtest extensivo (5+ horas)
- [ ] Ajustar custos de materiais
- [ ] Ajustar requisitos de skill
- [ ] Ajustar tempos de crafting
- [ ] Verificar economia (não quebra progressão vanilla)

### Sprint 4.2 - Qualidade & Bugs
**Tempo estimado: 4-6 horas**

- [ ] Revisar todos os textos de items/receitas
- [ ] Corrigir typos e traduções (se aplicável)
- [ ] Testar edge cases (item quebrado, sem skill, etc)
- [ ] Verificar que nada causa crash

### Sprint 4.3 - Documentação de Usuário
**Tempo estimado: 3-4 horas**

- [ ] Escrever README.md para Workshop
- [ ] Listar todas as receitas (guia rápido)
- [ ] Screenshots/exemplos
- [ ] Changelog inicial
- [ ] Licença e créditos

### Sprint 4.4 - Workshop Upload
**Tempo estimado: 2-3 horas**

- [ ] Criar preview image
- [ ] Preparar descrição completa
- [ ] Upload no Steam Workshop
- [ ] Testar download e instalação
- [ ] Monitorar primeiros comentários

**Entregável Fase 4**: v1.0 no Steam Workshop, público

---

## FASE 5: Pós-Release (Semana 7+)

### Manutenção Contínua
- [ ] Responder feedback de usuários
- [ ] Corrigir bugs reportados
- [ ] Ajustar balanceamento se necessário
- [ ] Pequenos patches (v1.1, v1.2)

### Expansões Futuras (Opcional)
- [ ] **v2.0**: Sistema ModData (modificações múltiplas)
- [ ] **v2.5**: Mais containers (coletes, jaquetas)
- [ ] **v3.0**: Slots customizados especiais
- [ ] **v3.5**: Compatibilidade com outros mods populares

---

## Cronograma Visual

```
Semana 0: [========] Setup & Engenharia Reversa
Semana 1: [========] Proof of Concept (3 receitas funcionando)
Semana 2: [============] Core Loop (Tier 1 completo)
Semana 3: [========] Core Loop (polish)
Semana 4: [============] Expansão (Tier 2 e 3)
Semana 5: [========] Expansão (componentes especiais)
Semana 6: [========] Polish & Release
         └─────────┘
    LANÇAMENTO v1.0
```

**Total estimado: 6-7 semanas** (trabalhando 5-10h/semana)

---

## Checkpoints de Decisão

### Checkpoint 1 (Fim da Semana 1)
**Pergunta**: O proof of concept funciona?
- ✅ SIM → Continuar para Fase 2
- ❌ NÃO → Revisar abordagem técnica, pedir ajuda

### Checkpoint 2 (Fim da Semana 3)
**Pergunta**: O core loop está divertido?
- ✅ SIM → Expandir conteúdo (Fase 3)
- ❌ NÃO → Iterar no balanceamento antes de adicionar mais

### Checkpoint 3 (Fim da Semana 5)
**Pergunta**: Está pronto para release?
- ✅ SIM → Polish e lançar
- ❌ NÃO → 1-2 semanas extras de polish

---

## Sinais de Alerta (Quando Pausar)

🚨 **Pause e reavalie se:**
- Passou 3+ dias sem progresso técnico
- Mesmas receitas não funcionam depois de 5+ tentativas
- Perdeu motivação/interesse no projeto
- Scope creep: querendo adicionar features fora do plano

**Solução**: Voltar ao básico, simplificar, ou pedir ajuda na comunidade

---

## Métricas de Sucesso

### v1.0 Launch
- [ ] Mod funciona sem crashes
- [ ] 10+ receitas implementadas
- [ ] Balanceamento testado (5+ horas de gameplay)
- [ ] Upload no Workshop completo

### Pós-Launch (3 meses)
- [ ] 100+ downloads
- [ ] Feedback positivo (>70% thumbs up)
- [ ] 0-2 bugs críticos reportados
- [ ] Base de usuários engajada

---

## Recursos de Emergência

Se travar em alguma fase:
1. **Comunidade PZ Discord**: https://discord.gg/projectzomboid
2. **Fóruns oficiais**: https://theindiestone.com/forums/
3. **Subreddit**: r/projectzomboid (tag [MODDING])
4. **Modding Wiki**: https://pzwiki.net/wiki/Modding
5. **Claude (eu!)**: Sempre disponível para debugging

**Lembre-se**: Perfeito é inimigo do feito. v1.0 não precisa ter tudo - precisa FUNCIONAR.
