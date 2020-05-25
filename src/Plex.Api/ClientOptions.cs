using System;

namespace Plex.Api
{
    public class ClientOptions
    {
        public string Product { get; set; } = "Unknown";
        public string DeviceName { get; set; } = "Unknown";
        public Guid ClientId { get; set; } = Guid.NewGuid();
        public string Version { get; set; } = "v1";
        public string Platform { get; set; } = "Web";
    }
}