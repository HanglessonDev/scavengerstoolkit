# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado no [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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