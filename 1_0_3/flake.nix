{
  description = ''Wrapper around the GMP bindings for the Nim language.'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-bignum-1_0_3.flake = false;
  inputs.src-bignum-1_0_3.ref   = "refs/tags/1.0.3";
  inputs.src-bignum-1_0_3.owner = "SciNim";
  inputs.src-bignum-1_0_3.repo  = "bignum";
  inputs.src-bignum-1_0_3.type  = "github";
  
  inputs."gmp".owner = "nim-nix-pkgs";
  inputs."gmp".ref   = "master";
  inputs."gmp".repo  = "gmp";
  inputs."gmp".dir   = "v0_2_5";
  inputs."gmp".type  = "github";
  inputs."gmp".inputs.nixpkgs.follows = "nixpkgs";
  inputs."gmp".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-bignum-1_0_3"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-bignum-1_0_3";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}