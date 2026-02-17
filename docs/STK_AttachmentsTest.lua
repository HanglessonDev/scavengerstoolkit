--[[============================================================================
   STK Attachments Test v1.0
   Testa se setAttachmentsProvided() funciona em runtime
   
   Como usar:
   1. Copie este arquivo para: media/lua/client/STK_AttachmentsTest.lua
   2. Inicie o jogo em debug mode
   3. Spawne uma Schoolbag: /giveitem Bag_Schoolbag
   4. Equipe a mochila no slot de costas
   5. Verifique os logs no console
   6. Verifique se os slots aparecem no hotbar
   ============================================================================]]

local DEBUG_MODE = true

local function log(msg)
	if DEBUG_MODE then
		print("[STK-AttachmentsTest] " .. tostring(msg))
	end
end

--[[============================================================================
   TESTE 1: Adicionar attachments ao equipar mochila
   ============================================================================]]

local function testAttachmentsOnEquip(character, item)
	-- Validação básica
	if not item then
		log("Item é nil, ignorando...")
		return
	end

	local itemType = item:getType()
	log("Item equipado: " .. itemType)

	-- Só testa em Schoolbag
	if itemType ~= "Bag_Schoolbag" then
		log("Não é Schoolbag, ignorando...")
		return
	end

	log("========================================")
	log("INICIANDO TESTE DE ATTACHMENTS")
	log("========================================")

	-- PASSO 1: Verificar attachments ANTES
	log("PASSO 1: Verificando attachments originais...")
	local originalAttachments = item:getAttachmentsProvided()

	if originalAttachments then
		log("  Attachments originais encontrados: " .. originalAttachments:size())
		for i = 0, originalAttachments:size() - 1 do
			log("    - " .. originalAttachments:get(i))
		end
	else
		log("  Nenhum attachment original (nil)")
	end

	-- PASSO 2: Criar nova lista de attachments
	log("PASSO 2: Criando nova lista de attachments...")
	local newAttachments = ArrayList:new()
	newAttachments:add("SmallBeltLeft")
	newAttachments:add("SmallBeltRight")
	newAttachments:add("WebbingRight")
	newAttachments:add("WebbingLeft")
	newAttachments:add("BedrollBottom")

	log("  Lista criada com " .. newAttachments:size() .. " attachments")

	-- PASSO 3: Aplicar com setAttachmentsProvided
	log("PASSO 3: Aplicando setAttachmentsProvided()...")

	local success, error = pcall(function()
		item:setAttachmentsProvided(newAttachments)
	end)

	if not success then
		log("  ❌ ERRO ao chamar setAttachmentsProvided: " .. tostring(error))
		log("========================================")
		return
	end

	log("  ✅ setAttachmentsProvided() executou sem erro!")

	-- PASSO 4: Verificar se foi aplicado
	log("PASSO 4: Verificando se attachments foram aplicados...")
	local currentAttachments = item:getAttachmentsProvided()

	if currentAttachments then
		log("  Attachments atuais: " .. currentAttachments:size())
		for i = 0, currentAttachments:size() - 1 do
			log("    - " .. currentAttachments:get(i))
		end

		-- Verificar se os novos estão lá
		if currentAttachments:size() == newAttachments:size() then
			log("  ✅ SUCESSO: Número de attachments correto!")
		else
			log("  ⚠️ ATENÇÃO: Número diferente do esperado")
			log("    Esperado: " .. newAttachments:size())
			log("    Atual: " .. currentAttachments:size())
		end
	else
		log("  ❌ FALHA: getAttachmentsProvided() retornou nil")
	end

	-- PASSO 5: Popup visual para o jogador
	log("PASSO 5: Mostrando popup visual...")
	HaloTextHelper.addTextWithArrow(
		character,
		"Teste de Attachments executado!",
		true,
		102,
		204,
		102 -- Verde
	)

	log("========================================")
	log("TESTE COMPLETO!")
	log("========================================")
	log("")
	log("PRÓXIMOS PASSOS:")
	log("1. Verifique se os slots aparecem no HOTBAR")
	log("2. Tente DESEQUIPAR e RE-EQUIPAR a mochila")
	log("3. Verifique se os slots persistem")
	log("========================================")
