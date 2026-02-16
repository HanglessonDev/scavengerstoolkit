# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado no [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
  - Ajusta construtores de classes para garantir tipagem correta
  - Corrige problemas com herança de classes e metatables
  - Melhora consistência na tipagem de classes herdadas
* `.luarc.json`: atualiza configuração para melhor suporte a tipagem do Project Zomboid
  - Adiciona caminhos para bibliotecas de tipagem do jogo
  - Atualiza lista de globals com funções do mod

### Corrigido
* Erros de tipagem "param-type-mismatch" e "return-type-mismatch" no sistema de timed actions
* Problemas com herança de classes em LuaLS causando avisos incorretos
* Verificações de valores nil em operações matemáticas para evitar crashes
* Erro de exibição de nomes corretos para itens de upgrade no menu de remoção
* Erro de item de upgrade não retornando ao inventário ao ser removido
* Erro de 'call to nil' ao buscar itens de upgrade
* Erro de 'player of non-table' no menu de contexto

## [0.2.1] - 2026-02-12

### Modificado
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/ItemName_EN.txt` e `PTBR/ItemName_PTBR.txt`: removidas entradas de receitas para separar em novo arquivo
* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/Recipes_EN.txt` e `PTBR/Recipes_PTBR.txt`: novos arquivos criados para armazenar traduções de receitas
* `scavengerstoolkit/42.12/media/scripts/items/STK_BagTags.txt`: atualização das tags de desmontagem (FannyPack, SatchelBag, Schoolbag)
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: atualização das tags usadas nas receitas de desmontagem

## [0.2.0] - 2026-02-11

### Adicionado
* `scavengerstoolkit/42.12/media/scripts/recipes/STK_Recipes.txt`: receitas de desmontagem para bolsas e mochilas
  - Disassemble School Bag
  - Disassemble Fanny Pack
  - Disassemble Satchel

* `scavengerstoolkit/42.12/media/scripts/items/STK_BagTags.txt`: tags de desmontagem para Fanny Packs (front/back), Satchels (médico, militar, couro, correio, pesca), Schoolbags (infantil, médico, patches, viagem)

* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/ItemName_EN.txt` e `PTBR/ItemName_PTBR.txt`: traduções para as novas receitas de desmontagem

* `.aim/memory.jsonl`: diretrizes de tradução para manter consistência linguística

* `.luarc.json`: configuração do Lua Language Server

### Modificado
* `scavengerstoolkit/42.12/media/scripts/items/STK_Items.txt`: adicionado comentário de depreciação

### Removido
* `scavengerstoolkit/42.12/media/lua/client/STK_Client.lua`: arquivo obsoleto, não mais necessário

## [0.1.0] - 2026-02-10

### Adicionado
* `scavengerstoolkit/42.12/media/scripts/items/STK_Items.txt`: definições dos itens
  - Alças de mochila (Backpack Straps): Basic, Reinforced, Tactical
  - Tecidos de mochila (Backpack Fabric): Basic, Reinforced, Tactical
  - Fivela de cinto reforçada (Reinforced Belt Buckle)

* `scavengerstoolkit/42.12/media/scripts/items/STK_Models.txt`: modelos 3D para os novos itens

* `scavengerstoolkit/42.12/media/lua/shared/Translate/EN/ItemName_EN.txt` e `PTBR/ItemName_PTBR.txt`: traduções em inglês e português brasileiro

* `scavengerstoolkit/42.12/media/textures/`: texturas para os novos itens
  - Item_BackpackStrapsBasic.png, Item_BackpackStrapsReinforced.png, Item_BackpackStrapsTactical.png
  - Item_BackpackFabricBasic.png, Item_BackpackFabricReinforced.png, Item_BackpackFabricTactical.png
  - Item_BeltBuckleReinforced.png
  - WorldItems/BackpackFabricBasic_Piece.png, WorldItems/BackpackFabricReinforced_Piece.png, WorldItems/BackpackFabricTactical_Piece.png

* Documentação do sistema de reciclagem em `docs/`

### Modificado
* Arquivos de tradução: atualizados nomes de componentes para seguir hierarquia consistente (Basic/Reinforced/Tactical)
* Documentação: atualizada para refletir nomes atuais dos itens
* Sistema de nomenclatura padronizado para seguir formato `STK.NomeDoItem`

### Corrigido
* Erro de ortografia em "Tatical" para "Tactical" em arquivos de tradução
* Nome de modelo 3D de "BeltBuckletReinforced_Ground" para "BeltBuckleReinforced_Ground"

### Removido
* `scavengerstoolkit/42.12/media/textures/BagStrap.png` e `Belt.png`: texturas antigas não utilizadas