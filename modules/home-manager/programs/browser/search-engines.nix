{
  # Search Engine
  s = {
    url = "https://search.uimataso.com/search?q={}";
    name = "Searx";
  };
  g = {
    url = "https://www.google.com/search?q={}";
    name = "Google";
  };
  d = {
    url = "https://duckduckgo.com/?q={}";
    name = "DuckDuckGo";
  };

  # Nix
  np = {
    url = "https://search.nixos.org/packages?type=packages&query={}";
    name = "NixOS Search - Packages";
  };
  nm = {
    url = "https://mynixos.com/search?q={}";
    name = "MyNixOS";
  };
  no = {
    url = "https://search.nixos.org/options?channel=unstable&sort=relevance&type=packages&query={}";
    name = "NixOS Search - Options";
  };
  ho = {
    url = "https://home-manager-options.extranix.com/?query={}&release=master";
    name = "HomeManager Options";
  };

  # Linux Wiki
  nw = {
    url = "https://nixos.wiki/index.php?search={}";
    name = "NixOS Wiki";
  };
  aw = {
    url = "https://wiki.archlinux.org/index.php?search={}";
    name = "Arch Wiki";
  };
  gw = {
    url = "https://wiki.gentoo.org/index.php?title=Special%3ASearch&search={}&go=Go";
    name = "Gentoo Wiki";
  };

  # Dev
  ru = {
    url = "https://doc.rust-lang.org/std/iter/?search={}";
    name = "Rust Std";
  };
  gh = {
    url = "https://github.com/search?q={}";
    name = "GitHub";
  };

  # Misc
  w = {
    url = "https://www.wikipedia.org/w/index.php?title=Special:Search&search={}";
    name = "Wikipedia";
  };
  y = {
    url = "https://www.youtube.com/results?search_query={}";
    name = "Youtube";
  };
  gm = {
    url = "https://www.google.com/maps?q={}";
    name = "Google Maps";
  };
  gt = {
    url = "https://translate.google.com/?sl=auto&text={}&op=translate";
    name = "Google Translate";
  };
  gi = {
    url = "https://www.google.com/search?tbm=isch&q={}";
    name = "Google Image";
  };
  cb = {
    url = "https://dictionary.cambridge.org/spellcheck/english/?q={}";
    name = "Cambridge Dictionary";
  };
  cbc = {
    url = "https://dictionary.cambridge.org/spellcheck/english-chinese-traditional/?q={}";
    name = "Cambridge Dictionary - En to Ch";
  };
  rd = {
    url = "https://www.reddit.com/search/?q={}";
    name = "Reddit";
  };
}