end

--[[============================================================================
   TESTE 2: Persistência após save/load
   ============================================================================]]

local function testPersistence()
	log("========================================")
	log("TESTE DE PERSISTÊNCIA")
	log("========================================")

	local player = getPlayer()
	if not player then
		log("❌ Player não encontrado")
		return
	end

	local inv = player:getInventory()
	local bags = inv:FindAll("Bag_Schoolbag")

	if not bags or bags:isEmpty() then
		log("❌ Nenhuma Schoolbag encontrada no inventário")
		log("Use: /giveitem Bag_Schoolbag")
		return
	end

	log("Encontradas " .. bags:size() .. " Schoolbags")

	for i = 0, bags:size() - 1 do
		local bag = bags:get(i)
		log("")
		log("Mochila #" .. (i + 1) .. ":")

		local attachments = bag:getAttachmentsProvided()
		if attachments then
			log("  Attachments: " .. attachments:size())
			for j = 0, attachments:size() - 1 do
				log("    - " .. attachments:get(j))
			end
		else
			log("  Sem attachments")
		end
	end

	log("========================================")
	log("Salve e recarregue o jogo para testar persistência")
	log("========================================")
end

--[[============================================================================
   TESTE 3: Remover attachments
   ============================================================================]]

local function testRemoveAttachments(character, item)
	if not item or item:getType() ~= "Bag_Schoolbag" then
		return
	end

	log("========================================")
	log("TESTE: REMOVER ATTACHMENTS")
	log("========================================")

	-- Criar lista vazia
	local emptyList = ArrayList:new()

	log("Removendo todos os attachments...")
	item:setAttachmentsProvided(emptyList)

	local current = item:getAttachmentsProvided()
	if current and current:isEmpty() then
		log("✅ SUCESSO: Attachments removidos!")
	else
		log("⚠️ Attachments ainda presentes: " .. (current and current:size() or "nil"))
	end

	log("========================================")
end

--[[============================================================================
   REGISTRAR HOOKS
   ============================================================================]]

-- Sistema de controle para evitar rodar múltiplas vezes
local lastTestedBag = nil
local testCooldown = 0

-- Hook usando OnPlayerUpdate (polling) - mais confiável
Events.OnPlayerUpdate.Add(function(player)
	-- Cooldown para evitar spam (testa a cada 30 frames ~1 segundo)
	testCooldown = testCooldown - 1
	if testCooldown > 0 then
		return
	end
	testCooldown = 30

	-- Pegar mochila equipada
	local backItem = player:getWornItem("Back")

	-- Se não tem mochila, reseta controle
	if not backItem then
		lastTestedBag = nil
		return
	end

	-- Se não é Schoolbag, ignora
	if backItem:getType() ~= "Bag_Schoolbag" then
		return
	end

	-- Se já testamos esta mochila específica, não testa de novo
	if lastTestedBag == backItem then
		return
	end

	-- Marcar como testado
	lastTestedBag = backItem

	-- EXECUTAR TESTE!
	log("==> MOCHILA DETECTADA! Executando teste...")
	testAttachmentsOnEquip(player, backItem)
end)

log("========================================")
log("STK Attachments Test CARREGADO")
log("========================================")
log("Comandos disponíveis:")
log("  /stk-test-persist  - Testa persistência")
log("  /stk-test-remove   - Remove attachments")
log("========================================")

--[[============================================================================
   COMANDOS DE TESTE
   ============================================================================]]

-- Comando: testar persistência
Events.OnCustomUIKey.Add(function(key)
	if key == Keyboard.KEY_F9 then
		testPersistence()
	end
end)

-- Mensagem inicial
Events.OnGameStart.Add(function()
	log("")
	log("========================================")
	log("TESTE PRONTO!")
	log("========================================")
	log("1. Spawne uma mochila: /giveitem Bag_Schoolbag")
	log("2. Equipe a mochila")
	log("3. Observe os logs")
	log("4. Pressione F9 para teste de persistência")
	log("========================================")
	log("")
end)
