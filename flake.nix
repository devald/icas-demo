{
  description = "Minimal Terragrunt-based Infra Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        tools = with pkgs; [
          terraform
          terragrunt
          awscli2
          kubectl
        ];

        envVarsScript = ''
          if [ "''${CI:-}" != "true" ]; then
            export TG_PROVIDER_CACHE=1
            export AWS_PROFILE=demo-profile
            export AWS_REGION=eu-central-1
            echo "🧭 Using local AWS profile: $AWS_PROFILE"
          else
            echo "⚙️ CI detected – skipping AWS_PROFILE export"
          fi
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          name = "terragrunt-shell";
          packages = tools;
          shellHook = ''
            ${envVarsScript}

            echo "🧪 Welcome to the Terraform + Terragrunt development environment!"
            echo "→ Terraform Version: ${pkgs.terraform.version}"
            echo "→ Terragrunt Version: ${pkgs.terragrunt.version}"

            exec ${pkgs.zsh}/bin/zsh
          '';
        };

        apps.validate = flake-utils.lib.mkApp {
          drv = pkgs.writeShellApplication {
            name = "validate-terragrunt";
            runtimeInputs = tools;
            text = ''
              ${envVarsScript}

              echo "→ Running Terraform and Terragrunt validation..."

              echo "→ terraform fmt -recursive -check"
              ${pkgs.terraform}/bin/terraform fmt -recursive -check

              echo "→ terragrunt hcl fmt --check"
              ${pkgs.terragrunt}/bin/terragrunt hcl fmt --check

              echo "→ terragrunt hcl validate"
              hcl_output=$(${pkgs.terragrunt}/bin/terragrunt hcl validate 2>&1)
              echo "$hcl_output"
              echo "$hcl_output" | grep -q "Error" && exit 1

              echo "✅ Validation completed successfully."
            '';
          };
        };

        apps.apply = flake-utils.lib.mkApp {
          drv = pkgs.writeShellApplication {
            name = "apply-terragrunt";
            runtimeInputs = tools;
            text = ''
              ${envVarsScript}

              echo "→ Running: terragrunt run --all apply"
              ${pkgs.terragrunt}/bin/terragrunt run --all apply --non-interactive

              echo "🚀 Apply completed successfully."
            '';
          };
        };
      }
    );
}
