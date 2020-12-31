using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameStateManager
{
    public enum GameState
    {
        None,
        Main,
        CreateRole,
        Gameing,
    }
    public static GameState curState = GameState.None;
}
