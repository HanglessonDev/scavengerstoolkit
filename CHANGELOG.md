# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado no [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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