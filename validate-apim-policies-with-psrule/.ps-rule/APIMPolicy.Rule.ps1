<#
    This file contains PSRule rules that can be used to validate Azure API Management policy files.
#>


# Synopsis: The first policy inside the inbound section should be the base policy to make sure important logic like security checks are applied first.
Rule "APIMPolicy.Rules.InboundBasePolicy" -If { $PSRule.TargetType.StartsWith("APIMPolicy.Types.") -and $PSRule.TargetType -ne "APIMPolicy.Types.Global" -and $PSRule.TargetType -ne "APIMPolicy.Types.Fragment" } {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    $Assert.HasField($policy.inbound, "base")
    $Assert.HasFieldValue($policy, "inbound.FirstChild.Name", "base")
}

# Synopsis: The backend section should only have the base policy to make sure the request is forwarded, and because only one policy is allowed.
Rule "APIMPolicy.Rules.BackendBasePolicy" -Type "APIMPolicy.Types.Workspace", "APIMPolicy.Types.Product", "APIMPolicy.Types.API", "APIMPolicy.Types.Operation" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "backend")
    $Assert.HasField($policy.backend, "base")
    $Assert.HasFieldValue($policy, "backend.ChildNodes.Count", 1)
}

# Synopsis: The outbound section should include the base policy so generic logic like error handling can be applied.
Rule "APIMPolicy.Rules.OutboundBasePolicy" -Type "APIMPolicy.Types.Workspace", "APIMPolicy.Types.Product", "APIMPolicy.Types.API", "APIMPolicy.Types.Operation" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "outbound")
    $Assert.HasField($policy.outbound, "base")
}


# Synopsis: The on-error section should include the base policy so generic logic like error handling can be applied.
Rule "APIMPolicy.Rules.OnErrorBasePolicy" -Type "APIMPolicy.Types.Workspace", "APIMPolicy.Types.Product", "APIMPolicy.Types.API", "APIMPolicy.Types.Operation" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "on-error")
    $Assert.HasField($policy."on-error", "base")
}

# Synopsis: The backend section in the global policy should only have the forward-request policy to make sure the request is forwarded, and because only one policy is allowed.
Rule "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy" -Type "APIMPolicy.Types.Global" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "backend")
    $Assert.HasField($policy.backend, "forward-request")
    $Assert.HasFieldValue($policy, "backend.ChildNodes.Count", 1)
}

# Synopsis: A set-backend-service policy should use a backend entity (by setting the backend-id attribute) so it's reusable and easier to maintain.
Rule "APIMPolicy.Rules.UseBackendEntity" `
    -If { 
        $PSRule.TargetType.StartsWith("APIMPolicy.Types.") -and `
        $TargetObject.Content.DocumentElement.SelectNodes(".//*[local-name()='set-backend-service']").Count -ne 0 
    } `
{
    $policy = $TargetObject.Content.DocumentElement

    # Select all set-backend-service policies
    $setBackendServicePolicies = $policy.SelectNodes(".//*[local-name()='set-backend-service']")

    # Check that each backend has the backend-id attribute set
    foreach ($setBackendServicePolicy in $setBackendServicePolicies) {
        $Assert.HasField($setBackendServicePolicy, "backend-id")
    }
}

# Synopsis: The subscription key header (Ocp-Apim-Subscription-Key) should be removed in the inbound section of the global policy to prevent it from being forwarded to the backend.
Rule "APIMPolicy.Rules.RemoveSubscriptionKeyHeader" -Type "APIMPolicy.Types.Global" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    
    # Select all set-header policies from the inbound section that are direct children.
    # We only check the first level, because the header should always be removed and not optionally (e.g. when it's nested in a choose>when).
    # The expression is surround by @(...) because the result is a single XmlElement if only one is found, but we want an array.
    $setHeaderPolicies = @( $policy.inbound.ChildNodes | Where-Object { $_.LocalName -eq "set-header" -and $_.name -eq "Ocp-Apim-Subscription-Key" -and $_."exists-action" -eq "delete" } )

    if ($setHeaderPolicies.Count -gt 0) {
        $Assert.Pass()
    } else {
        $Assert.Fail("Unable to find a set-header policy that removes the Ocp-Apim-Subscription-Key header as a direct child of the inbound section.")
    }
}