--[[--
-- 可以端本地协议通讯类
-- @Author:Seven
-- @DateTime:2017-06-09 17:39:47
--]]
local START_ID = 1000000

ClientProto  = {}

ClientProto.Test 							= START_ID+1 			-- 测试
ClientProto.RecGotoHeroView 				= START_ID+2 			-- 获得召唤武将界面跳转到武将界面 通知关闭召唤界面
ClientProto.OnTouchNpcTask      			= START_ID+3            -- 点击npc,有任务
ClientProto.OnTouchNpcNoTask    			= START_ID+4            -- 点击npc,无任务
ClientProto.OnHeroFightChange    			= START_ID+5            -- 出战武将变更
ClientProto.ShowMainUIAutoPath    			= START_ID+6            -- 显示主界面自动寻路
ClientProto.ShowMainUIAutoAtk       		= START_ID+7            -- 显示主界面自动挂机
ClientProto.HidOrShowMainUI         		= START_ID+8            -- 隐藏或显示主界面
ClientProto.OpenFunction            		= START_ID+10           -- 功能开启（true为开启，false为开启完成）
ClientProto.FinishScene             		= START_ID+11           -- 场景加载完成
ClientProto.HideOrShowMainUIRightTop		= START_ID+12           -- 显示或隐藏主ui右上角ui（fub）
ClientProto.StarOrEndSit            		= START_ID+13           -- 开始或者结束打坐(true为开始打坐，false为结束打坐)
ClientProto.JoystickStartMove       		= START_ID+14           -- 摇杆开始移动
ClientProto.ShowOrHideMainuiBtn  			= START_ID+15           -- 显示或者隐藏主界面的按钮
ClientProto.CharacterRide           		= START_ID+16           -- 上坐骑或签字下坐骑通知（true为上坐骑，false为下坐骑）
ClientProto.TeamInfoRec             		= START_ID+17           -- 上坐骑或签字下坐骑通知（true为上坐骑，false为下坐骑）
ClientProto.HeroFightOrRest         		= START_ID+18           -- 武将出站或休息
ClientProto.ShowSitEffect           		= START_ID+19           -- 显示打坐特效(true为双人)
ClientProto.ShowHotPoint            		= START_ID+20           -- 显示主界面红点
ClientProto.AutoAtk                 		= START_ID+21           -- 挂机
ClientProto.TouchMonster            		= START_ID+22           -- 点击怪物
ClientProto.HideOrShowTaskPanel     		= START_ID+23           -- 显示或者隐藏任务面板
ClientProto.OnStopAutoMove  				= START_ID+24           -- 通知寻路到达，中断，或重新寻路，需要结束上次寻路
ClientProto.IsCanUseSkill   				= START_ID+25           -- 是否可以使用技能
ClientProto.VoiceMessageR   				= START_ID+26           -- 语音消息返回{msgType = 类型,fileId = 语音id,text = 转文字结果}
ClientProto.PlayerLoaderFinish   			= START_ID+27           -- 玩家加载完成
ClientProto.NPCLoaderFinish         		= START_ID+28           -- npc加载完成
ClientProto.EnterChallengeCopy				= START_ID+29           -- 进入挑战副本=======
ClientProto.TowerStorehouseChange		    = START_ID+30           -- 爬塔仓库变更(true 有物品，false 没有物品)
ClientProto.ChangePlayerModle               = START_ID+31           -- 更换玩家模型（需要传模型id）
ClientProto.ChangePlayerWeaponModle         = START_ID+32           -- 更换玩家武器模型（需要传模型id）
ClientProto.PoolFinishLoadedOne             = START_ID+33           -- 缓冲池加载完成一个
ClientProto.SceneOnFocus                    = START_ID+34           -- 开始聚焦场景
ClientProto.TitleChange                     = START_ID+35           -- 自身称号改变
ClientProto.JointTeam                    	= START_ID+36			-- 组队加入队伍
ClientProto.PlayerBlood						= START_ID+37			-- 自身玩家血量
ClientProto.CloseTaskChapterUI			    = START_ID+38			-- 关闭任务章节ui
ClientProto.PlayerSelfBeAttacked            = START_ID+39           -- 玩自己被攻击
ClientProto.PlayerSelfAttack                = START_ID+40           -- 玩自己攻击
ClientProto.PlayerAutoMove                  = START_ID+41           -- 开始自动寻路
ClientProto.ShowAwardEffect                 = START_ID+42           -- 显示主界面奖励领取特效
ClientProto.HorseGoToGroup                 	= START_ID+43           -- 通知界面进行跳转
ClientProto.UpdateChatMessage               = START_ID+44           -- 通知处理聊天信息
ClientProto.FristBattleMainui               = START_ID+45           -- 首场战斗主界面
ClientProto.ForceGuideNext                  = START_ID+46           -- 强制新手引导到下一步
ClientProto.ShowXPBtn                       = START_ID+47           -- 显示或者隐藏xp技能按钮
ClientProto.StoyFinish                      = START_ID+48           -- 剧情一大步完成
ClientProto.ShowSmallMap	 				= START_ID+49           -- 通知显示或者隐藏小地图
ClientProto.ShowATKPanel	 				= START_ID+50           -- 是否显示主界面攻击按钮
ClientProto.HideAllOpenUI	 		        = START_ID+51           -- 隐藏当前的打开的ui(主界面除外)
ClientProto.RefreshMainUI                   = START_ID+52           -- 刷新主界面
ClientProto.HusongLeftUI					= START_ID+53			-- 护送任务UI显示
ClientProto.HusongNPC						= START_ID+54			-- 护送NPC
ClientProto.CopyViewClose					= START_ID+55			-- 组队副本关闭
ClientProto.ComboText						= START_ID+56			-- 连击
ClientProto.MainUiShowControl				= START_ID+57			-- 主界面控件显示
ClientProto.HorseShowState					= START_ID+58			-- 通知关闭显示坐骑界面
ClientProto.MainUICopyEffect                = START_ID+59           --主界面副本按钮特效提醒
ClientProto.PlayNormalAtk                   = START_ID+60           --武将普攻造成的伤害
ClientProto.BuffInfo						= START_ID+61			--Buff信息
ClientProto.HeroLoaderFinish   				= START_ID+62           -- 武将加载完成
ClientProto.HeroBlood						= START_ID+63			-- 自身武将血量
ClientProto.Login15Day						= START_ID+64			-- 签到15天
ClientProto.MonsterLoaderFinish				= START_ID+65			-- 怪物加载完毕
ClientProto.BossBlood						= START_ID+66			-- boss血量
ClientProto.TransferMapFinish				= START_ID+67			-- 切换场景成功并且加载完（包括本地图传送）
ClientProto.MainUiShowDaily					= START_ID+68			-- 活动主ui显示活动图标
ClientProto.MouseClick   					= START_ID+69			-- 鼠标点击
ClientProto.MainUiHideDaily					= START_ID+70			-- 活动主ui隐藏活动图标
ClientProto.RemoveMapModel					= START_ID+71			-- 删除地图上模型
ClientProto.OpenFuncSkill					= START_ID+72			-- 开启技能
ClientProto.AllLoaderFinish					= START_ID+73			-- 所有加载完成
ClientProto.MainCopyBtn						= START_ID+74  			-- 主界面副本按钮切换
ClientProto.LegionViewClose					= START_ID+75  			-- 关闭军团主界面
ClientProto.LegionActivityRedPoint			= START_ID+76			--军团活动红点
ClientProto.UIRedPoint						= START_ID+77			-- UI界面红点
ClientProto.MonsterDead						= START_ID+78			--  怪物死亡 
ClientProto.CloseChat						= START_ID+79			--  关闭聊天ui  
ClientProto.CopyExitButtonEffect			= START_ID+80			--  离开副本按钮特效
ClientProto.Setting							= START_ID+81			--设置通知
ClientProto.RefreshTask						= START_ID+82			--通知刷新任务列表
ClientProto.refreshPlayerName				= START_ID+83			--刷新玩家名字
ClientProto.closeActiveEx					= START_ID+84			--关闭开服活动界面
ClientProto.UpdateFunTips					= START_ID+85			--更新功能预告tips
ClientProto.CloseOffline					= START_ID+86			--关闭开服活动界面
ClientProto.DoTask 							= START_ID+87			--通知做任务
ClientProto.AutoDotask						= START_ID+88			--通知自动做显示进入
ClientProto.OpenAutoDoTask					= START_ID+89			--开启自动做任务
ClientProto.PlayerDie 						= START_ID+90			--通知角色死亡
ClientProto.PlayerRelive 					= START_ID+91			--通知角色复活 
ClientProto.GuideClose						= START_ID+92			--指引通知关闭 
ClientProto.HideOrShowATKPanel			    = START_ID+93			--显示或者隐藏攻击面板
ClientProto.GuideFeeble						= START_ID+94			--弱指引
ClientProto.GuideFeebleClose				= START_ID+95			--弱指引关闭或离开
ClientProto.RefreshLeftPanel				= START_ID+96			--刷新左边状态栏状态
ClientProto.MainUiTextEffect				= START_ID+97			--主界面字特效





