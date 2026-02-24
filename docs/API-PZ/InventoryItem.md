# Documentação Técnica: InventoryItem

> **Project Zomboid** - Classe de Itens do Inventário  
> Namespace: `zombie.inventory.InventoryItem`

---

## Visão Geral

A classe `InventoryItem` representa um item individual no inventário do Project Zomboid. É uma das classes fundamentais do sistema de itens do jogo, herdando de `GameEntity` e fornecendo funcionalidades extensas para gerenciamento de estado, propriedades físicas, condições, fluidos, e muito mais.

---

## Hierarquia de Classes

```
GameEntity (superclasse)
    └── InventoryItem
            ├── ClothingItem
            ├── WeaponItem
            ├── FoodItem
            └── ... (outras especializações)
```

---

## Criação de Instâncias

### Construtores Estáticos

```lua
-- Criar novo item a partir de parâmetros básicos
---@param module string      -- Módulo do item (ex: "Base")
---@param name string        -- Nome do item (ex: "Axe")
---@param type string        -- Tipo completo (ex: "Base.Axe")
---@param tex string         -- Textura do item
---@return InventoryItem
InventoryItem.new(module, name, type, tex)

-- Criar novo item a partir de definição ScriptItem
---@param module string
---@param name string
---@param type string
---@param item Item          -- Definição do script do item
---@return InventoryItem
InventoryItem.new(module, name, type, item)

-- Carregar item de ByteBuffer (save/load)
---@param input ByteBuffer
---@param WorldVersion integer
---@param doSaveTypeCheck boolean?
---@param i InventoryItem?
---@return InventoryItem
InventoryItem.loadItem(input, WorldVersion, doSaveTypeCheck, i)
```

---

## Métodos de Identificação

### Identificadores Únicos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getID()` | `integer` | **ID único da instância** do item no mundo |
| `:getType()` | `string` | Tipo completo do item (ex: `"Base.Axe"`) |
| `:getName()` | `string` | Nome técnico do item |
| `:getName(player)` | `string` | Nome do item (pode variar por jogador) |
| `:getDisplayName()` | `string` | Nome para exibição na UI |
| `:getFullType()` | `string` | Tipo completo formatado |
| `:getStringItemType()` | `string` | Tipo como string simples |
| `:getModule()` | `string` | Módulo de origem (ex: `"Base"`, `"YourMod"`) |
| `:getModID()` | `string` | ID do mod que adicionou o item |
| `:getModName()` | `string` | Nome do mod |
| `:getRegistry_id()` | `integer` | ID de registro no sistema |
| `:getEntityNetID()` | `integer` | ID para sincronização de rede |

### Exemplo de Uso

```lua
local item = player:getInventory():getFirstItem("Base.Axe")

if item then
    local id = item:getID()              -- ID único: 12345
    local type = item:getType()          -- Tipo: "Base.Axe"
    local name = item:getName()          -- Nome: "Axe"
    local display = item:getDisplayName() -- Ex: "Axe" ou "Rusty Axe"
    local module = item:getModule()      -- Módulo: "Base"
end
```

---

## Métodos de Estado e Condição

### Condição do Item

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getCondition()` | `integer` | Condição atual (0-100) |
| `:getConditionMax()` | `integer` | Condição máxima possível |
| `:getCurrentCondition()` | `number` | Condição em porcentagem (0-100) |
| `:setCondition(value, doSound?)` | - | Define condição atual |
| `:incrementCondition(increment)` | - | Incrementa/decrementa condição |
| `:reduceCondition()` | - | Reduz condição naturalmente |
| `:randomizeCondition()` | - | Randomiza condição |
| `:isDamaged()` | `boolean` | Verifica se está danificado |
| `:isBroken()` | `boolean` | Verifica se está quebrado |
| `:setBroken(broken)` | - | Define estado quebrado |
| `:onBreak()` | - | Executa lógica de quebra |

### Condição da Lâmina (Armas Cortantes)

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getSharpness()` | `number` | Afiamento atual |
| `:getMaxSharpness()` | `number` | Afiamento máximo |
| `:setSharpness(value)` | - | Define afiamento |
| `:isSharpenable()` | `boolean` | Pode ser afiado |
| `:isDull()` | `boolean` | Está sem fio |
| `:sharpnessCheck(...)` | `boolean` | Verifica afiamento com skill |
| `:applyMaxSharpness()` | - | Restaura afiamento máximo |

