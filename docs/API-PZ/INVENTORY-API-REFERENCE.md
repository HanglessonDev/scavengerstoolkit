# Referência da API de Inventário - Project Zomboid

> Pesquisa realizada em: 16 de fevereiro de 2026  
> Fonte: `.libraries/library/java/zombie/inventory/`

---

## 📚 Fontes Pesquisadas

| Arquivo | Caminho |
|---------|---------|
| `InventoryItem.lua` | `.libraries/library/java/zombie/inventory/InventoryItem.lua` |
| `ItemContainer.lua` | `.libraries/library/java/zombie/inventory/ItemContainer.lua` |

---

## 🎒 ItemContainer (Bags/Containers)

**Classe:** `ItemContainer`  
**Arquivo:** `.libraries/library/java/zombie/inventory/ItemContainer.lua`

### Métodos Set (Modificação)

| Método | Parâmetro(s) | Descrição |
|--------|--------------|-----------|
| `setCapacity(capacity)` | `capacity: integer` | Define o número máximo de slots do container |
| `setWeightReduction(weightReduction)` | `weightReduction: integer` | Define redução de peso em porcentagem |
| `setCustomName(name)` | `name: string` | Define nome personalizado do container |
| `setType(type)` | `type: string` | Define o tipo do container |
| `setParent(parent)` | `parent: IsoObject` | Define o objeto pai do container |
| `setSourceGrid(SourceGrid)` | `SourceGrid: IsoGridSquare` | Define a grade de origem |
| `setOnlyAcceptCategory(onlyAcceptCategory)` | `onlyAcceptCategory: string` | Define categoria de itens aceitos |
| `setContainerPosition(containerPosition)` | `containerPosition: string` | Define posição do container |
| `setCookingFactor(CookingFactor)` | `CookingFactor: number` | Define fator de cozimento |
| `setCustomTemperature(newTemp)` | `newTemp: number` | Define temperatura personalizada |
| `setFreezerPosition(freezerPosition)` | `freezerPosition: string` | Define posição do freezer |
| `setOpenSound(openSound)` | `openSound: string` | Define som de abrir |
| `setCloseSound(closeSound)` | `closeSound: string` | Define som de fechar |
| `setPutSound(putSound)` | `putSound: string` | Define som de guardar item |
| `setTakeSound(takeSound)` | `takeSound: string` | Define som de pegar item |
| `setAcceptItemFunction(functionName)` | `functionName: string` | Define função para aceitar itens |
| `setItems(Items)` | `Items: ArrayList<InventoryItem>` | Define lista de itens |
| `setActive(active)` | `active: boolean` | Ativa/desativa container |
| `setDirty(dirty)` | `dirty: boolean` | Define estado "sujo" |
| `setExplored(b)` | `b: boolean` | Define como explorado |
| `setHasBeenLooted(hasBeenLooted)` | `hasBeenLooted: boolean` | Define se foi saqueado |
| `setIsDevice(IsDevice)` | `IsDevice: boolean` | Define se é um dispositivo |
| `setDrawDirty(b)` | `b: boolean` | Define dirty de desenho |

### Métodos Get (Leitura)

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `getCapacity()` | `integer` | Retorna capacidade máxima (slots) |
| `getMaxWeight()` | `number` | Retorna peso máximo |
| `getContentsWeight()` | `number` | Retorna peso do conteúdo atual |
| `getAvailableWeightCapacity()` | `number` | Retorna capacidade de peso disponível |
| `getItems()` | `ArrayList<InventoryItem>` | Retorna lista de itens |
| `getType()` | `string` | Retorna tipo do container |
| `getCustomName()` | `string` | Retorna nome personalizado |
| `getParent()` | `IsoObject` | Retorna objeto pai |
| `getSourceGrid()` | `IsoGridSquare` | Retorna grade de origem |
| `getContainerPosition()` | `string` | Retorna posição |
| `getCookingFactor()` | `number` | Retorna fator de cozimento |
| `getTemprature()` | `number` | Retorna temperatura |
| `getCustomTemperature()` | `number` | Retorna temperatura personalizada |
| `getWeightReduction()` | `integer` | Retorna redução de peso |
| `getOpenSound()` | `string` | Retorna som de abrir |
| `getCloseSound()` | `string` | Retorna som de fechar |
| `getPutSound()` | `string` | Retorna som de guardar |
| `getTakeSound()` | `string` | Retorna som de pegar |
| `getAcceptItemFunction()` | `string` | Retorna função de aceitar itens |
| `getOnlyAcceptCategory()` | `string` | Retorna categoria aceita |
| `isActive()` | `boolean` | Verifica se está ativo |
| `isEmpty()` | `boolean` | Verifica se está vazio |
| `isCorpse()` | `boolean` | Verifica se é cadáver |
| `isVehiclePart()` | `boolean` | Verifica se é parte de veículo |
| `isVehicleSeat()` | `boolean` | Verifica se é assento de veículo |
| `isPowered()` | `boolean` | Verifica se está energizado |
| `isTemperatureChanging()` | `boolean` | Verifica se muda temperatura |

### Métodos de Manipulação de Itens

