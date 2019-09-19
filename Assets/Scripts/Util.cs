using System.Text;
using SLua;

[CustomLuaClass]
public static class Util
{
    public static byte[] UTF8Bytes(string data)
    {
        return Encoding.UTF8.GetBytes(data);
    }
}