### Condição da Cabeça (Armas)

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getHeadCondition()` | `integer` | Condição da cabeça |
| `:getHeadConditionMax()` | `integer` | Condição máxima da cabeça |
| `:setHeadCondition(value)` | - | Define condição da cabeça |
| `:hasHeadCondition()` | `boolean` | Possui condição de cabeça |
| `:headConditionCheck(...)` | `boolean` | Verifica condição |
| `:getTimesRepaired()` | `integer` | Vezes reparado |
| `:getTimesHeadRepaired()` | `integer` | Vezes reparado (cabeça) |

---

## Métodos de Peso e Capacidade

### Peso

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getWeight()` | `number` | Peso base do item |
| `:getActualWeight()` | `number` | Peso real (com modificações) |
| `:getEquippedWeight()` | `number` | Peso quando equipado |
| `:getUnequippedWeight()` | `number` | Peso quando não equipado |
| `:getContentsWeight()` | `number` | Peso do conteúdo |
| `:getExtraItemsWeight()` | `number` | Peso de itens extras |
| `:setWeight(weight)` | - | Define peso base |
| `:setActualWeight(weight)` | - | Define peso real |
| `:isCustomWeight()` | `boolean` | Peso customizado |

### Capacidade e Usos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getMaxCapacity()` | `integer` | Capacidade máxima |
| `:getItemCapacity()` | `number` | Capacidade do item |
| `:getMaxUses()` | `integer` | Usos máximos |
| `:getCurrentUses()` | `integer` | Usos atuais |
| `:getCurrentUsesFloat()` | `number` | Usos atuais (float) |
| `:getMaxAmmo()` | `integer` | Munição máxima |
| `:getCurrentAmmoCount()` | `integer` | Munição atual |
| `:setCount(count)` | - | Define quantidade (stack) |
| `:getCount()` | `integer` | Quantidade no stack |

---

## Métodos de Contêiner e Posição

### Contêiner

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getContainer()` | `ItemContainer` | Contêiner atual |
| `:setContainer(container)` | - | Define contêiner |
| `:getContainerX()` | `integer` | Posição X no contêiner |
| `:getContainerY()` | `integer` | Posição Y no contêiner |
| `:setContainerX(x)` | - | Define posição X |
| `:setContainerY(y)` | - | Define posição Y |
| `:getOutermostContainer()` | `ItemContainer` | Contêiner mais externo |
| `:getRightClickContainer()` | `ItemContainer` | Contêiner do clique direito |
| `:OnAddedToContainer(container)` | - | Callback ao adicionar |
| `:OnBeforeRemoveFromContainer(container)` | - | Callback antes de remover |

### Posição no Mundo

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getSquare()` | `IsoGridSquare` | Quadrado atual no mundo |
| `:getWorldItem()` | `IsoWorldInventoryObject` | Objeto de mundo |
| `:setWorldItem(worldItem)` | - | Define objeto de mundo |
| `:getX()` | `number` | Coordenada X |
| `:getY()` | `number` | Coordenada Y |
| `:getZ()` | `number` | Coordenada Z |
| `:getOriginX()` | `integer` | Origem X |
| `:getOriginY()` | `integer` | Origem Y |
| `:getOriginZ()` | `integer` | Origem Z |
| `:setOrigin(x, y, z)` | `boolean` | Define origem |
| `:RemoveFromContainer(item)` | `boolean` | Remove do contêiner (estático) |

