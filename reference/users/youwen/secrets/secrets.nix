let
  youwen = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrIRHcvh0fxYNc0sukl8nSGRU8z1RjRmuc20iuk9TUqAxeew+0pSvY9lU4vshhrcGUe2OKIxgKJ76xdfGRw5ofmmd5Fr4If6tzWAWdE6Jr3J/w58YL6/ISOyRwjTserjWFIaO41y9OuLzf3UtzBF/1zexnGwq2lMJ7MAi0JNJ5O+umgrcnF1BDWyw7ymVkiQTruJ3LV2XgJDpOKQlFnVGKgYyMgVGeGYjiZO9Sj8edq1ZFeEH1jN5TnAdnqsiwhFgZpCrBxFFZKohuQLyH+QaOmBsdgSZwsg4Prndtxp5GTrknupPCgEWJ1rgvykEchYajeWQLxyeW/O/4iSST7VLKS7dgzUHZ5Dxf/QP1iCSeJqCIIJssuIslMK1vYmJZYk098ZDlLrFCLepQqy0YGvZe4OVP4BK4UNu5DKKLTpPNwDnyf1NSNTT2q2TsWXKWBDl1eurX9MBR24ZQEoP0gvcnTKr+2rheOTWJ5asDswEWphp5zQxBjztPGe55H0zjnqk= youwen@demeter";
  users = [ youwen ];

  demeter = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdcVbgUyQb+W3UjmYb3K9l9jkq/NkTSWAGFUJczJ07kEAg9nUUEfU6RGMCzCEbwWsVpNZysRfef6nxerQBcKiRz/bLUocFl/80ZoylQuxkWU8cvGdImFCtP76YKoVNwuHS0R31Qi90zQLnxs1oLmULSACH6Mw7+suYkVtH1prQdUHdx2bcOPqFk8Qpm8WuRNHxEbrFNuHNarHF3XHo/iIgJh8OeMbwE+MtoZCSfPMEnWGg4nKal3fQ3GO21wUyIZIZrSCMiYKzfvWrlLhd8rkKbGp+VRNe3m5q7k5p+pGSJMYHTRaGwOGY92L+GJOjjr/HrloINiEMC82zmUWctXQhK+4ni3ssPmOesEblfr9tXfwU0Xh0zNhqeljw/ptaZrM3k/yMW4h1DgI9BeBwcNcYqaHLwX6IqG5b8XxI+/JQniQmZIZM+kBx6GyZFrPxM84XWxhwjRKnn4oBU8kVn3RBlNwz3AFIjGpOh86Rd343X8Q6JbrMT/z17bL6StKXZfUFqgOWEs/JJEHT/DWKL2zF2ppqa5ZuJhzevrtKfAxomURXnQ77MPCUtbo2PFHmcl3fUD+yS2GD/8a492rUlCG2d5FS7KfW3L9rQwTnNBqQMGUu1Uc6qz5LWLEF7yoBtdKKZ3Y4lyPP3/lAQPs5j0Jx+coBdySca3xrmmvMj4/aIQ== root@nixos";
  systems = [ demeter ];
in
{
  "youwenw_app_password.age".publicKeys = users ++ systems;
  "youwen_ucsb_client_id.age".publicKeys = users ++ systems;
  "youwen_ucsb_client_secret.age".publicKeys = users ++ systems;
  "tincan_app_password.age".publicKeys = users ++ systems;
  "github_cli_secret_config.age".publicKeys = users ++ systems;
  "github_ssh_priv_key.age".publicKeys = users ++ systems;
}