using System.Collections;
using System.Threading.Tasks;
using SLua;
using NativeWebSocket;

[CustomLuaClass]
public class WebSocket : NativeWebSocket.WebSocket
{
    public WebSocket(string url) : base(url) { }

    public new IEnumerator Connect()
    {
        Task task = base.Connect();
        while (!task.IsCompleted)
        {
            yield return null;
        }
    }

    public new string State => base.State.ToString();

    public new IEnumerator Send(byte[] bytes)
    {
        Task task = base.Send(bytes);
        while (!task.IsCompleted)
        {
            yield return null;

        }
    }

    public new IEnumerator SendText(string message)
    {
        Task task = base.SendText(message);
        while (!task.IsCompleted)
        {
            yield return null;
        }
    }

    public new IEnumerator Close()
    {
        Task task = base.Close();
        while (!task.IsCompleted)
        {
            yield return null;
        }
    }

    public void RegOpenEvent(WebSocketOpenEventHandler handler)
    {
        OnOpen += handler;
    }

    public void UnregOpenEvent(WebSocketOpenEventHandler handler)
    {
        OnOpen -= handler;
    }

    public void RegMessageEvent(WebSocketMessageEventHandler handler)
    {
        OnMessage += handler;
    }

    public void UnregMessageEvent(WebSocketMessageEventHandler handler)
    {
        OnMessage -= handler;
    }

    public void RegErrorEvent(WebSocketErrorEventHandler handler)
    {
        OnError += handler;
    }

    public void UnregErrorEvent(WebSocketErrorEventHandler handler)
    {
        OnError -= handler;
    }

    public void RegCloseEvent(WebSocketCloseEventHandler handler)
    {
        OnClose += handler;
    }

    public void UnregCloseEvent(WebSocketCloseEventHandler handler)
    {
        OnClose -= handler;
    }
}
