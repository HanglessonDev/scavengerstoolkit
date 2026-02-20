# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado no [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.14.3] - 2026-02-20
       
### Adicionado
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: novas receitas de upgrade Basic→Reinforced
  - Upgrade de alças: 2x Basic + agulha + linha + couro → 1x Reinforced (Tailoring 2)
  - Upgrade de tecido: 2x Basic + agulha + linha + denim → 1x Reinforced (Tailoring 2)
       
### Modificado
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: receitas de desmontagem atualizadas       
  - Adicionado comentário explicativo sobre ausência de requisito de Tailoring
  - Corrigido ordem dos outputs para consistência
* `scavengerstoolkit/42.12/media/lua/client/STK_FeedbackSystem.lua`: sistema de mensagens reformulado        
  - Implementado sistema de raridade com pesos (Common=13, Incommon=5, Rare=2)
  - Adicionado anti-repetição: nunca repete última mensagem por categoria
  - Adicionado cooldown de raras: cada mensagem rara dispara no máximo uma vez por sessão
  - Atualizado catálogo de mensagens com chaves estruturadas (`UI_STK_FB_<Category>_<Rarity><Index>`)
  - Adicionados métodos `resetRares()` e `resetLastUsed()` para testes
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/UI_EN.txt`, `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/UI_PTBR.txt`: traduções expandidas
  - Adicionadas mensagens humanizadas por raridade (Comum, Incomum, Rara)
  - Categorias: AddSuccess, RemoveFailed, RemoveExpert
  - Removida categoria AddFailed (não utilizada)

## [0.14.2] - 2026-02-19

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`: sons e animações específicas para ações de upgrade
  - Adicionar upgrade: som "Sewing" + animação "SewingCloth"
  - Remover upgrade: som "Sewing" + animação "SewingCloth"
  - Função `stopSound()` para limpeza segura de sons ao interromper ação

### Corrigido
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: timed actions das receitas atualizadas
  - Receitas de desmontagem: alterado de `Making` para `RipSheets`
  - Receitas de montagem: alterado de `Making` para `SewingCloth`

## [0.14.1] - 2026-02-19

### Removido
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: shim de compatibilidade legado (Fase 4) deletado
  - Módulo marcado para remoção desde a Fase 4, mantido temporariamente para migração gradual

### Modificado
* `scavengerstoolkit/42.12/media/lua/client/STK_ContextMenu.lua`: migrado de `STKBagUpgrade` para `STK_Core` diretamente
* `scavengerstoolkit/42.12/media/lua/client/STK_Tooltips.lua`: migrado de `STKBagUpgrade` para `STK_Core` diretamente
* `scavengerstoolkit/42.12/media/lua/shared/STK_Core.lua`: adicionado `initBagClient()` para inicialização segura no client (não dispara eventos server)

## [0.14.0] - 2026-02-19

### Adicionado
* Busca de ferramentas e materiais em containers equipados (worn + IsInventoryContainer)
  - Agulha, linha, tesoura, faca e itens de upgrade agora são encontrados sem precisar mover itens manualmente

### Corrigido
* `scavengerstoolkit/42.12/media/lua/server/STK_UpgradeLogic.lua`: ferramentas com condição 0 (quebradas) agora permanecem no inventário como itens quebrados ao invés de serem removidas
  - Afeta: agulha, tesoura, faca
  - Comportamento alinhado com vanilla PZ: `setCondition(0)` deixa item no inventário com estado quebrado
  - Thread (consumível) continua sendo removido quando esgota

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STK_Core.lua`: refatorada lógica de busca de ferramentas para incluir containers equipados
* `scavengerstoolkit/42.12/media/lua/server/STK_UpgradeLogic.lua`: atualizada validação para suportar busca em containers equipados
* `scavengerstoolkit/42.12/media/lua/server/STK_Validation.lua`: expandida validação para verificar ferramentas em containers equipados
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: atualizada lógica de verificação de materiais para incluir containers equipados
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`: atualizada ação para usar nova lógica de busca
* `scavengerstoolkit/42.12/media/lua/client/STK_ContextMenu.lua`: atualizado menu de contexto para refletir nova funcionalidade

