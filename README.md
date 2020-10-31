# colyseus-slua
[colyseus-unity3d](https://github.com/colyseus/colyseus-unity3d)需根據Schema定義檔預先產生序列化和反序列化代碼，在開發階段雙端協作不易，遊戲發布後也無法熱更新。colyseus-slua（Unity版本的Colyseus client for Lua）整合[slua](https://github.com/pangweiwei/slua)、[colyseus-defold](https://github.com/colyseus/colyseus-defold)和colyseus-unity3d透過動態語言Lua解決這些問題。
### v0.1.0
- slua選用[v1.62](https://github.com/chsqn/slua/tree/v1.6.2)([0adf47b](https://github.com/chsqn/slua/commit/0adf47bb411adf7b70ad78a717788d7e7ba904e6))，暫不考慮不支持LuaJIT的[v1.70](https://github.com/pangweiwei/slua/releases/tag/v1.7.0)。
- colyseus-defold更新至[789449c](https://github.com/colyseus/colyseus-defold/commit/789449cdeb5e9d804889e50b2e160ba602e7e3ef)。
- colyseus-unity3d更新至[30c9b7d](https://github.com/colyseus/colyseus-unity3d/commit/30c9b7d8e8259a7516fafcbd26179a0ab6a91ec9)。
- 暫時屏蔽Auth、Push和Storage。