---

## Métodos de Propriedades Visuais

### Texturas e Ícones

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getTexture()` | `Texture` | Textura principal |
| `:getIcon()` | `Texture` | Ícone do item |
| `:setIcon(texture)` | - | Define ícone |
| `:getTex()` | `Texture` | Textura atual |
| `:setTexture(texture)` | - | Define textura |
| `:getTextureBurnt()` | `Texture` | Textura queimada |
| `:getTextureCooked()` | `Texture` | Textura cozida |
| `:getTexturerotten()` | `Texture` | Textura podre |
| `:getTextureColorMask()` | `Texture` | Máscara de cor |
| `:getTextureFluidMask()` | `Texture` | Máscara de fluido |
| `:getStaticModel()` | `string` | Modelo estático |
| `:getWorldStaticModel()` | `string` | Modelo estático do mundo |

### Cores

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getColor()` | `Color` | Cor do item |
| `:setColor(color)` | - | Define cor |
| `:getColorRed()` | `number` | Componente vermelho |
| `:getColorGreen()` | `number` | Componente verde |
| `:getColorBlue()` | `number` | Componente azul |
| `:setColorRed(value)` | - | Define vermelho |
| `:setColorGreen(value)` | - | Define verde |
| `:setColorBlue(value)` | - | Define azul |
| `:isCustomColor()` | `boolean` | Cor customizada |

---

## Métodos de Estado Especial

### Comida e Podridão

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:isFood()` | `boolean` | É comida |
| `:getAge()` | `number` | Idade do item |
| `:setAge(age)` | - | Define idade |
| `:updateAge()` | - | Atualiza idade |
| `:isRotten()` | `boolean` | Está podre |
| `:HowRotten()` | `number` | Nível de podridão |
| `:isCooked()` | `boolean` | Está cozido |
| `:setCooked(cooked)` | - | Define estado cozido |
| `:isCookable()` | `boolean` | Pode cozinhar |
| `:getCookingTime()` | `number` | Tempo de cozimento |
| `:getMinutesToCook()` | `number` | Minutos para cozinhar |
| `:getMinutesToBurn()` | `number` | Minutos para queimar |
| `:getFoodSicknessChange()` | `integer` | Mudança de enjoo |
| `:inheritOlderFoodAge(other)` | - | Herda idade de outra comida |

### Fluidos e Líquidos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:isFluidContainer()` | `boolean` | É contêiner de fluido |
| `:isEmptyOfFluid()` | `boolean` | Está vazio |
| `:isFullOfFluid()` | `boolean` | Está cheio |
| `:isBeingFilled()` | `boolean` | Está sendo enchido |
| `:getFluidContainerFromSelfOrWorldItem()` | `FluidContainer` | Obtém contêiner de fluido |
| `:storeWater(amount)` | - | Armazena água |
| `:emptyLiquid()` | `InventoryItem` | Esvazia líquido |

### Sangue e Sujeira

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getBloodLevel()` | `number` | Nível de sangue |
| `:setBloodLevel(level)` | - | Define nível de sangue |
| `:getBlood(bodyPartType)` | `number` | Sangue por parte do corpo |
| `:setBlood(bodyPartType, amount)` | - | Define sangue |
| `:hasBlood()` | `boolean` | Possui sangue |
| `:isBloody()` | `boolean` | Está sangrento |
| `:getBloodClothingType()` | `ArrayList` | Tipos de sangue na roupa |
| `:getDirt(bodyPartType)` | `number` | Sujeira por parte |
| `:setDirt(bodyPartType, amount)` | - | Define sujeira |
| `:hasDirt()` | `boolean` | Possui sujeira |
| `:isWet()` | `boolean` | Está molhado |
| `:setWet(wet)` | - | Define estado molhado |
| `:getWetness()` | `number` | Nível de molhamento |

---

## Métodos de Equipamento

### Estado de Equipamento

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:isEquipped()` | `boolean` | Está equipado |
| `:isEquippedNoSprint()` | `boolean` | Equipado (sem sprint) |
| `:isFakeEquipped()` | `boolean` | Falsamente equipado |
| `:isFakeEquipped(character)` | `boolean` | Falsamente equipado (personagem) |
| `:getEquipParent()` | `IsoGameCharacter` | Personagem que equipou |
| `:setEquipParent(parent, register?)` | - | Define personagem |
| `:getUser()` | `IsoGameCharacter` | Usuário atual |
| `:getOwner()` | `IsoGameCharacter` | Proprietário |
| `:getPreviousOwner()` | `IsoGameCharacter` | Proprietário anterior |
| `:canBeEquipped()` | `ItemBodyLocation` | Local onde pode equipar |
| `:isBodyLocation(location)` | `boolean` | Verifica local do corpo |
| `:isProtectFromRainWhileEquipped()` | `boolean` | Protege da chuva quando equipado |

