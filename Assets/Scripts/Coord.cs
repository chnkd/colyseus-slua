#pragma warning disable RECS0016 // Bitwise operation on enum which has no [Flags] attribute
#pragma warning disable IDE0058 // Use discarded local

using System.IO;
using UnityEngine;
using SLua;

public class Coord : MonoBehaviour
{
    private LuaTable game;

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
        LuaSvr luaSvr = new LuaSvr();
#if UNITY_EDITOR
        LuaSvr.mainState.loaderDelegate += (string file, ref string absolutePath) =>
        {
            absolutePath = Application.dataPath + "/" + file.Replace('.', '/') + ".lua";
            return File.ReadAllBytes(absolutePath);
        };
#endif
        luaSvr.init((completion) => Debug.Log(completion), () =>
        {
            luaSvr.start("Scripts/entry");
            game = LuaSvr.mainState.getTable("Game");
            game.invoke("Start", game);
        }, LuaSvrFlag.LSF_BASIC | LuaSvrFlag.LSF_EXTLIB);
    }

    private void OnApplicationQuit()
    {
        if (game != null)
        {
            game.invoke("Finish", game);
        }
    }
}