## [0.13.1] - 2026-02-18

### Corrigido
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: adicionada flag `IsNotWorn` nas receitas de desmontagem para impedir que mochilas equipadas sejam desmontadas acidentalmente
  - Afeta: Schoolbag, FannyPack, SatchelBag, HikingBag, DuffelBag
  - Previne perda catastrófica de mochila em uso + todo inventário

## [0.13.0] - 2026-02-18

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STK_Logger.lua`: novo módulo de logging centralizado com níveis debug/info/warn/error e função wrap() para proteger event listeners de crashes

### Modificado
* `scavengerstoolkit/42.12/media/lua/client/STK_ContextMenu.lua`: substituído logger local por STK_Logger, melhorada formatação e estrutura do código
* `scavengerstoolkit/42.12/media/lua/client/STK_FeedbackSystem.lua`: substituído logger local por STK_Logger, adicionado log.wrap() nos listeners de eventos
* `scavengerstoolkit/42.12/media/lua/client/STK_SilentSpeaker.lua`: substituído logger local por STK_Logger, removido código de logging duplicado
* `scavengerstoolkit/42.12/media/lua/server/STK_Commands.lua`: substituído logger local por STK_Logger, adicionado log.wrap() nos listeners de eventos
* `scavengerstoolkit/42.12/media/lua/server/STK_KnifeAlternative.lua`: substituído logger local por STK_Logger, melhorada estrutura de logs
* `scavengerstoolkit/42.12/media/lua/server/STK_TailoringXP.lua`: substituído logger local por STK_Logger, removido código duplicado
* `scavengerstoolkit/42.12/media/lua/server/STK_UpgradeLogic.lua`: substituído logger local por STK_Logger, adicionado log.error() para validação de parâmetros inválidos
* `scavengerstoolkit/42.12/media/lua/server/STK_Validation.lua`: substituído logger local por STK_Logger, adicionado log.warn() para validações falhas
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: substituído logger local por STK_Logger, removida documentação obsoleta sobre hooks
* `scavengerstoolkit/42.12/media/lua/shared/STK_Events.lua`: substituído logger local por STK_Logger

### Removido
* Código de logging duplicado em todos os módulos (~200 linhas removidas) - centralizado em STK_Logger.lua

## [0.12.0] - 2026-02-18

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STK_Constants.lua`: novo módulo shared como fonte única de verdade para dados estáticos (VALID_BAGS, BAG_LIMIT_RULES, VIABLE_KNIVES)

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STK_Core.lua`: refatorado para usar `STK_Constants`, moveu lógica de limites para `getLimitForType()`, simplificou `isValidBag()` e `canAddUpgrade()`, adicionou inicialização correta de `LMaxUpgrades` no `initBagData()`
* `scavengerstoolkit/42.12/media/lua/server/STK_KnifeAlternative.lua`: agora utiliza `STK_Constants.VIABLE_KNIVES` em vez de tabela local duplicada
* `scavengerstoolkit/42.12/media/lua/client/STK_SilentSpeaker.lua`: alterado de `UIFont.Small` para `UIFont.Dialogue` para melhor consistência visual

### Removido
* `scavengerstoolkit/42.12/media/lua/server/STK_ContainerLimits.lua`: módulo removido - lógica de limites centralizada em `STK_Core.getLimitForType()` com dados de `STK_Constants`

## [0.11.0] - 2026-02-17

### Adicionado
* `docs/ARCHITECTURE_PROPOSAL_EVENTS.md`, `docs/STK_AttachmentsTest.lua`: nova documentação de arquitetura baseada em eventos e arquivo de teste
* `docs/POLISH.md`: backlog de melhorias de polimento (UI/UX, feedback visual, sons, partículas)
* `scavengerstoolkit/42.12/media/lua/client/STK_ContextMenu.lua`: novo módulo de menu de contexto centralizado
* `scavengerstoolkit/42.12/media/lua/client/STK_FeedbackSystem.lua`: novo módulo de feedback humanizado com falas coloridas
* `scavengerstoolkit/42.12/media/lua/client/STK_SilentSpeaker.lua`: novo módulo para mensagens de chat silenciosas (sem audição de zombies)
* `scavengerstoolkit/42.12/media/lua/client/STK_Tooltips.lua`: novo módulo de tooltips dinâmicos para mochilas e upgrades
* `scavengerstoolkit/42.12/media/lua/server/STK_Commands.lua`: novo módulo de comandos server (OnNewGame, OnPlayer Join)
* `scavengerstoolkit/42.12/media/lua/server/STK_ContainerLimits.lua`: novo módulo de limites de upgrades por tipo de mochila (movido para server)
* `scavengerstoolkit/42.12/media/lua/server/STK_KnifeAlternative.lua`: novo módulo de facas alternativas para tesouras (movido para server)
* `scavengerstoolkit/42.12/media/lua/server/STK_TailoringXP.lua`: novo módulo de XP de costura com chance de falha (movido para server)
* `scavengerstoolkit/42.12/media/lua/server/STK_UpgradeLogic.lua`: novo módulo de lógica de upgrades (movido para server)
* `scavengerstoolkit/42.12/media/lua/server/STK_Validation.lua`: novo módulo de validação de ferramentas e upgrades (movido para server)
* `scavengerstoolkit/42.12/media/lua/shared/STK_Core.lua`: novo módulo core do sistema com inicialização centralizada
* `scavengerstoolkit/42.12/media/lua/shared/STK_Events.lua`: novo módulo de eventos para comunicação client/server
* `scavengerstoolkit/42.12/media/lua/shared/STK_Utils.lua`: novo módulo de utilitários gerais

### Corrigido
* `scavengerstoolkit/42.12/media/lua/server/STK_Commands.lua`, `STK_UpgradeLogic.lua`: correção de chamada de eventos e validação de ferramentas alternativas
* `scavengerstoolkit/42.12/media/lua/server/STK_TailoringXP.lua`, `STK_Validation.lua`: eliminação de duplicação de código client/server de XP e ferramentas

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: refatoração para nova arquitetura com hooks e sistema de prioridades
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`: atualização para usar novos módulos server e correção de warnings LuaLS
* `scavengerstoolkit/42.12/media/lua/client/STK_SilentSpeaker.lua`: alterado de `UIFont.Small` para `UIFont.Dialogue` para melhor consistência visual
* `docs/COMPONENTES.md`, `docs/CONCEITO.md`: atualização de documentação de arquitetura e conceitos
* `.aim/memory.jsonl`: atualização de diretrizes de tradução
* **Cabeçalhos de copyright**: adicionados em todos os arquivos Lua do projeto