### Armas e Combate

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:isWeapon()` | `boolean` | É arma |
| `:getWeaponLevel()` | `integer` | Nível da arma |
| `:isTwoHandWeapon()` | `boolean` | É arma de duas mãos |
| `:getSwingAnim()` | `string` | Animação de ataque |
| `:getMaxAmmo()` | `integer` | Munição máxima |
| `:getCurrentAmmoCount()` | `integer` | Munição atual |
| `:setCurrentAmmoCount(ammo)` | - | Define munição |
| `:getAmmoType()` | `AmmoType` | Tipo de munição |
| `:getGunType()` | `string` | Tipo de arma de fogo |
| `:getDamage()` | `number` | Dano da arma |
| `:getWeaponHitArmourSound()` | `string` | Som de acerto |

---

## Métodos de Som

### Sons Gerais

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getEquipSound()` | `string` | Som ao equipar |
| `:getUnequipSound()` | `string` | Som ao desequipar |
| `:getBreakSound()` | `string` | Som ao quebrar |
| `:getDamagedSound()` | `string` | Som ao danificar |
| `:getDropSound()` | `string` | Som ao dropar |
| `:getPlaceOneSound()` | `string` | Som ao colocar (1) |
| `:getPlaceMultipleSound()` | `string` | Som ao colocar (múltiplo) |
| `:getSoundByID(id)` | `string` | Som por ID |
| `:getSoundParameter(param)` | `string` | Parâmetro de som |
| `:updateEquippedAndActivatedSound(emitter?)` | - | Atualiza som equipado |
| `:updateSound(emitter?)` | - | Atualiza som |

### Sons de Ativação

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:isActivated()` | `boolean` | Está ativado |
| `:setActivated(activated)` | - | Define ativação |
| `:setActivatedRemote(activated)` | - | Define ativação remota |
| `:canBeActivated()` | `boolean` | Pode ativar |
| `:playActivateSound()` | - | Toca som de ativar |
| `:playDeactivateSound()` | - | Toca som de desativar |
| `:playActivateDeactivateSound()` | - | Toca som de ativação |

---

## Métodos de Luz e Iluminação

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:canEmitLight()` | `boolean` | Pode emitir luz |
| `:isEmittingLight()` | `boolean` | Está emitindo luz |
| `:getLightDistance()` | `integer` | Distância da luz |
| `:getLightStrength()` | `number` | Intensidade da luz |
| `:setLightDistance(distance)` | - | Define distância |
| `:setLightStrength(strength)` | - | Define intensidade |
| `:isTorchCone()` | `boolean` | É cone de tocha |
| `:setTorchCone(isTorchCone)` | - | Define cone de tocha |
| `:getTorchDot()` | `number` | Ponto da tocha |

---

## Métodos de Habilidades e XP

