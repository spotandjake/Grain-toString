{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    grain.url = "github:spotandjake/grain-nix";
  };
  outputs = { flakelight, grain, ... }:
    flakelight ./. ({ lib, ... }: {
      systems = lib.systems.flakeExposed;
      devShell = {
        packages = pkgs: [
          pkgs.go-task # task command - script runner
          pkgs.wasmtime # Alternative wasm runner
        ];
      };
    });
}