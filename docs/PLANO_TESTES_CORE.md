# 🧪 Plano de Testes - STK Bag Upgrade System (FASE CORE)

## 🎯 Objetivo
Validar que as funcionalidades CORE estão 100% funcionais antes de adicionar features avançadas.

---

## 📋 Checklist de Instalação

### Passo 1: Estrutura de Arquivos
```
scavengerstoolkit/
├── mod.info
└── media/
    └── lua/
        ├── client/
        │   └── OnInventoryContextMenu_STK.lua
        ├── shared/
        │   ├── STKBagUpgrade.lua
        │   └── TimedActions/
        │       └── ISSTKBagUpgradeAction.lua
        └── server/
```

**Verificações:**
- [x] Arquivos estão nas pastas corretas
  - > Obs: Arquivos dentro de `shared/` não podem importar arquivos de `client` ou `server`
- [x] Nomes dos arquivos estão corretos (case-sensitive!)
- [x] `require` statements estão corretos nos arquivos

---

## 🔧 Pré-requisitos para Testes

### Recursos Necessários:
- [x] Character com permissão para usar comandos de debug
- [x] Acesso ao console do jogo (F11)
- [x] Mod ativado nas opções do jogo
- [x] DEBUG_MODE habilitado no código

### Itens para Testes Manuais:
```
/additem Base.Bag_Schoolbag
/additem STK.BackpackFabricBasic
/additem STK.BackpackStrapsBasic
/additem STK.BeltBuckleReinforced
/additem Base.Needle
/additem Base.Thread 5
/additem Base.Scissors
```

---

## 🎮 Testes no Jogo

### TESTE 1: Sistema Inicializa ✅
**Objetivo:** Verificar que o mod carrega sem erros

**Passos:**
1. Inicie o jogo
2. Carregue um save ou inicie novo jogo
3. Pressione `F11` para abrir console
4. Procure por mensagens de erro

**Resultado Esperado:**
```
[SimpleBoxUpgrade] Módulo carregado. DEBUG_MODE está: true
```

**Status:** ✅ Passou

**Se falhou, anote o erro:**
```
_____________________________________________
_____________________________________________
```

---

### TESTE 2: Obter Itens de Upgrade ✅
**Objetivo:** Conseguir itens STK de upgrade

**Método A - Spawn direto (modo debug):**
```lua
/additem STK.BackpackStrapsBasic
/additem STK.BackpackStrapsReinforced
/additem STK.BackpackFabricBasic
/additem STK.BackpackFabricTactical
/additem STK.BeltBuckleReinforced
/additem Base.Needle
/additem Base.Thread 5
/additem Base.Scissors
```

**Método B - Desmontar mochila (realista):**
1. Spawne uma mochila: `/additem Base.Bag_Schoolbag`
2. Spawne tesoura: `/additem Base.Scissors`
3. Clique direito na mochila
4. Procure opção de desmontar (suas recipes STK existentes)

**Resultado Esperado:**
- Itens aparecem no inventário
- Itens têm ícones corretos (ou ícone placeholder se não tem sprites)

**Status:** ✅ Passou

---

### TESTE 3: Menu de Contexto Aparece ✅
**Objetivo:** Verificar que o menu aparece nas situações corretas

**3A - Clicar na Mochila:**
1. Spawne mochila: `/additem Base.Bag_Schoolbag`
2. Spawne upgrade: `/additem STK.BackpackFabricBasic`
3. Spawne ferramentas: `/additem Base.Needle` e `/additem Base.Thread`
4. Clique direito na **mochila**

**Resultado Esperado:**
- Aparece opção "Adicionar Upgrade STK"
- Ao passar o mouse, submenu mostra "BackpackFabricBasic (+3 Capacidade)"

**Status:** ✅ Passou

**3C - Sem Ferramentas:**
1. Remova Needle e Thread do inventário
2. Clique direito na mochila

**Resultado Esperado:**
- Opção "Adicionar Upgrade STK" está **desabilitada** (cinza)
- Tooltip explica: "Você precisa de Agulha e Linha para costurar upgrades."

**Status:** [ ] ✅ Passou | [ ] ❌ Falhou

---

### TESTE 4: Adicionar Upgrade de Capacidade ✅
**Objetivo:** Instalar upgrade e verificar se capacidade aumenta

**Passos:**
1. Spawne: `/additem Base.Bag_Schoolbag`
2. Abra inventário, veja a capacidade da Schoolbag
   - **Anote capacidade original:** _____ (deve ser 15)
3. Spawne: `/additem STK.BackpackFabricBasic`
4. Spawne: `/additem Base.Needle` e `/additem Base.Thread`
5. Clique direito na Schoolbag → "Adicionar Upgrade STK" → "BackpackFabricBasic"
6. Aguarde animação (~3 segundos)
7. Verifique capacidade da Schoolbag novamente

**Resultado Esperado:**
- Capacidade era: 15
- Capacidade agora: 18 (15 + 3)
- BackpackFabricBasic foi removido do inventário
- Thread foi consumido (perdeu 1 uso)
- Personagem disse: "Upgrade instalado com sucesso!"

**Status:** ✅ Passou

