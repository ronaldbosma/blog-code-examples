This folder contains an example on how to replace placeholders in a string using user-defined functions in Bicep. It also uses the Bicep Test Framework to test the functions. You can run the tests using the following command:

```bash
bicep test .\tests.bicep
```

Files:
- [replace-placeholders.bicep](./replace-placeholders.bicep): contains user-defined functions to replace placeholders.
- [tests.bicep](./tests.bicep): contains tests for the `replacePlaceholders` function.
- [test-replace-placeholders.bicep](./test-replace-placeholders.bicep): helper Bicep file used by `tests.bicep` to test the `replacePlaceholders` function.
- [bicepconfig.json](./bicepconfig.json): Bicep configuration file to enable the experimental test framework.

Documentation:
- [User-defined functions in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-functions)
- [Imports in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import)
- [Exploring the awesome Bicep Test Framework](https://rios.engineer/exploring-the-bicep-test-framework-%F0%9F%A7%AA/)