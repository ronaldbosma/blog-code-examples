This folder contains an example on how to apply Azure naming conventions using user-defined functions in Bicep. It also uses the Bicep Test Framework to test the functions.

Files:
- [naming-conventions.bicep](./naming-conventions.bicep): contains user-defined functions to apply Azure naming conventions.
- [tests.bicep](./tests.bicep): contains tests for the `getResourceName` function.
- [test-get-resource-name.bicep](./test-get-resource-name.bicep): helper Bicep file used by `tests.bicep` to test the `getResourceName` function.
- [bicepconfig.json](./bicepconfig.json): Bicep configuration file to enable the experimental test framework.

Documentation:
- [User-defined functions in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-functions)
- [Imports in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import)
- [Exploring the awesome Bicep Test Framework](https://rios.engineer/exploring-the-bicep-test-framework-%F0%9F%A7%AA/)