let
  trusted = [
    "uimataso.com"
    "*.uimataso.com"

    "proton.me"
    "simplelogin.io"
    "porkbun.com"

    "accounts.google.com"
    "google.com"
    "youtube.com"

    "github.com"
    "tailscale.com"
    "mynixos.com"

    "aws.amazon.com"
    "cloudflare.com"

    "openrouter.ai"
    "chatgpt.com"

    "leetcode.com"
    "codeforces.com"
    "reddit.com"
    "printables.com"

    "monkeytype.com"
    "typ.ing"
    "shurufa.app"
  ];
in
{
  allowCookie = trusted ++ [ ];
  allowJavaScript = trusted ++ [ ];
}
