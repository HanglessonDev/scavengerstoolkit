# Pending Polish — Scavenger's Toolkit

Documentação de melhorias de polimento e UX pendentes.

**Foco:** Usar recursos existentes do Project Zomboid (sons, animações, feedbacks) sem adicionar assets novos.

**Não é:** Features novas ou mudanças de arquitetura.

---

## 🔊 Áudio

### [ ] Tocar som de tesoura durante remoção de upgrade

**Contexto:** Ao remover um upgrade, o jogador usa tesoura (ou faca), mas nenhum som é reproduzido.

**Solução sugerida:**
- Usar som existente de tesoura do PZ
- Tocar durante a timed action de remoção
- Referências: procurar por `ISCutFabric` ou ações de tailoring vanilla

**Status:** Pendente
**Prioridade:** Média
**Dificuldade:** Baixa

---

### [ ] Tocar som de agulha/costura durante adição de upgrade

**Contexto:** Ao adicionar um upgrade, o jogador usa agulha e linha, mas nenhum som é reproduzido.

**Solução sugerida:**
- Usar som existente de costura do PZ
- Tocar durante a timed action de adição
- Referências: procurar por `ISSew` ou ações de tailoring vanilla

**Status:** Pendente
**Prioridade:** Média
**Dificuldade:** Baixa

---

## 🎬 Animação

### [ ] Verificar se animação de craft está adequada

**Contexto:** A ação usa `CharacterActionAnims.Craft`, mas pode haver animação mais específica.

**Solução sugerida:**
- Pesquisar animações vanilla de costura/conserto
- Usar animação mais apropriada se disponível

**Status:** Pendente
**Prioridade:** Baixa
**Dificuldade:** Baixa

---

### [ ] Barra de progresso aparecer também nas ferramentas e materiais

**Contexto:** Durante o craft, a barra de progresso aparece apenas na mochila sendo modificada. Ferramentas (agulha, tesoura) e materiais (linha) não mostram progresso.

**Solução sugerida:**
- Estender lógica de `setJobDelta` para itens sendo usados
- Referências: procurar como PZ faz em ações de craft vanilla (ex: ISRepairClothing, ISCooking)

**Status:** Pendente
**Prioridade:** Baixa
**Dificuldade:** Média

---

## 📜 UI/Feedback

### ✅ Tooltip mostra upgrades instalados ao passar o mouse

**Status:** ✅ **Implementado** em `STK_Tooltips.lua`

- Tooltip exibe slots disponíveis/usados
- Mostra bônus de capacidade e weight reduction
- Preview do valor do upgrade em itens STK

---

### [ ] Expandir sistema de fala humanizada com humor negro e reações emocionais

**Contexto:** Sistema atual (`STK_SilentSpeaker.lua` + `STK_FeedbackSystem.lua`) tem frases simples. Pode ser enriquecido com mais personalidade, alinhado ao tom de Project Zomboid.

**Solução sugerida:**

1. **Mais frases variadas**
   - Adicionar 10-15 frases por categoria (sucesso, falha, material destruído)
   - Incluir gírias, expressões de frustração/alívio

2. **Humor negro característico do PZ**
   - Frases como: "Pelo menos não era minha mão", "Consertado... mais ou menos"
   - Ironias sobre a situação pós-apocalíptica

3. **Sistema de "estresse/frustração"**
   - Rastrear falhas consecutivas do jogador
   - Após N falhas, mudar tom das frases (mais bravo/desesperado)
   - Resetar contador após sucesso

4. **Frases em duas partes (reação emocional + comentário)**
   - Exemplo falha: 
     - Parte 1: "Droga! Errei de novo!"
     - Parte 2: "Quem precisa de dedos funcionais mesmo?"
   - Exemplo sucesso:
     - Parte 1: "Isso!"
     - Parte 2: "Vou vender isso quando o mundo acabar... oh espera."

5. **Arquivos de tradução**
   - Expandir `UI_PTBR.txt` e `UI_EN.txt` com novas categorias
   - Separar por "tom": neutro, frustrado, eufórico, irônico

**Status:** Pendente
**Prioridade:** Média
**Dificuldade:** Média
**Impacto:** Alto (melhora imersão significativamente)

**Referências de tom:**
- Narração de morte do PZ ("You died of...")
- Frases dos NPCs em mods vanilla
- Tom de "sobrevivente cansado da situação"

---

## ⚙️ Sandbox Options

### ✅ Adicionar opções de limite para Hiking Bags e Duffel Bags

