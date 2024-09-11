{ lib }:
let
  # Merge list of attrsets
  # Example:
  #   `mergeAttrsets [ { a = 1; b = 2; } { a = 3; c = 4; } ] -> { a = 3; b = 2; c = 4; }`
  # mergeAttrsets :: [set] -> set
  mergeAttrsets = list: lib.lists.foldl (acc: val: acc // val) { } list;

  # Merge sub attrsets
  # Example:
  #   `mergeSubAttrsets { x = { a = 1; b = 2; }; y = { a = 3; c = 4; }; } -> { a = 3; b = 2; c = 4; }`
  # mergeSubAttrsets :: set -> set
  mergeSubAttrsets = set: mergeAttrsets (lib.attrsets.attrValues set);

  # Map sub attrsets
  # Example:
  #   ```nix
  #   v = { x = { a = 1; b = 2; }; y = { a = 3; c = 4; }; }
  #   f = f = key: val: "${key}-${val}"
  #   nestMapAttrsets f v
  #   ```
  #   ```nix
  #   {
  #     x = { a = "x-a"; b = "x-b"; };
  #     y = { a = "y-a"; c = "y-c"; };
  #   }
  #   ```
  # mapSubAttrsets :: f -> set -> set
  # f :: key -> val -> any
  mapSubAttrsets =
    f:
    lib.attrsets.mapAttrs (key: vals: lib.attrsets.genAttrs (builtins.attrNames vals) (val: f key val));

  # Rename sub attrset's key
  # Example:
  #   ```nix
  #   v = { x = { a = 1; b = 2; }; y = { a = 3; c = 4; }; }
  #   f = f = key: val: "${key}-${val}"
  #   f = key: sub_key: sub_val: "${key}-${sub_key}-${builtins.toString sub_val}"
  #   renameSubAttrsetsKey f v
  #   ```
  #   ```nix
  #   {
  #     x = { x-a-1 = 1; x-b-2 = 2; };
  #     y = { y-a-3 = 3; y-c-4 = 4; };
  #   }
  #   ```
  # renameSubAttrsetsKey :: f -> set -> set
  # f :: key -> sub_key -> sub_val -> str
  renameSubAttrsetsKey =
    f:
    lib.attrsets.mapAttrs (
      key: val:
      lib.attrsets.mapAttrs' (
        sub_key: sub_val: lib.attrsets.nameValuePair (f key sub_key sub_val) sub_val
      ) val
    );
in
{
  inherit
    mergeAttrsets
    mergeSubAttrsets
    mapSubAttrsets
    renameSubAttrsetsKey
    ;
}
