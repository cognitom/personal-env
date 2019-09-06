function FindProxyForURL(url, host) {
  if (
    !shExpMatch(url, "*//public.*.localhost.zone:*") && 
    shExpMatch(url, "*//*.localhost.zone:*")
  ) {
    return "SOCKS5 localhost:1080";
  }
  
  return "DIRECT";
}