| Método | Parâmetro(s) | Retorno | Descrição |
|--------|--------------|---------|-----------|
| `AddItem(item)` | `item: InventoryItem` | `InventoryItem` | Adiciona item |
| `AddItem(type)` | `type: string` | `InventoryItem` | Adiciona item por tipo |
| `AddItem(type, useDelta)` | `type: string, useDelta: number` | `boolean` | Adiciona item com delta de uso |
| `AddItem(type, useDelta, synchSpawn)` | `type: string, useDelta: number, synchSpawn: boolean` | `boolean` | Adiciona item com sync |
| `AddItemBlind(item)` | `item: InventoryItem` | `InventoryItem` | Adiciona item sem verificação |
| `AddItems(item, count)` | `item: InventoryItem, count: integer` | `ArrayList<InventoryItem>` | Adiciona múltiplos itens |
| `AddItems(item, use)` | `item: string, use: integer` | `ArrayList<InventoryItem>` | Adiciona itens com uso |
| `AddItems(items)` | `items: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Adiciona lista de itens |
| `SpawnItem(type)` | `type: string` | `InventoryItem` | Spawna item do tipo |
| `SpawnItem(type, useDelta)` | `type: string, useDelta: number` | `boolean` | Spawna item com delta |
| `SpawnItem(item)` | `item: InventoryItem` | - | Spawna item |
| `Remove(item)` | `item: InventoryItem` | - | Remove item |
| `Remove(itemType)` | `itemType: ItemType` | `InventoryItem` | Remove por tipo |
| `RemoveAll(itemType)` | `itemType: string` | `ArrayList<InventoryItem>` | Remove todos do tipo |
| `RemoveAll(itemType, count)` | `itemType: string, count: integer` | `ArrayList<InventoryItem>` | Remove quantidade do tipo |
| `Find(itemType)` | `itemType: string` ou `ItemType` | `InventoryItem` | Encontra item por tipo |
| `FindAll(type)` | `type: string` | `ArrayList<InventoryItem>` | Encontra todos do tipo |
| `FindAndReturn(type, count)` | `type: string, count: integer` | `ArrayList<InventoryItem>` | Encontra e retorna quantidade |
| `FindAndReturn(type)` | `type: string` | `InventoryItem` | Encontra e retorna |
| `FindAndReturn(type, itemToCheck)` | `type: string, itemToCheck: ArrayList<InventoryItem>` | `InventoryItem` | Encontra verificando lista |
| `FindAndReturnCategory(category)` | `category: string` | `InventoryItem` | Encontra por categoria |
| `FindAndReturnStack(type)` | `type: string` | `InventoryItem` | Encontra stack |
| `FindAndReturnStack(itemlike)` | `itemlike: InventoryItem` | `InventoryItem` | Encontra stack similar |
| `FindAndReturnWaterItem(uses)` | `uses: integer` | `InventoryItem` | Encontra item de água |
| `FindWaterSource()` | - | `InventoryItem` | Encontra fonte de água |
| `HasType(itemType)` | `itemType: ItemType` | `boolean` | Verifica se tem tipo |
| `contains(item)` | `item: InventoryItem` | `boolean` | Verifica se contém item |
| `contains(type)` | `type: string` | `boolean` | Verifica se contém tipo |
| `contains(type, doInv)` | `type: string, doInv: boolean` | `boolean` | Verifica com inventário |
| `contains(type, doInv, ignoreBroken)` | `type: string, doInv: boolean, ignoreBroken: boolean` | `boolean` | Verifica ignorando quebrados |
| `containsEval(functionObj)` | `functionObj: function` | `boolean` | Avalia função |
| `containsEvalArg(functionObj, arg)` | `functionObj: function, arg: any` | `boolean` | Avalia função com argumento |
| `containsEvalArgRecurse(functionObj, arg)` | `functionObj: function, arg: any` | `boolean` | Avalia recursivamente |
| `containsEvalRecurse(functionObj)` | `functionObj: function` | `boolean` | Avalia recursivamente |
| `containsRecursive(item)` | `item: InventoryItem` | `boolean` | Verifica recursivamente |
| `containsTag(itemTag)` | `itemTag: ItemTag` | `boolean` | Verifica tag |
| `containsTagEval(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `boolean` | Avalia tag com função |
| `containsTagEvalArgRecurse(itemTag, functionObj, arg)` | `itemTag: ItemTag, functionObj: function, arg: any` | `boolean` | Avalia tag recursivamente |
| `containsTagEvalRecurse(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `boolean` | Avalia tag recursivamente |
| `containsTagRecurse(itemTag)` | `itemTag: ItemTag` | `boolean` | Verifica tag recursivamente |
| `containsType(type)` | `type: string` | `boolean` | Verifica tipo |
| `containsTypeEvalArgRecurse(type, functionObj, arg)` | `type: string, functionObj: function, arg: any` | `boolean` | Avalia tipo recursivamente |
| `containsTypeEvalRecurse(type, functionObj)` | `type: string, functionObj: function` | `boolean` | Avalia tipo recursivamente |
| `containsTypeRecurse(type)` | `type: string` | `boolean` | Verifica tipo recursivamente |
| `containsWithModule(moduleType)` | `moduleType: string` | `boolean` | Verifica com módulo |
| `containsWithModule(moduleType, withDeltaLeft)` | `moduleType: string, withDeltaLeft: boolean` | `boolean` | Verifica módulo com delta |
| `canItemFit(in_item)` | `in_item: InventoryItem` | `boolean` | Verifica se item cabe |
| `hasRoomFor(chr, item)` | `chr: IsoGameCharacter, item: InventoryItem` | `boolean` | Verifica espaço para item |
| `hasRoomFor(chr, weightVal)` | `chr: IsoGameCharacter, weightVal: number` | `boolean` | Verifica espaço para peso |
| `clear()` | - | - | Limpa container |
| `emptyIt()` | - | - | Esvazia container |
| `removeAllItems()` | - | - | Remove todos itens |
| `takeItemsFrom(other)` | `other: ItemContainer` | - | Transfere itens de outro |

### Métodos de Busca Avançada

| Método | Parâmetro(s) | Retorno | Descrição |
|--------|--------------|---------|-----------|
| `getAll(predicate)` | `predicate: Predicate<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna todos com predicado |
| `getAll(predicate, result)` | `predicate: Predicate<InventoryItem>, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna todos com resultado |
| `getAllCategory(category)` | `category: string` | `ArrayList<InventoryItem>` | Retorna todos da categoria |
| `getAllCategory(category, result)` | `category: string, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna categoria com resultado |
| `getAllCategoryRecurse(category, result)` | `category: string, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna categoria recursivo |
| `getAllEval(functionObj)` | `functionObj: function` | `ArrayList<InventoryItem>` | Avalia todos |
| `getAllEval(functionObj, result)` | `functionObj: function, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia todos com resultado |
| `getAllEvalArg(functionObj, arg)` | `functionObj: function, arg: any` | `ArrayList<InventoryItem>` | Avalia todos com argumento |
| `getAllEvalArg(functionObj, arg, result)` | `functionObj: function, arg: any, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia todos com arg e resultado |
| `getAllEvalArgRecurse(functionObj, arg)` | `functionObj: function, arg: any` | `ArrayList<InventoryItem>` | Avalia recursivo com arg |
| `getAllEvalArgRecurse(functionObj, arg, result)` | `functionObj: function, arg: any, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia recursivo completo |
| `getAllEvalRecurse(functionObj)` | `functionObj: function` | `ArrayList<InventoryItem>` | Avalia recursivo |
| `getAllEvalRecurse(functionObj, result)` | `functionObj: function, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia recursivo com resultado |
| `getAllRecurse(predicate, result)` | `predicate: Predicate<InventoryItem>, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna todos recursivo |
| `getAllTag(itemTag)` | `itemTag: ItemTag` | `ArrayList<InventoryItem>` | Retorna todos por tag |
| `getAllTag(itemTag, result)` | `itemTag: ItemTag, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna tag com resultado |
| `getAllTagEval(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `ArrayList<InventoryItem>` | Avalia tag |
| `getAllTagEval(itemTag, functionObj, result)` | `itemTag: ItemTag, functionObj: function, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tag com resultado |
| `getAllTagEvalArg(itemTag, functionObj, arg)` | `itemTag: ItemTag, functionObj: function, arg: any` | `ArrayList<InventoryItem>` | Avalia tag com arg |
| `getAllTagEvalArg(itemTag, functionObj, arg, result)` | `itemTag: ItemTag, functionObj: function, arg: any, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tag completo |
| `getAllTagEvalArgRecurse(itemTag, functionObj, arg, result)` | `itemTag: ItemTag, functionObj: function, arg: any, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tag recursivo completo |
| `getAllTagEvalRecurse(itemTag, functionObj, result)` | `itemTag: ItemTag, functionObj: function, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tag recursivo |
| `getAllTagRecurse(itemTag, result)` | `itemTag: ItemTag, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna tag recursivo |
| `getAllType(type)` | `type: string` | `ArrayList<InventoryItem>` | Retorna todos por tipo |
| `getAllType(type, result)` | `type: string, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna tipo com resultado |
| `getAllTypeEval(type, functionObj)` | `type: string, functionObj: function` | `ArrayList<InventoryItem>` | Avalia tipo |
| `getAllTypeEval(type, functionObj, result)` | `type: string, functionObj: function, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tipo com resultado |
| `getAllTypeEvalArg(type, functionObj, arg)` | `type: string, functionObj: function, arg: any` | `ArrayList<InventoryItem>` | Avalia tipo com arg |
| `getAllTypeEvalArg(type, functionObj, arg, result)` | `type: string, functionObj: function, arg: any, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tipo completo |
| `getAllTypeEvalArgRecurse(type, functionObj, arg, result)` | `type: string, functionObj: function, arg: any, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tipo recursivo completo |
| `getAllTypeEvalArgRecurse(type, functionObj, arg)` | `type: string, functionObj: function, arg: any` | `ArrayList<InventoryItem>` | Avalia tipo recursivo |
| `getAllTypeEvalRecurse(type, functionObj, result)` | `type: string, functionObj: function, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia tipo recursivo |
| `getAllTypeEvalRecurse(type, functionObj)` | `type: string, functionObj: function` | `ArrayList<InventoryItem>` | Avalia tipo recursivo |
| `getAllTypeRecurse(type)` | `type: string` | `ArrayList<InventoryItem>` | Retorna tipo recursivo |
| `getAllTypeRecurse(type, result)` | `type: string, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna tipo recursivo |
| `getAllWaterFillables()` | - | `ArrayList<InventoryItem>` | Retorna enchíveis de água |
| `getAllWaterFluidSources(includeTainted)` | `includeTainted: boolean` | `ArrayList<InventoryItem>` | Retorna fontes de água |
| `getAllCleaningFluidSources()` | - | `ArrayList<InventoryItem>` | Retorna fluidos de limpeza |
| `getAllFoodsForAnimals()` | - | `ArrayList<InventoryItem>` | Retorna comida para animais |
| `getBest(predicate, comparator)` | `predicate: Predicate<InventoryItem>, comparator: Comparator<InventoryItem>` | `InventoryItem` | Retorna melhor item |
| `getBestBandage(descriptor)` | `descriptor: SurvivorDesc` | `InventoryItem` | Retorna melhor bandagem |
| `getBestCondition(predicate)` | `predicate: Predicate<InventoryItem>` | `InventoryItem` | Retorna melhor condição |
| `getBestCondition(type)` | `type: string` | `InventoryItem` | Retorna melhor condição por tipo |
| `getBestConditionEval(functionObj)` | `functionObj: function` | `InventoryItem` | Avalia melhor condição |
| `getBestConditionEvalArg(functionObj, arg)` | `functionObj: function, arg: any` | `InventoryItem` | Avalia melhor condição com arg |
| `getBestConditionEvalArgRecurse(functionObj, arg)` | `functionObj: function, arg: any` | `InventoryItem` | Avalia melhor condição recursivo |
| `getBestConditionEvalRecurse(functionObj)` | `functionObj: function` | `InventoryItem` | Avalia melhor condição recursivo |
| `getBestConditionRecurse(predicate)` | `predicate: Predicate<InventoryItem>` | `InventoryItem` | Retorna melhor condição recursivo |
| `getBestConditionRecurse(type)` | `type: string` | `InventoryItem` | Retorna melhor condição recursivo |
| `getBestEval(predicateObj, comparatorObj)` | `predicateObj: function, comparatorObj: function` | `InventoryItem` | Avalia melhor |
| `getBestEvalArg(predicateObj, comparatorObj, arg)` | `predicateObj: function, comparatorObj: function, arg: any` | `InventoryItem` | Avalia melhor com arg |
| `getBestEvalArgRecurse(predicateObj, comparatorObj, arg)` | `predicateObj: function, comparatorObj: function, arg: any` | `InventoryItem` | Avalia melhor recursivo |
| `getBestEvalRecurse(predicateObj, comparatorObj)` | `predicateObj: function, comparatorObj: function` | `InventoryItem` | Avalia melhor recursivo |
| `getBestFood(descriptor)` | `descriptor: SurvivorDesc` | `InventoryItem` | Retorna melhor comida |
| `getBestRecurse(predicate, comparator)` | `predicate: Predicate<InventoryItem>, comparator: Comparator<InventoryItem>` | `InventoryItem` | Retorna melhor recursivo |
| `getBestType(type, comparator)` | `type: string, comparator: Comparator<InventoryItem>` | `InventoryItem` | Retorna melhor tipo |
| `getBestTypeEval(type, comparatorObj)` | `type: string, comparatorObj: function` | `InventoryItem` | Avalia melhor tipo |
| `getBestTypeEvalArg(type, comparatorObj, arg)` | `type: string, comparatorObj: function, arg: any` | `InventoryItem` | Avalia melhor tipo com arg |
| `getBestTypeEvalArgRecurse(type, comparatorObj, arg)` | `type: string, comparatorObj: function, arg: any` | `InventoryItem` | Avalia melhor tipo recursivo |
| `getBestTypeEvalRecurse(type, comparatorObj)` | `type: string, comparatorObj: function` | `InventoryItem` | Avalia melhor tipo recursivo |
| `getBestTypeRecurse(type, comparator)` | `type: string, comparator: Comparator<InventoryItem>` | `InventoryItem` | Retorna melhor tipo recursivo |
| `getBestWeapon()` | - | `InventoryItem` | Retorna melhor arma |
| `getBestWeapon(desc)` | `desc: SurvivorDesc` | `InventoryItem` | Retorna melhor arma |
| `getFirst(predicate)` | `predicate: Predicate<InventoryItem>` | `InventoryItem` | Retorna primeiro |
| `getFirstAvailableFluidContainer(type)` | `type: string` | `InventoryItem` | Retorna primeiro container fluido |
| `getFirstCategory(category)` | `category: string` | `InventoryItem` | Retorna primeiro da categoria |
| `getFirstCategoryRecurse(category)` | `category: string` | `InventoryItem` | Retorna primeiro categoria recursivo |
| `getFirstCleaningFluidSources()` | - | `InventoryItem` | Retorna primeiro fluido limpeza |
| `getFirstEval(functionObj)` | `functionObj: function` | `InventoryItem` | Avalia primeiro |
| `getFirstEvalArg(functionObj, arg)` | `functionObj: function, arg: any` | `InventoryItem` | Avalia primeiro com arg |
| `getFirstEvalArgRecurse(functionObj, arg)` | `functionObj: function, arg: any` | `InventoryItem` | Avalia primeiro recursivo |
| `getFirstEvalRecurse(functionObj)` | `functionObj: function` | `InventoryItem` | Avalia primeiro recursivo |
| `getFirstFluidContainer(type)` | `type: string` | `InventoryItem` | Retorna primeiro container fluido |
| `getFirstRecurse(predicate)` | `predicate: Predicate<InventoryItem>` | `InventoryItem` | Retorna primeiro recursivo |
| `getFirstTag(itemTag)` | `itemTag: ItemTag` | `InventoryItem` | Retorna primeiro por tag |
| `getFirstTagEval(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `InventoryItem` | Avalia primeiro tag |
| `getFirstTagEvalArgRecurse(itemTag, functionObj, arg)` | `itemTag: ItemTag, functionObj: function, arg: any` | `InventoryItem` | Avalia primeiro tag recursivo |
| `getFirstTagEvalRecurse(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `InventoryItem` | Avalia primeiro tag recursivo |
| `getFirstTagRecurse(itemTag)` | `itemTag: ItemTag` | `InventoryItem` | Retorna primeiro tag recursivo |
| `getFirstType(type)` | `type: string` | `InventoryItem` | Retorna primeiro tipo |
| `getFirstTypeEval(type, functionObj)` | `type: string, functionObj: function` | `InventoryItem` | Avalia primeiro tipo |
| `getFirstTypeEvalArgRecurse(type, functionObj, arg)` | `type: string, functionObj: function, arg: any` | `InventoryItem` | Avalia primeiro tipo recursivo |
| `getFirstTypeEvalRecurse(type, functionObj)` | `type: string, functionObj: function` | `InventoryItem` | Avalia primeiro tipo recursivo |
| `getFirstTypeRecurse(type)` | `type: string` | `InventoryItem` | Retorna primeiro tipo recursivo |
| `getFirstTypeRecurse(key)` | `key: ItemKey` | `InventoryItem` | Retorna primeiro tipo recursivo |
| `getFirstWaterFluidSources(includeTainted)` | `includeTainted: boolean` | `InventoryItem` | Retorna primeiro água |
| `getFirstWaterFluidSources(includeTainted, taintedPriority)` | `includeTainted: boolean, taintedPriority: boolean` | `InventoryItem` | Retorna primeiro água |
| `getSome(predicate, count)` | `predicate: Predicate<InventoryItem>, count: integer` | `ArrayList<InventoryItem>` | Retorna alguns |
| `getSome(predicate, count, result)` | `predicate: Predicate<InventoryItem>, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns com resultado |
| `getSomeCategory(category, count)` | `category: string, count: integer` | `ArrayList<InventoryItem>` | Retorna alguns categoria |
| `getSomeCategory(category, count, result)` | `category: string, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns categoria |
| `getSomeCategoryRecurse(category, count, result)` | `category: string, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns categoria recursivo |
| `getSomeEval(functionObj, count)` | `functionObj: function, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns |
| `getSomeEval(functionObj, count, result)` | `functionObj: function, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns com resultado |
| `getSomeEvalArg(functionObj, arg, count)` | `functionObj: function, arg: any, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns com arg |
| `getSomeEvalArg(functionObj, arg, count, result)` | `functionObj: function, arg: any, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns completo |
| `getSomeEvalArgRecurse(functionObj, arg, count)` | `functionObj: function, arg: any, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns recursivo |
| `getSomeEvalArgRecurse(functionObj, arg, count, result)` | `functionObj: function, arg: any, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns recursivo |
| `getSomeEvalRecurse(functionObj, count)` | `functionObj: function, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns recursivo |
| `getSomeEvalRecurse(functionObj, count, result)` | `functionObj: function, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns recursivo |
| `getSomeRecurse(predicate, count, result)` | `predicate: Predicate<InventoryItem>, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns recursivo |
| `getSomeTag(itemTag, count)` | `itemTag: ItemTag, count: integer` | `ArrayList<InventoryItem>` | Retorna alguns tag |
| `getSomeTag(itemTag, count, result)` | `itemTag: ItemTag, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns tag |
| `getSomeTagEval(itemTag, functionObj, count)` | `itemTag: ItemTag, functionObj: function, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tag |
| `getSomeTagEval(itemTag, functionObj, count, result)` | `itemTag: ItemTag, functionObj: function, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tag |
| `getSomeTagEvalArg(itemTag, functionObj, arg, count)` | `itemTag: ItemTag, functionObj: function, arg: any, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tag |
| `getSomeTagEvalArg(itemTag, functionObj, arg, count, result)` | `itemTag: ItemTag, functionObj: function, arg: any, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tag |
| `getSomeTagEvalArgRecurse(itemTag, functionObj, arg, count)` | `itemTag: ItemTag, functionObj: function, arg: any, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tag recursivo |
| `getSomeTagEvalArgRecurse(itemTag, functionObj, arg, count, result)` | `itemTag: ItemTag, functionObj: function, arg: any, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tag recursivo |
| `getSomeTagEvalRecurse(itemTag, functionObj, count)` | `itemTag: ItemTag, functionObj: function, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tag recursivo |
| `getSomeTagEvalRecurse(itemTag, functionObj, count, result)` | `itemTag: ItemTag, functionObj: function, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tag recursivo |
| `getSomeTagRecurse(itemTag, count)` | `itemTag: ItemTag, count: integer` | `ArrayList<InventoryItem>` | Retorna alguns tag recursivo |
| `getSomeTagRecurse(itemTag, count, result)` | `itemTag: ItemTag, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns tag recursivo |
| `getSomeType(type, count)` | `type: string, count: integer` | `ArrayList<InventoryItem>` | Retorna alguns tipo |
| `getSomeType(type, count, result)` | `type: string, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns tipo |
| `getSomeTypeEval(type, functionObj, count)` | `type: string, functionObj: function, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tipo |
| `getSomeTypeEval(type, functionObj, count, result)` | `type: string, functionObj: function, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tipo |
| `getSomeTypeEvalArg(type, functionObj, arg, count)` | `type: string, functionObj: function, arg: any, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tipo |
| `getSomeTypeEvalArg(type, functionObj, arg, count, result)` | `type: string, functionObj: function, arg: any, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tipo |
| `getSomeTypeEvalArgRecurse(type, functionObj, arg, count)` | `type: string, functionObj: function, arg: any, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tipo recursivo |
| `getSomeTypeEvalArgRecurse(type, functionObj, arg, count, result)` | `type: string, functionObj: function, arg: any, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tipo recursivo |
| `getSomeTypeEvalRecurse(type, functionObj, count)` | `type: string, functionObj: function, count: integer` | `ArrayList<InventoryItem>` | Avalia alguns tipo recursivo |
| `getSomeTypeEvalRecurse(type, functionObj, count, result)` | `type: string, functionObj: function, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Avalia alguns tipo recursivo |
| `getSomeTypeRecurse(type, count)` | `type: string, count: integer` | `ArrayList<InventoryItem>` | Retorna alguns tipo recursivo |
| `getSomeTypeRecurse(type, count, result)` | `type: string, count: integer, result: ArrayList<InventoryItem>` | `ArrayList<InventoryItem>` | Retorna alguns tipo recursivo |

### Contadores

| Método | Parâmetro(s) | Retorno | Descrição |
|--------|--------------|---------|-----------|
| `getCount(predicate)` | `predicate: Predicate<InventoryItem>` | `integer` | Conta com predicado |
| `getCountEval(functionObj)` | `functionObj: function` | `integer` | Conta avaliando |
| `getCountEvalArg(functionObj, arg)` | `functionObj: function, arg: any` | `integer` | Conta avaliando com arg |
| `getCountEvalArgRecurse(functionObj, arg)` | `functionObj: function, arg: any` | `integer` | Conta avaliando recursivo |
| `getCountEvalRecurse(functionObj)` | `functionObj: function` | `integer` | Conta avaliando recursivo |
| `getCountRecurse(predicate)` | `predicate: Predicate<InventoryItem>` | `integer` | Conta recursivo |
| `getCountTag(itemTag)` | `itemTag: ItemTag` | `integer` | Conta por tag |
| `getCountTagEval(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `integer` | Conta tag avaliando |
| `getCountTagEvalArg(itemTag, functionObj, arg)` | `itemTag: ItemTag, functionObj: function, arg: any` | `integer` | Conta tag com arg |
| `getCountTagEvalArgRecurse(itemTag, functionObj, arg)` | `itemTag: ItemTag, functionObj: function, arg: any` | `integer` | Conta tag recursivo |
| `getCountTagEvalRecurse(itemTag, functionObj)` | `itemTag: ItemTag, functionObj: function` | `integer` | Conta tag recursivo |
| `getCountTagRecurse(itemTag)` | `itemTag: ItemTag` | `integer` | Conta tag recursivo |
| `getCountType(type)` | `type: string` | `integer` | Conta por tipo |
| `getCountTypeEval(type, functionObj)` | `type: string, functionObj: function` | `integer` | Conta tipo avaliando |
| `getCountTypeEvalArg(type, functionObj, arg)` | `type: string, functionObj: function, arg: any` | `integer` | Conta tipo com arg |
| `getCountTypeEvalArgRecurse(type, functionObj, arg)` | `type: string, functionObj: function, arg: any` | `integer` | Conta tipo recursivo |
| `getCountTypeEvalRecurse(type, functionObj)` | `type: string, functionObj: function` | `integer` | Conta tipo recursivo |
| `getCountTypeRecurse(type)` | `type: string` | `integer` | Conta tipo recursivo |
| `getItemCount(type)` | `type: string` | `integer` | Conta itens por tipo |
| `getItemCount(type, doBags)` | `type: string, doBags: boolean` | `integer` | Conta itens com bags |
| `getItemCountRecurse(type)` | `type: string` | `integer` | Conta itens recursivo |
| `getItemCountFromTypeRecurse(type)` | `type: string` | `integer` | Conta itens tipo recursivo |
| `getNumItems(item)` | `item: string` | `integer` | Número de itens |
| `getNumberOfItem(findItem)` | `findItem: string` | `integer` | Número de item |
| `getNumberOfItem(findItem, includeReplaceOnDeplete)` | `findItem: string, includeReplaceOnDeplete: boolean` | `integer` | Número de item |
| `getNumberOfItem(findItem, includeReplaceOnDeplete, insideInv)` | `findItem: string, includeReplaceOnDeplete: boolean, insideInv: boolean` | `integer` | Número de item |
| `getNumberOfItem(findItem, includeReplaceOnDeplete, containers)` | `findItem: string, includeReplaceOnDeplete: boolean, containers: ArrayList<ItemContainer>` | `integer` | Número de item |
| `getUsesRecurse(predicate)` | `predicate: Predicate<InventoryItem>` | `integer` | Usa recursivo |
| `getUsesType(type)` | `type: string` | `integer` | Usa por tipo |
| `getUsesTypeRecurse(type)` | `type: string` | `integer` | Usa tipo recursivo |
| `getWaterContainerCount()` | - | `integer` | Conta containers de água |

### Outros Métodos

| Método | Parâmetro(s) | Retorno | Descrição |
|--------|--------------|---------|-----------|
| `getOutermostContainer()` | - | `ItemContainer` | Retorna container mais externo |
| `getSquare()` | - | `IsoGridSquare` | Retorna quadrado |
| `getWorldPosition(out_result)` | `out_result: Vector2` | `Vector2` | Retorna posição mundo |
| `getCharacter()` | - | `IsoGameCharacter` | Retorna personagem |
| `getVehicle()` | - | `BaseVehicle` | Retorna veículo |
| `getVehicleDoor()` | - | `VehicleDoor` | Retorna porta veículo |
| `getVehicleDoorPart()` | - | `VehiclePart` | Retorna parte da porta |
| `getVehiclePart()` | - | `VehiclePart` | Retorna parte veículo |
| `getVehicleSeatDoor()` | - | `VehicleDoor` | Retorna porta assento |
| `getVehicleSeatDoorPart()` | - | `VehiclePart` | Retorna parte porta assento |
| `getAnimalInventoryItem(animal)` | `animal: IsoAnimal` | `AnimalInventoryItem` | Retorna item animal |
| `getAvailableFluidContainer(type)` | `type: string` | `ArrayList<InventoryItem>` | Retorna containers fluidos |
| `getAvailableFluidContainersCapacity(type)` | `type: string` | `number` | Retorna capacidade fluidos |
| `getBestCondition(predicate)` | `predicate: Predicate<InventoryItem>` | `InventoryItem` | Melhor condição |
| `getContainingItem()` | - | `InventoryItem` | Retorna item conteúdo |
| `getEffectiveCapacity(chr)` | `chr: IsoGameCharacter` | `integer` | Capacidade efetiva |
| `getFirstAvailableFluidContainer(type)` | `type: string` | `InventoryItem` | Primeiro container fluido |
| `getItemById(id)` | `id: integer` | `InventoryItem` | Retorna item por ID (deprecated) |
| `getItemFromTag(itemTag)` | `itemTag: ItemTag` | `InventoryItem` | Retorna item por tag |
| `getItemFromTag(itemTag, ignoreBroken, includeInv)` | `itemTag: ItemTag, ignoreBroken: boolean, includeInv: boolean` | `InventoryItem` | Retorna item por tag |
| `getItemFromTag(itemTag, chr, notEquipped, ignoreBroken, includeInv)` | `itemTag: ItemTag, chr: IsoGameCharacter, notEquipped: boolean, ignoreBroken: boolean, includeInv: boolean` | `InventoryItem` | Retorna item por tag |
| `getItemFromType(type)` | `type: string` | `InventoryItem` | Retorna item por tipo |
| `getItemFromType(type, ignoreBroken, includeInv)` | `type: string, ignoreBroken: boolean, includeInv: boolean` | `InventoryItem` | Retorna item por tipo |
| `getItemFromType(type, chr, notEquipped, ignoreBroken, includeInv)` | `type: string, chr: IsoGameCharacter, notEquipped: boolean, ignoreBroken: boolean, includeInv: boolean` | `InventoryItem` | Retorna item por tipo |
| `getItemFromTypeRecurse(type)` | `type: string` | `InventoryItem` | Retorna item tipo recursivo |
| `getItemWithID(id)` | `id: integer` | `InventoryItem` | Retorna item com ID |
| `getItemWithIDRecursiv(id)` | `id: integer` | `InventoryItem` | Retorna item com ID recursivo |
| `getItems4Admin()` | - | `LinkedHashMap<string, InventoryItem>` | Retorna itens (admin) |
| `getItemsFromCategory(category)` | `category: string` | `ArrayList<InventoryItem>` | Retorna itens da categoria |
| `getItemsFromFullType(type)` | `type: string` | `ArrayList<InventoryItem>` | Retorna itens tipo completo |
| `getItemsFromFullType(type, includeInv)` | `type: string, includeInv: boolean` | `ArrayList<InventoryItem>` | Retorna itens tipo completo |
| `getItemsFromType(type)` | `type: string` | `ArrayList<InventoryItem>` | Retorna itens por tipo |
| `getItemsFromType(type, includeInv)` | `type: string, includeInv: boolean` | `ArrayList<InventoryItem>` | Retorna itens por tipo |
| `getRecipeItem(recipe, chr, recursive)` | `recipe: string, chr: IsoGameCharacter, recursive: boolean` | `InventoryItem` | Retorna item de receita |
| `getTotalFoodScore(desc)` | `desc: SurvivorDesc` | `number` | Pontuação total comida |
| `getTotalWeaponScore(desc)` | `desc: SurvivorDesc` | `number` | Pontuação total arma |
| `hasRecipe(recipe, chr)` | `recipe: string, chr: IsoGameCharacter` | `boolean` | Verifica receita |
| `hasRecipe(recipe, chr, recursive)` | `recipe: string, chr: IsoGameCharacter, recursive: boolean` | `boolean` | Verifica receita |
| `haveThisKeyId(keyId)` | `keyId: integer` | `InventoryItem` | Verifica chave |
| `isInCharacterInventory(chr)` | `chr: IsoGameCharacter` | `boolean` | Verifica inventário personagem |
| `isInside(item)` | `item: InventoryItem` | `boolean` | Verifica se está dentro |
| `isItemAllowed(item)` | `item: InventoryItem` | `boolean` | Verifica se item permitido |
| `isRemoveItemAllowed(item)` | `item: InventoryItem` | `boolean` | Verifica se remoção permitida |
| `isShop()` | - | `boolean` | Verifica se é loja |
| `isStove()` | - | `boolean` | Verifica se é fogão |
| `isMicrowave()` | - | `boolean` | Verifica se é microondas |
| `isOccupiedVehicleSeat()` | - | `boolean` | Verifica assento ocupado |
| `canCharacterOpenVehicleDoor(playerObj)` | `playerObj: IsoGameCharacter` | `boolean` | Verifica se abre porta |
| `canCharacterUnlockVehicleDoor(playerObj)` | `playerObj: IsoGameCharacter` | `boolean` | Verifica se destrava porta |
| `canHumanCorpseFit()` | - | `boolean` | Verifica se cadáver cabe |
| `doesVehicleDoorNeedOpening()` | - | `boolean` | Verifica se porta precisa abrir |
| `dumpContentsInSquare(sq)` | `sq: IsoGridSquare` | - | Despeja conteúdo |
| `findHumanCorpseItem()` | - | `InventoryItem` | Encontra cadáver humano |
| `findItem(in_predicate, doInv)` | `in_predicate: Invokers.Params2.Boolean.IParam2<InventoryItem>, doInv: boolean` | `InventoryItem` | Encontra item |
| `findItem(in_itemToCompare, in_predicate, doInv)` | `in_itemToCompare: T, in_predicate: Invokers.Params2.Boolean.ICallback<T, InventoryItem>, doInv: boolean` | `InventoryItem` | Encontra item |
| `findItem(type, doInv, ignoreBroken)` | `type: string, doInv: boolean, ignoreBroken: boolean` | `InventoryItem` | Encontra item |
| `containsID(id)` | `id: integer` | `boolean` | Verifica ID |
| `containsHumanCorpse()` | - | `boolean` | Verifica cadáver humano |
| `isEmptyOrUnwanted(player)` | `player: IsoPlayer` | `boolean` | Verifica vazio ou indesejado |
| `isExistYet()` | - | `boolean` | Verifica existência |
| `isDrawDirty()` | - | `boolean` | Verifica dirty desenho |
| `requestSync()` | - | - | Solicita sync |
| `requestServerItemsForContainer()` | - | - | Solicita itens servidor |
| `reset()` | - | - | Reseta |
| `save(output)` | `output: ByteBuffer` | `ArrayList<InventoryItem>` | Salva |
| `save(output, noCompress)` | `output: ByteBuffer, noCompress: IsoGameCharacter` | `ArrayList<InventoryItem>` | Salva |
| `load(input, WorldVersion)` | `input: ByteBuffer, WorldVersion: integer` | `ArrayList<InventoryItem>` | Carrega |
| `removeItemOnServer(item)` | `item: InventoryItem` | - | Remove item servidor (deprecated) |
| `removeItemWithID(id)` | `id: integer` | `boolean` | Remove item com ID |
| `removeItemWithIDRecurse(id)` | `id: integer` | `boolean` | Remove item com ID recursivo |
| `removeItemsFromProcessItems()` | - | - | Remove itens processados |
| `addItemsToProcessItems()` | - | - | Adiciona itens processados |
| `DoAddItem(item)` | `item: InventoryItem` | `InventoryItem` | Adiciona item interno |
| `DoAddItemBlind(item)` | `item: InventoryItem` | `InventoryItem` | Adiciona item blind interno |
| `DoRemoveItem(item)` | `item: InventoryItem` | - | Remove item interno |
| `addItemOnServer(item)` | `item: InventoryItem` | - | Adiciona item servidor |
| `addItem(item)` | `item: InventoryItem` ou `ItemKey` | `InventoryItem` ou `T` | Adiciona item |
| `addItems(item, count)` | `item: ItemKey, count: integer` | `List<InventoryItem>` | Adiciona itens |
| `toString()` | - | `string` | Retorna string |

---

## 🎒 InventoryItem (Itens)

**Classe:** `InventoryItem`  
**Arquivo:** `.libraries/library/java/zombie/inventory/InventoryItem.lua`

### Métodos Set (Modificação)

| Método | Parâmetro(s) | Descrição |
|--------|--------------|-----------|
| `setActivated(activated)` | `activated: boolean` | Ativa/desativa item |
| `setActivatedRemote(activated)` | `activated: boolean` | Ativa/desativa remotamente |
| `setActualWeight(ActualWeight)` | `ActualWeight: number` | Define peso atual |
| `setAge(Age)` | `Age: number` | Define idade |
| `setAlcoholPower(alcoholPower)` | `alcoholPower: number` | Define poder alcoólico |
| `setAlcoholic(alcoholic)` | `alcoholic: boolean` | Define se é alcoólico |
| `setAmmoType(ammoType)` | `ammoType: AmmoType` | Define tipo de munição |
| `setAnimalTracks(animalTracks)` | `animalTracks: AnimalTracks` | Define rastros de animal |
| `setAttachedSlot(attachedSlot)` | `attachedSlot: integer` | Define slot de anexo |
| `setAttachedSlotType(attachedSlotType)` | `attachedSlotType: string` | Define tipo de slot de anexo |
| `setAttachedToModel(attachedToModel)` | `attachedToModel: string` | Define modelo anexado |
| `setAttachmentReplacement(attachementReplacement)` | `attachementReplacement: string` | Define substituição de anexo |
| `setAttachmentType(attachmentType)` | `attachmentType: string` | Define tipo de anexo |
| `setAttachmentsProvided(attachmentsProvided)` | `attachmentsProvided: ArrayList<string>` | **Define attachments fornecidos** |
| `setBandagePower(bandagePower)` | `bandagePower: number` | Define poder de bandagem |
| `setBeingFilled(v)` | `v: boolean` | Define se está sendo enchido |
| `setBlood(bodyPartType, amount)` | `bodyPartType: BloodBodyPartType, amount: number` | Define sangue por parte do corpo |
| `setBloodClothingType(bloodClothingType)` | `bloodClothingType: ArrayList<BloodClothingType>` | Define tipo de sangue |
| `setBloodLevel(level)` | `level: number` | Define nível de sangue |
| `setBoredomChange(boredomChange)` | `boredomChange: number` | Define mudança de tédio |
| `setBrakeForce(brakeForce)` | `brakeForce: number` | Define força de freio |
| `setBreakSound(breakSound)` | `breakSound: string` | Define som de quebrar |
| `setBroken(broken)` | `broken: boolean` | Define se está quebrado |
| `setBurnt(Burnt)` | `Burnt: boolean` | Define se está queimado |
| `setBurntString(BurntString)` | `BurntString: string` | Define string de queimado |
| `setCanBeActivated(activatedItem)` | `activatedItem: boolean` | Define se pode ativar |
| `setCanBeRemote(canBeRemote)` | `canBeRemote: boolean` | Define se pode ser remoto |
| `setChanceToSpawnDamaged(chanceToSpawnDamaged)` | `chanceToSpawnDamaged: integer` | Define chance de spawnar danificado |
| `setColor(color)` | `color: Color` | Define cor |
| `setColorBlue(colorBlue)` | `colorBlue: number` | Define azul da cor |
| `setColorGreen(colorGreen)` | `colorGreen: number` | Define verde da cor |
| `setColorRed(colorRed)` | `colorRed: number` | Define vermelho da cor |
| `setCondition(Condition)` | `Condition: integer` | Define condição |
| `setCondition(Condition, doSound)` | `Condition: integer, doSound: boolean` | Define condição com som |
| `setConditionFrom(item)` | `item: InventoryItem` | Define condição de outro item |
| `setConditionFromHeadCondition(item)` | `item: InventoryItem` | Define condição de head condition |
| `setConditionFromModData(other)` | `other: InventoryItem` | Define condição de modData |
| `setConditionLowerNormal(conditionLowerNormal)` | `conditionLowerNormal: number` | Define redução normal de condição |
| `setConditionLowerOffroad(conditionLowerOffroad)` | `conditionLowerOffroad: number` | Define redução offroad de condição |
| `setConditionMax(ConditionMax)` | `ConditionMax: integer` | Define condição máxima |
| `setConditionNoSound(Condition)` | `Condition: integer` | Define condição sem som |
| `setConditionTo(item)` | `item: InventoryItem` | Define condição para item |
| `setConditionWhileLoading(Condition)` | `Condition: integer` | Define condição durante carga |
| `setContainer(container)` | `container: ItemContainer` | Define container pai |
| `setContainerX(containerX)` | `containerX: integer` | Define X do container |
| `setContainerY(containerY)` | `containerY: integer` | Define Y do container |
| `setCooked(Cooked)` | `Cooked: boolean` | Define se está cozido |
| `setCookedString(CookedString)` | `CookedString: string` | Define string de cozido |
| `setCookingTime(CookingTime)` | `CookingTime: number` | Define tempo de cozimento |
| `setCount(count)` | `count: integer` | Define quantidade |
| `setCountDownSound(sound)` | `sound: string` | Define som de contagem |
| `setCurrentAmmoCount(ammo)` | `ammo: integer` | Define munição atual |
| `setCurrentUses(newuses)` | `newuses: integer` | Define usos atuais |
| `setCurrentUsesFloat(newUses)` | `newUses: number` | Define usos atuais (float) |
| `setCurrentUsesFrom(other)` | `other: InventoryItem` | Define usos de outro item |
| `setCustomColor(customColor)` | `customColor: boolean` | Define cor customizada |
| `setCustomMenuOption(customMenuOption)` | `customMenuOption: string` | Define opção de menu customizada |
| `setCustomName(customName)` | `customName: boolean` | Define nome customizado |
| `setCustomWeight(custom)` | `custom: boolean` | Define peso customizado |
| `setDescription(Description)` | `Description: string` | Define descrição |
| `setDirt(bodyPartType, amount)` | `bodyPartType: BloodBodyPartType, amount: number` | Define sujeira |
| `setDisplayCategory(displayCategory)` | `displayCategory: string` | Define categoria de exibição |
| `setDoingExtendedPlacement(enable)` | `enable: boolean` | Define placement estendido |
| `setDurability(durability)` | `durability: number` | Define durabilidade |
| `setEngineLoudness(engineLoudness)` | `engineLoudness: number` | Define ruído do motor |
| `setEquipParent(parent)` | `parent: IsoGameCharacter` | Define personagem equipado |
| `setEquipParent(parent, register)` | `parent: IsoGameCharacter, register: boolean` | Define personagem equipado |
| `setEvolvedRecipeName(evolvedRecipeName)` | `evolvedRecipeName: string` | Define nome de receita evoluída |
| `setExplosionSound(explosionSound)` | `explosionSound: string` | Define som de explosão |
| `setFatigueChange(fatigueChange)` | `fatigueChange: number` | Define mudança de fadiga |
| `setFavorite(favorite)` | `favorite: boolean` | Define como favorito |
| `setFoodSicknessChange(foodSicknessChange)` | `foodSicknessChange: integer` | Define mudança de enjoo |
| `setGunType(gunType)` | `gunType: string` | Define tipo de arma |
| `setHaveBeenRepaired(haveBeenRepaired)` | `haveBeenRepaired: integer` | Define se foi reparado |
| `setHeadCondition(value)` | `value: integer` | Define head condition |
| `setHeadConditionFromCondition(item)` | `item: InventoryItem` | Define head condition de condition |
| `setID(itemId)` | `itemId: integer` | Define ID |
| `setIcon(texture)` | `texture: Texture` | Define ícone |
| `setIconsForTexture(iconsForTexture)` | `iconsForTexture: ArrayList<string>` | Define ícones para textura |
| `setInfected(infected)` | `infected: boolean` | Define se está infectado |
| `setInitialised(initialised)` | `initialised: boolean` | Define se inicializado |
| `setInverseCoughProbability(inverseCoughProbability)` | `inverseCoughProbability: integer` | Define probabilidade inversa de tosse |
| `setInverseCoughProbabilitySmoker(inverseCoughProbabilitySmoker)` | `inverseCoughProbabilitySmoker: integer` | Define probabilidade inversa (fumante) |
| `setIsCookable(IsCookable)` | `IsCookable: boolean` | Define se é cozinhável |
| `setIsCraftingConsumed(craftingConsumed)` | `craftingConsumed: boolean` | Define se é consumido no craft |
| `setItemCapacity(capacity)` | `capacity: number` | Define capacidade do item |
| `setItemHeat(itemHeat)` | `itemHeat: number` | Define calor do item |
| `setItemType(itemType)` | `itemType: ItemType` | Define tipo de item |
| `setItemWhenDry(itemWhenDry)` | `itemWhenDry: string` | Define item quando seco |
| `setJobDelta(delta)` | `delta: number` | Define delta de trabalho |
| `setJobType(type)` | `type: string` | Define tipo de trabalho |
| `setKeyId(keyId)` | `keyId: integer` | Define ID da chave |
| `setLastAged(time)` | `time: number` | Define último envelhecimento |
| `setLightDistance(lightDistance)` | `lightDistance: integer` | Define distância da luz |
| `setLightStrength(lightStrength)` | `lightStrength: number` | Define intensidade da luz |
| `setMaxAmmo(maxAmmoCount)` | `maxAmmoCount: integer` | Define munição máxima |
| `setMaxCapacity(maxCapacity)` | `maxCapacity: integer` | Define capacidade máxima |
| `setMediaType(b)` | `b: integer` | Define tipo de mídia |
| `setMeltingTime(meltingTime)` | `meltingTime: number` | Define tempo de derretimento |
| `setMetalValue(metalValue)` | `metalValue: number` | Define valor de metal |
| `setMinutesToBurn(MinutesToBurn)` | `MinutesToBurn: number` | Define minutos para queimar |
| `setMinutesToCook(MinutesToCook)` | `MinutesToCook: number` | Define minutos para cozinhar |
| `setModelIndex(index)` | `index: integer` | Define índice do modelo |
| `setModule(module)` | `module: string` | Define módulo |
| `setName(name)` | `name: string` | Define nome |
| `setNewPlaceDir(newPlaceDir)` | `newPlaceDir: IsoDirections` | Define direção de placement |
| `setNoRecipes(player, noCrafting)` | `player: IsoPlayer, noCrafting: boolean` | Define sem receitas |
| `setOffAge(OffAge)` | `OffAge: integer` | Define idade de estrago |
| `setOffAgeMax(OffAgeMax)` | `OffAgeMax: integer` | Define idade máxima de estrago |
| `setOffString(OffString)` | `OffString: string` | Define string de estrago |
| `setOrigin(x, y)` | `x: integer, y: integer` | Define origem |
| `setOrigin(x, y, z)` | `x: integer, y: integer, z: integer` | Define origem 3D |
| `setOrigin(sq)` | `sq: IsoGridSquare` | Define origem |
| `setOriginX(value)` | `value: integer` | Define X de origem |
| `setOriginY(value)` | `value: integer` | Define Y de origem |
| `setOriginZ(value)` | `value: integer` | Define Z de origem |
| `setPlaceDir(placeDir)` | `placeDir: IsoDirections` | Define direção de placement |
| `setPreviousOwner(previousOwner)` | `previousOwner: IsoGameCharacter` | Define dono anterior |
| `setQuality(value)` | `value: integer` | Define qualidade |
| `setRecordedMediaData(data)` | `data: MediaData` | Define dados de mídia |
| `setRecordedMediaIndex(id)` | `id: integer` | Define índice de mídia |
| `setRecordedMediaIndexInteger(id)` | `id: integer` | Define índice de mídia (inteiro) |
| `setReduceInfectionPower(reduceInfectionPower)` | `reduceInfectionPower: number` | Define redução de infecção |
| `setRegistry_id(itemscript)` | `itemscript: Item` | Define ID de registro |
| `setRemoteControlID(remoteControlID)` | `remoteControlID: integer` | Define ID de controle remoto |
| `setRemoteController(remoteController)` | `remoteController: boolean` | Define se é controle remoto |
| `setRemoteRange(remoteRange)` | `remoteRange: integer` | Define alcance remoto |
| `setReplaceOnUse(replaceOnUse)` | `replaceOnUse: string` | Define substituição ao usar |
| `setReplaceOnUseOn(ReplaceOnUseOn)` | `ReplaceOnUseOn: string` | Define substituição ao usar em |
| `setRequireInHandOrInventory(requireInHandOrInventory)` | `requireInHandOrInventory: ArrayList<string>` | Define requisitos |
| `setRightClickContainer(rightClickContainer)` | `rightClickContainer: ItemContainer` | Define container de clique direito |
| `setScriptItem(ScriptItem)` | `ScriptItem: Item` | Define item de script |
| `setSharpness(value)` | `value: number` | Define afiamento |
| `setSharpnessFrom(item)` | `item: InventoryItem` | Define afiamento de outro item |
| `setStashChance(stashChance)` | `stashChance: integer` | Define chance de esconderijo |
| `setStashMap(stashMap)` | `stashMap: string` | Define mapa de esconderijo |
| `setStaticModel(model)` | `model: string` ou `ModelKey` | Define modelo estático |
| `setStaticModelsByIndex(staticModelsByIndex)` | `staticModelsByIndex: ArrayList<string>` | Define modelos estáticos |
| `setStressChange(stressChange)` | `stressChange: number` | Define mudança de estresse |
| `setSuspensionCompression(suspensionCompression)` | `suspensionCompression: number` | Define compressão de suspensão |
| `setSuspensionDamping(suspensionDamping)` | `suspensionDamping: number` | Define amortecimento de suspensão |
| `setTaken(Taken)` | `Taken: ArrayList<IsoObject>` | Define tomados |
| `setTexture(texture)` | `texture: Texture` | Define textura |
| `setTextureBurnt(textureBurnt)` | `textureBurnt: Texture` | Define textura queimada |
| `setTextureColorMask(tex)` | `tex: string` | Define máscara de cor |
| `setTextureCooked(textureCooked)` | `textureCooked: Texture` | Define textura cozida |
| `setTextureFluidMask(tex)` | `tex: string` | Define máscara de fluido |
| `setTexturerotten(texturerotten)` | `texturerotten: Texture` | Define textura podre |
| `setTimesHeadRepaired(haveBeenRepaired)` | `haveBeenRepaired: integer` | Define vezes reparado (head) |
| `setTimesRepaired(haveBeenRepaired)` | `haveBeenRepaired: integer` | Define vezes reparado |
| `setTooltip(tooltip)` | `tooltip: string` | Define tooltip |
| `setTorchCone(isTorchCone)` | `isTorchCone: boolean` | Define cone de tocha |
| `setType(type)` | `type: string` | Define tipo |
| `setUnCookedString(UnCookedString)` | `UnCookedString: string` | Define string de cru |
| `setUnhappyChange(unhappyChange)` | `unhappyChange: number` | Define mudança de infelicidade |
| `setUnwanted(player, unwanted)` | `player: IsoPlayer, unwanted: boolean` | Define como indesejado |
| `setUseDelta(useDelta)` | `useDelta: number` | Define delta de uso |
| `setUses(uses)` | `uses: integer` | Define usos (deprecated) |
| `setUsesFrom(other)` | `other: InventoryItem` | Define usos de outro item |
| `setWeight(Weight)` | `Weight: number` | Define peso |
| `setWet(isWet)` | `isWet: boolean` | Define se está molhado |
| `setWetCooldown(wetCooldown)` | `wetCooldown: number` | Define cooldown de molhado |
| `setWheelFriction(wheelFriction)` | `wheelFriction: number` | Define fricção da roda |
| `setWorker(worker)` | `worker: string` | Define trabalhador |
| `setWorldAlpha(worldAlpha)` | `worldAlpha: number` | Define alpha do mundo |
| `setWorldItem(w)` | `w: IsoWorldInventoryObject` | Define item do mundo |
| `setWorldScale(scale)` | `scale: number` | Define escala do mundo |
| `setWorldStaticItem(model)` | `model: string` | Define item estático do mundo |
| `setWorldStaticModel(model)` | `model: string` ou `ModelKey` | Define modelo estático do mundo |
| `setWorldStaticModelsByIndex(staticModelsByIndex)` | `staticModelsByIndex: ArrayList<string>` | Define modelos estáticos do mundo |
| `setWorldTexture(WorldTexture)` | `WorldTexture: string` | Define textura do mundo |
| `setWorldXRotation(rot)` | `rot: number` | Define rotação X do mundo |
| `setWorldYRotation(rot)` | `rot: number` | Define rotação Y do mundo |
| `setWorldZRotation(rot)` | `rot: number` | Define rotação Z do mundo |

### Métodos Get (Leitura)

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `getA()` | `number` | Retorna A |
| `getActualWeight()` | `number` | Retorna peso atual |
| `getAge()` | `number` | Retorna idade |
| `getAimReleaseSound()` | `string` | Retorna som de liberação de mira |
| `getAlcoholPower()` | `number` | Retorna poder alcoólico |
| `getAlternateModelName()` | `string` | Retorna nome de modelo alternativo |
| `getAmmoType()` | `AmmoType` | Retorna tipo de munição |
| `getAnimalFeedType()` | `string` | Retorna tipo de ração |
| `getAnimalTracks()` | `AnimalTracks` | Retorna rastros de animal |
| `getAttachedSlot()` | `integer` | Retorna slot de anexo |
| `getAttachedSlotType()` | `string` | Retorna tipo de slot de anexo |
| `getAttachedToModel()` | `string` | Retorna modelo anexado |
| `getAttachmentReplacement()` | `string` | Retorna substituição de anexo |
| `getAttachmentType()` | `string` | Retorna tipo de anexo |
| `getAttachmentsProvided()` | `ArrayList<string>` | **Retorna attachments fornecidos** |
| `getB()` | `number` | Retorna B |
| `getBandagePower()` | `number` | Retorna poder de bandagem |
| `getBlood(bodyPartType)` | `number` | Retorna sangue por parte do corpo |
| `getBloodClothingType()` | `ArrayList<BloodClothingType>` | Retorna tipo de sangue |
| `getBloodLevel()` | `number` | Retorna nível de sangue |
| `getBloodLevelAdjustedHigh()` | `number` | Retorna nível de sangue ajustado (alto) |
| `getBloodLevelAdjustedLow()` | `number` | Retorna nível de sangue ajustado (baixo) |
| `getBodyLocation()` | `ItemBodyLocation` | Retorna localização do corpo |
| `getBookSubjects()` | `List<BookSubject>` | Retorna assuntos do livro |
| `getBoredomChange()` | `number` | Retorna mudança de tédio |
| `getBrakeForce()` | `number` | Retorna força de freio |
| `getBreakSound()` | `string` | Retorna som de quebrar |
| `getBringToBearSound()` | `string` | Retorna som de apontar |
| `getBulletHitArmourSound()` | `string` | Retorna som de tiro na armadura |
| `getBurntString()` | `string` | Retorna string de queimado |
| `getByteData()` | `ByteBuffer` | Retorna dados byte |
| `getCategory()` | `string` | Retorna categoria |
| `getChanceToSpawnDamaged()` | `integer` | Retorna chance de spawnar danificado |
| `getCleanString(weight)` | `string` | Retorna string de limpeza |
| `getClothingItem()` | `ClothingItem` | Retorna item de roupa |
| `getClothingItemExtra()` | `ArrayList<string>` | Retorna extra de roupa |
| `getClothingItemExtraOption()` | `ArrayList<string>` | Retorna opção extra de roupa |
| `getClothingItemName()` | `string` | Retorna nome de roupa |
| `getColor()` | `Color` | Retorna cor |
| `getColorBlue()` | `number` | Retorna azul |
| `getColorGreen()` | `number` | Retorna verde |
| `getColorInfo()` | `ColorInfo` | Retorna info de cor |
| `getColorRed()` | `number` | Retorna vermelho |
| `getCondition()` | `integer` | Retorna condição |
| `getConditionLowerChance()` | `integer` | Retorna chance de redução de condição |
| `getConditionLowerNormal()` | `number` | Retorna redução normal de condição |
| `getConditionLowerOffroad()` | `number` | Retorna redução offroad de condição |
| `getConditionMax()` | `integer` | Retorna condição máxima |
| `getConsolidateOption()` | `string` | Retorna opção de consolidar |
| `getContainer()` | `ItemContainer` | Retorna container |
| `getContainerX()` | `integer` | Retorna X do container |
| `getContainerY()` | `integer` | Retorna Y do container |
| `getContentsWeight()` | `number` | Retorna peso do conteúdo |
| `getCookedString()` | `string` | Retorna string de cozido |
| `getCookingTime()` | `number` | Retorna tempo de cozimento |
| `getCount()` | `integer` | Retorna quantidade |
| `getCountDownSound()` | `string` | Retorna som de contagem |
| `getCoverType()` | `CoverType` | Retorna tipo de cobertura |
| `getCurrentAmmoCount()` | `integer` | Retorna munição atual |
| `getCurrentCondition()` | `number` | Retorna condição real (0-100) |
| `getCurrentUses()` | `integer` | Retorna usos atuais |
| `getCurrentUsesFloat()` | `number` | Retorna usos atuais (float) |
| `getCustomMenuOption()` | `string` | Retorna opção de menu customizada |
| `getDamagedSound()` | `string` | Retorna som de dano |
| `getDeadBodyObject()` | `IsoDeadBody` | Retorna objeto de cadáver |
| `getDescription()` | `string` | Retorna descrição |
| `getDigType()` | `string` | Retorna tipo de escavação |
| `getDirt(bodyPartType)` | `number` | Retorna sujeira |
| `getDiscomfortModifier()` | `number` | Retorna modificador de desconforto |
| `getDisplayCategory()` | `string` | Retorna categoria de exibição |
| `getDisplayName()` | `string` | Retorna nome de exibição |
| `getDoubleClickRecipe()` | `string` | Retorna receita de clique duplo |
| `getDropSound()` | `string` | Retorna som de drop |
| `getDurability()` | `number` | Retorna durabilidade |
| `getEatTime()` | `integer` | Retorna tempo de comer |
| `getEatType()` | `string` | Retorna tipo de comer |
| `getEngineLoudness()` | `number` | Retorna ruído do motor |
| `getEntityNetID()` | `integer` | Retorna ID de rede da entidade |
| `getEquipParent()` | `IsoGameCharacter` | Retorna personagem equipado |
| `getEquipSound()` | `string` | Retorna som de equipar |
| `getEquippedWeight()` | `number` | Retorna peso equipado |
| `getEvolvedRecipeName()` | `string` | Retorna nome de receita evoluída |
| `getExplosionSound()` | `string` | Retorna som de explosão |
| `getExtinguishedItem()` | `InventoryItem` | Retorna item extinto |
| `getExtraItems()` | `ArrayList<string>` | Retorna itens extras |
| `getExtraItemsWeight()` | `number` | Retorna peso de itens extras |
| `getFabricType()` | `string` | Retorna tipo de tecido |
| `getFatigueChange()` | `number` | Retorna mudança de fadiga |
| `getFileName()` | `string` | Retorna nome do arquivo |
| `getFillFromDispenserSound()` | `string` | Retorna som de encher do dispensador |
| `getFillFromLakeSound()` | `string` | Retorna som de encher do lago |
| `getFillFromTapSound()` | `string` | Retorna som de encher da torneira |
| `getFillFromToiletSound()` | `string` | Retorna som de encher do vaso |
| `getFireFuelRatio()` | `number` | Retorna razão de combustível de fogo |
| `getFluidContainerFromSelfOrWorldItem()` | `FluidContainer` | Retorna container de fluido |
| `getFoodSicknessChange()` | `integer` | Retorna mudança de enjoo |
| `getFullType()` | `string` | Retorna tipo completo |
| `getG()` | `number` | Retorna G |
| `getGameEntityType()` | `GameEntityType` | Retorna tipo de entidade |
| `getGunType()` | `string` | Retorna tipo de arma |
| `getHaveBeenRepaired()` | `integer` | Retorna se foi reparado |
| `getHeadCondition()` | `integer` | Retorna head condition |
| `getHeadConditionLowerChance()` | `integer` | Retorna chance de redução de head condition |
| `getHeadConditionLowerChanceMultiplier()` | `number` | Retorna multiplicador de chance |
| `getHeadConditionMax()` | `integer` | Retorna head condition máxima |
| `getHearingModifier()` | `number` | Retorna modificador de audição |
| `getHotbarEquippedWeight()` | `number` | Retorna peso equipado na hotbar |
| `getID()` | `integer` | Retorna ID |
| `getIcon()` | `Texture` | Retorna ícone |
| `getIconsForTexture()` | `ArrayList<string>` | Retorna ícones para textura |
| `getInvHeat()` | `number` | Retorna calor do inventário |
| `getInverseCoughProbability()` | `integer` | Retorna probabilidade inversa de tosse |
| `getInverseCoughProbabilitySmoker()` | `integer` | Retorna probabilidade inversa (fumante) |
| `getIsCraftingConsumed()` | `boolean` | Retorna se é consumido no craft |
| `getItemAfterCleaning()` | `string` | Retorna item após limpeza |
| `getItemCapacity()` | `number` | Retorna capacidade do item |
| `getItemHeat()` | `number` | Retorna calor do item |
| `getItemReplacementPrimaryHand()` | `ItemReplacement` | Retorna substituição mão principal |
| `getItemReplacementSecondHand()` | `ItemReplacement` | Retorna substituição mão secundária |
| `getItemWhenDry()` | `string` | Retorna item quando seco |
| `getJobDelta()` | `number` | Retorna delta de trabalho |
| `getJobType()` | `string` | Retorna tipo de trabalho |
| `getKeyId()` | `integer` | Retorna ID da chave |
| `getLastAged()` | `number` | Retorna último envelhecimento |
| `getLightDistance()` | `integer` | Retorna distância da luz |
| `getLightStrength()` | `number` | Retorna intensidade da luz |
| `getLootType()` | `string` | Retorna tipo de loot |
| `getLuaCreate()` | `string` | Retorna criação Lua |
| `getMagazineSubjects()` | `List<MagazineSubject>` | Retorna assuntos de revista |
| `getMaintenanceMod()` | `integer` | Retorna mod de manutenção |
| `getMaintenanceMod(isEquipped)` | `integer` | Retorna mod de manutenção |
| `getMaintenanceMod(character)` | `integer` | Retorna mod de manutenção |
| `getMaintenanceMod(isEquipped, character)` | `integer` | Retorna mod de manutenção |
| `getMakeUpType()` | `string` | Retorna tipo de maquiagem |
| `getMaxAmmo()` | `integer` | Retorna munição máxima |
| `getMaxCapacity()` | `integer` | Retorna capacidade máxima |
| `getMaxMilk()` | `integer` | Retorna leite máximo |
| `getMaxSharpness()` | `number` | Retorna afiamento máximo |
| `getMaxUses()` | `integer` | Retorna usos máximos |
| `getMechanicType()` | `integer` | Retorna tipo de mecânico |
| `getMediaData()` | `MediaData` | Retorna dados de mídia |
| `getMediaType()` | `integer` | Retorna tipo de mídia |
| `getMeltingTime()` | `number` | Retorna tempo de derretimento |
| `getMetalValue()` | `number` | Retorna valor de metal |
| `getMilkReplaceItem()` | `string` | Retorna item de substituição de leite |
| `getMinutesToBurn()` | `number` | Retorna minutos para queimar |
| `getMinutesToCook()` | `number` | Retorna minutos para cozinhar |
| `getModData()` | `table` | Retorna dados de mod |
| `getModID()` | `string` | Retorna ID do mod |
| `getModName()` | `string` | Retorna nome do mod |
| `getModelIndex()` | `integer` | Retorna índice do modelo |
| `getModule()` | `string` | Retorna módulo |
| `getName()` | `string` | Retorna nome |
| `getName(player)` | `string` | Retorna nome (player) |
| `getNewPlaceDir()` | `IsoDirections` | Retorna direção de placement |
| `getOffAge()` | `integer` | Retorna idade de estrago |
| `getOffAgeMax()` | `integer` | Retorna idade máxima de estrago |
| `getOffString()` | `string` | Retorna string de estrago |
| `getOnBreak()` | `string` | Retorna ao quebrar |
| `getOpeningRecipe()` | `string` | Retorna receita de abrir |
| `getOriginX()` | `integer` | Retorna X de origem |
| `getOriginY()` | `integer` | Retorna Y de origem |
| `getOriginZ()` | `integer` | Retorna Z de origem |
| `getOutermostContainer()` | `ItemContainer` | Retorna container mais externo |
| `getOwner()` | `IsoGameCharacter` | Retorna dono |
| `getPlaceDir()` | `IsoDirections` | Retorna direção de placement |
| `getPlaceMultipleSound()` | `string` | Retorna som de placement múltiplo |
| `getPlaceOneSound()` | `string` | Retorna som de placement único |
| `getPlayer()` | `IsoPlayer` | Retorna player |
| `getPourLiquidOnGroundSound()` | `string` | Retorna som de derramar no chão |
| `getPourType()` | `string` | Retorna tipo de derramar |
| `getPreviousOwner()` | `IsoGameCharacter` | Retorna dono anterior |
| `getQuality()` | `integer` | Retorna qualidade |
| `getR()` | `number` | Retorna R |
| `getRecordedMediaIndex()` | `integer` | Retorna índice de mídia gravada |
| `getReduceInfectionPower()` | `number` | Retorna redução de infecção |
| `getRegistry_id()` | `integer` | Retorna ID de registro |
| `getRemoteControlID()` | `integer` | Retorna ID de controle remoto |
| `getRemoteRange()` | `integer` | Retorna alcance remoto |
| `getReplaceOnExtinguish()` | `string` | Retorna substituição ao extinguir |
| `getReplaceOnUse()` | `string` | Retorna substituição ao usar |
| `getReplaceOnUseFullType()` | `string` | Retorna tipo completo de substituição |
| `getReplaceOnUseOn()` | `string` | Retorna substituição ao usar em |
| `getReplaceOnUseOnString()` | `string` | Retorna string de substituição |
| `getReplaceType(key)` | `string` | Retorna tipo de substituição |
| `getReplaceTypes()` | `string` | Retorna tipos de substituição |
| `getReplaceTypesMap()` | `HashMap<string, string>` | Retorna mapa de tipos de substituição |
| `getRequireInHandOrInventory()` | `ArrayList<string>` | Retorna requisitos |
| `getResearchableRecipes()` | `ArrayList<string>` | Retorna receitas pesquisáveis |
| `getResearchableRecipes(chr)` | `ArrayList<string>` | Retorna receitas pesquisáveis |
| `getRightClickContainer()` | `ItemContainer` | Retorna container de clique direito |
| `getScore(desc)` | `number` | Retorna pontuação |
| `getScriptItem()` | `Item` | Retorna item de script |
| `getSharpness()` | `number` | Retorna afiamento |
| `getSharpnessIncrement()` | `number` | Retorna incremento de afiamento |
| `getSharpnessMultiplier()` | `number` | Retorna multiplicador de afiamento |
| `getShoutMultiplier()` | `number` | Retorna multiplicador de grito |
| `getShoutType()` | `string` | Retorna tipo de grito |
| `getSoundByID(ID)` | `string` | Retorna som por ID |
| `getSoundParameter(parameterName)` | `string` | Retorna parâmetro de som |
| `getSquare()` | `IsoGridSquare` | Retorna quadrado |
| `getStashChance()` | `integer` | Retorna chance de esconderijo |
| `getStashMap()` | `string` | Retorna mapa de esconderijo |
| `getStaticModel()` | `string` | Retorna modelo estático |
| `getStaticModelException()` | `string` | Retorna exceção de modelo estático |
| `getStaticModelsByIndex()` | `ArrayList<string>` | Retorna modelos estáticos por índice |
| `getStrainModifier()` | `number` | Retorna modificador de tensão |
| `getStressChange()` | `number` | Retorna mudança de estresse |
| `getStringItemType()` | `string` | Retorna tipo de item como string |
| `getSuspensionCompression()` | `number` | Retorna compressão de suspensão |
| `getSuspensionDamping()` | `number` | Retorna amortecimento de suspensão |
| `getSwingAnim()` | `string` | Retorna animação de balanço |
| `getTags()` | `Set<ItemTag>` | Retorna tags |
| `getTaken()` | `ArrayList<IsoObject>` | Retorna tomados |
| `getTex()` | `Texture` | Retorna textura |
| `getTexture()` | `Texture` | Retorna textura |
| `getTextureBurnt()` | `Texture` | Retorna textura queimada |
| `getTextureColorMask()` | `Texture` | Retorna máscara de cor |
| `getTextureCooked()` | `Texture` | Retorna textura cozida |
| `getTextureFluidMask()` | `Texture` | Retorna máscara de fluido |
| `getTexturerotten()` | `Texture` | Retorna textura podre |
| `getTimesHeadRepaired()` | `integer` | Retorna vezes reparado (head) |
| `getTimesRepaired()` | `integer` | Retorna vezes reparado |
| `getTooltip()` | `string` | Retorna tooltip |
| `getTorchDot()` | `number` | Retorna ponto de tocha |
| `getType()` | `string` | Retorna tipo |
| `getUnCookedString()` | `string` | Retorna string de cru |
| `getUnequipSound()` | `string` | Retorna som de desequipar |
| `getUnequippedWeight()` | `number` | Retorna peso não equipado |
| `getUnhappyChange()` | `number` | Retorna mudança de infelicidade |
| `getUseDelta()` | `number` | Retorna delta de uso |
| `getUser()` | `IsoGameCharacter` | Retorna usuário |
| `getUses()` | `integer` | Retorna usos (deprecated) |
| `getVisionModifier()` | `number` | Retorna modificador de visão |
| `getVisual()` | `ItemVisual` | Retorna visual |
| `getWeaponHitArmourSound()` | `string` | Retorna som de acerto na armadura |
| `getWeaponLevel()` | `integer` | Retorna nível de arma |
| `getWeight()` | `number` | Retorna peso |
| `getWetCooldown()` | `number` | Retorna cooldown de molhado |
| `getWetness()` | `number` | Retorna molhabilidade |
| `getWheelFriction()` | `number` | Retorna fricção da roda |
| `getWithDrainable()` | `string` | Retorna com drenável |
| `getWithoutDrainable()` | `string` | Retorna sem drenável |
| `getWorker()` | `string` | Retorna trabalhador |
| `getWorldAlpha()` | `number` | Retorna alpha do mundo |
| `getWorldItem()` | `IsoWorldInventoryObject` | Retorna item do mundo |
| `getWorldObjectSprite()` | `string` | Retorna sprite de objeto do mundo |
| `getWorldStaticItem()` | `string` | Retorna item estático do mundo |
| `getWorldStaticModel()` | `string` | Retorna modelo estático do mundo |
| `getWorldStaticModelsByIndex()` | `ArrayList<string>` | Retorna modelos estáticos do mundo |
| `getWorldTexture()` | `string` | Retorna textura do mundo |
| `getWorldXRotation()` | `number` | Retorna rotação X do mundo |
| `getWorldYRotation()` | `number` | Retorna rotação Y do mundo |
| `getWorldZRotation()` | `number` | Retorna rotação Z do mundo |
| `getX()` | `number` | Retorna X |
| `getY()` | `number` | Retorna Y |
| `getZ()` | `number` | Retorna Z |

### Métodos de Verificação (Is/Has/Can)

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `CanStack(item)` | `boolean` | Verifica se pode empilhar |
| `DoTooltip(tooltipUI)` | - | Faz tooltip |
| `DoTooltip(tooltipUI, layout)` | - | Faz tooltip com layout |
| `DoTooltipEmbedded(tooltipUI, layoutOverride, offsetY)` | - | Faz tooltip incorporado |
| `HowRotten()` | `number` | Retorna quão podre está |
| `IsClothing()` | `boolean` | Verifica se é roupa |
| `IsDrainable()` | `boolean` | Verifica se é drenável |
| `IsFood()` | `boolean` | Verifica se é comida |
| `IsInventoryContainer()` | `boolean` | Verifica se é container |
| `IsLiterature()` | `boolean` | Verifica se é literatura |
| `IsMap()` | `boolean` | Verifica se é mapa |
| `IsRotten()` | `boolean` | Verifica se está podre |
| `IsWeapon()` | `boolean` | Verifica se é arma |
| `ModDataMatches(item)` | `boolean` | Verifica se modData corresponde |
| `allowRandomTint()` | `boolean` | Verifica se permite tint aleatório |
| `canBeActivated()` | `boolean` | Verifica se pode ativar |
| `canBeEquipped()` | `ItemBodyLocation` | Retorna localização de equipamento |
| `canBeRemote()` | `boolean` | Verifica se pode ser remoto |
| `canEmitLight()` | `boolean` | Verifica se pode emitir luz |
| `canHaveOrigin()` | `boolean` | Verifica se pode ter origem |
| `canStoreWater()` | `boolean` | Verifica se pode armazenar água |
| `checkSyncItemFields(b)` | `boolean` | Verifica sync de campos |
| `damageCheck()` | `boolean` | Verifica dano |
| `damageCheck(skill)` | `boolean` | Verifica dano com skill |
| `damageCheck(skill, multiplier)` | `boolean` | Verifica dano com multiplicador |
| `damageCheck(skill, multiplier, maintenance)` | `boolean` | Verifica dano com manutenção |
| `damageCheck(skill, multiplier, maintenance, isEquipped)` | `boolean` | Verifica dano equipado |
| `damageCheck(skill, multiplier, maintenance, isEquipped, character)` | `boolean` | Verifica dano completo |
| `finishupdate()` | `boolean` | Verifica se terminou update |
| `hasBlood()` | `boolean` | Verifica se tem sangue |
| `hasDirt()` | `boolean` | Verifica se tem sujeira |
| `hasHeadCondition()` | `boolean` | Verifica se tem head condition |
| `hasMetal()` | `boolean` | Verifica se tem metal |
| `hasModData()` | `boolean` | Verifica se tem modData |
| `hasOrigin()` | `boolean` | Verifica se tem origem |
| `hasQuality()` | `boolean` | Verifica se tem qualidade |
| `hasReplaceType(key)` | `boolean` | Verifica se tem tipo de substituição |
| `hasResearchableRecipes()` | `boolean` | Verifica se tem receitas pesquisáveis |
| `hasSharpness()` | `boolean` | Verifica se tem afiamento |
| `hasTag(tags)` | `boolean` | Verifica se tem tags |
| `hasTag(itemTag)` | `boolean` | Verifica se tem tag |
| `hasTimesHeadRepaired()` | `boolean` | Verifica se tem vezes reparado (head) |
| `haveExtraItems()` | `boolean` | Verifica se tem itens extras |
| `headConditionCheck()` | `boolean` | Verifica head condition |
| `headConditionCheck(skill)` | `boolean` | Verifica head condition com skill |
| `headConditionCheck(skill, multiplier)` | `boolean` | Verifica head condition |
| `headConditionCheck(skill, multiplier, maintenance)` | `boolean` | Verifica head condition |
| `headConditionCheck(skill, multiplier, maintenance, isEquipped)` | `boolean` | Verifica head condition |
| `is(item)` | `boolean` | Verifica se é item |
| `isActivated()` | `boolean` | Verifica se está ativado |
| `isAlcoholic()` | `boolean` | Verifica se é alcoólico |
| `isAlwaysWelcomeGift()` | `boolean` | Verifica se é presente de boas-vindas |
| `isAnimalCorpse()` | `boolean` | Verifica se é cadáver de animal |
| `isAnimalFeed()` | `boolean` | Verifica se é ração |
| `isBeingFilled()` | `boolean` | Verifica se está sendo enchido |
| `isBloody()` | `boolean` | Verifica se está sangrento |
| `isBodyLocation(itemBodyLocation)` | `boolean` | Verifica localização do corpo |
| `isBroken()` | `boolean` | Verifica se está quebrado |
| `isBurnt()` | `boolean` | Verifica se está queimado |
| `isCanBandage()` | `boolean` | Verifica se pode bandagem |
| `isConditionAffectsCapacity()` | `boolean` | Verifica se condição afeta capacidade |
| `isCookable()` | `boolean` | Verifica se é cozinhável |
| `isCooked()` | `boolean` | Verifica se está cozido |
| `isCustomColor()` | `boolean` | Verifica se tem cor customizada |
| `isCustomName()` | `boolean` | Verifica se tem nome customizado |
| `isCustomWeight()` | `boolean` | Verifica se tem peso customizado |
| `isDamaged()` | `boolean` | Verifica se está danificado |
| `isDisappearOnUse()` | `boolean` | Verifica se desaparece ao usar |
| `isDoingExtendedPlacement()` | `boolean` | Verifica se está em placement estendido |
| `isDull()` | `boolean` | Verifica se está sem fio |
| `isEmittingLight()` | `boolean` | Verifica se está emitindo luz |
| `isEmptyOfFluid()` | `boolean` | Verifica se está vazio de fluido |
| `isEntityValid()` | `boolean` | Verifica se entidade é válida |
| `isEquipped()` | `boolean` | Verifica se está equipado |
| `isEquippedNoSprint()` | `boolean` | Verifica se está equipado (sem sprint) |
| `isFakeEquipped()` | `boolean` | Verifica se está fake equipado |
| `isFakeEquipped(character)` | `boolean` | Verifica se está fake equipado |
| `isFavorite()` | `boolean` | Verifica se é favorito |
| `isFavouriteRecipeInput(player)` | `boolean` | Verifica se é entrada de receita favorita |
| `isFishingLure()` | `boolean` | Verifica se é isca de pesca |
| `isFluidContainer()` | `boolean` | Verifica se é container de fluido |
| `isFood()` | `boolean` | Verifica se é comida |
| `isForceDropHeavyItem()` | `boolean` | Verifica se força drop de item pesado |
| `isFullOfFluid()` | `boolean` | Verifica se está cheio de fluido |
| `isHidden()` | `boolean` | Verifica se está escondido |
| `isHumanCorpse()` | `boolean` | Verifica se é cadáver humano |
| `isInLocalPlayerInventory()` | `boolean` | Verifica se está no inventário local |
| `isInPlayerInventory()` | `boolean` | Verifica se está no inventário do player |
| `isInfected()` | `boolean` | Verifica se está infectado |
| `isInitialised()` | `boolean` | Verifica se está inicializado |
| `isIsCookable()` | `boolean` | Verifica se é cozinhável |
| `isItemType(itemType)` | `boolean` | Verifica se é tipo de item |
| `isKeepOnDeplete()` | `boolean` | Verifica se mantém ao esgotar |
| `isKeyRing()` | `boolean` | Verifica se é chaveiro |
| `isMemento()` | `boolean` | Verifica se é memento |
| `isNoRecipes(player)` | `boolean` | Verifica se não tem receitas |
| `isProtectFromRainWhileEquipped()` | `boolean` | Verifica se protege da chuva equipado |
| `isPureWater(includeTainted)` | `boolean` | Verifica se é água pura |
| `isRecordedMedia()` | `boolean` | Verifica se é mídia gravada |
| `isRemoteController()` | `boolean` | Verifica se é controle remoto |
| `isRequiresEquippedBothHands()` | `boolean` | Verifica se requer ambas mãos |
| `isSealed()` | `boolean` | Verifica se está selado |
| `isSharpenable()` | `boolean` | Verifica se pode afiar |
| `isSpice()` | `boolean` | Verifica se é tempero |
| `isTorchCone()` | `boolean` | Verifica se é cone de tocha |
| `isTrap()` | `boolean` | Verifica se é armadilha |
| `isTwoHandWeapon()` | `boolean` | Verifica se é arma de duas mãos |
| `isUnwanted(player)` | `boolean` | Verifica se é indesejado |
| `isUseWorldItem()` | `boolean` | Verifica se usa item do mundo |
| `isVanilla()` | `boolean` | Verifica se é vanilla |
| `isVisualAid()` | `boolean` | Verifica se é auxílio visual |
| `isWaterSource()` | `boolean` | Verifica se é fonte de água |
| `isWet()` | `boolean` | Verifica se está molhado |
| `isWorn()` | `boolean` | Verifica se está gasto |
| `sharpnessCheck()` | `boolean` | Verifica afiamento |
| `sharpnessCheck(skill)` | `boolean` | Verifica afiamento com skill |
| `sharpnessCheck(skill, multiplier)` | `boolean` | Verifica afiamento |
| `sharpnessCheck(skill, multiplier, maintenance)` | `boolean` | Verifica afiamento |
| `sharpnessCheck(skill, multiplier, maintenance, isEquipped)` | `boolean` | Verifica afiamento |
| `sharpnessCheck(skill, multiplier, maintenance, isEquipped, character)` | `boolean` | Verifica afiamento |

### Métodos de Manipulação

| Método | Parâmetro(s) | Retorno | Descrição |
|--------|--------------|---------|-----------|
| `CopyModData(DefaultModData)` | `DefaultModData: table` | - | Copia modData |
| `OnAddedToContainer(container)` | `container: ItemContainer` | - | Ao adicionar ao container |
| `OnBeforeRemoveFromContainer(container)` | `container: ItemContainer` | - | Antes de remover do container |
| `Remove()` | - | - | Remove item |
| `SetContainerPosition(x, y)` | `x: integer, y: integer` | - | Define posição no container |
| `SynchSpawn()` | - | - | Sincroniza spawn |
| `Use()` | - | - | Usa item |
| `Use(bCrafting)` | `bCrafting: boolean` | - | Usa item (craft) |
| `Use(bCrafting, bInContainer, bNeedSync)` | `bCrafting: boolean, bInContainer: boolean, bNeedSync: boolean` | - | Usa item completo |
| `UseAndSync()` | - | - | Usa e sincroniza |
| `UseForCrafting(uses)` | `uses: integer` | `boolean` | Usa para craft |
| `UseItem()` | - | - | Usa item |
| `addExtraItem(key)` | `key: ItemKey` | - | Adiciona item extra |
| `addExtraItem(type)` | `type: string` | - | Adiciona item extra |
| `applyMaxSharpness()` | - | - | Aplica afiamento máximo |
| `copyBloodLevelFrom(item)` | `item: InventoryItem` | - | Copia nível de sangue |
| `copyClothing(otherItem)` | `otherItem: InventoryItem` | - | Copia roupa |
| `copyConditionModData(other)` | `other: InventoryItem` | - | Copia condition e modData |
| `copyConditionStatesFrom(otherItem)` | `otherItem: InventoryItem` | - | Copia estados de condition |
| `copyModData(modData)` | `modData: table` | - | Copia modData |
| `copyTimesHeadRepairedFrom(item)` | `item: InventoryItem` | - | Copia vezes reparado (head) |
| `copyTimesHeadRepairedTo(item)` | `item: InventoryItem` | - | Copia vezes reparado (head) para |
| `copyTimesRepairedFrom(item)` | `item: InventoryItem` | - | Copia vezes reparado |
| `copyTimesRepairedTo(item)` | `item: InventoryItem` | - | Copia vezes reparado para |
| `createAndStoreDefaultDeadBody(square)` | `square: IsoGridSquare` | `IsoDeadBody` | Cria e armazena cadáver |
| `createCloneItem()` | - | `InventoryItem` | Cria clone |
| `doBreakSound()` | - | - | Toca som de quebrar |
| `doBuildingStash()` | - | - | Faz stash de construção |
| `doDamagedSound()` | - | - | Toca som de dano |
| `emptyLiquid()` | - | `InventoryItem` | Esvazia líquido |
| `incrementCondition(increment)` | `increment: integer` | - | Incrementa condição |
| `inheritFoodAgeFrom(otherFood)` | `otherFood: InventoryItem` | - | Herda idade de comida |
| `inheritOlderFoodAge(otherFood)` | `otherFood: InventoryItem` | - | Herda idade de comida mais velha |
| `initialiseItem()` | - | - | Inicializa item |
| `load(input, WorldVersion)` | `input: ByteBuffer, WorldVersion: integer` | - | Carrega |
| `loadCorpseFromByteData(square)` | `square: IsoGridSquare` | `IsoDeadBody` | Carrega cadáver |
| `monogramAfterDescriptor(desc)` | `desc: SurvivorDesc` | - | Monograma após descriptor |
| `nameAfterDescriptor(desc)` | `desc: SurvivorDesc` | - | Nome após descriptor |
| `onBreak()` | - | - | Ao quebrar |
| `playActivateDeactivateSound()` | - | - | Toca som de ativar/desativar |
| `playActivateSound()` | - | - | Toca som de ativar |
| `playDeactivateSound()` | - | - | Toca som de desativar |
| `randomizeCondition()` | - | - | Randomiza condição |
| `randomizeGeneralCondition()` | - | - | Randomiza condição geral |
| `randomizeHeadCondition()` | - | - | Randomiza head condition |
| `randomizeSharpness()` | - | - | Randomiza afiamento |
| `randomizeWorldZRotation()` | - | - | Randomiza rotação Z |
| `reduceCondition()` | - | - | Reduz condição |
| `reduceHeadCondition()` | - | - | Reduz head condition |
| `researchRecipes(character)` | `character: IsoGameCharacter` | - | Pesquisa receitas |
| `reset()` | - | - | Reseta |
| `save(output, net)` | `output: ByteBuffer, net: boolean` | - | Salva |
| `saveWithSize(output, net)` | `output: ByteBuffer, net: boolean` | - | Salva com tamanho |
| `setOrigin(sq)` | `sq: IsoGridSquare` | `boolean` | Define origem |
| `setOrigin(x, y)` | `x: integer, y: integer` | `boolean` | Define origem |
| `setOrigin(x, y, z)` | `x: integer, y: integer, z: integer` | `boolean` | Define origem 3D |
| `setWorldItem(w)` | `w: IsoWorldInventoryObject` | - | Define item do mundo |
| `setWorldScale(scale)` | `scale: number` | - | Define escala do mundo |
| `setWorldXRotation(rot)` | `rot: number` | - | Define rotação X |
| `setWorldYRotation(rot)` | `rot: number` | - | Define rotação Y |
| `setWorldZRotation(rot)` | `rot: number` | - | Define rotação Z |

---

## 📝 Exemplos de Uso

### Modificar capacidade de uma mochila

```lua
-- Pegar primeira mochila do inventário
local bag = player:getInventory():getFirst("Base.Backpack")
if bag then
    local container = bag:getContainer()
    if container then
        -- Modificar capacidade (slots)
        container:setCapacity(50)
        
        -- Modificar redução de peso (30%)
        container:setWeightReduction(30)
        
        -- Definir nome personalizado
        container:setCustomName("Minha Mochila Grande")
    end
end
```

### Modificar attachments de um item

```lua
-- Pegar uma faca do inventário
local knife = player:getInventory():getFirst("Base.Knife")
if knife then
    -- Definir attachments fornecidos
    knife:setAttachmentsProvided({"Base.Sheath"})
    
    -- Verificar attachments
    local attachments = knife:getAttachmentsProvided()
    for i = 0, attachments:size() - 1 do
        print(attachments:get(i))
    end
end
```

### Modificar condição e peso de um item

```lua
local item = player:getInventory():getFirst("Base.BaseballBat")
if item then
    -- Definir condição máxima
    item:setConditionMax(100)
    
    -- Definir condição atual
    item:setCondition(80)
    
    -- Modificar peso
    item:setWeight(1.5)
    
    -- Marcar como favorito
    item:setFavorite(true)
end
```

### Manipular itens em um container

```lua
local container = player:getInventory()

-- Adicionar item
container:AddItem("Base.WaterBottleFull")

-- Encontrar item
local water = container:Find("Base.WaterBottleFull")

-- Contar itens
local count = container:getCountType("Base.WaterBottleFull")

-- Remover todos de um tipo
container:RemoveAll("Base.WaterBottleFull")

-- Verificar se contém
if container:contains("Base.WaterBottleFull") then
    print("Tem água!")
end
```

---

## 🔗 Referências

- **InventoryItem:** `.libraries/library/java/zombie/inventory/InventoryItem.lua` (1978 linhas)
- **ItemContainer:** `.libraries/library/java/zombie/inventory/ItemContainer.lua` (1567 linhas)

---

*Documento gerado em 16 de fevereiro de 2026*
