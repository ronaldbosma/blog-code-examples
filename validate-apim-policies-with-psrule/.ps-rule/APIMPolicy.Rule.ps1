<#
    This file contains PSRule rules that can be used to validate Azure API Management policy files.
#>


# Synopsis: The first policy inside the inbound section should be the base policy to make sure important logic like security checks are applied first.
Rule "APIMPolicy.Rules.InboundBasePolicy" -If { $TargetObject.PolicyType?.StartsWith("APIMPolicy.Types.") -and $TargetObject.PolicyType -ne "APIMPolicy.Types.Global" -and $TargetObject.PolicyType -ne "APIMPolicy.Types.Fragment" } {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    $Assert.HasField($policy.inbound, "base")
    $Assert.HasFieldValue($policy, "inbound.FirstChild.Name", "base")
}

# Synopsis: The outbound section should include the base policy so generic logic like error handling can be applied.
Rule "APIMPolicy.Rules.OutboundBasePolicy" -Type "APIMPolicy.Types.Workspace", "APIMPolicy.Types.Product", "APIMPolicy.Types.API", "APIMPolicy.Types.Operation" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "outbound")
    $Assert.HasField($policy.outbound, "base")
}