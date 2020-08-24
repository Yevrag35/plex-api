using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;

namespace Plex.Api.Api
{
    public interface IApiRequest
    {
        string Endpoint { get; }
        string BaseUri { get; }
        HttpMethod HttpMethod { get; }
        IDictionary<string, string> RequestHeaders { get; }
        IDictionary<string, string> ContentHeaders { get; }
        IDictionary<string, string> QueryParams { get; }
        object Body { get; }
        string FullUri { get; }
    }
}
