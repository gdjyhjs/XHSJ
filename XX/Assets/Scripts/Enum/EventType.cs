
public enum EventTyp
{
    SpaceChange, // 变更选择的位置信息
    ClickWorld,
    DragItem,
    BeginDragItem,
    EndDragItem,
    MinValueChange, // 最小值变化 可能吃了恢复药之类的，需要更新属性显示
    AttrChange, // 属性值变化 可能吃了天材地宝之类的，需要更新属性显示
    BuffChange, // buff变化 可能吃了增益药之类的，需要更新属性显示
    ItemChange, // 背包的道具变化
    GongfaChange, // 装配的功法变化
    ChangeRide, // 变更坐骑
    GameDataChange, // 游戏数据变更
    ChangePos, // 变更角色位置信息

    end,
}
