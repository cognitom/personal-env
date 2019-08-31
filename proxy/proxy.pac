function FindProxyForURL(url, host) {
  if (shExpMatch(host, "workspace.localhost.zone")) {
    return "SOCKS5 localhost:1080";
  }
  
  return "DIRECT";
}
