using System.Net.Http;
using System.Text.Json;
using System.Net.Http.Json;
using System.Net.Http.Headers;

namespace AkariLinkShortenerApi
{
    public class AkariLinkShortener
    {
        private string apiKey;
        private readonly HttpClient httpClient;
        private readonly string apiUrl = "https://waa.ai/api";
        private readonly string secondApiUrl = "https://api.waa.ai/v2";
        public AkariLinkShortener()
        {
            httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.UserAgent.ParseAdd(
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0");
            httpClient.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public async Task<string> Login(string username, string password)
        {
            var data = JsonContent.Create(new
            {
                username = username,
                password = password
            });
            var response = await httpClient.PostAsync($"{apiUrl}/auth/login", data);
            var content = await response.Content.ReadAsStringAsync();
            using var document = JsonDocument.Parse(content);
            if (document.RootElement.TryGetProperty("api_key", out var apiKeyElement))
            {
                apiKey = apiKeyElement.GetString();
                httpClient.DefaultRequestHeaders.Add("Authorization", $"api-key {apiKey}");
            }
            return content;
        }

        public async Task<string> GenerateApiKey()
        {
            var response = await httpClient.PostAsync($"{apiUrl}/user/api-key", null);
            return await response.Content.ReadAsStringAsync();
        }

        public async Task<string> ShortenLink(string url)
        {
            var data = JsonContent.Create(new { url = url });
            var response = await httpClient.PostAsync($"{secondApiUrl}/links", data);
            return await response.Content.ReadAsStringAsync();
        }
        public async Task<string> GetLinks()
        {
            var response = await httpClient.GetAsync($"{secondApiUrl}/links");
            return await response.Content.ReadAsStringAsync();
        }
    }
}
