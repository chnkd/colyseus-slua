# colyseus-slua

## 以[slua](https://github.com/pangweiwei/slua)、[colyseus-defold](https://github.com/colyseus/colyseus-defold)和[colyseus-unity3d](https://github.com/colyseus/colyseus-unity3d)為基礎，整合Unity版本的Colyseus client for Lua。

   [colyseus-unity3d](https://github.com/colyseus/colyseus-unity3d)提供C#客戶端；colyseus-defold提供Lua客戶端。[Colyseus](https://github.com/colyseus/colyseus)推薦使用[Schema](https://docs.colyseus.io/state/schema/)序列化/反序列化遊戲物件。C#是靜態類型語言，須要根據Schema定義檔預先產製序列化/反序列化代碼。預製代碼在開發階段，雙端協作不易；遊戲發布後，也無法熱更新。Lua是動態語言，可以解決這些問題。

### v0.1.0
- slua選用[v1.62](https://github.com/pangweiwei/slua/releases/tag/1.6.2)([fa8177d](https://github.com/pangweiwei/slua/commit/fa8177d516238c46dfaa156e72139756e96bfee3))，暫不考慮不支持LuaJIT的[v1.70](https://github.com/pangweiwei/slua/releases/tag/v1.7.0)([c1b60ba](https://github.com/pangweiwei/slua/commit/c1b60bac0bf202f96cc29ca3fec6a021b7d284df))。
- colyseus-defold選用[dc7b331](https://github.com/colyseus/colyseus-defold/commit/dc7b331c70c7675df9a10403ac0ff7c050a9116b)。
- colyseus-unity3d選用[11db7ab](https://github.com/colyseus/colyseus-unity3d/commit/11db7ab923587ba11f421af4f055902048948196)。
