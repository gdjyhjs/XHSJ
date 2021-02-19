
public enum EventTyp
{
    SpaceChange,
    ClickWorld,
    DragItem,
    BeginDragItem,
    EndDragItem,
    MinValueChange, // 最小值变化 可能吃了恢复药之类的，需要更新属性显示
    AttrChange, // 属性值变化 可能吃了天材地宝之类的，需要更新属性显示
    BuffChange, // buff变化 可能吃了增益药之类的，需要更新属性显示
    ItemChange, // 背包的道具变化
    ChangeRide, // 变更坐骑
    GameDataChange, // 游戏数据变更

    end,
}