### Modificadores de Habilidade

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getMaintenanceMod()` | `integer` | Modificador de manutenção |
| `:getMaintenanceMod(isEquipped)` | `integer` | Modificador (equipado) |
| `:getMaintenanceMod(character)` | `integer` | Modificador (personagem) |
| `:getMaintenanceMod(isEquipped, character)` | `integer` | Modificador completo |
| `:getDiscomfortModifier()` | `number` | Modificador de desconforto |
| `:getHearingModifier()` | `number` | Modificador de audição |
| `:getVisionModifier()` | `number` | Modificador de visão |
| `:getShoutMultiplier()` | `number` | Multiplicador de grito |
| `:getStrainModifier()` | `number` | Modificador de esforço |
| `:getReduceInfectionPower()` | `number` | Redução de infecção |

### Receitas e Crafting

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getResearchableRecipes()` | `ArrayList` | Receitas pesquisáveis |
| `:getResearchableRecipes(chr)` | `ArrayList` | Receitas (personagem) |
| `:hasResearchableRecipes()` | `boolean` | Possui receitas |
| `:researchRecipes(character)` | - | Pesquisa receitas |
| `:isFavouriteRecipeInput(player)` | `boolean` | É entrada favorita |
| `:isNoRecipes(player)` | `boolean` | Não tem receitas |
| `:setNoRecipes(player, noCrafting)` | - | Define sem receitas |
| `:getOpeningRecipe()` | `string` | Receita de abrir |
| `:getDoubleClickRecipe()` | `string` | Receita de duplo clique |
| `:getEvolvedRecipeName()` | `string` | Nome de receita evoluída |
| `:setEvolvedRecipeName(name)` | - | Define nome evoluído |

---

## Métodos de Metadados e Tags

### ModData

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getModData()` | `table` | Tabela de metadados |
| `:hasModData()` | `boolean` | Possui metadados |
| `:copyModData(modData)` | - | Copia metadados |
| `:CopyModData(defaultModData)` | - | Copia metadados padrão |
| `:ModDataMatches(item)` | `boolean` | Metadados iguais |
| `:setConditionFromModData(other)` | - | Define condição de modData |

### Tags

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getTags()` | `Set<ItemTag>` | Conjunto de tags |
| `:hasTag(tags)` | `boolean` | Possui tags (array) |
| `:hasTag(itemTag)` | `boolean` | Possui tag específica |

### Itens Extras e Anexos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:getExtraItems()` | `ArrayList` | Itens extras |
| `:addExtraItem(key/type)` | - | Adiciona item extra |
| `:haveExtraItems()` | `boolean` | Possui itens extras |
| `:getAttachmentsProvided()` | `ArrayList` | Anexos fornecidos |
| `:getAttachmentType()` | `string` | Tipo de anexo |
| `:getAttachedSlot()` | `integer` | Slot de anexo |
| `:getAttachedSlotType()` | `string` | Tipo de slot |
| `:getAttachedToModel()` | `string` | Modelo anexado |
| `:setAttachmentType(type)` | - | Define tipo de anexo |

---

## Métodos de Verificação de Tipo

