--- @file scavengerstoolkit\42.12\media\lua\client\STK_SandboxUI.lua
--- @brief Customização da UI das opções de sandbox do STK com separadores visuais
---
--- Este módulo aplica patches nos painéis de opções do sandbox (single player,
--- admin panel e host settings) para transformar GroupTitles em separadores
--- visuais com linhas horizontais e títulos centralizados.
---
--- Funcionalidades:
---   - Render personalizado para separadores (linha horizontal com título)
---   - Correção do bug de sobreposição de Y no admin panel
---   - Suporte consistente em todos os contextos de UI do sandbox
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

if isServer() then
	return
end

require("OptionScreens/SandboxOptions")
require("OptionScreens/ServerSettingsScreen")
require("ISUI/AdminPanel/ISServerSandboxOptionsUI")

--- @class STK_SandboxUI
local STK_SandboxUI = {}

--- Identificador de página do STK no menu de sandbox.
--- Deve corresponder ao valor de `Sandbox_STK` nas traduções.
--- @type string
local PAGE_NAME = "Scavenger's Toolkit"

--- Convenção de nome usada nos sandbox-options.txt para identificar separadores.
--- Qualquer option cujo nome contenha esta string será transformada em separador.
local SEPARATOR_KEY = "GroupTitle"

local LINE_HEIGHT = 2
local LINE_COLOR = { r = 0.2, g = 0.2, b = 0.2, a = 1.0 }
local TITLE_FONT = UIFont.Cred1

---------------------------
-- Render do Separador   --
---------------------------

--- Substitui o render padrão do ISTickBox para desenhar uma linha horizontal
--- com título centralizado, cobrindo toda a largura do painel pai.
---
---@param self ISTickBox
local function separatorRender(self)
	local parent = self:getParent()
	-- startX: quanto recuar à esquerda para alinhar com a label mais distante
	local startX = -(self.x - parent.stkLineX)
	local y = self.height + LINE_HEIGHT
	local endX = parent.stkLineWidth - parent.stkLineX

	self:drawRect(startX, y, endX, LINE_HEIGHT, LINE_COLOR.a, LINE_COLOR.r, LINE_COLOR.g, LINE_COLOR.b)

	if self.stkTitle then
		self:drawText(
			self.stkTitle,
			startX + (endX / 2) - self.stkTextWidth / 2,
			y - self.stkTextHeight + LINE_HEIGHT,
			0.2,
			0.5,
			1.0,
			1.0,
			TITLE_FONT
		)
	end
end

---------------------------
-- Patch de Separadores  --
---------------------------

--- Transforma um ISTickBox GroupTitle em separador visual.
--- Esconde o widget original e substitui o render.
---
---@param panel table painel da página de sandbox
---@param key string chave do controle (ex: "STK.ContainerLimitsGroupTitle")
---@param label ISLabel label correspondente ao controle
---@return boolean true se o patch foi aplicado
local function patchSeparator(panel, key, label)
	if not string.find(key, SEPARATOR_KEY) then
		return false
	end

	label:setVisible(false)

	local ctrl = panel.controls[key]
	ctrl.render = separatorRender
	ctrl.stkTitle = label.name
	ctrl.stkTextHeight = getTextManager():MeasureStringY(TITLE_FONT, label.name)
	ctrl.stkTextWidth = getTextManager():MeasureStringX(TITLE_FONT, label.name)
	return true
end

---------------------------
-- Setup do Painel       --
---------------------------

--- Calcula métricas de layout e aplica patches de separadores no painel.
--- Também corrige o bug de sobreposição de Y presente no admin panel.
---
---@param panel table painel criado por createPanel
---@param isAdminPanel boolean? true quando chamado do contexto admin
local function setupPanel(panel, isAdminPanel)
	-- Remove transparência (fica visualmente ruim com separadores)
	panel.backgroundColor = { r = 0, g = 0, b = 0, a = 1 }

	-- Calcula a borda direita (stkLineWidth) e esquerda (stkLineX) do painel
	-- usadas pelo separatorRender para estender a linha da borda à borda
	panel.stkLineWidth = nil
	for _, ctrl in pairs(panel.controls) do
		local endX = ctrl.x + ctrl.width
		if not panel.stkLineWidth or endX > panel.stkLineWidth then
			panel.stkLineWidth = endX
		end
	end

	-- O admin panel não possui panel.labels nativamente:
	-- os ISLabel são filhos diretos do painel sem índice por chave de opção.
	-- Reconstituímos o mapeamento emparelhando labels e controls pela ordem de inserção.
	if isAdminPanel and panel.labels == nil then
		local usedKeys = {}
		panel.labels = {}
		for _, child in pairs(panel.children) do
			if child.Type == "ISLabel" then
				for k, _ in pairs(panel.controls) do
					local alreadyUsed = false
					for _, uk in pairs(usedKeys) do
						if uk == k then
							alreadyUsed = true
							break
						end
					end
					if not alreadyUsed then
						panel.labels[k] = child
						table.insert(usedKeys, k)
						break
					end
				end
			end
		end

		-- Fix do bug de Y: no admin panel os controles ficam sobrepostos.
		-- Recalcula a posição Y de cada controle com base no anterior.
		local controlGap
		local lastY
		for k, ctrl in pairs(panel.controls) do
			if controlGap == nil and lastY ~= nil then
				controlGap = (ctrl.y - lastY) - ctrl.height
			end
			if controlGap ~= nil and lastY ~= nil then
				ctrl:setY(lastY + ctrl.height + controlGap)
				if panel.labels[k] then
					panel.labels[k]:setY(lastY + ctrl.height + controlGap)
				end
			end
			lastY = ctrl:getY()
		end

		if lastY and controlGap then
			panel:setScrollHeight(lastY + controlGap + 20)
		end
	end

	-- stkLineX: posição X da label mais à esquerda (início da linha do separador)
	panel.stkLineX = nil
	for k, label in pairs(panel.labels or {}) do
		if not panel.stkLineX or label.x < panel.stkLineX then
			panel.stkLineX = label.x
		end
		patchSeparator(panel, k, label)
	end
end

---------------------------
-- Verificação de Página --
---------------------------

---@param name string
---@return boolean
local function isSTKPage(name)
	return name ~= nil and string.find(name, PAGE_NAME) ~= nil
end

---------------------------
-- Hook: Single Player   --
---------------------------

local old_soloCreatePanel = SandboxOptionsScreen.createPanel
---@param self SandboxOptionsScreen
---@param page table
---@return table
SandboxOptionsScreen.createPanel = function(self, page)
	local panel = old_soloCreatePanel(self, page)
	if not isSTKPage(page and page.name) then
		return panel
	end
	setupPanel(panel, false)
	return panel
end

---------------------------
-- Hook: Admin Panel     --
---------------------------

local old_adminCreateChildren = ISServerSandboxOptionsUI.createChildren
---@param self ISServerSandboxOptionsUI
ISServerSandboxOptionsUI.createChildren = function(self)
	old_adminCreateChildren(self)
	for _, lbitem in pairs(self.listbox.items) do
		local item = lbitem.item
		if isSTKPage(item.page and item.page.name) then
			setupPanel(item.panel, true)
		end
	end
end

---------------------------
-- Hook: Host Settings   --
---------------------------

local old_aboutToShow = ServerSettingsScreen.aboutToShow
---@param self ServerSettingsScreen
ServerSettingsScreen.aboutToShow = function(self)
	old_aboutToShow(self)
	for _, v in pairs(self.pageEdit.listbox.items) do
		if isSTKPage(v.text) then
			setupPanel(v.item.panel, false)
		end
	end
end
