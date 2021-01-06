function FindProxyForURL(url, host) {
  if (
    !shExpMatch(url, "*//public.*.localhost.*") && 
    (shExpMatch(url, "*//*.localhost.*") || shExpMatch(url, "*//10.146.0.*"))
  ) {
    return "SOCKS5 localhost:1080";
  }
  
  return "DIRECT";
}
