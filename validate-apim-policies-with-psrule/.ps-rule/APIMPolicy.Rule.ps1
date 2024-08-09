<#
    This file contains PSRule rules that can be used to validate Azure API Management policy files.
#>


# Synopsis: The first policy inside the inbound section should be the base policy.
Rule "APIMPolicy.Rules.InboundBasePolicy" -Type "APIMPolicy.Types.API", "APIMPolicy.Types.Operation" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    $Assert.HasField($policy.inbound, "base")
    $Assert.HasFieldValue($policy, "inbound.FirstChild.Name", "base")
}