### Tipos de Item

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:isClothing()` | `boolean` | É roupa |
| `:isWeapon()` | `boolean` | É arma |
| `:isFood()` | `boolean` | É comida |
| `:isLiterature()` | `boolean` | É literatura |
| `:isMap()` | `boolean` | É mapa |
| `:isDrainable()` | `boolean` | É drenável |
| `:isInventoryContainer()` | `boolean` | É contêiner |
| `:isAnimalCorpse()` | `boolean` | É carcaça animal |
| `:isHumanCorpse()` | `boolean` | É carcaça humana |
| `:isTrap()` | `boolean` | É armadilha |
| `:isFishingLure()` | `boolean` | É isca de pesca |
| `:isKeyRing()` | `boolean` | É chaveiro |
| `:isRemoteController()` | `boolean` | É controle remoto |
| `:isRecordedMedia()` | `boolean` | É mídia gravada |
| `:isVisualAid()` | `boolean` | É auxílio visual |
| `:isMemento()` | `boolean` | É lembrança |
| `:isFavorite()` | `boolean` | É favorito |
| `:isSealed()` | `boolean` | Está lacrado |
| `:isHidden()` | `boolean` | Está escondido |
| `:isWorn()` | `boolean` | Está vestido |
| `:isInfected()` | `boolean` | Está infectado |
| `:isBroken()` | `boolean` | Está quebrado |
| `:isBurnt()` | `boolean` | Está queimado |
| `:isDull()` | `boolean` | Está sem fio |
| `:isAlcoholic()` | `boolean` | É alcoólico |
| `:isSpice()` | `boolean` | É tempero |
| `:isAnimalFeed()` | `boolean` | É ração animal |
| `:isWaterSource()` | `boolean` | É fonte de água |
| `:isVanilla()` | `boolean` | É item vanilla |
| `:isCustomName()` | `boolean` | Nome customizado |
| `:isInitialised()` | `boolean` | Está inicializado |

### Verificações de Tipo por ItemType

```lua
---@param itemType ItemType
---@return boolean
function __InventoryItem:isItemType(itemType) end
```

---

## Métodos de Ações e Uso

### Uso do Item

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:Use()` | - | Usa o item |
| `:Use(bCrafting)` | - | Usa (crafting) |
| `:Use(bCrafting, bInContainer, bNeedSync)` | - | Usa (completo) |
| `:UseAndSync()` | - | Usa e sincroniza |
| `:UseForCrafting(uses)` | `boolean` | Usa para crafting |
| `:UseItem()` | - | Usa item |
| `:getCurrentUses()` | `integer` | Usos atuais |
| `:setCurrentUses(uses)` | - | Define usos |
| `:getMaxUses()` | `integer` | Usos máximos |
| `:isDisappearOnUse()` | `boolean` | Desaparece ao usar |
| `:getReplaceOnUse()` | `string` | Substitui ao usar |
| `:getReplaceOnUseOn()` | `string` | Substitui ao usar em |
| `:setReplaceOnUse(type)` | - | Define substituição |

### Dano e Verificações

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:damageCheck()` | `boolean` | Verifica dano |
| `:damageCheck(skill)` | `boolean` | Verifica dano (skill) |
| `:damageCheck(skill, multiplier)` | `boolean` | Verifica dano (multiplicador) |
| `:damageCheck(skill, multiplier, maintenance)` | `boolean` | Verifica dano (manutenção) |
| `:damageCheck(skill, multiplier, maintenance, isEquipped)` | `boolean` | Verifica dano completo |
| `:damageCheck(skill, multiplier, maintenance, isEquipped, character)` | `boolean` | Verifica dano (personagem) |
| `:doDamagedSound()` | - | Toca som de dano |
| `:doBreakSound()` | - | Toca som de quebra |

---

## Métodos de Sincronização e Rede

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:SynchSpawn()` | - | Sincroniza spawn |
| `:syncItemFields()` | - | Sincroniza campos |
| `:checkSyncItemFields(b)` | - | Verifica sincronização |
| `:save(output, net)` | - | Salva em ByteBuffer |
| `:saveWithSize(output, net)` | - | Salva com tamanho |
| `:load(input, WorldVersion)` | - | Carrega de ByteBuffer |
| `:finishupdate()` | `boolean` | Finaliza atualização |
| `:update()` | - | Atualiza estado |
| `:shouldUpdateInWorld()` | `boolean` | Deve atualizar no mundo |
| `:isInLocalPlayerInventory()` | `boolean` | Está no inventário local |
| `:isInPlayerInventory()` | `boolean` | Está no inventário do jogador |
| `:isEntityValid()` | `boolean` | Entidade válida |

---

