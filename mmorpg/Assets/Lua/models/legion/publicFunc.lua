
--自适应的内容str
--node1 自适应的文本
--node2 自适应的srollview
function gf_update_introduction(str,node1,node2)
	-- local data = gf_getItemObject("legion"):get_info()
	local introduction = str
	node1.text = introduction
	-- elf.refer:Get(2).transform.sizeDelta =Vector2(width ,height)
	local sizeDelta = node1.gameObject.transform.sizeDelta
	local content = node2.transform:FindChild("Viewport").transform:FindChild("Content")
	content.transform.sizeDelta = Vector2(sizeDelta.x,node1.preferredHeight) 

	content.transform.localPosition = Vector3(content.transform.localPosition.x,0,0)

	if node1.preferredHeight <= 211 then
		node2:GetComponent("UnityEngine.UI.ScrollRect").enabled = false
	else
		node2:GetComponent("UnityEngine.UI.ScrollRect").enabled = true
	end
end