### Removido
* `docs/BALANCEAMENTO.md`, `docs/ITEMS_DATABASE.md`, `docs/PLANO_TESTES_CORE.md`, `docs/RECEITAS.md`: documentação obsoleta ou movida para outros locais
* `scavengerstoolkit/42.12/media/lua/client/OnInventoryContextMenu_STK.lua`: menu de contexto legado (substituído por STK_ContextMenu.lua)
* `scavengerstoolkit/42.12/media/lua/client/ToolTipInvOverride_STK.lua`: override de tooltips legado (substituído por STK_Tooltips.lua)
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`, `STK_FeedbackSystem.lua`, `STK_KnifeAlternative.lua`, `STK_SilentSpeaker.lua`, `STK_TailoringXP.lua`: módulos movidos para pasta server na nova arquitetura

## [0.10.1] - 2026-02-16

### Adicionado
* `docs/API-PZ/INVENTORY-API-REFERENCE.md`: nova documentação de referência completa da API de inventário do Project Zomboid com todos os métodos de InventoryItem e ItemContainer, incluindo parâmetros, tipos de retorno e exemplos de uso prático

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`: otimiza sistema para evitar spam de logs através de tracking de bags processadas com weak table (GC automático), adiciona funções utilitárias `clearCache()` e `isProcessed()`, e mantém logs apenas na primeira inicialização de cada bag

