function FindProxyForURL(url, host) {
  if (
    !shExpMatch(url, "*//public.*.localhost.*") && 
    shExpMatch(url, "*//*.localhost.*")
  ) {
    return "SOCKS5 localhost:1080";
  }
  
  return "DIRECT";
}
