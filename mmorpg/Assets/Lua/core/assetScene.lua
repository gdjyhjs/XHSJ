------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--	asset 
--	author pu
------------------------------------------------
local CUtils=CUtils
local LuaHelper=LuaHelper
local CacheManager = Hugula.Loader.CacheManager
local gf_game_object_atlas = gf_game_object_atlas

AssetScene = class(function(self,url,scene_name,is_additive)
	self.base = false
    self.url = url
    self.is_additive = is_additive --(LoadSceneMode.Single,LoadSceneMode.Additive)
    self.asset_name = scene_name --asset name
    self.assetbundle_url = CUtils.GetRightFileName(url) --real use url
    self.key = CUtils.GetAssetBundleName(self.assetbundle_url) --以assetbundle name为key
    self.root = nil
    self.preload = false
end)

--清理引用
function AssetScene:clear()
	self.root = nil
	-- print("clear ",self.scene_name)
end

function AssetScene:is_loaded()
	if self.root == nil then return false end
	return true
end

-- 设置开始加重
function AssetScene:start_load()
	self.is_start_load = true
end

--消耗
function AssetScene:dispose()
	CacheManager.Unload(self.key) --清理缓存
	self.root = nil
	gf_game_object_atlas[self.key]=nil
end

function AssetScene:show(...)
	self.root = self
	-- print("scene show "..self.asset_name)
end

function AssetScene:hide(...)
	self:clear()
	LuaHelper.UnloadScene(self.asset_name)
end

--
function AssetScene:copy_to(asse)
    asse.root = self.root
	return asse
end

--是否是预加载
function AssetScene:is_preload()
	return self.preload
end

function AssetScene:set_preload( flag )
	self.preload = flag
end

function AssetScene:__tostring()
    return string.format("AssetScene.key = %s ,url =%s ", self.key,self.url)
end