## [0.10.0] - 2026-02-16

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: adiciona suporte para novos tipos de mochilas (Hiking Bags e Duffel Bags)
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`: expande sistema de limites para novos tipos de mochilas
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Recipes_EN.txt`, `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Recipes_PTBR.txt`: adiciona traduções para novas receitas de desmontagem e upgrade
* `scavengerstoolkit/42.12/media/scripts/items/STK_BagTags.txt`: adiciona tags para novos tipos de mochilas (HikingBag, DuffelBag)
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: cria novas receitas de desmontagem para diferentes tipos de mochilas e receitas de upgrade de itens

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: refatora sistema de validação de mochilas para incluir novos tipos
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`: atualiza sistema de limites para funcionar com novos tipos de mochilas
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/ItemName_EN.txt`, `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/ItemName_PTBR.txt`: formatação e organização dos arquivos de tradução

### Removido
* `scavengerstoolkit/42.12/media/scripts/items/STK_ItemsBags.txt`: remove arquivos obsoletos de receitas antigas
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_RecripesBags.txt`: remove arquivos obsoletos de receitas antigas

## [0.9.1] - 2026-02-15

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: Removido o uso de `player:Say()` legado para feedback do jogador.
* `scavengerstoolkit/42.12/media/lua/shared/STK_FeedbackSystem.lua`: Centralizado o sistema de feedback, substituindo todas as mensagens hardcoded por chaves de tradução e removendo o fallback genérico para usar apenas mensagens "humanizadas".
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/UI_EN.txt`, `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/UI_PTBR.txt`: Adicionadas chaves de tradução para as mensagens de feedback humanizadas e removidas as chaves genéricas não utilizadas.

## [0.9.0] - 2026-02-15

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STK_FeedbackSystem.lua`, `scavengerstoolkit/42.12/media/lua/shared/STK_SilentSpeaker.lua`: Novo sistema de Feedback Humanizado, que centraliza as mensagens de feedback do jogador com falas coloridas e não intrusivas.

### Corrigido
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`, `scavengerstoolkit/42.12/media/lua/shared/STK_TailoringXP.lua`: Corrigida a integração do sistema de remoção de upgrades, onde a falha na remoção não destruía o material. Agora, em caso de falha, o upgrade é removido da mochila (destruído), o item não é devolvido e o feedback de falha é acionado corretamente.

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: Refatoração da função `removeUpgrade` para centralizar a lógica de sucesso/falha e eliminar duplicação de código.
* `scavengerstoolkit/42.12/media/lua/shared/STK_TailoringXP.lua`: Ajustes no fluxo de chance de falha para se integrar corretamente com o novo sistema de feedback.

## [0.8.1] - 2026-02-15

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STK_TailoringXP.lua`:
  - Atualiza sistema de cores para o formato RGB inteiro (0-255)
  - Converte valores de XP de decimal para percentual inteiro
  - Adiciona feedback visual com HaloTextHelper para ganho de XP e falhas
  - Simplifica uso de player:Say() sem parâmetros de cor
  - Adiciona novas mensagens de sucesso e falha para o jogador
  - Implementa sistema de cores definidas para diferentes tipos de feedback
  - Adiciona função de teste para cores do HaloTextHelper
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Sandbox_EN.txt`:
  - Atualiza tooltips para refletir valores inteiros em vez de decimais
  - Adiciona explicações sobre conversão de porcentagens
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/UI_EN.txt`:
  - Adiciona novas mensagens de sucesso para adição de upgrades
  - Adiciona mensagem de destruição de material para popups visuais
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Sandbox_PTBR.txt`:
  - Atualiza tooltips para refletir valores inteiros em vez de decimais
  - Adiciona explicações sobre conversão de porcentagens
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/UI_PTBR.txt`:
  - Adiciona novas mensagens de sucesso para adição de upgrades
  - Adiciona mensagem de destruição de material para popups visuais
* `scavengerstoolkit/42.12/media/sandbox-options.txt`:
  - Altera tipos de opções de XP de double para integer
  - Atualiza valores padrão e limites para refletir sistema de porcentagens inteiras

## [0.8.0] - 2026-02-15

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STK_TailoringXP.lua`: nova funcionalidade que adiciona sistema de XP e falha na remoção de upgrades de costura
  - Implementa ganho de XP ao adicionar upgrades com redução progressiva baseada no nível de habilidade
  - Adiciona chance de falha ao remover upgrades que destrói o material, com redução baseada na habilidade
  - Inclui sistema de mensagens para feedback ao jogador sobre sucesso/falha
  - Adiciona opções configuráveis via sandbox para controle do sistema

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Sandbox_EN.txt`:
  - Adiciona traduções para novas opções de sandbox relacionadas ao sistema de XP de costura
  - Adiciona opções para configurar XP base, redução por nível e chance de falha
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/UI_EN.txt`:
  - Adiciona mensagens de falha e sucesso para o sistema de costura
  - Inclui mensagens para jogadores inexperientes e experientes
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Sandbox_PTBR.txt`:
  - Adiciona traduções para novas opções de sandbox relacionadas ao sistema de XP de costura
  - Adiciona opções para configurar XP base, redução por nível e chance de falha
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/UI_PTBR.txt`:
  - Adiciona mensagens de falha e sucesso para o sistema de costura
  - Inclui mensagens para jogadores inexperientes e experientes