## Métodos de Tooltip e UI

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:DoTooltip(tooltipUI)` | - | Gera tooltip |
| `:DoTooltip(tooltipUI, layout)` | - | Gera tooltip (layout) |
| `:DoTooltipEmbedded(tooltipUI, layout, offsetY)` | - | Tooltip incorporado |
| `:getTooltip()` | `string` | Texto do tooltip |
| `:setTooltip(tooltip)` | - | Define tooltip |
| `:getDescription()` | `string` | Descrição |
| `:setDescription(desc)` | - | Define descrição |
| `:getCategory()` | `string` | Categoria |
| `:getDisplayCategory()` | `string` | Categoria de exibição |
| `:setDisplayCategory(category)` | - | Define categoria |
| `:getCustomMenuOption()` | `string` | Opção de menu customizada |
| `:setCustomMenuOption(option)` | - | Define opção |

---

## Métodos de Utilitários

### Clone e Cópia

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:createCloneItem()` | `InventoryItem` | Cria clone |
| `:copyConditionModData(other)` | - | Copia condição/modData |
| `:copyConditionStatesFrom(other)` | - | Copia estados de condição |
| `:copyTimesRepairedFrom(item)` | - | Copia reparos |
| `:copyTimesRepairedTo(item)` | - | Copia para reparos |
| `:copyTimesHeadRepairedFrom(item)` | - | Copia reparos de cabeça |
| `:copyTimesHeadRepairedTo(item)` | - | Copia para reparos de cabeça |
| `:copyModData(modData)` | - | Copia modData |
| `:copyBloodLevelFrom(item)` | - | Copia nível de sangue |
| `:inheritFoodAgeFrom(other)` | - | Herda idade de comida |
| `:setConditionFrom(item)` | - | Define condição de outro item |
| `:setSharpnessFrom(item)` | - | Define afiamento de outro item |
| `:setCurrentUsesFrom(other)` | - | Define usos de outro item |
| `:setUsesFrom(other)` | - | Define usos de outro item |

### Inicialização e Reset

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:initialiseItem()` | - | Inicializa item |
| `:reset()` | - | Reseta item |
| `:Remove()` | - | Remove item |
| `:setInitialised(initialised)` | - | Define inicializado |
| `:isInitialised()` | `boolean` | Está inicializado |

### Utilitários Diversos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `:toString()` | `string` | Representação string |
| `:CanStack(item)` | `boolean` | Pode empilhar |
| `:is(item)` | `boolean` | É item (comparação) |
| `:getScore(desc)` | `number` | Pontuação (SurvivorDesc) |
| `:isUnwanted(player)` | `boolean` | É indesejado |
| `:setUnwanted(player, unwanted)` | - | Define indesejado |
| `:isForceDropHeavyItem()` | `boolean` | Força dropar (pesado) |
| `:isKeepOnDeplete()` | `boolean` | Mantém quando esgota |
| `:unsealIfNotFull()` | - | Deslaca se não cheio |
| `:doBuildingStash()` | - | Faz stash de construção |
| `:setStashChance(chance)` | - | Define chance de stash |
| `:getStashChance()` | `integer` | Chance de stash |
| `:getStashMap()` | `string` | Mapa de stash |

---

## Métodos Estáticos

```lua
-- Remove item do contêiner
---@param item InventoryItem
---@return boolean
InventoryItem.RemoveFromContainer(item)

-- Obtém string de modData para "no recipes"
---@return string
InventoryItem.getNoRecipesModDataString()

-- Carrega item de ByteBuffer
---@param input ByteBuffer
---@param WorldVersion integer
---@param doSaveTypeCheck boolean?
---@param i InventoryItem?
---@return InventoryItem
InventoryItem.loadItem(input, WorldVersion, doSaveTypeCheck, i)

-- Cria novo item
---@param module string
---@param name string
---@param type string
---@param tex string|Item
---@return InventoryItem
InventoryItem.new(module, name, type, tex)
```

---

## Constantes e Propriedades de Classe

```lua
-- Tipo da classe
---@type Class<InventoryItem>
InventoryItem.class

