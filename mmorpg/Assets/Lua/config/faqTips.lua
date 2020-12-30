local ret = {
	[1001] = {
		tips_id = 1001, --[[不重复id]]
		-- 坐骑进阶
		width = 300, --[[tips宽度]]
		content1 = "1.进阶需消耗<color=#73d675>坐骑进阶石</color>，获得一定的经验。", --[[内容1]]
		content2 = "2.经验满了后即会进行<color=#73d675>升星</color>，升星可获得大量<color=#73d675>属性加成</color>。", --[[内容2]]
		content3 = "3.达到9星时升星即为进阶，<color=#73d675>进阶</color>可获得大量<color=#73d675>属性加成、提升坐骑速度</color>，同时<color=#73d675>激活</color>新的坐骑<color=#73d675>形象</color>。", --[[内容3]]
	} ,
	[1002] = {
		tips_id = 1002, --[[不重复id]]
		-- 坐骑喂养
		width = 300, --[[tips宽度]]
		content1 = "1.喂养<color=#73d675>升级可增加坐骑属性</color>，坐骑属性均直接<color=#73d675>增加到主角</color>的属性上。", --[[内容1]]
		content2 = "2.喂养达到一定等级，可<color=#73d675>激活</color>对应的<color=#73d675>坐骑技能</color>。", --[[内容2]]
		content3 = "3.可使用<color=#73d675>多余的装备和道具</color>进行喂养。", --[[内容3]]
		content4 = "4.使用【记忆喂养】，可将已经<color=#73d675>记忆的道具</color>进行<color=#73d675>一键喂养</color>。", --[[内容4]]
	} ,
	[1003] = {
		tips_id = 1003, --[[不重复id]]
		-- 喂养记忆
		width = 300, --[[tips宽度]]
		content1 = "1.喂养坐骑时，<color=#73d675>自动记忆曾经喂养过的道具</color>，保存在喂养记忆中。", --[[内容1]]
		content2 = "2.若有记忆中的道具要<color=#73d675>删除</color>，则可选中记忆中相应的道具，在<color=#73d675>点击【保存记忆】</color>。", --[[内容2]]
		content3 = "3.喂养绑定道具只记忆绑定道具；若<color=#73d675>喂养非绑道具，则记忆绑和非绑</color>的该道具。", --[[内容3]]
		content4 = "4.部分<color=#73d675>贵重道具不保存</color>在喂养记忆中。", --[[内容4]]
	} ,
	[1004] = {
		tips_id = 1004, --[[不重复id]]
		-- 坐骑幻化
		width = 300, --[[tips宽度]]
		content1 = "1.通过<color=#73d675>坐骑进阶</color>，即可<color=#73d675>激活</color>新的进阶坐骑<color=#73d675>形象</color>。", --[[内容1]]
		content2 = "2.<color=#73d675>已激活</color>的坐骑可以<color=#73d675>随时进行幻化，场景里的坐骑形象</color>将会显示为幻化后的形象。", --[[内容2]]
		content3 = "3.幻化<color=#73d675>只会改变</color>坐骑<color=#73d675>形象</color>，不会改变坐骑属性。", --[[内容3]]
	} ,
	[1005] = {
		tips_id = 1005, --[[不重复id]]
		-- 特殊幻化
		width = 300, --[[tips宽度]]
		content1 = "1.通过<color=#73d675>坐骑道具</color>，即可<color=#73d675>激活</color>新的进阶坐骑<color=#73d675>形象</color>。", --[[内容1]]
		content2 = "2.<color=#73d675>已激活</color>的坐骑可以<color=#73d675>随时进行幻化，场景里的坐骑形象</color>将会显示为幻化后的形象。", --[[内容2]]
		content3 = "3.幻化<color=#73d675>只会改变</color>坐骑<color=#73d675>形象</color>，不会改变坐骑属性。", --[[内容3]]
		content4 = "4.<color=#73d675>坐骑速度</color>只取<color=#73d675>最高值</color>。", --[[内容4]]
	} ,
	[1006] = {
		tips_id = 1006, --[[不重复id]]
		-- 坐骑封灵
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>每个坐骑形象</color>都可以进行封灵，封灵等级都是<color=#73d675>独立</color>的。", --[[内容1]]
		content2 = "2.每一级封灵都有5种属性，<color=#73d675>每种属性可封灵4次</color>，获得对应的属性。", --[[内容2]]
		content3 = "3.所有属性都封灵完毕后，即可<color=#73d675>提升封灵等级</color>，获得<color=#73d675>额外的属性加成</color>。", --[[内容3]]
	} ,
	[1011] = {
		tips_id = 1011, --[[不重复id]]
		-- 我的好友
		width = 300, --[[tips宽度]]
		content1 = "1.向好友<color=#73d675>赠送体力</color>的同时，<color=#73d675>自身可获得</color>1点体力，每天最多可获得<color=#73d675>25点</color>。", --[[内容1]]
		content2 = "2.每天可以<color=#73d675>领取25点</color>好友赠送的体力。", --[[内容2]]
		content3 = "3.当好友达到上限的时候，可在<color=#73d675>【好友管理】</color>对好友进行<color=#73d675>批量删除</color>操作。", --[[内容3]]
	} ,
	[1012] = {
		tips_id = 1012, --[[不重复id]]
		-- 我的仇人
		width = 300, --[[tips宽度]]
		content1 = "1.在<color=#73d675>野外地图被</color>别的玩家<color=#73d675>击至重伤</color>，对方会自动成为你的<color=#73d675>仇人</color>。", --[[内容1]]
		content2 = "2.每被重伤一次，<color=#73d675>仇恨度+1</color>；每重伤仇人1次，<color=#73d675>仇恨度-1</color>。", --[[内容2]]
		content3 = "3.<color=#73d675>仇恨度为0</color>之后，则该玩家<color=#73d675>不再是你的仇人</color>。", --[[内容3]]
	} ,
	[1013] = {
		tips_id = 1013, --[[不重复id]]
		-- 黑名单
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>黑名单内</color>的玩家，在所有频道的<color=#73d675>聊天信息</color>均会自动对其进行<color=#73d675>屏蔽</color>。", --[[内容1]]
		content2 = "2.<color=#73d675>黑名单内</color>的玩家对你发起的<color=#73d675>私聊</color>等信息将会自动<color=#73d675>屏蔽</color>。", --[[内容2]]
	} ,
	[1021] = {
		tips_id = 1021, --[[不重复id]]
		-- 剧情副本
		width = 300, --[[tips宽度]]
		content1 = "1.进入剧情副本需要<color=#73d675>消耗一定的体力</color>。", --[[内容1]]
		content2 = "2.每<color=#73d675>12分钟恢复1点体力</color>，体力达到上限之后不再增加。", --[[内容2]]
		content3 = "3.可花费<color=#73d675>10元宝购买20体力；提升VIP</color>等级，可<color=#73d675>增加</color>每天购买体力的<color=#73d675>次数</color>。", --[[内容3]]
		content4 = "4.获得<color=#73d675>3星评价</color>的剧情副本，可进行<color=#73d675>扫荡</color>。", --[[内容4]]
	} ,
	[1031] = {
		tips_id = 1031, --[[不重复id]]
		-- 护送美人
		width = 300, --[[tips宽度]]
		content1 = "1.每人每天可护送<color=#73d675>3次</color>，护送的美人<color=#73d675>品质越高，奖励越高</color>。", --[[内容1]]
		content2 = "2.可<color=#73d675>刷新美人品质</color>，每天有<color=#73d675>3次免费</color>次数，<color=#73d675>VIP</color>会有次数加成和经验<color=#73d675>加成</color>。", --[[内容2]]
		content3 = "3.可花费元宝刷新美人品质，<color=#73d675>优先使用绑定元宝</color>。", --[[内容3]]
		content4 = "4.双倍护送活动时间内护送，可获得<color=#73d675>双倍奖励</color>哦。", --[[内容4]]
	} ,
	[1041] = {
		tips_id = 1041, --[[不重复id]]
		-- 1v1竞技
		width = 320, --[[tips宽度]]
		content1 = "1.每人每天可挑战<color=#73d675>10次</color>，根据<color=#73d675>VIP</color>等级可花费元宝<color=#73d675>购买挑战次数</color>，挑战次数次日重置。", --[[内容1]]
		content2 = "2.挑战<color=#73d675>胜利</color>即可获得<color=#73d675>奖励</color>和对方的<color=#73d675>积分，积分越高，奖励越高</color>。", --[[内容2]]
		content3 = "3.挑战<color=#73d675>失败</color>不扣除自身积分，而且只能得到<color=#73d675>一半</color>的挑战奖励。", --[[内容3]]
		content4 = "4.<color=#73d675>每天21:00</color>，会根据<color=#73d675>段位结算奖励</color>，奖励需要<color=#73d675>自行领取</color>。", --[[内容4]]
		content5 = "5.每<color=#73d675>周日24:00</color>则会根据<color=#73d675>排名发放奖励</color>。", --[[内容5]]
		content6 = "6.<color=#73d675>斗币</color>可在兑换商店<color=#73d675>兑换</color>物品。", --[[内容6]]
	} ,
	[1051] = {
		tips_id = 1051, --[[不重复id]]
		-- 在线奖励
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>每天</color>达到一定的在线时间，即可领取<color=#73d675>在线奖励</color>。", --[[内容1]]
		content2 = "2.每在线<color=#73d675>10分钟</color>，即可累积<color=#73d675>5绑定元宝，本周在线累积</color>的绑定元宝奖励，可在<color=#73d675>下周领取</color>。", --[[内容2]]
		content3 = "3.<color=#73d675>等级越高</color>，每周可累积的绑定元宝<color=#73d675>越多</color>。", --[[内容3]]
	} ,
	[1061] = {
		tips_id = 1061, --[[不重复id]]
		-- 逐鹿战场
		width = 370, --[[tips宽度]]
		content1 = "1.<color=#73d675>击败</color>敌对阵营的玩家，可获得阵营积分、荣誉和战功，甚至能够获得对方身上的<color=#73d675>能量珠</color>。", --[[内容1]]
		content2 = "2.完成<color=#73d675>战场任务</color>，可获得大量的奖励。", --[[内容2]]
		content3 = "3.采集<color=#73d675>能量珠</color>，上交给军需官，可<color=#73d675>增加阵营的能量贮备</color>，同时获得奖励。", --[[内容3]]
		content4 = "4.<color=#73d675>能量储备</color>里的能量，可<color=#73d675>自动补充</color>战旗和守护塔<color=#73d675>损失的能量</color>。", --[[内容4]]
		content5 = "5.可<color=#73d675>攻陷</color>敌方阵营的<color=#73d675>战旗和守护塔</color>，获得大量奖励。", --[[内容5]]
		content6 = "6.战场开启<color=#73d675>10分钟内，战旗</color>处于<color=#73d675>无敌</color>状态，10分钟后才可以被攻击。", --[[内容6]]
		content7 = "7.<color=#73d675>攻陷敌方的战旗</color>，即可获得战场的<color=#73d675>胜利</color>。", --[[内容7]]
	} ,
	[1071] = {
		tips_id = 1071, --[[不重复id]]
		-- 魔狱修炼
		width = 320, --[[tips宽度]]
		content1 = "1.进入<color=#73d675>魔狱绝地</color>后，在10倍修炼状态下击败里面的怪物，可获得<color=#73d675>10倍经验</color>。", --[[内容1]]
		content2 = "2.10倍经验效果可<color=#73d675>与VIP打怪加成、多倍经验药加成进行叠加</color>，同时<color=#73d675>组队</color>杀怪也有<color=#73d675>经验加成</color>。", --[[内容2]]
		content3 = "3.<color=#73d675>每天0点</color>会自动<color=#73d675>重置为30分钟</color>10倍修炼时间，最多可使用道具增加至<color=#73d675>60分钟</color>。", --[[内容3]]
		content4 = "4.可使用<color=#73d675>修炼石</color>增加10倍修炼时间，同类道具每天可使用<color=#73d675>2个</color>。", --[[内容4]]
		content5 = "5.可以花费元宝进行<color=#73d675>鼓舞</color>，每次鼓舞可<color=#73d675>增加10%的伤害</color>，最高可增加100%伤害。", --[[内容5]]
		content6 = "6.鼓舞伤害只能在<color=#73d675>魔狱绝地系列场景内生效</color>，并且<color=#73d675>次日清空</color>。", --[[内容6]]
	} ,
	[1081] = {
		tips_id = 1081, --[[不重复id]]
		-- 武将图鉴
		width = 370, --[[tips宽度]]
		content1 = "1.收集足够的<color=#73d675>武将碎片</color>，即可自动<color=#73d675>招募</color>该武将。", --[[内容1]]
		content2 = "2.拥有武将后，对应的武将碎片可用于武将<color=#73d675>觉醒</color>。", --[[内容2]]
		content3 = "3.武将拥有<color=#73d675>传承属性</color>，招募后可<color=#73d675>为人物增加属性</color>，传承属性随着武将<color=#73d675>觉醒等级</color>的提升而<color=#73d675>倍增</color>。", --[[内容3]]
		content4 = "4.可在【出战阵容】里面调整<color=#73d675>出战的武将及出战顺序</color>。", --[[内容4]]
		content5 = "5.第1位的武将死亡后，需要<color=#73d675>60秒</color>才能复活，第2位武将会自动出战，以此类推。", --[[内容5]]
		content6 = "6.招募后的武将，<color=#73d675>资质和技能</color>是随机生成的，可通过<color=#73d675>洗炼进行改变</color>。", --[[内容6]]
	} ,
	[1082] = {
		tips_id = 1082, --[[不重复id]]
		-- 武将洗炼
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>每次</color>洗炼需要<color=#73d675>消耗洗髓丹</color>，武将<color=#73d675>品级越高</color>，所需<color=#73d675>洗髓丹越多</color>，洗炼可<color=#73d675>改变武将资质和技能</color>。", --[[内容1]]
		content2 = "2.洗炼<color=#73d675>次数越多</color>，洗炼的<color=#73d675>资质越高</color>，出现<color=#73d675>技能</color>的概率<color=#73d675>越高</color>。", --[[内容2]]
		content3 = "3.洗炼时可以<color=#73d675>锁定技能</color>，锁定后该技能不会随洗炼而改变。", --[[内容3]]
		content4 = "4.点击洗炼前的技能图标，即可进行<color=#73d675>锁定和解除锁定</color>。", --[[内容4]]
		content5 = "5.每个锁定的的技能，每<color=#73d675>洗炼1次</color>，都需要<color=#73d675>消耗1个</color>洗练锁。", --[[内容5]]
	} ,
	[1083] = {
		tips_id = 1083, --[[不重复id]]
		-- 武将觉醒
		width = 300, --[[tips宽度]]
		content1 = "1.武将<color=#73d675>觉醒</color>，需要<color=#73d675>消耗</color>一定数量的<color=#73d675>武将碎片</color>。", --[[内容1]]
		content2 = "2.觉醒后，可<color=#73d675>增加4项资质</color>一定的数值，并且提高4项<color=#73d675>资质的上限</color>。", --[[内容2]]
		content3 = "3.<color=#73d675>觉醒</color>等级每增加<color=#73d675>1级，传承属性</color>则会<color=#73d675>增加1倍</color>。", --[[内容3]]
	} ,
	[1084] = {
		tips_id = 1084, --[[不重复id]]
		-- 武将属性
		width = 290, --[[tips宽度]]
		content1 = "天资：影响武将升级后增加的<color=#73d675>所有属性</color>的具体值", --[[内容1]]
		content2 = "武力：影响武将升级后增加的<color=#73d675>攻击、暴击、命中、穿透</color>属性", --[[内容2]]
		content3 = "体魄：影响武将升级后增加的<color=#73d675>生命、坚韧、免伤、格挡</color>属性", --[[内容3]]
		content4 = "灵动：影响武将升级后增加的<color=#73d675>物防、法防、闪避、回血</color>属性", --[[内容4]]
	} ,
	[1085] = {
		tips_id = 1085, --[[不重复id]]
		-- 武将布阵
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>上阵武将</color>可获得一定的<color=#73d675>属性加成</color>。", --[[内容1]]
		content2 = "2.<color=#73d675>主角</color>可以获得上阵武将的<color=#73d675>部分属性</color>。", --[[内容2]]
		content3 = "3.<color=#73d675>不同阵位</color>获得的<color=#73d675>属性类型不同</color>。", --[[内容3]]
		content4 = "4.可对阵位进行升级，<color=#73d675>阵位等级越高，获得的属性越多</color>。", --[[内容4]]
	} ,
	[1091] = {
		tips_id = 1091, --[[不重复id]]
		-- 寻宝
		width = 300, --[[tips宽度]]
		content1 = "1.寻宝需要消耗<color=#73d675>秘藏宝钥</color>，一次性<color=#73d675>寻宝越多</color>，需要的秘藏宝钥<color=#73d675>越优惠</color>。", --[[内容1]]
		content2 = "2.<color=#73d675>每次寻宝</color>都可获得<color=#73d675>1点寻宝积分和道具</color>奖励。", --[[内容2]]
		content3 = "3.寻宝积分可用于<color=#73d675>兑换道具</color>。", --[[内容3]]
		content4 = "4.具体<color=#73d675>概率</color>请移步<color=#73d675>官网</color>查看。", --[[内容4]]
	} ,
	[1101] = {
		tips_id = 1101, --[[不重复id]]
		-- 烽火3V3
		width = 300, --[[tips宽度]]
		content1 = "1.每天<color=#73d675>前10场</color>3V3对决可获得大量荣誉值及段位积分。", --[[内容1]]
		content2 = "2.段位积分<color=#73d675>每周一重置</color>。", --[[内容2]]
	} ,
	[1111] = {
		tips_id = 1111, --[[不重复id]]
		-- 超值月卡
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>可以同时购买两种类型的卡</color>,即购买了月卡的同时也可以购买周卡，反之亦然。", --[[内容1]]
		content2 = "2.<color=#73d675>有效期和福利</color>都是<color=#73d675>单独计算</color>的,同时购买享受更多优惠哟。", --[[内容2]]
		content3 = "3.<color=#73d675>等级越高</color>,获得的道具越好。", --[[内容3]]
		content4 = "4.没有领取的奖励，将以<color=#73d675>邮件</color>方式发送给您。", --[[内容4]]
	} ,
	[1121] = {
		tips_id = 1121, --[[不重复id]]
		-- 魔狱领主
		width = 320, --[[tips宽度]]
		content1 = "1.每击杀1只世界BOSS，掉落归属玩家会增加<color=#73d675>1点</color>疲劳值。", --[[内容1]]
		content2 = "2.当人物疲劳值达到<color=#73d675>3点</color>，本日将无法对世界BOSS造成伤害。", --[[内容2]]
		content3 = "3.当人物等级比世界BOSS高<color=#73d675>100级及以上</color>时，击杀领主无奖励掉落，且仍然会增加疲劳值。", --[[内容3]]
		content4 = "4.疲劳值每天凌晨<color=#73d675>0点</color>重置。", --[[内容4]]
	} ,
	[1122] = {
		tips_id = 1122, --[[不重复id]]
		-- 野外BOSS
		width = 320, --[[tips宽度]]
		content1 = "1.野外BOSS神出鬼没，不定时地在北岭各个地方随机出现，请注意！", --[[内容1]]
		content2 = "2.有玩家和野外BOSS战斗中时，其他玩家不可挑战！", --[[内容2]]
	} ,
	[1131] = {
		tips_id = 1131, --[[不重复id]]
		-- 军团信息
		width = 300, --[[tips宽度]]
		content1 = "1.通过完成<color=#73d675>军团任务、捐献、参与各种军团活动</color>等，可获得军团<color=#73d675>贡献</color>和军团<color=#73d675>资金</color>。", --[[内容1]]
		content2 = "2.军团<color=#73d675>贡献</color>可用于<color=#73d675>修炼、战魂、兑换道具</color>等。", --[[内容2]]
		content3 = "3.军团<color=#73d675>资金</color>可用于<color=#73d675>军团升级、战魂升级</color>等。", --[[内容3]]
		content4 = "4.可将多余的<color=#73d675>装备捐献到军团仓库</color>里，从而获得仓库积分，<color=#73d675>仓库积分</color>可用于<color=#73d675>兑换军团仓库里的装备</color>。", --[[内容4]]
		content5 = "5.<color=#73d675>退出军团</color>后，军团贡献和仓库积分均会被<color=#73d675>清空</color>。", --[[内容5]]
	} ,
	[1132] = {
		tips_id = 1132, --[[不重复id]]
		-- 军团修炼
		width = 300, --[[tips宽度]]
		content1 = "1.修炼<color=#73d675>等级上限与军团等级相关</color>，军团等级越高，修炼上限越高。", --[[内容1]]
		content2 = "2.可以使用<color=#73d675>经书修炼</color>，也可以消耗<color=#73d675>军团贡献和铜钱</color>修炼。", --[[内容2]]
		content3 = "3.<color=#73d675>一键修炼</color>可以直接修炼到升级为止。", --[[内容3]]
	} ,
	[1133] = {
		tips_id = 1133, --[[不重复id]]
		-- 军团战旗
		width = 300, --[[tips宽度]]
		content1 = "1.<color=#73d675>统帅和副统帅</color>可以<color=#73d675>升级战旗</color>，战旗等级上限与军团等级有关。", --[[内容1]]
		content2 = "2.<color=#73d675>每天</color>可以进行<color=#73d675>3次</color>鼓舞（24点重置），<color=#73d675>每次30分钟</color>，鼓舞时间可叠加。", --[[内容2]]
		content3 = "3.每次鼓舞需要<color=#73d675>消耗10点军团贡献</color>。", --[[内容3]]
	} ,
	[1141] = {
		tips_id = 1141, --[[不重复id]]
		-- 牌局玩法
		width = 500, --[[tips宽度]]
		content1 = "<color=#73d675>游戏规则1：</color>双方使用15张相同手牌，进行最多3局的比赛。每局5张牌。", --[[内容1]]
		content2 = "<color=#73d675>游戏规则2：</color>比赛有选牌、对牌两阶段，对牌结束结算当局，<color=#73d675>高分者：胜</color>，<color=#73d675>分数一致：平</color>。", --[[内容2]]
		content3 = "<color=#73d675>游戏规则3：</color>选牌需<color=#73d675>在20秒内</color>，选择手牌中任意5张牌出牌，超时由系统随机选牌出牌。", --[[内容3]]
		content4 = "<color=#73d675>游戏规则4：</color>对牌据选牌的顺序进行对牌。普通牌直接计算各自得分，特殊牌在效果生效后，再计算得分。", --[[内容4]]
		content5 = "<color=#73d675>胜负规则1：</color>若比赛中没有平局，则按照3局2胜的规则判断胜负。", --[[内容5]]
		content6 = "<color=#73d675>胜负规则2：</color>若有2场平局，则胜1场的胜利。", --[[内容6]]
		content7 = "<color=#73d675>胜负规则3：</color> 若3局都为平局或者1胜1负1平，则按照平局处理。平局不计算胜场。", --[[内容7]]
		content8 = "<color=#73d675>奖励规则：</color>胜利则胜场数+1，胜场数每日重置，达标后直接发送奖励到背包。", --[[内容8]]
	} ,
	[1151] = {
		tips_id = 1151, --[[不重复id]]
		-- 官职说明
		width = 420, --[[tips宽度]]
		content1 = "1.文官通过获得<color=#73d675>名望</color>来提升官职，武官通过获得<color=#73d675>战功</color>来提升官职。", --[[内容1]]
		content2 = "2.玩家每天可以领取<color=#73d675>1次</color>对应官职的俸禄，官职越高俸禄越多。", --[[内容2]]
		content3 = "3.文官与武官增加的<color=#73d675>属性各不相同</color>，官职越高增加的属性越高。", --[[内容3]]
		content4 = "4.获得名望途径：<color=#73d675>护送任务、每日任务、金榜题名、军团任务、七煞卡牌</color>。", --[[内容4]]
		content5 = "5.获得战功途径：<color=#73d675>1v1竞技、烽火3v3、逐鹿战场、魔族围城、世界BOSS、组队副本、兵来将挡、时空宝库</color>。", --[[内容5]]
	} ,
	[1161] = {
		tips_id = 1161, --[[不重复id]]
		-- 装备打造
		width = 300, --[[tips宽度]]
		content1 = "1.每次成功<color=#73d675>打造装备</color>后，可获得一定的<color=#73d675>神器值</color>。", --[[内容1]]
		content2 = "2.当神器值达到<color=#73d675>满值后打造</color>，必定可以打造出<color=#73d675>带星级</color>属性的<color=#73d675>最高2个品质之一</color>的1星以上装备。", --[[内容2]]
		content3 = "3.<color=#73d675>不同等级</color>的神器值分开累积，<color=#73d675>不可叠加</color>。", --[[内容3]]
		content4 = "4.打造时<color=#73d675>加入灵石/魂石</color>，可确保打造出<color=#73d675>对应高品质</color>装备。", --[[内容4]]
		content5 = "5.打造时<color=#73d675>加入星魂石</color>，可提高打造获得<color=#73d675>星级属性</color>的概率。", --[[内容5]]
	} ,
	[1162] = {
		tips_id = 1162, --[[不重复id]]
		-- 装备洗炼
		width = 300, --[[tips宽度]]
		content1 = "1.可洗炼的条目与装备颜色有关，<color=#73d675>紫、金、橙、红</color>分别解锁<color=#73d675>1-4</color>条洗炼属性。", --[[内容1]]
		content2 = "2.可<color=#73d675>锁定</color>洗炼属性，使其在下次洗炼中<color=#73d675>不被改变</color>。", --[[内容2]]
		content3 = "3.可<color=#73d675>花费元宝</color>，使下一次洗炼<color=#73d675>必定</color>出现<color=#73d675>1条紫色</color>以上属性。", --[[内容3]]
		content4 = "4.随着<color=#73d675>锁定</color>洗炼属性<color=#73d675>数目的增加</color>，洗练石消耗和必出紫色元宝<color=#73d675>消耗也会增加</color>。", --[[内容4]]
		content5 = "5.洗炼<color=#73d675>次数越多</color>，洗炼得到的<color=#73d675>属性越好</color>。", --[[内容5]]
	} ,
	[1171] = {
		tips_id = 1171, --[[不重复id]]
		-- 基础属性
		width = 380, --[[tips宽度]]
		content1 = "攻击：造成伤害的基础属性", --[[内容1]]
		content2 = "生命：主角的生命上限", --[[内容2]]
		content3 = "物防：抵抗物理攻击伤害的基础属性", --[[内容3]]
		content4 = "法防：抵抗法术攻击伤害的基础属性", --[[内容4]]
		content5 = "穿透：攻击时，无视目标一定的防御值", --[[内容5]]
		content6 = "免伤：受击时，减免一定比例的伤害", --[[内容6]]
		content7 = "命中：命中成功，则该次攻击生效", --[[内容7]]
		content8 = "闪避：闪避成功，则该次攻击失效", --[[内容8]]
		content9 = "暴击：用于计算攻击时触发暴击的概率", --[[内容9]]
		content10 = "坚韧：受击时，减少暴击率和暴击伤害", --[[内容10]]
		content11 = "格挡：格挡成功，受到伤害减少20%", --[[内容11]]
		content12 = "回血：每10秒自动恢复的生命值", --[[内容12]]
	} ,
	[1172] = {
		tips_id = 1172, --[[不重复id]]
		-- 特殊属性
		width = 460, --[[tips宽度]]
		content1 = "伤害：攻击时，增加一定比例的伤害", --[[内容1]]
		content2 = "伤害减免：受击时，减免一定比例的伤害", --[[内容2]]
		content3 = "暴击率：攻击时，额外增加的暴击率", --[[内容3]]
		content4 = "暴击伤害：暴击后造成的伤害率，初始为150%", --[[内容4]]
		content5 = "命中率：攻击时，额外增加的命中率", --[[内容5]]
		content6 = "闪避率：受击时，额外增加的闪避率", --[[内容6]]
		content7 = "穿透率：攻击时，额外增加的穿透率", --[[内容7]]
		content8 = "坚韧率：受击时，额外增加的坚韧率", --[[内容8]]
		content9 = "格挡率：受击时，额外增加的格挡率", --[[内容9]]
		content10 = "回血率：每10秒恢复生命上限一定比例的生命", --[[内容10]]
	} ,
	[1181] = {
		tips_id = 1181, --[[不重复id]]
		-- 市场
		width = 200, --[[tips宽度]]
		content1 = "已绑定和有时限的物品无法上架", --[[内容1]]
	} ,
	[1191] = {
		tips_id = 1191, --[[不重复id]]
		-- 猎命说明
		width = 400, --[[tips宽度]]
		content1 = "1.每次猎命都可能找到更厉害的武将帮你猎命。", --[[内容1]]
		content2 = "2.更厉害的武将能帮你猎取到更高级的天命。", --[[内容2]]
		content3 = "3.点击召唤可以使用元宝让最高级的武将帮你猎命。", --[[内容3]]
	} ,
	[1201] = {
		tips_id = 1201, --[[不重复id]]
		-- 离线经验
		width = 400, --[[tips宽度]]
		content1 = "1.离线<color=#73d675>1分钟</color>以上，即可获得<color=#73d675>离线经验</color>，离线经验<color=#73d675>与等级、主角战斗力有关</color>。", --[[内容1]]
		content2 = "2.离线经验需<color=#73d675>手动领取</color>，领取后<color=#73d675>清空</color>当前累积离线时间，并<color=#73d675>扣除</color>相应的可累积离线时间。", --[[内容2]]
		content3 = "3.当前累积离线时间，<color=#73d675>不可能超过</color>可累积离线时间。", --[[内容3]]
		content4 = "4.可使用<color=#73d675>离线经验卡增加</color>可累积离线时间。", --[[内容4]]
		content5 = "5.每天达到一定<color=#73d675>活跃度</color>，可<color=#73d675>免费领取</color>离线经验卡。", --[[内容5]]
	} ,
}
return ret