* `scavengerstoolkit/42.12/media/sandbox-options.txt`:
  - Adiciona novas opções de configuração para o sistema de XP de costura
  - Inclui opções para habilitar/desabilitar o sistema e ajustar parâmetros

## [0.7.1] - 2026-02-14

### Modificado
* `scavengerstoolkit/42.12/media/lua/client/OnInventoryContextMenu_STK.lua`:
  - Adiciona função helper `setTooltip()` para exibir tooltips consistentes nas opções
  - Implementa tooltips informativos para opções indisponíveis no menu
  - Adiciona ordenação alfabética para itens de upgrade no menu de adição
  - Adiciona ordenação alfabética para upgrades no menu de remoção
  - Atualiza texto de validação para refletir suporte a facas alternativas
* `scavengerstoolkit/42.12/media/lua/client/ToolTipInvOverride_STK.lua`:
  - Calcula dinamicamente apenas linhas relevantes no tooltip (slots, bônus reais)
  - Adiciona cores distintas para informações de mochila e de upgrade
  - Corrige cálculo de valores de redução de peso (ajusta conversão de percentual)
  - Melhora legibilidade geral do sistema de tooltips
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`:
  - Otimiza busca de tipo de mochila (usa texto simples em vez de pattern matching - ~30% mais rápido)
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`:
  - Atualiza textos de ações para usar sistema de tradução
  - Implementa uso correto de desgaste de tesouras (apenas quando realmente usadas)
  - Adiciona tempos configuráveis via sandbox para ações de adicionar/remover upgrades
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/UI_EN.txt`:
  - Adiciona traduções para textos de instalação e remoção de upgrades
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/UI_PTBR.txt`:
  - Adiciona traduções para textos de instalação e remoção de upgrades

## [0.7.0] - 2026-02-14

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STK_KnifeAlternative.lua`: nova funcionalidade que permite o uso de facas como alternativa às tesouras para remoção de upgrades
  - Implementa sistema de verificação de facas viáveis (cozinha, caça, canivete, etc.)
  - Adiciona opção configurável via sandbox para habilitar/desabilitar a funcionalidade
  - Inclui sistema de desgaste das facas ao serem usadas para remoção de upgrades
  - Registra hooks para integração com o sistema de upgrades
* `scavengerstoolkit/42.12/media/lua/client/ToolTipInvOverride_STK.lua`:
  - Adiciona documentação completa com anotações LuaLS (@file, @brief, @author, @version, @license, @copyright)
  - Adiciona tipagem apropriada para os campos do tooltip
* Novas opções de sandbox adicionadas para controlar a funcionalidade de facas alternativas

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`:
  - Atualiza sistema de verificação de ferramentas para permitir facas como alternativa às tesouras
  - Adiciona hook checkRemoveTools para verificação de ferramentas alternativas
  - Atualiza lógica de validação de ferramentas para remover upgrades
  - Remove código morto (tabela upgradeItemValues comentada)
  - Otimiza função getUpgradeItems() com cache de container.getItems()
  - Otimiza função isBagValid() usando lookup table O(1) ao invés de loop O(n)
  - Corrige acentuação em mensagens de log
  - Atualiza documentação com mudanças realizadas
