# Associating the FW Policy to Azure Firewall

## Different ways to associate the firewall policy

- Add the Firewall Policy to the Firewall module when creating the Firewall.
- Update the Firewall module by adding the Firewall Policy parameter.
- Associate by using the CLI command:
  - az network firewall update --name <"insert fw name"> -- resource-group <"insert rg name"> --firewall-policy <"insert fw policy name">
