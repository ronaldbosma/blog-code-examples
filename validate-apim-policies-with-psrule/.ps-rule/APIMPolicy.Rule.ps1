<#
    This file contains PSRule rules that can be used to validate Azure API Management policy files.
#>


# Synopsis: The first policy inside the inbound section should be the base policy.
Rule "APIMPolicy.Rules.InboundBasePolicy" -If { $TargetObject.PolicyType?.StartsWith("APIMPolicy.Types.") -and $TargetObject.PolicyType -ne "APIMPolicy.Types.Global" } {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    $Assert.HasField($policy.inbound, "base")
    $Assert.HasFieldValue($policy, "inbound.FirstChild.Name", "base")
}

# Synopsis: The first policy inside the outbound section should be the base policy.
Rule "APIMPolicy.Rules.OutboundBasePolicy" -Type "APIMPolicy.Types.API", "APIMPolicy.Types.Operation" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "outbound")
    $Assert.HasField($policy.outbound, "base")
    $Assert.HasFieldValue($policy, "outbound.FirstChild.Name", "base")
}