using System.Threading.Tasks;

namespace Plex.Api.Api
{
    public interface IApiService
    {
        Task InvokeApiAsync(IApiRequest request);
        Task<T> InvokeApiAsync<T>(IApiRequest request);
    }
}