* `scavengerstoolkit/42.12/media/lua/client/ToolTipInvOverride_STK.lua`:
  - Atualiza exibição de valores de upgrade para usar sistema de tradução
  - Adiciona verificações `value and value > 0` para evitar erros com valores nil
  - Renomeia variável `color` para `colorUpgrade` por clareza
  - Adiciona anotações `@diagnostic disable` para lidar com warnings do EmmyLua
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`:
  - Atualiza validação de remoção de upgrade para usar sistema de verificação de ferramentas expandido
  - Melhora robustez da verificação de ferramentas durante ações
* `.luarc.json`:
  - Atualiza configuração com novas funções e classes do Project Zomboid
  - Adiciona desativação da regra "lowercase-global" para compatibilidade

### Corrigido
* `scavengerstoolkit/42.12/media/lua/client/ToolTipInvOverride_STK.lua`:
  - Corrige tratamento de valores nil para evitar erros de runtime
  - Corrige warnings do EmmyLua com anotações apropriadas

## [0.6.0] - 2026-02-14

### Adicionado
* `scavengerstoolkit/42.12/media/lua/client/ToolTipInvOverride_STK.lua`: novo script para estender a funcionalidade de tooltips
  - Implementa sistema dinâmico para exibir informações de upgrades nas mochilas
  - Exibe slots disponíveis/utilizados, bônus de capacidade e redução de peso
  - Exibe valores de upgrade para itens de melhoria (capacidade e redução de peso)
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/UI_EN.txt`: arquivo de tradução para textos de interface em inglês
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/UI_PTBR.txt`: arquivo de tradução para textos de interface em português brasileiro

### Modificado
* `scavengerstoolkit/42.12/media/scripts/items/STK_Items.txt`:
  - Comentários nas linhas de tooltip para evitar conflitos com o novo sistema dinâmico
  - Linhas afetadas: BackpackStrapsBasic, BackpackStrapsReinforced, BackpackStrapsTactical, BackpackFabricBasic, BackpackFabricReinforced, BackpackFabricTactical, BeltBuckleReinforced

### Renomeado
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Tooltip_EN.txt` → `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Tooltip_.txt`
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Tooltip_PTBR.txt` → `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Tooltip_.txt`

## [0.5.0] - 2026-02-14

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Sandbox_EN.txt`: arquivo de tradução para opções de sandbox em inglês
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Sandbox_PTBR.txt`: arquivo de tradução para opções de sandbox em português brasileiro
* `scavengerstoolkit/42.12/media/sandbox-options.txt`: opções configuráveis via sandbox para ajustar limites de upgrade e valores de itens
  - Opções para definir limites de upgrade por tipo de mochila (FannyPack, Satchel, Schoolbag)
  - Opções para ajustar valores dos upgrades (alças, tecido, fivela)
  - Opções para habilidades como costura e tempo de craft

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`:
  - Atualização para ler valores de upgrade do SandboxVars em vez de valores fixos
  - Implementação de lógica condicional para obter valores configuráveis de sandbox
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`:
  - Atualização para ler limites de container do SandboxVars em vez de valores fixos
  - Implementação de função getLimitForBagType para obter limites configuráveis

## [0.4.1] - 2026-02-13

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: sistema de prioridades para hooks com níveis (VERY_HIGH, HIGH, NORMAL, LOW)
  - Registro de hooks com prioridade específica para controle de ordem de execução
  - Validação aprimorada para operações de adição/remoção de upgrades
  - Melhorias no sistema de logging com informações detalhadas de prioridade

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`:
  - Implementação do sistema de hooks para suportar prioridades de execução
  - Atualização do sistema de registro de hooks para aceitar parâmetro de prioridade
  - Melhoria na ordenação e execução de hooks baseada em prioridades
  - Atualização da lógica de validação para considerar prioridades de hooks
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`:
  - Registro de hook com prioridade VERY_HIGH para execução em primeiro lugar

## [0.4.0] - 2026-02-13

### Adicionado
* `scavengerstoolkit/42.12/media/lua/shared/STK_ContainerLimits.lua`: nova funcionalidade que define limites dinâmicos de upgrades baseados no tipo de container
  - Implementa sistema de hooks para extensibilidade
  - Define limites específicos para diferentes tipos de mochilas (FannyPack: 1, Satchel: 2, Schoolbag: 3)
  - Permite sobrescrita de limites padrão para compatibilidade com outros mods
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: adiciona sistema de hooks para extensibilidade
  - Implementa pontos de extensão (beforeInitBag, afterInitBag, beforeAdd, afterAdd, beforeRemove, afterRemove)
  - Permite que outras funcionalidades se integrem ao fluxo principal
  - Atualiza lógica para suportar limites dinâmicos de containers

### Modificado
* `scavengerstoolkit/42.12/media/lua/client/OnInventoryContextMenu_STK.lua`:
  - Atualiza menu de contexto para usar sistema de tradução
  - Remove exibição de estatísticas nos nomes dos itens no menu (agora exibidos em tooltips)
  - Melhora consistência com sistema de tradução existente

### Adicionado
* Sistema de hooks para extensibilidade do módulo STKBagUpgrade
  - Pontos de extensão (beforeInitBag, afterInitBag, beforeAdd, afterAdd, beforeRemove, afterRemove)
  - Nova funcionalidade de limites dinâmicos de containers (STK_ContainerLimits.lua)
  - Definição de limites específicos por tipo de container

## [0.3.1] - 2026-02-13

### Corrigido
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/ContextMenu_PTBR.txt`: corrige acentuação e caracteres especiais em português brasileiro
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/ContextMenu_EN.txt`: adiciona arquivo de tradução para contexto em inglês
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Tooltip_EN.txt`: adiciona arquivo de tradução para tooltips em inglês
* `scavengerstoolkit/42.12/media/lua/shared/Translate/PTBR/Tooltip_PTBR.txt`: adiciona arquivo de tradução para tooltips em português brasileiro
* `scavengerstoolkit/42.12/media/scripts/items/STK_Items.txt`: atualiza com correções de nomenclatura