-- Tabela de metatables para a classe
__classmetatables[InventoryItem.class] = { __index = __InventoryItem }

-- Referência no namespace zombie.inventory
zombie.inventory.InventoryItem = InventoryItem
```

---

## Exemplos de Uso

### Exemplo 1: Verificar e Usar Item

```lua
local function tryUseItem(player, itemType)
    local item = player:getInventory():getFirstItem(itemType)
    
    if not item then
        print("Item não encontrado: " .. tostring(itemType))
        return false
    end
    
    -- Verificar condição
    if item:isBroken() then
        print("Item está quebrado!")
        return false
    end
    
    -- Verificar usos restantes
    if item:getCurrentUses() <= 0 then
        print("Item sem usos!")
        return false
    end
    
    -- Usar item
    item:Use()
    print("Item usado: " .. item:getDisplayName())
    return true
end
```

### Exemplo 2: Gerenciar Condição de Arma

```lua
local function repairWeapon(player, weapon)
    if not weapon:isWeapon() then
        return false
    end
    
    local condition = weapon:getCondition()
    local conditionMax = weapon:getConditionMax()
    
    if condition >= conditionMax then
        print("Arma já está em condição máxima!")
        return false
    end
    
    -- Reparar arma
    local repairAmount = 20
    weapon:incrementCondition(repairAmount)
    
    print("Arma reparada: " .. weapon:getDisplayName() .. 
          " (" .. weapon:getCondition() .. "/" .. weapon:getConditionMax() .. ")")
    return true
end
```

### Exemplo 3: Verificar Comida e Podridão

```lua
local function checkFoodSafety(foodItem)
    if not foodItem:isFood() then
        return nil, "Não é comida"
    end
    
    if foodItem:isRotten() then
        return false, "Comida está podre!"
    end
    
    local age = foodItem:getAge()
    local offAgeMax = foodItem:getOffAgeMax()
    
    if age >= offAgeMax then
        return false, "Comida estragada!"
    end
    
    local daysUntilRotten = (offAgeMax - age) / 600  -- 600 ticks = 1 dia
    return true, "Dura mais " .. math.floor(daysUntilRotten) .. " dias"
end
```

### Exemplo 4: Sincronizar Item em Multiplayer

```lua
local function syncItemWithWorld(item)
    if not item then return end
    
    -- Verificar se está no mundo
    local worldItem = item:getWorldItem()
    if worldItem then
        item:SynchSpawn()
        print("Item sincronizado no mundo: ID " .. item:getID())
    end
    
    -- Atualizar campos
    item:syncItemFields()
end
```

### Exemplo 5: Trabalhar com Contêineres

```lua
local function organizeItemInContainer(item, container)
    if not item or not container then return end
    
    -- Adicionar item ao contêiner
    item:setContainer(container)
    item:SetContainerPosition(0, 0)
    
    -- Verificar se é contêiner de fluido
    if item:isFluidContainer() then
        if item:isEmptyOfFluid() then
            print("Contêiner vazio")
        elseif item:isFullOfFluid() then
            print("Contêiner cheio")
        end
    end
    
    -- Sincronizar
    item:syncItemFields()
end
```

---

## Referências Relacionadas

- [`Item`](./Item.md) - Definição de script de item
- [`ItemContainer`](./ItemContainer.md) - Contêiner de itens
- [`IsoPlayer`](./IsoPlayer.md) - Jogador
- [`IsoWorldInventoryObject`](./IsoWorldInventoryObject.md) - Item no mundo
- [`GameEntity`](./GameEntity.md) - Classe base

---

## Notas de Versão

| Versão | Mudanças |
|--------|----------|
| 41.x | Implementação base |
| 42.0+ | Adicionado suporte a fluidos, melhorias de sincronização |
| 42.12 | Atualizações de API, novos métodos de condição |

---

*Documentação gerada a partir dos arquivos de definição do Project Zomboid 42.12*
