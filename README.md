# AkariLinkShortener.cs
Web-API for [waa.ai](https://waa.ai/) a link shortener that plays on that fact that Akari has no presence

## Example
```cs
using AkariLinkShortenerApi;

namespace Application
{
    internal class Program
    {
        static async Task Main()
        {
            var api = new AkariLinkShortener();
            await api.Login("username", "password");
            string shortUrl = await api.ShortenLink("https://example.com");
            Console.WriteLine(shortUrl);
        }
    }
}
```