## [0.3.0] - 2026-02-13

### Adicionado
* `docs/PLANO_TESTES_CORE.md`: novo documento com plano detalhado de testes para o sistema de upgrades de mochilas
* `scavengerstoolkit/42.12/media/lua/client/OnInventoryContextMenu_STK.lua`: adição de anotações LuaLS (@class, @param, @return, etc.)
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: adição de anotações LuaLS completas
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`: adição de anotações LuaLS e melhorias de tipagem

### Modificado
* `scavengerstoolkit/42.12/media/lua/client/OnInventoryContextMenu_STK.lua`:
  - Corrige avisos de tipagem relacionados a valores nil em operações matemáticas
  - Adiciona verificações `value and value > 0` para evitar erros
  - Atualiza construtores para garantir tipagem correta
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`:
  - Adiciona verificação de valores nil antes de operações matemáticas
  - Melhora consistência na tipagem de funções
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`:
  - Ajusta construtor para garantir inicialização correta dos campos
  - Melhora tipagem de parâmetros e retornos

### Corrigido
* Erros de runtime causados por valores nil em operações matemáticas
* Warnings do LuaLS em todos os módulos principais

## [0.2.0] - 2026-02-12

### Adicionado
* Sistema de upgrade de mochilas com suporte a alças, tecidos e fivelas
* Menu de contexto para adicionar e remover upgrades
* Sistema de limites de upgrades por tipo de mochila
* Traduções em inglês e português brasileiro

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/STKBagUpgrade.lua`: implementação inicial do sistema de upgrades
* `scavengerstoolkit/42.12/media/lua/client/OnInventoryContextMenu_STK.lua`: menu de contexto para upgrades
* `scavengerstoolkit/42.12/media/lua/shared/TimedActions/ISSTKBagUpgradeAction.lua`: ações cronometradas para upgrades

## [0.1.0] - 2026-02-11

### Adicionado
* Estrutura inicial do projeto ScavengersToolkit
* Configuração de módulos e scripts básicos
* Documentação inicial (README, CHANGELOG, ROADMAP)
