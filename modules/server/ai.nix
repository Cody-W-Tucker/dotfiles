{ config, pkgs, ... }:

{
  # Ollama local llm
  services = {
    nginx.virtualHosts = {
      "search.homehub.tv" = {
        useACMEHost = "homehub.tv";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://search.homehub.tv:8888";
          proxyWebsockets = true;
        };
      };
      "ai.homehub.tv" = {
        useACMEHost = "homehub.tv";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:11435";
          proxyWebsockets = true;
        };
      };
      "ollama.homehub.tv" = {
        useACMEHost = "homehub.tv";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:11434";
        };
      };
    };
    ollama = {
      enable = true;
      port = 11434;
      openFirewall = false;
      host = "127.0.0.1";
    };
    open-webui = {
      enable = true;
      port = 11435;
      host = "127.0.0.1";
      openFirewall = false;
      environment = {
        OLLAMA_API_BASE_URL = "https://ollama.homehub.tv";
        # Disable authentication
        WEBUI_AUTH = "False";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        SEARXNG_QUERY_URL = "https://search.homehub.tv/search?q=<query>";
        USER_AGENT = "Ollama";
        ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION = "False";
        AIOHTTP_CLIENT_TIMEOUT = "600";
      };
    };
    searx = {
      enable = true;
      redisCreateLocally = true;
      settings = {
        use_default_settings = true;
        server = {
          base_url = "http://search.homehub.tv:8888";
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = "secret";
          limiter = false;
          image_proxy = true;
        };
        ui = {
          static_use_hash = true;
        };
        search = {
          safe_search = 0;
          autocomplete = "";
          default_lang = "";
          formats = [ "html" "json" ];
        };
        outgoing = {
          useragent_suffix = "webdev@tmvsocial.com";
        };
      };
    };
  };
}