**Se falhou, o que aconteceu:**
```
_____________________________________________
_____________________________________________
```

---

### TESTE 5: Adicionar Upgrade de Weight Reduction ✅
**Objetivo:** Instalar upgrade e verificar se weight reduction aumenta

**Passos:**
1. Use a mesma Schoolbag do teste anterior (capacidade 18)
2. Veja weight reduction atual
   - **Anote WR original:** _____ (deve ser 0%)
3. Spawne: `/additem STK.BackpackStrapsBasic`
4. Certifique-se de ter Needle e Thread
5. Clique direito na Schoolbag → "Adicionar Upgrade STK" → "BackpackStrapsBasic"
6. Aguarde animação
7. Verifique weight reduction

**Resultado Esperado:**
- Weight Reduction era: 0%
- Weight Reduction agora: 5% (0% + 5%)
- Capacidade continua: 18 (não mudou)
- BackpackStrapsBasic foi removido

**Status:** ✅ Passou

---

### TESTE 6: Múltiplos Upgrades no Mesmo Item ✅
**Objetivo:** Verificar que upgrades acumulam

**Passos:**
1. Use a mesma Schoolbag (Cap: 18, WR: 5%)
2. Instale BackpackFabricTactical (+8 capacidade)
3. Verifique stats

**Resultado Esperado:**
- Capacidade: 26 (18 + 8)
- Weight Reduction: 5% (não mudou)

**Status:** ✅ Passou

**Passos (continuação):**
1. Agora instale BeltBuckleReinforced (+10% WR)
2. Verifique stats

**Resultado Esperado:**
- Capacidade: 26 (não mudou)
- Weight Reduction: 15% (5% + 10%)
- Total de upgrades na mochila: 3

**Status:** [ ] ✅ Passou | [ ] ❌ Falhou

---

### TESTE 7: Limite de Upgrades ✅
**Objetivo:** Verificar que não permite mais de 3 upgrades

**Passos:**
1. Use a mochila do teste anterior (já tem 3 upgrades)
2. Spawne: `/additem STK.BackpackStrapsReinforced`
3. Certifique-se de ter Needle e Thread
4. Clique direito na mochila

**Resultado Esperado:**
- Opção "Adicionar Upgrade STK" está **desabilitada**
- Tooltip explica: "Esta mochila já atingiu o máximo de upgrades."

**Status:** ✅ Passou

---

### TESTE 8: Remover Upgrade ✅
**Objetivo:** Remover upgrade e recuperar o item

**Passos:**
1. Use a mochila com 3 upgrades (Cap: 26, WR: 15%)
2. Spawne tesoura: `/additem Base.Scissors`
3. Anote condição da tesoura: _____ / 10
4. Clique direito na mochila → "Remover Upgrade STK"
5. Escolha "BackpackFabricBasic (+3 Capacidade)"
6. Aguarde animação (~2.5 segundos)
7. Verifique:
   - Stats da mochila
   - Inventário da mochila
   - Condição da tesoura

**Resultado Esperado:**
- Capacidade voltou: 23 (26 - 3)
- Weight Reduction continua: 15%
- BackpackFabricBasic voltou para **dentro da mochila** (não no inventário principal)
- Tesoura desgastou: perdeu 1 ponto de condição
- Personagem disse: "Upgrade removido!"

**Status:** ✅ Passou

---

### TESTE 9: Persistência (Save/Load) ✅
**Objetivo:** Verificar que upgrades persistem após save

**Passos:**
1. Use a mochila atual com upgrades
2. **Anote stats atuais:**
   - Capacidade: _____
   - Weight Reduction: _____
   - Upgrades instalados: _________________
3. Salve o jogo (ESC → Save)
4. Feche completamente o jogo
5. Reabra o jogo
6. Carregue o save
7. Verifique a mochila

**Resultado Esperado:**
- Capacidade: IGUAL ao anotado
- Weight Reduction: IGUAL ao anotado
- Upgrades: Ainda instalados
- Mochila funciona normalmente

**Status:** ✅ Passou

---

### TESTE 10: Diferentes Tipos de Mochilas ✅
**Objetivo:** Verificar que funciona em vários tipos de container

**Testes Rápidos:**

**10A - Satchel:**
```
/additem Base.Bag_Satchel
```
- [x] Menu aparece
- [x] Upgrade funciona
- [x] Stats atualizam

**10B - FannyPack:**
```
/additem Base.Bag_FannyPackFront
```
- [x] Menu aparece
- [x] Upgrade funciona
- [x] Stats atualizam

**10C - Schoolbag Variants:**
```
/additem Base.Bag_Schoolbag_Medical
```
- [x] Menu aparece
- [x] Upgrade funciona
- [x] Stats atualizam

**Status Geral:** ✅ Todos passaram

---

### TESTE 11: Edge Cases ⚠️
**Objetivo:** Tentar quebrar o sistema

**11A - Mochila Equipada:**
1. Equipe a mochila (coloque nas costas)
2. Tente adicionar upgrade

**Resultado Esperado:**
- Deve funcionar normalmente OU
- Menu não aparece/está desabilitado