**Contexto:** `sandbox-options.txt` possui apenas:
- `FannyPackLimit`
- `SatchelLimit`  
- `SchoolbagLimit`

Mas `STK_Core.lua` valida também **Hiking Bags** (4 tipos) e **Duffel Bags** (7 tipos).

**Solução sugerida:**
- Adicionar `HikingBagLimit` e `DuffelBagLimit` ao `sandbox-options.txt`
- Atualizar `STK_ContainerLimits.lua` para ler dessas opções
- Manter padrão de categoria (não adicionar 1 opção por tipo individual)

**Status:** Pendente
**Prioridade:** Média
**Dificuldade:** Baixa

---

## 🛠️ Mecânicas

### [ ] Devolver ferramentas quebradas (tesoura, faca, agulha) em vez de remover

**Contexto:** Atualmente, quando uma ferramenta atinge condição 0, ela é **removida** do inventário (`:Remove()`). Isso é punitivo demais e perde o uso vanilla de itens quebrados.

**Problema:**
- Tesouras, facas e agulhas quebradas podem ter uso no jogo vanilla (ex: reciclagem, craft)
- Remoção permanente é frustrante para o jogador
- Quebra de imersão: o objeto "desaparece" do nada

**Arquivos afetados:**
- `STK_UpgradeLogic.lua` — linhas de degradação de needle, thread, scissors, knife

**Status:** Pendente
**Prioridade:** Alta
**Dificuldade:** Baixa
**Impacto:** Alto (reduz frustração, preserva itens vanilla)

---

### [ ] Receitas de disassemble devem ignorar mochilas equipadas

**Contexto:** Se o jogador acidentalmente selecionar uma mochila que está equipada para desmanchar (disassemble), ela será destruída e todo o conteúdo será perdido.

**Problema:**
- Perda acidental de mochila em uso + todo inventário dentro
- Sem aviso ou prevenção contra erro do usuário
- Frustração alta em caso de clique equivocado

**Solução sugerida:**
- Validar se a mochila alvo está equipada antes de iniciar a receita
- Bloquear a ação se estiver equipada (exibir mensagem: "Não é possível desmanchar uma mochila equipada")
- Alternativa: mover automaticamente para o chão/inventário antes de permitir

**Arquivos afetados:**
- `STK_UpgradeLogic.lua` — lógica de remoção de upgrade
- `STK_Core.lua` — validações de itens

**Status:** Pendente
**Prioridade:** Alta
**Dificuldade:** Baixa
**Impacto:** Alto (previne perda catastrófica de itens)

---

### [ ] Buscar materiais e ferramentas em containers equipados

**Contexto:** Atualmente, o sistema só detecta materiais e ferramentas no inventário direto do jogador. Se a agulha, tesoura, linha ou faca estiverem dentro de uma mochila equipada, não são encontrados.

**Problema:**
- Jogador precisa mover manualmente ferramentas para o inventário principal
- Experiência frustrante: o item "está lá" (na mochila) mas o craft não funciona
- Quebra de imersão: na vida real, você usaria sem precisar desembolsar

**Solução sugerida:**
- Expandir busca para incluir containers equipados (mochilas nas costas, cinturão, ombro)
- Usar APIs vanilla do PZ para iterar sobre equipamentos equipados
- Manter comportamento atual apenas para o item alvo (mochila sendo upada)

**Arquivos afetados:**
- `STK_Core.lua` — funções de busca/validação de materiais
- `STK_UpgradeLogic.lua` — validação de pré-requisitos

**Status:** Pendente
**Prioridade:** Alta
**Dificuldade:** Média
**Impacto:** Alto (melhora significativa na UX)

---

## ⚡ Performance

### [ ] Otimizar scan de upgrades no inventário

**Contexto:** `STK_Core.getUpgradeItems()` faz loop em todos os itens do container.

**Solução sugerida:**
- Cachear resultado se possível
- Usar filtros vanilla do PZ se disponível

**Status:** Pendente
**Prioridade:** Baixa
**Dificuldade:** Média

---

## 🧪 Validação


## 📋 Checklist de Revisão

Antes de considerar "polido", verificar:

- [ ] Sons apropriados em todas as ações
- [ ] Feedback visual claro (sucesso/falha)
- [ ] Tooltips informativos
- [ ] Animações adequadas
- [ ] Mensagens de erro claras
- [ ] Funciona em multiplayer

---

## 📚 Referências Vanilla


**Última atualização:** 2026-02-17
**Versão do mod:** 3.0.0