**Status:** ✅ Passou
```
Funcionou normalmente, tanto pra adicionar, quanto pra remover com a mochila vazia
```

**11B - Sem Thread no Meio da Ação:**
1. Inicie ação de adicionar upgrade
2. Durante a animação, jogue fora o Thread
3. Veja o que acontece

**Status:** ✅ Passou
```
Não joga a linha fora durante a animação, só depois que termina
```

**Resultado Esperado (versão FIXED):**
- Ação cancela automaticamente
- Upgrade não é aplicado
- Item de upgrade não é consumido

**Status:** ✅ Passou

**11C - Mochila Cheia:**
1. Encha a mochila completamente
2. Tente remover upgrade (que voltaria para dentro da mochila)

**Resultado Esperado:**
- Upgrade é removido
- Item cai no chão (se mochila cheia) OU
- Ação falha com mensagem

**Status:** [ ] ✅ Passou | [ ] ❌ Falhou | [ ] 🤷 Outro comportamento

---

## 🐛 Debug e Troubleshooting

### Se algo não funciona:

**1. Verifique Console (F11):**
- Procure linhas com `[STKBagUpgrade]`
- Anote erros exatos

**2. Verifique DEBUG_MODE:**
No arquivo `STKBagUpgrade.lua`, linha ~11:
```lua
local DEBUG_MODE = true  ← Certifique-se que está true
```

**3. Erros Comuns:**

| Erro | Causa | Solução |
|------|-------|---------|
| "attempt to call nil value" | require errado | Verifique paths dos require |
| "attempt to index nil" | Item não existe | Verifique spawn do item |
| Menu não aparece | Faltou ferramentas | Spawne Needle + Thread |
| Stats não atualizam | Função updateBag não chamada | Verifique callback na TimedAction |
| Upgrade não persiste | ModData não salvou | Adicione syncModData() |

---

## 📊 Planilha de Resultados

### Resumo Final

| Teste | Status | Observações |
|-------|--------|-------------|
| 1. Sistema inicializa | ✅ | |
| 2. Obter itens | ✅ | |
| 3. Menu aparece | ✅ | |
| 4. Add upgrade (Cap) | ✅ | |
| 5. Add upgrade (WR) | ✅ | |
| 6. Múltiplos upgrades | ✅ | |
| 7. Limite de upgrades | ✅ | |
| 8. Remover upgrade | ✅ | |
| 9. Persistência | ✅ | |
| 10. Tipos de mochilas | ✅ | |
| 11. Edge cases | ✅⚠️ | Ainda falta alguns |

**Taxa de Sucesso:** 11 / 11 testes

---

## ✅ Critérios para Avançar para Próxima Fase

Para considerar o CORE validado e partir para features avançadas:

- [x] **Mínimo 9/11 testes passaram** (82%)
- [x] **Testes críticos 4, 5, 6, 8, 9 TODOS passaram** (funcionalidades core)
- [x] **Nenhum crash/erro fatal** no console
- [x] **Save/Load funciona** (persistência é crítica)

Se esses critérios forem atingidos: **✅ CORE VALIDADO - Pode avançar!**

Se não: **⚠️ Precisa de ajustes - Volte e corrija problemas**

---

## 📝 Template de Bug Report

Se encontrar bugs, use este template:

```
BUG #___

O QUE ESTAVA FAZENDO:
_____________________________________________

O QUE ESPERAVA:
_____________________________________________

O QUE ACONTECEU:
_____________________________________________

ERRO NO CONSOLE (se houver):
_____________________________________________
_____________________________________________

PODE REPRODUZIR? [ ] Sim [ ] Não

PASSOS PARA REPRODUZIR:
1. ___________________________________________
2. ___________________________________________
3. ___________________________________________
```

---

## 🎯 Próximos Passos Após Validação

Quando CORE estiver 100% validado:

**Opção 1 - Features Rápidas:**
- Implementar Tailoring skill bonus
- Implementar limites por tipo de container
- Implementar knife alternative

**Opção 2 - Polish Core:**
- Adicionar tooltips customizados
- Adicionar mais feedback visual
- Adicionar sons (opcional)

**Opção 3 - Gameplay:**
- Adicionar loot distribution (opcional, já tem o sistema de disassemble)
- Balancear valores

**Decisão:** Depois dos testes, a gente decide! 🚀

---

## 💡 Dicas de Teste

1. **Teste um de cada vez** - Não pule etapas
2. **Anote tudo** - Bugs são mais fáceis de corrigir com detalhes
3. **Use DEBUG_MODE = true** - Facilita muito
4. **Salve frequentemente** - Antes de cada teste crítico
5. **Teste em mundo novo E save antigo** - Compatibilidade importa

Boa sorte nos testes! 🧪

## Observações para  Polish Core:
- [ ] Falas do personagem mais humanas, humor negro, zumbis podem ouvir?
- [ ] Mudar as descrições do quanto os materiais melhoram (ex: +8 Capacidade) para o item e não no menu de contexto, deixa o menu mais limpo.
- [ ] Menu de contexto com problemas de utf-8 ao exibir os itens disponiveis tanto para remover quando pra adicionar, (ex: "ç" e coisas do portugues)